#!/bin/sh

fetch() {
	if ! pgrep -x newsboat >/dev/null; then
		unread="$(newsboat -x reload print-unread | awk '{print $1}')"
		if [ "$unread" -gt 0 ]; then
			echo "$unread"
		else
			echo ""
		fi
	else
		notify-send "Newsboat is already running."
	fi
}

trap true USR1

while true; do
	fetch
	sleep 900 &
	wait
done
