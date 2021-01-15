#!/bin/sh

case "$1" in
	click-left)
		windowid="$(xdotool search --maxdepth 1 --onlyvisible --class "_bar_")"
		if [ -n "$windowid" ]; then
			xdotool windowkill "$windowid"
		else
			alacritty \
				--class _bar_date_,_bar_date_ \
				--title _bar_date_ \
				-e sh -c 'cal -y; read' &
		fi
		;;
	*)
		date '+%Y-%m-%d'
		;;
esac
