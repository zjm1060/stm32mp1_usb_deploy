#!/bin/sh

runing () {
    while : ; do
        sleep 0.1
        echo -e "\\ \r\c"
        sleep 0.1
        echo -e "| \r\c"
        sleep 0.1
        echo -e "/ \r\c"
        sleep 0.1
        echo -e "- \r\c"
    done
}

runing & CYLON_PID=$!

DISK="/dev/mmcblk0"
MOUNT_POINT="/mnt/udisk"
PACKAGE_DIR="$MOUNT_POINT/package"
PART_MOUNT="/mnt/p"

mkdir -p $MOUNT_POINT

mount /dev/sda1 $MOUNT_POINT

echo "Install the bootloader and kernel ..."
dd if="$PACKAGE_DIR/st-image-bootfs-openstlinux-weston-minimal-stm32mp1-disco.ext4" of=${DISK}p4
echo "Install device drivers ..."
dd if="$PACKAGE_DIR/st-image-vendorfs-openstlinux-weston-minimal-stm32mp1-disco.ext4" of=${DISK}p5
echo "Install the operating system and applications ..."
dd if="$PACKAGE_DIR/st-image-simple-openstlinux-weston-minimal-stm32mp1-disco.ext4" of=${DISK}p6

echo "Initialize user data ..."
mkdir -p ${PART_MOUNT}4
mkdir -p ${PART_MOUNT}5
mkdir -p ${PART_MOUNT}6
mkdir -p ${PART_MOUNT}7

mount ${DISK}p4 ${PART_MOUNT}4
mount ${DISK}p5 ${PART_MOUNT}5
mount ${DISK}p6 ${PART_MOUNT}6
mount ${DISK}p7 ${PART_MOUNT}7

resize2fs ${DISK}p4
resize2fs ${DISK}p5
resize2fs ${DISK}p6
resize2fs ${DISK}p7

sync

cat ${MOUNT_POINT}/boot/logo

umount $MOUNT_POINT

kill $CYLON_PID

sleep 10

reboot
