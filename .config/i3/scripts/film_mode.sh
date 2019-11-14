#!/bin/bash

ON=on
OFF=off

function usage() {
	echo "$0: turn on or off the film mode, i.e. killall disturbing apps, autolock and notification daemon"
	echo "usage: $0 [on|off]"
  echo "if no argument is specified, try to guess whether film mode is on or off and toggle"
	exit 0
}

function on() {
  killall xautolock
  xset dpms 0
  # expire before pausing dunst so the notification does not show up at resume
  notify-send -i "vlc" -t "1900" -u "normal" -a "Film Mode" "On !"
  sleep 2
  # pause dunst, continue receive notification
  killall -SIGUSR1 dunst
}

function off() {
  # resume dunst, show all dangling notifications
  killall -SIGUSR2 dunst
  xautolock -time 9 -locker ~/.config/i3/lock/lock.sh &
  xset dpms 600
  notify-send -i "vlc" -t "1900" -u "normal" -a "Film Mode" "Off !"
}

if [ "${1}" == "${ON}" ]; then
  on
elif [ "${1}" == "${ON}" ]; then
  off
else
  pgrep xautolock &>/dev/null
  if [ $? == "0" ]; then
    on
  else
    off
  fi
fi
