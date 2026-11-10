#!/usr/bin/env bash
# Undoes ceph-host-prepare.sh
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
state=$root/ci/.ceph-state

[ -f "$state" ] || exit 0

dev=$(sed -n 's/^dev=//p' "$state")
file=$(sed -n 's/^file=//p' "$state")

sudo losetup -d "$dev" || true
sudo rm -f "$file"
rm -f "$state" "$root/ci/.ceph-block"
