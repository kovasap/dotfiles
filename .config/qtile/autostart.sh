#!/bin/bash

# Start copyq
nohup copyq &

nm-applet &

udiskie &

# Mount all drives when starting up
udiskie-mount -a

/usr/lib/xfce-polkit/xfce-polkit &
