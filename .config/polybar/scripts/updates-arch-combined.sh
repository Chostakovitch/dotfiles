#!/bin/sh

connect=$(ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` &> /dev/null)
if [ $? -eq 0 ]; then
    updates_arch=$(/usr/bin/checkupdates | wc -l)
    updates_aur=$(/usr/bin/checkupdates-aur | wc -l)
    updates=$(("$updates_arch" + "$updates_aur"))
    if [ "$updates" -gt 0 ]; then
        echo "%{F#dd7777}%{F#ddd} $updates_arch | $updates_aur"
    else
        echo "%{F#77dd77}%{F#ddd} 0"
    fi
else
    echo "%{F#77dd77}%{F#ddd} Offline"
fi
