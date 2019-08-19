#!/usr/bin/bash

# see https://tyler.vc/auto-monitor-detection-on-linux for source

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

# TODO use for loop here
# Detect if the monitor is connected and, if so, the monitor's ID:
conHdmi=$(xrandr | grep '^HDMI-1 connected')
echo $conHdmi
conDP2=$(xrandr | grep '^DP-2 connected')
echo $conDP2
conDP1=$(xrandr | grep '^DP-1 connected')
echo $conDP1

# The useful part: check what the connection status is, and run some other commands
xrandr_cmd="xrandr --output eDP-1 --primary --auto"
if [ -n "$conHdmi" -a -n "$conDP2" ]; then
    xrandr_cmd="$xrandr_cmd --output HDMI-1 --auto --above eDP-1 --output DP-2 --right-of HDMI-1"
elif [ -n "$conHdmi" ]; then
    xrandr_cmd="$xrandr_cmd --output HDMI-1 --auto --left-of eDP-1"
elif [ -n "$conDP2" ]; then
    xrandr_cmd="$xrandr_cmd --output DP-2 --auto --right-of eDP-1"
elif [ -n "$conDP1" ]; then
    xrandr_cmd="$xrandr_cmd --output DP-1 --auto --right-of eDP-1"
fi

pkill compton
xrandr --auto
echo $xrandr_cmd
eval $xrandr_cmd
~kovas/bin/run-compton.bash
