#!/bin/sh

updates_arch=$(checkupdates | wc -l)

if ! updates_aur=$(trizen -Su --aur --quiet | wc -l); then
    updates_aur=0
fi

updates=$(("$updates_arch" + "$updates_aur"))

if [ "$updates" -gt 0 ]; then
    echo "%{F#dd7777}%{F#ddd} $updates"
else
    echo "%{F#77dd77}%{F#ddd} 0"
fi
