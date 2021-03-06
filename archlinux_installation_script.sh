#!/bin/sh

# Personal arch linux installation script. This uses EFISTUB for booting directly
# into the kernel, so no boot loader. This script uses only 1 disk and 3 partitions
# the first for EFI (esp), second for swap and last for root.

printf 'password: '            && read -r PASSWORD

printf '\n'
printf 'password:         %s\n' "$PASSWORD"
printf '\n'
printf 'Confirm? (y|n): ' && read -r CONFIRMATION

case "$CONFIRMATION" in
	y) ;;
	n) echo "exit" && exit ;;
	*) echo "exit" && exit ;;
esac

reflector --country Brazil --protocol https --protocol http --latest 10 --sort rate --save /etc/pacman.d/mirrorlist

DISK="/dev/nvme0n1"
EFI_PARTITION="$DISK"p1
SWAP_PARTITION="$DISK"p2
LINUX_PARTITION="$DISK"p3
EFI_PARTITION_NUMBER=1
HOSTNAME="archlinux"

timedatectl set-ntp true

echo y | mkfs.fat -F32 "$EFI_PARTITION"
echo y | mkfs.ext4 "$LINUX_PARTITION"
mkswap "$SWAP_PARTITION"
swapon "$SWAP_PARTITION"
mount "$LINUX_PARTITION" /mnt
mkdir /mnt/boot
mount "$EFI_PARTITION" /mnt/boot

pacstrap /mnt base linux linux-firmware
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
echo "KEYMAP=br-abnt2" > /etc/vconsole.conf
localectl set-x11-keymap br abnt2 abnt2

echo "$HOSTNAME" > /etc/hostname

{ echo "$PASSWORD"; echo "$PASSWORD"; } | passwd

sed -i 's/#Color/Color/g' /etc/pacman.conf

pacman --noconfirm -S intel-ucode linux-headers nvidia-dkms broadcom-wl-dkms iwd
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
systemctl enable iwd.service

mkdir /etc/iwd
echo "[General]" > /etc/iwd/main.conf
echo "EnableNetworkConfiguration=true" >> /etc/iwd/main.conf
echo "[Network]" >> /etc/iwd/main.conf
echo "NameResolvingService=systemd" >> /etc/iwd/main.conf

ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

exit
EOF

umount -R /mnt
