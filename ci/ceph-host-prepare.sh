#!/usr/bin/env bash
# Prepares the host for the Ceph variant of the kind cluster (see kind-up.sh):
#   - attaches a loop device on a sparse file, which Rook turns into the OSD (the prod OSD is /dev/sdb)
#   - loads the rbd kernel module, which Ceph block volumes need; without it ci/.ceph-block is not created
#     and the block tests are skipped
#
# CI_OSD_FILE  backing file (default: /var/tmp/axiom-ci-osd.img)
# CI_OSD_SIZE  size of the file, it is sparse (default: 12G)
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

file=${CI_OSD_FILE:-/var/tmp/axiom-ci-osd.img}
size=${CI_OSD_SIZE:-12G}

rm -f "$root/ci/.ceph-block" "$root/ci/.ceph-state"

sudo truncate -s "$size" "$file"
dev=$(sudo losetup --find --show "$file")
printf 'dev=%s\nfile=%s\n' "$dev" "$file" >"$root/ci/.ceph-state"
echo "OSD device: $dev (backed by $file)"

if sudo modprobe rbd; then
    touch "$root/ci/.ceph-block"
else
    echo "::warning::the rbd kernel module is not available, Ceph block storage will not be tested"
fi
