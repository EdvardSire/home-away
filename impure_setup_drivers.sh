#!/usr/bin/env bash

DRIVERS="/home/user/.nix-profile/drivers"

if [ -d "$DRIVERS" ]; then
    ln -sf $DRIVERS/opengl-driver /run/
fi
