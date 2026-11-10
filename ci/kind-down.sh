#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

kind delete cluster --name "${CI_KIND_CLUSTER:-axiom-ci}" --kubeconfig "${CI_KUBECONFIG:-$root/ci/.kubeconfig}"
rm -f "${CI_KUBECONFIG:-$root/ci/.kubeconfig}"
