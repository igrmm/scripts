#!/bin/sh

case "$1" in
	-i)
		echo "file://$(pwd)/$2" | xclip -i -selection clipboard -t text/uri-list
		;;
	-o)
		IN="$(xclip -selection clipboard -o)"
		if echo "$IN" | grep 'file://' >/dev/null; then
			IN="$(echo "$IN" | sed 's#file://##')"
			OUT="$(basename "$IN")"
			rsync -P "$IN" "$OUT"
		fi
		;;
esac
