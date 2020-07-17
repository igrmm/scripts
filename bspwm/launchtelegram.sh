#!/bin/sh

[ -n "$(xtitle $(bspc query -N -n .window) | grep Telegram)" ] \
	&& xdo activate -n "telegram-desktop" \
	|| telegram-desktop
