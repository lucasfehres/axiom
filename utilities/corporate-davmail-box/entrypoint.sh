#!/bin/bash
set -e

/config.sh

DISPLAY="${DISPLAY:-:100}"
XPRA_PORT="${XPRA_PORT:-14500}"
XPRA_ENCODING="${XPRA_ENCODING:-h264}"
XPRA_DPI="${XPRA_DPI:-96}"
XPRA_RESIZE="${XPRA_RESIZE:-yes}"

echo "========================================="
echo "  Xpra + Openbox Container"
echo "  Display  : ${DISPLAY}"
echo "  Port     : ${XPRA_PORT}"
echo "  Encoding : ${XPRA_ENCODING}"
echo "========================================="

# Build Xpra start command
XPRA_ARGS=(
    start-desktop "${DISPLAY}"
    --bind-tcp=0.0.0.0:${XPRA_PORT}
    --html=on
    --start=openbox-session
    --daemon=no
    --encoding=${XPRA_ENCODING}
    --dpi=${XPRA_DPI}
    --resize-display=${XPRA_RESIZE}
    --clipboard=yes
    --notifications=no
    --mdns=no
    --printing=no
    --forward-xdg-open=off
)

# Optional password authentication
if [ -n "${XPRA_PASSWORD}" ]; then
    echo "${XPRA_PASSWORD}" > /tmp/xpra_password
    chmod 600 /tmp/xpra_password
    XPRA_ARGS+=(
        --auth=file:filename=/tmp/xpra_password
    )
    echo "  Auth     : password protected"
else
    XPRA_ARGS+=(--auth=none)
    echo "  Auth     : none (set XPRA_PASSWORD to enable)"
fi

echo "========================================="
echo ""

exec xpra "${XPRA_ARGS[@]}"
