#!/bin/sh

WINDOWS=$(bspc query -N -n .window)

for wid in $WINDOWS
do
    if xprop -id "$wid" | grep -q Telegram; then
        xdo activate -n "Telegram"
        exit
    fi
done
Telegram
