#!/bin/bash
# Init wrapper for exeuntu container
# This script initializes the container with systemd

# Ensure proper permissions for systemd
if [ ! -d /run/systemd ]; then
    mkdir -p /run/systemd
fi

# Start systemd as PID 1
exec /lib/systemd/systemd
