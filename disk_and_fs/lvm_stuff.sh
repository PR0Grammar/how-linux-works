#! /usr/bin/env bash

set -euo pipefail

if [ "${EUID}" -ne 0 ]; then
	echo "Please run with sudo"
	exit 1
fi

echo "This script will use some common lvs cmds"
echo -e "\n"

echo "\"vgs\" shows the volume groups currently configured on the system"
vgs
echo -e "\n"
