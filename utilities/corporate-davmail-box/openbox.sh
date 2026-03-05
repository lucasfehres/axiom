#!/bin/bash
# Openbox autostart — place commands here to launch apps on session start.
# Example:
#   xterm &
#   firefox &

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax --exit-with-session)
    export DBUS_SESSION_BUS_ADDRESS
fi

# Set a solid background color (no wallpaper needed)
xsetroot -solid "#4287f5" &

xterm &
davmail &

# prepare the edging
xdg-settings set default-web-browser fake-microsoft-edge.desktop
xdg-mime default fake-microsoft-edge.desktop x-scheme-handler/http
xdg-mime default fake-microsoft-edge.desktop x-scheme-handler/https
xdg-mime default fake-microsoft-edge.desktop text/html
