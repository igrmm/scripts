#!/bin/sh

printf 'hostname: ' && read -r HOSTNAME
printf 'username: ' && read -r USERNAME
printf 'password: ' && read -r PASSWORD
printf 'linux partition: ' && read -r LINUX_PARTITION
printf 'efi partition: ' && read -r EFI_PARTITION

printf '\n'
printf 'hostname:        %s\n' "$HOSTNAME"
printf 'username:        %s\n' "$USERNAME"
printf 'password:        %s\n' "$PASSWORD"
printf 'linux partition: %s\n' "$LINUX_PARTITION"
printf 'efi partition:   %s\n' "$EFI_PARTITION"
printf '\n'
printf 'Confirm? (y|n): ' && read -r CONFIRMATION

case "$CONFIRMATION" in
	y) ;;
	n) echo "exit" && exit ;;
	*) echo "exit" && exit ;;
esac

timedatectl set-ntp true

echo y | mkfs.ext4 "$LINUX_PARTITION"
mount "$LINUX_PARTITION" /mnt
mkdir /mnt/boot
mount "$EFI_PARTITION" /mnt/boot

pacstrap /mnt base base-devel linux linux-firmware broadcom-wl iwd neovim
genfstab -U /mnt >> /mnt/etc/fstab

PARTUUID="$(blkid $LINUX_PARTITION -s PARTUUID -o value)"
efibootmgr \
	--disk $ESP \
	--part $ESPPART \
	--create --label "Arch Linux" \
	--loader /vmlinuz-linux \
	--unicode "root=$PARTUUID rw initrd=\intel-ucode.img initrd=\initramfs-linux.img"

cat <<EOF | arch-chroot /mnt
ln -sf /usr/share/zoneinfo/America/Campo_Grande /etc/localtime
hwclock --systohc
echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=pt_BR.UTF-8" > /etc/locale.conf
echo "KEYMAP=br-abnt2" > /etc/vconsole.conf

echo "$HOSTNAME" > /etc/hostname

{ echo "$PASSWORD"; echo "$PASSWORD"; } | passwd

sed -i 's/#Color/Color/g' /etc/pacman.conf

exit
EOF

umount -R /mnt
