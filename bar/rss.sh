#!/bin/sh

fetch() {
	if ! pgrep -x newsboat >/dev/null; then
		unread="$(newsboat -x reload print-unread | awk '{print $1}')"
		[ "$unread" -gt 0 ] && echo "$unread"
	else
		notify-send "Newsboat is already running."
	fi
}

trap fetch USR1

fetch

while true; do
	sleep 900 &
	wait
done
