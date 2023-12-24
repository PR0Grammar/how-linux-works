#! /usr/bin/env bash

echo "During boot, most Linux distros hide boot diagnostics with splash screens"
echo "The best way to view the the kernel's boot and runtime diagnostics is with \"jorunalctl -k\" which shows the logs from the current boot. For previous boots, you can use -b"

echo ""
echo "The Linux kernel init steps are:"
echo "CPU inspection"
echo "Memory inspection"
echo "Device bus discvoery"
echo "Device discovery"
echo "Auxiliary kernel subsystem setup (eg. networking)"
echo "Root fs mount"
echo "Usper space start"

# User space spin up
echo ""
echo "The first user-space process starts up as init"
echo ""

journalctl -k | grep "as init process"

# Kernel Params
echo "The kernel receieves a set of text-based kernel params containing a few additional system detail."
echo "You can view the params passed to your system's currently running kernel by looking at \"/proc/cmdline\""
echo ""

cat /proc/cmdline


