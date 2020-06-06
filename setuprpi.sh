#!/bin/bash

RICE=false

SETUP_SD_CARD=false

HOSTNAME="rbp"

USAGE="\nUSAGE: ./setuprbp.sh --username=username --password=password
       \nUSAGE: ./setuprbp.sh --rice --username=username --password=password
       \nUSAGE: ./setuprbp.sh --set-up-sdcard\n"

for i in "$@"; do
	case $i in
		-u=*|--username=*)
			USERNAME="${i#*=}"
			;;
		-p=*|--password=*)
			PASSWORD="${i#*=}"
			;;
		--rice)
			RICE=true
			;;
		--set-sdcard)
			SETUP_SD_CARD=true
			;;
	esac
done

if [ "$USERNAME" = "" ] || [ "$PASSWORD" = "" ]; then
	echo -e $USAGE
	exit
fi

if [ "$RICE" = true ] && [ "$SETUP_SD_CARD" = true ]; then
	echo -e $USAGE
	exit
fi

add_to_package_list() {
	PACKAGE_LIST=$PACKAGE_LIST" $1"
}

#Essential
add_to_package_list base-devel
add_to_package_list sudo
add_to_package_list xf86-video-fbturbo-git
add_to_package_list xorg

#Tools
add_to_package_list neovim

#Appearance
add_to_package_list xcursor-bluecurv
add_to_package_list papirus-icon-theme
add_to_package_list arc-solid-gtk-theme

#Fonts
add_to_package_list ttf-inconsolata
add_to_package_list ttf-croscore
add_to_package_list noto-fonts-emoji
add_to_package_list awesome-terminal-fonts

set_up_sdcard() {
	echo set_up_sdcard
}

rice() {
	echo rice
}

if [ ! $RICE ] && [ ! $SETUP_SD_CARD]; then

	loadkeys br-abnt2
	pacman-key --init
	pacman-key --populate archlinuxarm
	timedatectl set-ntp true
	ln -sf /usr/share/zoneinfo/America/Campo_Grande /etc/localtime
	hwclock --systohc
	echo pt_BR.UTF-8 UTF-8 >> /etc/locale.gen
	echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
	locale-gen
	echo LANG=pt_BR.UTF-8 > /etc/locale.conf
	echo KEYMAP=br-abnt2 > /etc/vconsole.conf
	echo $HOSTNAME > /etc/hostname
	{ echo $PASSWORD; echo $PASSWORD; } | passwd

	echo 'Section "InputClass"' > /etc/X11/xorg.conf.d/00-keyboard.conf
	echo 'Identifier "system-keyboard"' >> /etc/X11/xorg.conf.d/00-keyboard.conf
	echo 'MatchIsKeyboard "on"' >> /etc/X11/xorg.conf.d/00-keyboard.conf
	echo 'Option "XkbLayout" "br"' >> /etc/X11/xorg.conf.d/00-keyboard.conf
	echo 'Option "XkbModel" "abnt2"' >> /etc/X11/xorg.conf.d/00-keyboard.conf
	echo 'Option "XkbVariant" "abnt2"' >> /etc/X11/xorg.conf.d/00-keyboard.conf
	echo 'EndSection' >> /etc/X11/xorg.conf.d/00-keyboard.conf

	userdel -r alarm
	useradd -m -G wheel $USERNAME
	{ echo $PASSWORD; echo $PASSWORD; } | passwd $USERNAME
	echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

	sed -i 's/#Color/Color/g' /etc/pacman.conf
	pacman -Syyu
	pacman --noconfirm --needed -S $PACKAGE_LIST

	cd /home/$USERNAME/
	git clone http://github.com/$USERNAME/scripts
	git clone http://github.com/$USERNAME/dotfiles
	chown $USERNAME -R /home/$USERNAME/
	chgrp $USERNAME -R /home/$USERNAME/

elif [ "$RICE" = true ]; then
	rice
fi
