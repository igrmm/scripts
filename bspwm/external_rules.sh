#!/bin/sh

wid="$1"
class="$2"
instance="$3"

# remove shadows from borders
xprop -id "$wid" -f _PICOM_SHADOW 32c -set _PICOM_SHADOW 1;

WM_NAME() {
	xprop -id "$wid" '\t$0' WM_NAME | cut -f 2
}

# Calculator
[ "$class" = "calculator" ] && echo 'state=floating rectangle=300x300+810+390'

# Gdx2D
[ "$class" = "Gdx2D" ] && echo 'state=floating'

# GdxExample
[ "$class" = "GdxExample" ] && echo 'state=floating'

# FIREFOX
[ "$class" = "firefox" ] && echo 'desktop=^10'

# STEAM
[ "$class" = "Steam" ] && echo 'desktop=^9'

# THUNDERBIRD
[ "$class" = "Thunderbird" ] && echo 'desktop=^8'

# THUNDERBIRD MSG COMPOSE
[ "$instance" = "Msgcompose" ] && echo 'state=floating'

# JETBRAINS IDEA SPLASH SCREEN
if [ "$instance" = "jetbrains-idea-ce" ]; then
	# necessary because diff window is not totally decorated yet
	sleep 0.1
	case "$(WM_NAME)" in
		# splash screen
		'"win0"')
			echo 'state=floating'
			;;
		# git diff window
		*'[Default Changelist]"')
			echo 'state=floating rectangle=1052x950+434+65'
			;;
	esac
fi

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
case "$class" in _bar_date_) echo 'rectangle=664x704+628+188' ;; esac
