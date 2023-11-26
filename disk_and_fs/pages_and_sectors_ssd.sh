#! /usr/bin/env bash
set -euo pipefail


if [ "${EUID}" -ne 0 ]; then
	echo "Please run with sudo"
	exit 1
fi

# SSDs read blocks of data in units called pages (not VM pages).
# These reads can occur in blocks of 4096/8192 and the read must begin at a multiple of that size

# Where you start your partitions matters here to ensure we don't have addtional reads

echo -e "Observe a parition like /dev/sda1. Note the start\n"

parted -l

echo -e "If you run \"cat /sys/block/sda/sda1/start\", you get the start of the partition in unit of 512 bytes (multiple that number by 512 to get the start from \"parted -l \" above \n"

START=$(cat /sys/block/sda/sda1/start)

echo "Start(512 byte): ${START}"
echo "Real start (as listed in parted): $(($START*512))"

# If our SSD reads in blocks of 4096, there are 8 sectors (the 512-byte blocks) in a page. So if the number printed by the above command is divisble by 8, we have an optimal read (ie. no additional reads on another page). Alternatively (maybe more intutive) is to multiply by 512 to get the 'real' byte start, then divide by 4096.
