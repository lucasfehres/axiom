#!/bin/bash
set -e

# ── System dbus ───────────────────────────────────────────────────────────────
mkdir -p /run/dbus
if ! pgrep -x dbus-daemon > /dev/null; then
    dbus-daemon --system --fork
    echo "[priv] Started system dbus"
fi

# ── XDG_RUNTIME_DIR for xprauser (uid 1000) ──────────────────────────────────
mkdir -p /run/user/1000
chmod 700 /run/user/1000
chown xprauser:xprauser /run/user/1000
echo "[priv] Created XDG_RUNTIME_DIR"

# ── Drop to xprauser and run entrypoint ──────────────────────────────────────
exec gosu xprauser /entrypoint.sh "$@"
