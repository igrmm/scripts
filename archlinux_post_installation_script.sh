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

pacman -Syu base-devel xorg-xinit man-db man-pages nvidia-settings sudo \
	alsa-utils picom xwallpaper libnotify dunst xdotool xclip sxiv \
	ntfs-3g exfat-utils rsync htop neofetch vifm ffmpegthumbnailer \
	ghostscript fzf imagemagick scrot pacman-contrib ncdu vnstat \
	newsboat mpv rclone sxhkd bspwm rofi alacritty zsh xcursor-bluecurve \
	papirus-icon-theme arc-solid-gtk-theme ttf-croscore noto-fonts-emoji \
	awesome-terminal-fonts noto-fonts ttf-fira-code

useradd -m -G wheel -s /bin/zsh "$USERNAME"

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

mkdir /home/"$USERNAME"/repositories

git clone https://github.com/igrmm/dotfiles /home/"$USERNAME"/repositories/dotfiles
git clone https://github.com/igrmm/scripts /home/"$USERNAME"/repositories/scripts

chown "$USERNAME:$USERNAME" -R /home/"$USERNAME"

echo "exec ~/repositories/scripts/bin/autorice --post-installation" \
	> /home/"$USERNAME"/.zprofile

systemctl enable vnstat.service

{ echo "$PASSWORD"; echo "$PASSWORD"; } | passwd "$USERNAME"
