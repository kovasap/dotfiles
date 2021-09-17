#!/usr/bin/bash

# see https://tyler.vc/auto-monitor-detection-on-linux for source

# Need to also add file /etc/udev/rules.d/monitor-detect.rules with contents:
# ACTION=="change", RUN+="/home/kovas/bin/setup-monitors.bash"

# udev will wait for our script to finish before the monitor is available
# for use, so we will use the `at` command to run our command again as
# another user:
if [ "$1" != "forked" ]; then
    echo "$(dirname $0)/$(basename $0) forked" | at now
    exit
fi

# udev runs as root, so we need to tell it how to connect to the X server:
export DISPLAY=:0
export XAUTHORITY=/home/kovas/.Xauthority

# Find out the device path to our graphics card:
cardPath=/sys/$(udevadm info -q path -n /dev/dri/card0)

outputs=('DP-2' 'DP-1' 'DP-1-1' 'DP-2-1' 'DP-1-2' 'DP-2-2' 'HDMI-1')
xrandr_output=$(xrandr)

reset_cmd="xrandr --output eDP-1 --primary --auto"
for o in "${outputs[@]}"; do
    reset_cmd="$reset_cmd --output $o --off"
done
echo $reset_cmd
eval $reset_cmd

echo $xrandr_output
xrandr_cmd="xrandr --output eDP-1 --primary --auto"
relative_loc="--left-of eDP-1"
for o in "${outputs[@]}"; do
    connected=$(echo "$xrandr_output" | grep "^$o connected")
    echo $o
    echo $connected
    if [ -n "$connected" ]; then
        xrandr_cmd="$xrandr_cmd --output $o --auto $relative_loc"
        relative_loc="--left-of $o"
    else
        xrandr_cmd="$xrandr_cmd --output $o --off"
    fi
done

pkill compton
echo $xrandr_cmd
eval $xrandr_cmd
/home/kovas/bin/run-compton.bash
feh --bg-fill /home/kovas/wallpaper
# Reset qtile.  Could also use qtile-cmd cli for this but I don't know how.
xdotool key 'ctrl+super+r'
