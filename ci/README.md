# CI

Three layers, all driven by `just` recipes inside the Nix shell (`shell.nix`), so a CI provider only has to provide Nix and Docker:

| Recipe | Layer | What it does |
| --- | --- | --- |
| `just ci-lint` | 1 | `flux build` every Kustomization in `flux/clusters/*/`, `kubeconform` the output, `kyverno test` (`ci/kyverno-tests/`) |
| `just ci-kind-up` | 2 | Creates a kind cluster, installs the hand-applied CRDs and Flux, and reconciles `flux/clusters/ci` |
| `just ci-test` | 3 | Runs the Chainsaw tests in `ci/chainsaw/` against that cluster |
| `just ci-kind-down` | | Deletes the kind cluster |

Run them locally the same way: `nix-shell --run 'just ci-lint'`. `ci-kind-up` needs Docker and, unless `CI_GIT_URL`/`CI_GIT_REF`/`CI_GIT_COMMIT` are set, reconciles your current branch from `origin`, so push it first. The repo must be readable without credentials, since the CI GitRepository has no `secretRef`.

## The CI cluster (`flux/clusters/ci`)

A small subset of the production cluster that runs on kind: cert-manager, Kyverno (plus policies) and Traefik. Everything that needs hardware or credentials (Rook-Ceph and its dependents, Liqo, kilo, Tailscale, external-dns, Velero, ZeroTier, the `*-endpoint` apps) is left out. It reuses the production workload directories, so it exercises the real manifests. CI-only resources live in `flux/infrastructure/ci/` (the `rook-ceph` namespace the Kyverno policy needs, and a self-signed ClusterIssuer replacing `letsencrypt`).

**Keep it updated.** When a component that is part of the CI cluster is renamed, moved or gets different `dependsOn`, change `flux/clusters/ci` and the Chainsaw tests with it. When you add a component that can run on kind, consider adding it.

## Porting to GitLab

Only `.github/workflows/ci.yaml` is provider specific. For GitLab, write a `.gitlab-ci.yml` with two jobs that run the same commands:

- `lint`: image `nixos/nix`, script `nix-shell --run 'just ci-lint'`
- `integration`: same image, but the runner must expose Docker (a DinD service or a mounted socket); script `just ci-kind-up`, `just ci-test`, and `just ci-kind-down` in `after_script`

Map the environment the GitHub workflow sets for the integration job: `CI_GIT_URL` (`$CI_REPOSITORY_URL` without credentials), `CI_GIT_REF` (`$CI_COMMIT_REF_NAME`) and `CI_GIT_COMMIT` (`$CI_COMMIT_SHA`). Note that GitLab sets its own `CI_*` variables, so check none of the names above clash. On a runner without internet access, mirror the Helm repositories and the image registries.
