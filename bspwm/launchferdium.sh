#!/bin/sh
dbus-send --dest=org.ferdium.Ferdium \
    --type=method_call \
    /org/ferdium \
    org.ferdium.Ferdium.ToggleWindow
