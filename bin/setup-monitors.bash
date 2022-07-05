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
# export DISPLAY=:1
export XAUTHORITY=/home/kovas/.Xauthority

outputs=('DP-2' 'DP-1' 'DP-1-8' 'DP-2-1' 'DP-1-2' 'DP-2-2' 'DP-1-1' 'HDMI-1' 'DP2' 'DP1' 'HDMI1' 'DP1-1' 'DP1-8' 'DP-3-8' 'DP-3-1' 'DP-3')
xrandr_output=$(xrandr)

main_output="eDP-1"

reset_cmd="xrandr --output $main_output --primary --auto"
for o in "${outputs[@]}"; do
    reset_cmd="$reset_cmd --output $o --off"
done
echo $reset_cmd
eval $reset_cmd

echo $xrandr_output
# xrandr_cmd="xrandr --output $main_output --scale 0.5x0.5 --auto"
xrandr_cmd="xrandr --output $main_output --scale 1x1 --mode 1920x1200"
if [ "$2" == "rotated" ]; then
    xrandr_cmd="$xrandr_cmd --rotate left"
else
    xrandr_cmd="$xrandr_cmd --rotate normal"
fi
relative_loc="--right-of $main_output"
# Make second screen primary
relative_loc="$relative_loc --primary"
for o in "${outputs[@]}"; do
    connected=$(echo "$xrandr_output" | grep "^$o connected")
    echo $o
    echo $connected
    if [ -n "$connected" ]; then
        # See https://unix.stackexchange.com/a/502883
        # mouse_flicker_fix="--scale 0.9999x0.9999"
        mouse_flicker_fix=""
        xrandr_cmd="$xrandr_cmd --output $o $mouse_flicker_fix --auto $relative_loc"
        relative_loc="--right-of $o"
    fi
done
# Turn off all other screens
for o in "${outputs[@]}"; do
    connected=$(echo "$xrandr_output" | grep "^$o connected")
    echo $o
    echo $connected
    if [ -z "$connected" ]; then
        xrandr_cmd="$xrandr_cmd --output $o --off"
    fi
done

pkill compton
echo $xrandr_cmd
eval $xrandr_cmd
/home/kovas/bin/run-compton.bash
feh --bg-fill /home/kovas/wallpaper
# Reset qtile.  Could also use qtile-cmd cli for this but I don't know how.
xdotool key 'ctrl+super+q'
