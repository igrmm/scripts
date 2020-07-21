#!/bin/sh

fetch() {
	if ! pgrep -x checkupdates >/dev/null; then
		updates="$(checkupdates | wc -l)"
		[ "$updates" -gt 0 ] && echo "$updates"
	else
		notify-send "checkupdates is already running."
	fi
}

trap fetch USR1

fetch

while true; do
	sleep 900 &
	wait
done
