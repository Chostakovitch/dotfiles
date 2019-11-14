#!/bin/bash

LAPTOP="laptop"
DESKTOP="desk"
DEST_FILENAME="dest"

# Check if a file has been modified and deleted since last commit, if so perform an action
# $1 : path of file
# $2 : command to launch if file has been created of modifed
# $3 : command to launch if file has been deleted
function check_copy() {
	echo "$changed_files" | grep --quiet "$1"
	if [ $? == "0" ]; then
		echo "$changed_files" | cut -f 1 | grep --quiet "R"
		if [ $? == "0" ]; then
			echo "* $1 has been removed"
			echo "* Running $3" && eval "$3"
		else
			echo "* Changes detected in $1"
			echo "* Running $2" && eval "$2"
		fi
	fi
}

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

changed_files="$(git --git-dir=$HOME/.cfg/ --work-tree=$HOME diff-tree -r --name-status --no-commit-id HEAD@{1} HEAD)"

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

echo -e "\n=== Copy changed configuration which resides in outer directory ==="
# Destination files are regular files
for f in `find ${CONFIG} -type f -name ${DEST_FILENAME}`; do
	DIR=`dirname "${f}"`
	DEST=`cat ${f}`
	# Get all files, either regular files or symlinks, which are not the destination file nor specific desktop/laptop files
	# This is because if desktop/laptop files exist, they already have a symlink pointing to them at this stage
	for config_file in `find ${DIR} -maxdepth 1 -mindepth 1 -not \( -name "*.${LAPTOP}" -o -name "*.${DESKTOP}" -o -name "${DEST_FILENAME}" \)`; do
		# Now copy to destination
		check_copy "${config_file}" "sudo cp ${config_file} ${DEST}" "sudo rm ${DEST}"
	done
done

merge_config="polybar i3"
for m in $merge_config; do
	echo -e "\n=== Generate ${m} config file ==="
	cp ${CONFIG}/${m}/config_common ${CONFIG}/${m}/config
	for f in `find ${CONFIG}/${m}/config.d -type f -name "${1}"`; do
		echo "Found ${f}, add to regular config file"
		cat "${f}" >> ${CONFIG}/${m}/config
	done
done

# Reload i3 configuration
i3-msg reload && echo "Successfully reloaded i3 config"
