#!/usr/bin/bash

# see https://tyler.vc/auto-monitor-detection-on-linux for source

# Need to also add file /etc/udev/rules.d/monitor-detect.rules with contents:
# ACTION=="change", RUN+="/home/kovas/bin/setup-monitors.bash"

# udev will wait for our script to finish before the monitor is available
# for use, so we will use the `at` command to run our command again as
# another user:
if [ "$1" != "dry_run" ]; then
    if [ "$1" != "forked" ]; then
        echo "$(dirname $0)/$(basename $0) forked" | at now
        exit
    fi
fi

# udev runs as root, so we need to tell it how to connect to the X server:
# export DISPLAY=:1
export XAUTHORITY=/home/kovas/.Xauthority

# order matters, outputs will be laid out left to right
outputs=('DP-2' 'DP-1' 'DP-1-8' 'DP-2-8' 'DP-2-1' 'DP-1-2' 'DP-2-2' 'DP-1-1' 'HDMI-1' 'DP2' 'DP1' 'HDMI1' 'DP1-1' 'DP1-8' 'DP-3-1' 'DP-3-8' 'DP-3' 'DP-0.8' 'DP-4' 'DP-4.8' 'DP-0' 'HDMI-0')
xrandr_output=$(xrandr)

if [[ $(hostname) == 'frostyarch' ]]; then
    echo 'frostyarch'
    main_output="DP-4.8"
    main_output_config="--auto"
else
    main_output="eDP-1"
    main_output_config="--scale 1x1 --mode 1920x1200"
    other_output_config='--mode 2560x1440'
fi

reset_cmd="xrandr --output $main_output --primary --auto"
for o in "${outputs[@]}"; do
    reset_cmd="$reset_cmd --output $o --off"
done
echo "Resetting with..."
echo $reset_cmd
if [ "$1" != "dry_run" ]; then
    eval $reset_cmd
fi

echo $xrandr_output
xrandr_cmd="xrandr --output $main_output $main_output_config"
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
    if [ "$o" != "$main_output" ]; then
        if [ -n "$connected" ]; then
            # See https://unix.stackexchange.com/a/502883
            # mouse_flicker_fix="--scale 0.9999x0.9999"
            mouse_flicker_fix=""
            if [ "$o" == "DP-0" ]; then
               other_output_config='--mode 2560x1440 --rate 144'
            elif [ "$o" == "HDMI-0" ]; then
               other_output_config='--mode 1920x1080'
            else 
               other_output_config='--auto'
            fi
            xrandr_cmd="$xrandr_cmd --output $o $mouse_flicker_fix $other_output_config $relative_loc"
            relative_loc="--right-of $o"
        fi
    fi
done
# Turn off all other screens
for o in "${outputs[@]}"; do
    connected=$(echo "$xrandr_output" | grep "^$o connected")
    if [ -z "$connected" ]; then
        xrandr_cmd="$xrandr_cmd --output $o --off"
    fi
done

echo "Starting with..."
echo $xrandr_cmd
if [ "$1" != "dry_run" ]; then
    pkill picom 
    eval $xrandr_cmd
    feh --bg-fill ~/wallpaper
    # Reset qtile by sending the right key command.  
    # This must match the command in the qtile config file. 
    # Could also use qtile-cmd cli for this but I don't know how.
    xdotool key 'ctrl+super+Escape'
    picom
fi
