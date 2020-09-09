#!/bin/sh

DISK="/dev/nvme0n1"
LINUX_PARTITION="$DISK"p3
EFI_PARTITION_NUMBER=1

PARTUUID="$(blkid $LINUX_PARTITION -s PARTUUID -o value)"
efibootmgr \
	--disk $DISK \
	--part $EFI_PARTITION_NUMBER \
	--create --label "Arch Linux" \
	--loader /vmlinuz-linux \
	--unicode "root=PARTUUID=$PARTUUID video=efifb:1920x1080-bgr rw initrd=\intel-ucode.img initrd=\initramfs-linux.img"

