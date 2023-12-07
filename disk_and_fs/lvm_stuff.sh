#! /usr/bin/env bash

set -euo pipefail

if [ "${EUID}" -ne 0 ]; then
	echo "Please run with sudo"
	exit 1
fi

# Read that we have both flash drive devices connected
FD_FILE_A=$(parted -l | sed -n '/SanDisk Cruzer Glide/{n;p}' | grep -Po '/dev/sd[a-z]')
FD_FILE_B=$(parted -l | sed -n '/Kingston DataTraveler 2.0/{n;p}' | grep -Po '/dev/sd[a-z]')

if [ -z "${FD_FILE_A}" ] || [ -z "${FD_FILE_B}" ]; then
	echo "Missing a flash drive. Make sure both are connected"
	exit 1
fi

# Ensure we have the right space in each partition
echo "We're going to use a 6GB partition from ${FD_FILE_A} and 10GB partition from ${FD_FILE_B}"
echo "We will create an LVM and then have two logical volumes of 8GB each that will use these partitions to illustrate the beauty of LVM"
echo "This script won't validate the above, so we ask you to verify. Make sure ${FD_FILE_A}1 has slightly more than 6GB of space and ${FD_FILE_B}1 has slightly more than 10GB of space (remember that PVs are divided into PEs, so we need to ensure we have just the right amount of space)"
echo ""

lsblk | grep "${FD_FILE_A:5}1"
lsblk | grep "${FD_FILE_B:5}1"
read -p "Press enter to continue"
echo ""

# Create the volume group
echo "Cool. Now we'll create a volume group with \"vgcreate\". To use this command, you have to specify a name and a initial physical volume"
echo "We will name it 'myvg' and have ${FD_FILE_A}1 as the inital physical volume"
echo ""

vgcreate --force myvg "${FD_FILE_A}1"

echo ""
echo "Now you'll see the new volume group using \"vgs\""
echo ""
vgs

# Add another physical volume to the new volume group
echo "Now let's add another physcial volume using \"vgextend\". Similar to \"vgcreate\", we specify a device (our case - ${FD_FILE_B}1 and volume group myvg"
echo ""

vgextend myvg "${FD_FILE_B}1"

echo ""
echo "Running \"vgs\", we now we 2 PVs in the volume group"

vgs


read -p "Press enter to continue"

# Create logical volume
echo "Now that we have our physical volumes linked to the volume group, let's create the logical volumes"
echo "\"lvcreate\" is used to do this. We need to specify the size of the LV and the type"
echo "We can specify either the size in bytes OR the number of physical extents (PE). We'll use size in bytes (8G each)"
echo "For type, we'll use \"linear\" which is the simplest type that doesn't include redundancy or other special features"
echo ""

lvcreate --size 8g --type linear -n mylv1 myvg
lvcreate --size 8g --type linear -n mylv2 myvg

echo "We can verify that we created the LVs with \"lvs\""
echo ""

lvs

echo ""
echo "We can also view the total/available/used PE with \"vgdisplay myvg\""
echo ""

vgdisplay myvg

read -p "Press enter to continue"

# Maniuplate logical volumes
echo "Now let's use the LVs by making a fs and mounting it."
echo "/dev/mapper will contain the symoblic links to the devices for the LVs. The device is specified in the format: /dev/mapper/<VG name>-<LV name>"
echo "For our case, the devices are /dev/mapper/myvg-mylv1 and /dev/mapper/myvg-mylv2"
echo ""
 
mkfs -t ext4 /dev/mapper/myvg-mylv1
mkdir -p /mnt_tmp
mount /dev/mapper/myvg-mylv1 /mnt_tmp
df /mnt_tmp
umount /mnt_tmp

echo ""

read -p "Press enter to continue"

# Removing logical volumes
echo "Now let's remove the mylv2 LV using \"lvremove\""
lvremove myvg/mylv2

echo ""

# Resizing logical volumes and filesystems
echo "We can now resize mylv1 using \"lvresize\""
echo "Note that we need to resize both the logical volume AND the filesystem inside it"
echo "Like the command to make the LV, you can specify either PE or byte size. We'll add 3GB"
echo "To resize the file system inside, you can use \"fsadm\", but lvresize has a flag to do this for you (-r)!"
echo ""

lvresize -r --size +3g myvg/mylv1 

echo ""
read -p "Press enter to continue"

# Clean up
echo "That's it! Now lets remove the volume group"
vgremove myvg
