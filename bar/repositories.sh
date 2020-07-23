#!/bin/sh

fetch() {
	if ! pgrep -x check_repositories >/dev/null; then
		check_repositories
	else
		notify-send "check_repositories is already running."
	fi
}

case "$1" in
	click-left)
		windowid="$(xdotool search --maxdepth 1 --onlyvisible --class "_bar_")"
		if [ -n "$windowid" ]; then
			xdotool windowkill "$windowid"
		else
			alacritty \
				--class _bar_date_,_bar_date_ \
				--title _bar_date_ \
				-e sh -c 'check_repositories -v; read' &
		fi
		;;
	*)
		trap true USR1

		while true; do
			fetch
			sleep 120 &
			wait
		done
		;;
esac
