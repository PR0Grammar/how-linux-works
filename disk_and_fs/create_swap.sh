#! /usr/bin/env bash

set -euo pipefail

if [ "${EUID}" -ne 0 ]; then
	echo "Please run in sudio"
	exit 1
fi

FD_FILE=$(parted -l | sed -n '/SanDisk Cruzer Glide/{n;p}' | grep -Po '/dev/sd[a-z]')

if [ -z "${FD_FILE}" ]; then
	echo "Please plug in the flash drive"
	exit 1
fi

# Partition the disk
echo "Lets create a swap space!"
echo "If you haven't already, partition ${FD_FILE} with fdisk. The partition should be empty"
echo "We'll create the swap space in ${FD_FILE}1"

read -p "Press enter to continue"

# Creating the swap space

mkswap "${FD_FILE}1"

echo -e "\n"

# Swapon/swapoff
echo "Now lets use \"swapon\" to register the swap space with the kernel"
TOTAL_S=$(free | grep "Swap:" | grep -Po  "[0-9]+" | head -1)
echo "Current total swap space: ${TOTAL_S}"
swapon "${FD_FILE}1"
TOTAL_S_A=$(free | grep "Swap:" | grep -Po  "[0-9]+" | head -1)
echo "New total swap space: ${TOTAL_S_A}"
DELTA=$((TOTAL_S_A-TOTAL_S))
echo "Notice the increase, we added an additional ${DELTA} kB of swap space!"
echo "Now let's deallocate this from the pool using \"swapoff\""

swapoff "${FD_FILE}1"
TOTAL_S_B=$(free | grep "Swap:" | grep -Po  "[0-9]+" | head -1)
echo "Final total swap space: ${TOTAL_S_B}"

