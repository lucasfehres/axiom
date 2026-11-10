# Namespace Cilium's Gateway API reads TLS secrets from (gatewayAPI.secretsNamespace in
# nix/services/rke2/manifests/axiom-rke2-cilium.yaml)
cilium_secrets_ns := "kube-system"

# Cilium (>= 1.19) serves Gateway TLS secrets as `cilium-sync-secret-<hash>`, which it only creates
# itself when gatewayAPI.secretsNamespace.sync is true. The hash is internal to Cilium, so instead of
# computing it we read the secret name each listener's filter chain asks for from the generated
# CiliumEnvoyConfig (`cilium-gateway-<gateway>`), matched on the listener hostname.
#
# Copy cert-manager managed TLS secrets referenced by Cilium Gateways to Cilium's copies
sync-gateway-certs:
    #!/usr/bin/env bash
    set -euo pipefail
    kubectl get gateways -A -o json \
        | jq -r '.items[]
            | select(.spec.gatewayClassName == "cilium")
            | .metadata as $gw
            | .spec.listeners[]
            | select(.tls.certificateRefs and .hostname)
            | .tls.certificateRefs[0] as $ref
            | "\($gw.namespace) \($gw.name) \(.hostname) \($ref.namespace // $gw.namespace) \($ref.name)"' \
        | sort -u \
        | while read -r gw_ns gw host ns name; do
            # the CEC may not be reconciled yet (or the wrong name) - fail rather than copy to a guess
            target=$(kubectl get ciliumenvoyconfig -n "$gw_ns" "cilium-gateway-$gw" -o json \
                | jq -r --arg host "$host" '.spec.resources[]
                    | select(."@type" | endswith("config.listener.v3.Listener"))
                    | .filterChains[]
                    | select(.filterChainMatch.serverNames == [$host])
                    | .transportSocket.typedConfig.commonTlsContext.tlsCertificateSdsSecretConfigs[0].name' \
                | sed 's|.*/||')
            if [ -z "$target" ]; then
                echo "no Cilium secret name found for $gw_ns/$gw listener $host" >&2
                exit 1
            fi
            echo "$ns/$name -> {{cilium_secrets_ns}}/$target"
            kubectl get secret -n "$ns" "$name" -o json \
                | jq --arg name "$target" --arg ns "{{cilium_secrets_ns}}" \
                    '{apiVersion, kind, type, data, metadata: {name: $name, namespace: $ns}}' \
                | kubectl apply -f -
        done

# CI recipes. Run by .github/workflows/ci.yaml, but work the same locally (see ci/README.md)
#
# Statically validate all manifests (flux build, kubeconform, kyverno test)
ci-lint:
    ci/lint.sh

# Create a kind cluster and let Flux reconcile flux/clusters/ci into it
ci-kind-up:
    ci/kind-up.sh

# Run the Chainsaw integration tests against the kind cluster
ci-test:
    KUBECONFIG="${CI_KUBECONFIG:-{{justfile_directory()}}/ci/.kubeconfig}" chainsaw test ci/chainsaw --config ci/chainsaw/.chainsaw.yaml

# Delete the kind cluster
ci-kind-down:
    ci/kind-down.sh
