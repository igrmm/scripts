#!/bin/sh

WINDOWS=$(bspc query -N -n .window)

for wid in $WINDOWS
do
    if xprop -id "$wid" | grep -q telegram; then
        xdo activate -n "telegram-desktop"
        exit
    fi
done
telegram-desktop
