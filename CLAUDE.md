# Axiom

GitOps repo for the Axiom clusters: Flux manifests in `flux/` (entry points in `flux/clusters/<cluster>/`), NixOS config in `nix/`, and some Terraform/Pulumi.

## CI

Static validation, a kind smoke test and Chainsaw integration tests run on every PR touching `flux/`. See `ci/README.md` for how it works and how to run it locally (`nix-shell --run 'just ci-lint'`, `just ci-kind-up`, `just ci-test`).

**Keep the CI cluster up to date.** `flux/clusters/ci` (plus `flux/infrastructure/ci/` and the Chainsaw tests in `ci/chainsaw/`) is a hand-maintained subset of the production clusters. Whenever you add, remove or rename a component it includes (cert-manager, Kyverno and its policies, Traefik, and for Ceph: the Rook operator, `CephCluster`, object store, block pool and CloudNativePG, in `flux/clusters/ci-ceph*`), or change its `dependsOn`, path or namespaces in `flux/clusters/axiom`, make the same change there. When you add a component that can run on kind, add it to the CI cluster with a test. Keep all CI logic in `justfile` and `ci/` rather than in the workflow file, so it stays portable to GitLab.
