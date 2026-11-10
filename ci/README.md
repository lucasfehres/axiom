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

## Ceph (`ci-ceph.yaml`, heavier, separate workflow)

`just ci-kind-up-ceph` and `just ci-test-ceph` deploy the real Rook-Ceph manifests on top of the CI cluster and test them. It runs in its own workflow, on PRs touching Rook, CloudNativePG, Kyverno or CI files, weekly, and on demand, as it needs several GB of RAM and about 15-25 minutes.

- `ci/ceph-host-prepare.sh` attaches a sparse file (12G) as a loop device with `sudo losetup` and loads the `rbd` kernel module. The loop device replaces the production `/dev/sdb`. `kind-up.sh` passes its name to Flux in the `ci-ceph` ConfigMap, which is substituted into the `CephCluster` patch.
- `flux/clusters/ci-ceph/` holds the operator, `CephCluster` and object store (the production directories plus patches: no Prometheus monitoring, the CI node and the loop device). `flux/clusters/ci-ceph-block/` holds block storage and CloudNativePG, and is only applied when the host has the `rbd` module (`ci/.ceph-block`); otherwise the block tests are skipped with a warning.
- Tests: `ci/chainsaw-ceph/` (cluster health, the Kyverno patch on the real OSD Deployment, an S3 round trip with the COSI user) and `ci/chainsaw-ceph-block/` (a PVC on `rook-ceph-block`, a CloudNativePG cluster on it).
- Not covered: COSI bucket provisioning (the COSI controller isn't deployed, like production), Velero, snapshots, and the barman plugin.
- Needs sudo, so locally it changes your host (a loop device and a file under `/var/tmp`); `just ci-kind-down` undoes both.

## Porting to GitLab

Only `.github/workflows/ci.yaml` and `ci-ceph.yaml` are provider specific. The Ceph job needs a runner with `sudo`, Docker and enough memory. For GitLab, write a `.gitlab-ci.yml` with two jobs that run the same commands:

- `lint`: image `nixos/nix`, script `nix-shell --run 'just ci-lint'`
- `integration`: same image, but the runner must expose Docker (a DinD service or a mounted socket); script `just ci-kind-up`, `just ci-test`, and `just ci-kind-down` in `after_script`

Map the environment the GitHub workflow sets for the integration job: `CI_GIT_URL` (`$CI_REPOSITORY_URL` without credentials), `CI_GIT_REF` (`$CI_COMMIT_REF_NAME`) and `CI_GIT_COMMIT` (`$CI_COMMIT_SHA`). Note that GitLab sets its own `CI_*` variables, so check none of the names above clash. On a runner without internet access, mirror the Helm repositories and the image registries.
