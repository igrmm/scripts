#!/bin/sh

printf 'username: ' && read -r USERNAME
printf 'password: ' && read -r PASSWORD

printf '\n'
printf 'username: %s\n' "$USERNAME"
printf 'password: %s\n' "$PASSWORD"
printf '\n'
printf 'Confirm? (y|n) ' && read -r CONFIRMATION

case "$CONFIRMATION" in
	y) ;;
	n) echo "exit" && exit ;;
	*) echo "exit" && exit ;;
esac

pacman -S base-devel xorg-xinit man-db man-pages nvidia-settings sudo \
	alsa-utils

useradd -m -G wheel "$USERNAME"

{ echo "$PASSWORD"; echo "$PASSWORD"; } | passwd "$USERNAME"


