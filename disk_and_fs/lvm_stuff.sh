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
echo "We're going to use a 5GB partition from ${FD_FILE_A} and 10GB partition from ${FD_FILE_B}"
echo "We will create an LVM and then have two logical volumes of 10GB each that will use these partitions to illustrate the beauty of LVM"
echo "This script won't validate the above, so we ask you to verify. Make sure ${FD_FILE_A}1 has 5GB of space and ${FD_FILE_B}1 has 10GB of space"
echo ""

lsblk | grep "${FD_FILE_A:5}1"
lsblk | grep "${FD_FILE_B:5}1"
read -p "Press enter to continue"
echo ""

############## This comes after - skip for now
# echo "This script will use some common lvs cmds"
# echo -e "\n"

# echo "\"vgs\" shows the volume groups currently configured on the system"
# vgs
# echo -e "\n"
