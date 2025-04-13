#!/bin/bash

# Start copyq
nohup copyq &

nm-applet &

udiskie &

# Mount all drives when starting up
udiskie-mount -a

/usr/lib/xfce-polkit/xfce-polkit &

xinput --set-prop "pointer:Corsair CORSAIR SABRE RGB PRO Gaming Mouse" "libinput Accel Profile Enabled" 0, 1, 0
xinput --set-prop "pointer:Corsair CORSAIR SABRE RGB PRO Gaming Mouse" "libinput Accel Speed" -0.2
