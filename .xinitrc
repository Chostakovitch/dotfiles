xrandr --output eDP-1 --auto --output HDMI-2 --auto --scale 2x2 --above eDP-1
xrdb -merge ~/.Xresources
exec i3
