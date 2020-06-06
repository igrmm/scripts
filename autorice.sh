#!/bin/bash

USAGE="\nUSAGE: ./autorice.sh --username=username --hostname=hostname
       \nUSAGE: ./autorice.sh --username=username --hostname=hostname --post-installation\n"

POST_INSTALLATION=false

for i in "$@"; do
	case $i in
		-u=*|--username=*)
			USERNAME="${i#*=}"
			;;
		-h=*|--hostname=*)
			HOSTNAME="${i#*=}"
			;;
		--post-installation)
			POST_INSTALLATION=true
			;;
	esac
done

if [ "$USERNAME" = "" ] || [ "$HOSTNAME" = "" ]; then
	echo -e $USAGE
	exit
fi

if [ ! -d /home/$USERNAME/.config ]; then
    mkdir /home/$USERNAME/.config
fi

rm -rf /home/$USERNAME/.config/fontconfig
ln -s /home/$USERNAME/dotfiles/fontconfig /home/$USERNAME/.config/fontconfig

rm -rf /home/$USERNAME/.zshrc
ln -s /home/$USERNAME/dotfiles/.zshrc /home/$USERNAME/.zshrc

rm -rf /home/$USERNAME/.zprofile
ln -s /home/$USERNAME/dotfiles/.zprofile /home/$USERNAME/.zprofile

rm -rf /home/$USERNAME/.gtkrc-2.0
ln -s /home/$USERNAME/dotfiles/.gtkrc-2.0 /home/$USERNAME/.gtkrc-2.0

rm -rf /home/$USERNAME/.config/gtk-3.0
ln -s /home/$USERNAME/dotfiles/gtk-3.0 /home/$USERNAME/.config/gtk-3.0

rm -rf /home/$USERNAME/.config/i3blocks
ln -s /home/$USERNAME/dotfiles/i3blocks/$HOSTNAME /home/$USERNAME/.config/i3blocks

rm -rf /home/$USERNAME/.icons
ln -s /home/$USERNAME/dotfiles/cursor.theme /home/$USERNAME/.icons

rm -rf /home/$USERNAME/.config/termite
ln -s /home/$USERNAME/dotfiles/termite /home/$USERNAME/.config/termite

rm -rf /home/$USERNAME/.config/vifm
ln -s /home/$USERNAME/dotfiles/vifm /home/$USERNAME/.config/vifm

rm -rf /home/$USERNAME/.config/compton.conf
ln -s /home/$USERNAME/dotfiles/compton/$HOSTNAME /home/$USERNAME/.config/compton.conf

rm -rf /home/$USERNAME/.config/nvim
ln -s /home/$USERNAME/dotfiles/nvim /home/$USERNAME/.config/nvim

rm -rf /home/$USERNAME/.config/newsboat
ln -s /home/$USERNAME/dotfiles/newsboat /home/$USERNAME/.config/newsboat

rm -rf /home/$USERNAME/.config/sxiv
ln -s /home/$USERNAME/dotfiles/sxiv /home/$USERNAME/.config/sxiv

mkdir /home/$USERNAME/.local /home/$USERNAME/.local/share /home/$USERNAME/.local/share/applications
ln -s /home/$USERNAME/dotfiles/mime/vifm.desktop /home/$USERNAME/.local/share/applications/vifm.desktop
rm -rf /home/$USERNAME/.config/mimeapps.list
ln -s /home/$USERNAME/dotfiles/mime/mimeapps.list /home/$USERNAME/.config/mimeapps.list

rm .bash*

if [ "$POST_INSTALLATION" = true ]; then
	git clone https://aur.archlinux.org/yay.git
	cd yay && makepkg -Asci && cd .. && rm -rf yay
	yay -S archivemount rar2fs
	sed -i 's/colorscheme gruvbox/"colorscheme gruvbox/g' /home/$USERNAME/dotfiles/nvim/init.vim
	git clone https://github.com/VundleVim/Vundle.vim.git /home/$USERNAME/.vim/bundle/Vundle.vim
	nvim +PluginInstall +qall
	sed -i 's/"colorscheme gruvbox/colorscheme gruvbox/g' /home/$USERNAME/dotfiles/nvim/init.vim
	git clone https://github.com/zsh-users/zsh-syntax-highlighting .zsh/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-completions .zsh/zsh-completions
	git clone https://github.com/zsh-users/zsh-history-substring-search .zsh/zsh-history-substring-search
	git clone https://github.com/zsh-users/zsh-autosuggestions .zsh/zsh-autosuggestions
	source /home/$USERNAME/.zprofile
	if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
		exec startx /home/$USERNAME/dotfiles/xinitrc
	fi
fi
