#!/usr/bin/env bash
set -e
ISO_PATH="/home/ddd/git/nixos-config/hack/primordial-soup/temp/nixos.iso"
DEV_PATH="/dev/sda"

if [ -e "$ISO_PATH" ] && [ -e "$DEV_PATH" ] ; then
	echo "Flashing drive"
	echo "Destroying $DEV_PATH"
	sudo dd if="${ISO_PATH}" \
		of="${DEV_PATH}" \
		bs=4M \
		status=progress \
		oflag=sync
else
	echo "The Targets do not exist!"
fi

sync
