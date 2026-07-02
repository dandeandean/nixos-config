#!/usr/bin/env bash
ISO_URL="https://channels.nixos.org/nixos-26.05/latest-nixos-minimal-x86_64-linux.iso"
ISO_SHA_URL="https://channels.nixos.org/nixos-26.05/latest-nixos-minimal-x86_64-linux.iso.sha256"

OUTPUT_DIR="temp"
ISO_PATH="${OUTPUT_DIR}/nixos.iso"
SHA_PATH="${OUTPUT_DIR}/nixos.sha"

if ! [ -e "$ISO_PATH" ] ; then
	echo "Getting the ISO"
	wget --https-only \
					-O "$ISO_PATH" \
					"$ISO_URL"
fi

if ! [ -e "$SHA_PATH" ] ; then
	echo "Getting the SHA"
	wget --https-only \
					-O "$SHA_PATH" \
					"$ISO_SHA_URL"
fi

SHASUM="$(sha256sum "${OUTPUT_DIR}/nixos.iso" | awk '{ print $1 }')"
#NATIVE_NAME="$(sha256sum "${OUTPUT_DIR}/nixos.iso" | awk '{ print $2 }')"
echo "Computed SHAsum: ${SHASUM}"

if ! grep -q "$SHASUM" "$SHA_PATH" ; then
	echo "The SHAs do not match!"
	exit 65
fi

echo "SHA Check passed!"
echo "ISO Available at $ISO_PATH"

