#!/bin/sh

fetch() {
	if ! pgrep -x rclone >/dev/null; then
		changes="$(gdrive check 2>&1 | grep ERROR | wc -l)"
		if [ "$changes" -gt 0 ]; then
			echo "$changes"
		else
			echo ""
		fi
	fi
}

trap true USR1

while true; do
	fetch
	sleep 300 &
	wait
done
