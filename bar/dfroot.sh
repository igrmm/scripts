#!/bin/sh

case "$1" in
	click-left)
		windowid="$(xdotool search --maxdepth 1 --onlyvisible --class "_bar_")"
		if [ -n "$windowid" ]; then
			xdotool windowkill "$windowid"
		else
			alacritty \
				--class _bar_dfroot_,_bar_dfroot_ \
				--title _bar_dfroot_ \
				-e sh -c 'ncdu / --exclude /media' &
		fi
		;;
	*)
		df -h / | awk 'NR==2 {print $4}'
		;;
esac
