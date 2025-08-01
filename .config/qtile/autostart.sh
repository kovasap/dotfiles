#!/bin/bash

nohup copyq &

nm-applet &

udiskie &

# Only try to run if it isn't already running
if ! pgrep -x "syncthingtray-qt6" > /dev/null
then
nohup syncthingtray-qt6 &
fi

# Mount all drives when starting up
udiskie-mount -a

# Only try to run if it isn't already running
if ! pgrep -x "xfce-polkit" > /dev/null
then
/usr/lib/xfce-polkit/xfce-polkit &
fi

xinput --set-prop "pointer:Corsair CORSAIR SABRE RGB PRO Gaming Mouse" "libinput Accel Profile Enabled" 0, 1, 0
xinput --set-prop "pointer:Corsair CORSAIR SABRE RGB PRO Gaming Mouse" "libinput Accel Speed" -0.2
