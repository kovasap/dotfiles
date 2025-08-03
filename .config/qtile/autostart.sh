#!/bin/bash

nohup copyq &

nm-applet &

udiskie &

# https://github.com/Martchus/syncthingtray/issues/357#issuecomment-3148557080
nohup syncthingtray-qt6 --single-instance &

# Mount all drives when starting up
udiskie-mount -a

# Only try to run if it isn't already running
if ! pgrep -x "xfce-polkit" > /dev/null
then
/usr/lib/xfce-polkit/xfce-polkit &
fi

xinput --set-prop "pointer:Corsair CORSAIR SABRE RGB PRO Gaming Mouse" "libinput Accel Profile Enabled" 0, 1, 0
xinput --set-prop "pointer:Corsair CORSAIR SABRE RGB PRO Gaming Mouse" "libinput Accel Speed" -0.2
