#!/bin/sh

# Personal arch linux installation script for my laptop. This uses EFISTUB for
# booting directly into the kernel, so no boot loader.

printf 'username: ' && read -r USERNAME
printf 'password: ' && read -r PASSWORD

printf '\n'
printf 'username: %s\n' "$USERNAME"
printf 'password: %s\n' "$PASSWORD"
printf '\n'
printf 'Confirm? (y|n): ' && read -r CONFIRMATION

case "$CONFIRMATION" in
	y) ;;
	n) echo "exit" && exit ;;
	*) echo "exit" && exit ;;
esac

DISK="/dev/sda"
EFI_PARTITION="$DISK"7
LINUX_PARTITION="$DISK"6
EFI_PARTITION_NUMBER=7
HOSTNAME="laptop"

timedatectl set-timezone America/Campo_Grande
timedatectl set-ntp true

echo y | mkfs.fat -F 32 "$EFI_PARTITION"
echo y | mkfs.ext4 "$LINUX_PARTITION"
mount "$LINUX_PARTITION" /mnt
mkdir /mnt/boot
mount "$EFI_PARTITION" /mnt/boot

pacstrap -K /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

PARTUUID="$(blkid $LINUX_PARTITION -s PARTUUID -o value)"
efibootmgr \
	--disk $DISK \
	--part $EFI_PARTITION_NUMBER \
	--create --label "Arch Linux" \
	--loader /vmlinuz-linux \
	--unicode "root=PARTUUID=$PARTUUID video=efifb:1920x1080-bgr rw initrd=\intel-ucode.img initrd=\initramfs-linux.img"

cat << EOF | arch-chroot /mnt
ln -sf /usr/share/zoneinfo/America/Campo_Grande /etc/localtime
hwclock --systohc
echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=pt_BR.UTF-8" > /etc/locale.conf

echo "$HOSTNAME" > /etc/hostname

{ echo "$PASSWORD"; echo "$PASSWORD"; } | passwd

sed -i 's/#Color/Color/g' /etc/pacman.conf

pacman --noconfirm -S intel-ucode xf86-video-intel iwd zsh xorg-xinit sudo sxhkd bspwm rofi alacritty polybar xorg-xsetroot

useradd -m -G wheel -s /bin/zsh "$USERNAME"
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
{ echo "$PASSWORD"; echo "$PASSWORD"; } | passwd "$USERNAME"

systemctl enable systemd-resolved.service
systemctl enable iwd.service

mkdir /etc/iwd
echo "[General]" > /etc/iwd/main.conf
echo "EnableNetworkConfiguration=true" >> /etc/iwd/main.conf

echo "ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf" \
    > /home/"$USERNAME"/.zprofile
chown "$USERNAME:$USERNAME" -R /home/"$USERNAME"/.zprofile

exit
EOF

umount -R /mnt
