#!/bin/bash

LAPTOP="laptop"
DESKTOP="desk"
DEST_FILENAME="dest"

function usage() {
	echo "$0: creates symlink for divergent config between laptop and desktop (e.g. battery management...) and copy configuration to external locations"
	echo "usage: $0 [${LAPTOP}|${DESKTOP}]"
	exit 0
}

# Use XDG_CONFIG_HOME if defined, default otherwise
CONFIG=${XDG_CONFIG_HOME:-$HOME/.config}

# Check that there is one matching argument
if [ -z "{$1}" ] || [ "$#" -ne 1 ]; then
	usage
fi

if [ "${1}" != "${LAPTOP}" ] && [ "${1}" != "${DESKTOP}" ]; then
	usage
fi

echo "=== Create symlink to *.${1} regular files ==="
# Take all specific files and create a symlink pointing to it without the extension
# This file will be used by applications
for f in `find ${CONFIG} -type f -name "*.${1}"`; do
	echo "Create symlink to ${f}..."
	ln -sf ${f} ${f%.*}
done

# Take care of config files at home level, outside ${CONFIG} (e.g. Xresources)
for f in `find ${HOME} -maxdepth 1 -mindepth 1 -type f -name "*.${1}"`; do
	echo "Create symlink to ${f}..."
	ln -sf ${f} ${f%.*}
done

echo -e "\n=== Copy configuration which resides in outer directory ==="
# Destination files are regular files
for f in `find ${CONFIG} -type f -name ${DEST_FILENAME}`; do
	DIR=`dirname "${f}"`
	DEST=`cat ${f}`
	# Get all files, either regular files or symlinks, which are not the destination file nor specific desktop/laptop files
	# This is because if desktop/laptop files exist, they already have a symlink pointing to them at this stage
	for config_file in `find ${DIR} -maxdepth 1 -mindepth 1 -not \( -name "*.${LAPTOP}" -o -name "*.${DESKTOP}" -o -name "${DEST_FILENAME}" \)`; do
		# Now copy to destination
		echo "Copying ${config_file} to ${DEST}..."
		sudo cp ${config_file} ${DEST}
	done
done