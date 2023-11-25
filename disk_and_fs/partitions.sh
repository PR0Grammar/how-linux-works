#! /usr/bin/env bash

# Make sure to run this with sudo!
echo "(make sure to run this with sudo)"
# View the partitions of the disk
echo "Viewing partitions"
parted -l
echo -e "\n"
FLASH_DRIVE_DEVICE_FILE=$(parted -l | sed -n '/SanDisk Cruzer Glide/{n;p}' | grep -Po '/dev/sd[a-z]')

if [ -z "${FLASH_DRIVE_DEVICE_FILE}" ]; then
	echo "Exiting early since no flash drive found"
	exit 1
fi


# If we find the flash drive, let's practice paritioning
echo -e "Now let's partition our flash drive located in ${FLASH_DRIVE_DEVICE_FILE}\n"

echo "We'll do this with \"fdisk ${FLASH_DRIVE_DEVICE_FILE}\". This provides an text-based interactive way to partition the disk"
echo "The options you can enter (to name a few): d (delete partitions), n (add new partition), p (print partitions), q (quit w/o saving), w(save)"
echo -e "You can use option m for help while running\n"

read -p "Press enter to continue"

fdisk "${FLASH_DRIVE_DEVICE_FILE}"
