#! /usr/bin/env bash

set -eou pipefail

# Check if running superuser
if [ "${EUID}" -ne 0 ]; then
	echo "Please run with sudo"
	exit 1
fi

# Get flash drive device file
FD_FILE=$(parted -l | sed -n '/SanDisk Cruzer Glide/{n;p}' | grep -Po '/dev/sd[a-z]')

if [ -z "${FD_FILE}" ]; then
	echo "Missing flash drive device file. Please plug in flash drive"
	exit 1
fi


###### CREATE FS

echo "Flash drive device file: ${FD_FILE}"
echo "We will create a fs in partition 1. Is that fine?"
read -p "Press enter to continue"
echo ""

echo "We will run \"mkfs -t ext4 ${FD_FILE}1\" to create the fs on that partition"
echo "We will use the defaults provided by mkfs"
echo ""

mkfs -t ext4 "${FD_FILE}1"


echo "Notice the 'superblock'"
echo "This is a key component at the top level of the fs database"
echo "Its important that mkfs creates backups in case the original is destroyed"
echo ""
echo "Also important to note that creating a fs should only be done once for a new partition. Creating a fs on an existing fs will destroy the old data!"
echo ""

################ MOUNTING
echo "###### MOUNTING ######"
echo "Now let's mount the fs to a directory"
echo "We will mount the first partition onto /media/usb"
echo "We will run \"mount -t ext4 ${FD_FILE}1 /media/usb\" to mount the new fs onto the new dir"
echo "Normally you don't have to provide the fs type, but sometimes you need to distinguish specific types (eg. FAT types)"

read -p "Press enter to continue"
echo ""

mkdir -p /media/usb
mount -t ext4 "${FD_FILE}1" /media/usb/

echo "Note that we can view the mounted fs with \"mount\""
mount | grep /media/usb

echo "Now we'll unmount the fs by using umount and specifying the mount point (/media/usb/)."
echo ""

umount /media/usb/

echo "Notice now that mount doesn't provide the mounted fs anymore"
mount | grep /media/usb
