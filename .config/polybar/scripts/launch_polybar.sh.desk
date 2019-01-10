#!/usr/bin/env bash

names=("chostybottombar" "chostytopbar")
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
if type "xrandr"; then
  monitors=$(xrandr --query | grep " connected" | cut -d" " -f1)
  monarray=($monitors)
	for name in ${names[@]}; do
	  MONITOR=${monarray[1]} polybar -q --reload ${name} &
  done
else
  polybar --reload ${name} &
fi