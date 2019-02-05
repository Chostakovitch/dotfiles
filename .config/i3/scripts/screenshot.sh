#!/bin/bash

path="$SCREENSHOT_PATH"
output=`date +${path}/%Y-%m-%d_%H:%M:%S.jpg`
if [ ! -d "${path}" ]; then
	mkdir "${path}"
fi

touch "${output}"
maim -sl --color=0.6,0.4,0.2,0.2 -f jpg -u -m 9 -b 5 > "${output}"