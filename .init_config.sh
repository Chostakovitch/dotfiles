#!/bin/bash

LAPTOP="laptop"
DESKTOP="desk"

function usage() {
	echo "$0: creates symlink for divergent config between laptop and desktop (e.g. battery management...)"
	echo "usage: $0 [${LAPTOP}|${DESKTOP}]"
	exit 0
}

if [ -z "{$1}" ] || [ "$#" -ne 1 ]; then
	usage
fi

if [ "${1}" != "${LAPTOP}" ] && [ "${1}" != "${DESKTOP}" ]; then
	usage
fi

for f in `find ~/.config -type f -name "*.${1}"`; do
	echo "Symlinking to ${f}..."
	ln -sf ${f} ${f%.*}
done