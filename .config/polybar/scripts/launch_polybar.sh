#!/usr/bin/env bash

names=("chostybottombar" "chostytopbar")
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
if type "xrandr"; then
  for monitor in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    for name in ${names[@]}; do
      MONITOR=${monitor} polybar -q --reload ${name} &
    done
  done
else
  polybar --reload ${name} &
fi