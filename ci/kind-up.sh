#!/usr/bin/env bash
# Layer 2: create a kind cluster and let Flux reconcile flux/clusters/ci into it.
#
# CI_GIT_URL  clone URL of this repo (default: origin)
# CI_GIT_REF  branch to reconcile (default: the current branch)
# CI_GIT_COMMIT  optional commit SHA, for detached checkouts such as PR merge refs
# CI_CEPH     set to also deploy Ceph (flux/clusters/ci-ceph, and ci-ceph-block when the host has the rbd
#             kernel module). Needs sudo, to set up a loop device for the OSD; see ceph-host-prepare.sh
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$root"

cluster=${CI_KIND_CLUSTER:-axiom-ci}

# Use a kubeconfig that only knows the kind cluster, so nothing below can reach another cluster
# (kubectl and flux read KUBECONFIG; an unset or shared one could point at a real cluster)
export KUBECONFIG=${CI_KUBECONFIG:-$root/ci/.kubeconfig}
gateway_api=https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.4.1/config/crd

url=${CI_GIT_URL:-$(git remote get-url origin)}
ref=${CI_GIT_REF:-$(git rev-parse --abbrev-ref HEAD)}
commit=${CI_GIT_COMMIT:-}
ceph=${CI_CEPH:-}

# before the node exists, so that the loop device shows up in the node's /dev
[ -n "$ceph" ] && ci/ceph-host-prepare.sh

if ! kind get clusters | grep -qx "$cluster"; then
    kind create cluster --name "$cluster" --config ci/kind-config.yaml --kubeconfig "$KUBECONFIG" --wait 2m
else
    kind export kubeconfig --name "$cluster" --kubeconfig "$KUBECONFIG"
fi

if [ "$(kubectl config current-context)" != "kind-$cluster" ] || [ "$(kubectl config get-contexts -o name | wc -l)" -ne 1 ]; then
    echo "refusing to continue: $KUBECONFIG must only contain the kind-$cluster context" >&2
    exit 1
fi

# CRDs that are applied by hand in production (docs/Kubernetes.md)
for crd in gatewayclasses gateways httproutes referencegrants grpcroutes; do
    kubectl apply -f "$gateway_api/standard/gateway.networking.k8s.io_$crd.yaml"
done
kubectl apply -f "$gateway_api/experimental/gateway.networking.k8s.io_tlsroutes.yaml"

if [ -n "$ceph" ]; then
    kubectl apply -k 'github.com/kubernetes-sigs/container-object-storage-interface//?ref=v0.2.2'
    # for the VolumeSnapshotClass in rook-ceph-block, and the CSI snapshotter sidecars
    kubectl apply -k 'github.com/kubernetes-csi/external-snapshotter/client/config/crd?ref=v8.2.0'
fi

# Install the same controllers as production. `flux install --version` can't be used, as it refuses
# versions newer than the CLI, which comes from nixpkgs and lags behind.
kubectl apply --server-side -f flux/clusters/axiom/flux-system/gotk-components.yaml
kubectl rollout status -n flux-system deployment --timeout=5m

flux create source git flux-system \
    --url "$url" \
    --branch "$ref" \
    ${commit:+--commit "$commit"} \
    --interval 1m

# each root Kustomization creates the Kustomizations in its path
roots=(flux-system)
flux create kustomization flux-system \
    --source GitRepository/flux-system \
    --path ./flux/clusters/ci \
    --prune \
    --interval 1m

if [ -n "$ceph" ]; then
    # the loop device ceph-host-prepare.sh made, for the CephCluster patch in flux/clusters/ci-ceph
    dev=$(sed -n 's/^dev=//p' ci/.ceph-state)
    node=$cluster-control-plane
    # the device may have been created after the node started
    docker exec "$node" sh -c "[ -b $dev ] || mknod $dev b 7 ${dev#/dev/loop}"
    kubectl create configmap ci-ceph -n flux-system --from-literal=OSD_DEVICE="$dev" \
        --dry-run=client -o yaml | kubectl apply -f -

    roots+=(ci-ceph)
    flux create kustomization ci-ceph \
        --source GitRepository/flux-system \
        --path ./flux/clusters/ci-ceph \
        --prune \
        --interval 1m

    if [ -f ci/.ceph-block ]; then
        roots+=(ci-ceph-block)
        flux create kustomization ci-ceph-block \
            --source GitRepository/flux-system \
            --path ./flux/clusters/ci-ceph-block \
            --prune \
            --interval 1m
    fi
fi

dump() {
    flux get all -A || true
    kubectl get pods -A || true
    kubectl describe helmreleases -A || true
    if [ -n "$ceph" ]; then
        kubectl get -n rook-ceph cephclusters,cephobjectstores -o yaml || true
        kubectl logs -n rook-ceph deploy/rook-ceph-operator --tail=200 || true
        kubectl logs -n rook-ceph -l app=rook-ceph-osd-prepare --all-containers --tail=100 || true
    fi
}

# the root Kustomizations must have created their children before waiting for all of them
for r in "${roots[@]}"; do
    kubectl wait "kustomization/$r" -n flux-system --for=condition=Ready --timeout=10m || { dump; exit 1; }
done

if ! kubectl wait kustomizations --all -n flux-system --for=condition=Ready --timeout="${CI_WAIT:-15m}"; then
    dump
    exit 1
fi
