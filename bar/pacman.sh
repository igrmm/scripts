#!/bin/sh

fetch() {
	if ! pgrep -x checkupdates >/dev/null; then
		updates="$(checkupdates | wc -l)"
		if [ "$updates" -gt 0 ]; then
			echo "$updates"
		else
			echo ""
		fi
	else
		notify-send "checkupdates is already running."
	fi
}

trap true USR1

while true; do
	fetch
	sleep 900 &
	wait
done
