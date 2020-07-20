#!/bin/sh

case "$1" in
	click-left)
		windowid="$(xdotool search --maxdepth 1 --onlyvisible --class "_bar_")"
		if [ -n "$windowid" ]; then
			xdotool windowkill "$windowid"
		else
			alacritty \
				--class _bar_dffiles_,_bar_dffiles_ \
				--title _bar_dffiles_ \
				-e sh -c 'ncdu /media/files' &
		fi
		;;
	*)
		df -h ~/files | awk 'NR==2 {print $4}'
		;;
esac
