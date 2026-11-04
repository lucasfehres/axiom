# Namespace Cilium's Gateway API reads TLS secrets from (gatewayAPI.secretsNamespace in
# nix/services/rke2/manifests/axiom-rke2-cilium.yaml)
cilium_secrets_ns := "kube-system"

# Cilium serves `<namespace>-<name>` copies of Gateway TLS secrets, which it doesn't sync itself
#
# Copy cert-manager managed TLS secrets referenced by Cilium Gateways to Cilium's copies
sync-gateway-certs:
    #!/usr/bin/env bash
    set -euo pipefail
    kubectl get gateways -A -o json \
        | jq -r '.items[]
            | select(.spec.gatewayClassName == "cilium")
            | .metadata.namespace as $ns
            | .spec.listeners[].tls.certificateRefs[]?
            | "\(.namespace // $ns) \(.name)"' \
        | sort -u \
        | while read -r ns name; do
            target="$ns-$name"
            echo "$ns/$name -> {{cilium_secrets_ns}}/$target"
            kubectl get secret -n "$ns" "$name" -o json \
                | jq --arg name "$target" --arg ns "{{cilium_secrets_ns}}" \
                    '{apiVersion, kind, type, data, metadata: {name: $name, namespace: $ns}}' \
                | kubectl apply -f -
        done
