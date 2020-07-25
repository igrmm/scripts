#!/bin/sh

wid="$1"
class="$2"
instance="$3"

WM_NAME() {
	xprop -id "$wid" '\t$0' WM_NAME | cut -f 2
}

# Gdx2D
[ "$class" = "Gdx2D" ] && echo 'state=floating'

# FIREFOX
[ "$class" = "firefox" ] && echo 'desktop=^10'

# STEAM
[ "$class" = "Steam" ] && echo 'desktop=^9'

# THUNDERBIRD
[ "$class" = "Thunderbird" ] && echo 'desktop=^8'

# TELEGRAM
[ "$instance" = "telegram-desktop" ] && \
	case "$(WM_NAME)" in
		'"Media viewer"')
			;;
		*)
			echo 'state=floating rectangle=380x480+770+300'
			;;
	esac

# BAR
case "$class" in _bar_*) echo 'state=floating' ;; esac
