#!/usr/bin/env bash
# Layer 2: create a kind cluster and let Flux reconcile flux/clusters/ci into it.
#
# CI_GIT_URL  clone URL of this repo (default: origin)
# CI_GIT_REF  branch to reconcile (default: the current branch)
# CI_GIT_COMMIT  optional commit SHA, for detached checkouts such as PR merge refs
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

# Install the same controllers as production. `flux install --version` can't be used, as it refuses
# versions newer than the CLI, which comes from nixpkgs and lags behind.
kubectl apply --server-side -f flux/clusters/axiom/flux-system/gotk-components.yaml
kubectl rollout status -n flux-system deployment --timeout=5m

flux create source git flux-system \
    --url "$url" \
    --branch "$ref" \
    ${commit:+--commit "$commit"} \
    --interval 1m

flux create kustomization flux-system \
    --source GitRepository/flux-system \
    --path ./flux/clusters/ci \
    --prune \
    --interval 1m

dump() {
    flux get all -A || true
    kubectl get pods -A || true
    kubectl describe helmreleases -A || true
}

# the root Kustomization only creates the others, so wait for them to show up first
for _ in $(seq 1 60); do
    [ "$(kubectl get kustomizations -n flux-system -o name | wc -l)" -gt 1 ] && break
    sleep 5
done

if ! kubectl wait kustomizations --all -n flux-system --for=condition=Ready --timeout=15m; then
    dump
    exit 1
fi
