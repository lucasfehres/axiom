#!/usr/bin/env bash
# Layer 1: static validation. Needs no cluster.
#   1. `flux build` every Flux Kustomization in flux/clusters/*/ (this also runs kustomize)
#   2. kubeconform on the rendered output and on the Flux Kustomizations themselves
#   3. `kyverno test` for the Kyverno policies
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$root"

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

kubeconform_args=(
    -strict
    -ignore-missing-schemas
    -summary
    -schema-location default
    -schema-location 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json'
)

failed=0

echo "::group::flux build + kubeconform"
for file in flux/clusters/*/*.yaml; do
    # the flux-system dirs are Flux's own generated bootstrap files
    [[ "$file" == flux/clusters/*/flux-system/* ]] && continue

    name=$(yq '.metadata.name' "$file")
    path=$(yq '.spec.path' "$file")
    echo "== $file ($name -> $path)"

    if ! flux build kustomization "$name" \
        --path "$root/$path" \
        --kustomization-file "$file" \
        --dry-run >"$work/flux-built.yaml"; then
        echo "flux build failed for $file" >&2
        failed=1
        continue
    fi

    # `flux build` re-serializes its output and drops quotes ('true' becomes a boolean), so validate
    # kustomize's own output instead, unless the Flux Kustomization changes what is built
    if [ -f "$path/kustomization.yaml" ] \
        && [ "$(yq '.spec | has("patches") or has("images") or has("postBuild") or has("components") or has("namePrefix") or has("nameSuffix") or has("targetNamespace") or has("commonMetadata")' "$file")" = false ]; then
        # (kustomize rejects a kustomization without resources, which flux build accepts)
        kustomize build "$path" >"$work/rendered.yaml" 2>/dev/null || cp "$work/flux-built.yaml" "$work/rendered.yaml"
    else
        cp "$work/flux-built.yaml" "$work/rendered.yaml"
    fi

    # the API server prunes nulls (e.g. a map holding only comments), so drop them for validation too
    yq -i 'del(.. | select(. == null))' "$work/rendered.yaml"

    kubeconform "${kubeconform_args[@]}" "$file" "$work/rendered.yaml" || failed=1
done
echo "::endgroup::"

echo "::group::kyverno test"
# kyverno-policies/ mixes a ConfigMap and the ClusterPolicy, and the CLI only wants policies
mkdir -p "$work/kyverno"
cp ci/kyverno-tests/* "$work/kyverno/"
yq 'select(.kind == "ClusterPolicy")' flux/infrastructure/kyverno-policies/*.yaml >"$work/kyverno/policy.yaml"
kyverno test "$work/kyverno" || failed=1
echo "::endgroup::"

exit "$failed"
