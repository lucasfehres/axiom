#!/bin/bash

if [ ! -f /home/xprauser/.davmail.properties ]; then
    echo "No user config found, copying default /etc/davmail.properties..."
    cp /etc/davmail.properties /home/xprauser/.davmail.properties
else
    echo "Using existing /home/xprauser/.davmail.properties"
fi
