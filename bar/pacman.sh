#!/bin/sh

fetch() {
	if ! pgrep -x checkupdates >/dev/null; then
		updates="$(checkupdates 2>/dev/null | wc -l)"
		[ "$updates" -gt 0 ] && echo "$updates"
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
