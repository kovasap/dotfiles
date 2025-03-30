#!/bin/bash

if [[ `hostname` = 'raspberrypi' ]]; then 
  echo 'no xinitrc'
  exit
fi

export CALIBRE_USE_DARK_PALETTE=1

# Make shift-caps enable caps lock (and just caps escape instead)
setxkbmap -option "caps:escape_shifted_capslock"

xclickroot -r ~/bin/run-xmenu.sh &

# This changes the mouse sensitivity via a matrix that transforms mouse
# coordinates to screen coordinates.
# see https://askubuntu.com/questions/172972/configure-mouse-speed-not-pointer-acceleration
xinput --set-prop "pointer:Razer Razer DeathAdder Essential White Edition" "Coordinate Transformation Matrix" 0.4 0.0 0.0 0.0 0.4 0.0 0.0 0.0 1.0
# The coordinate transformation matrix sometimes leads to to the cursor jumping to the top corner, 
# see https://unix.stackexchange.com/a/639730/537424.
# Use of acceleration with the selected "flat" profile works to get around
# this, since I don't care about using acceleration myself.
xinput --set-prop "pointer:Corsair CORSAIR SABRE RGB PRO Gaming Mouse" "libinput Accel Speed" -0.2
xinput --set-prop "pointer:Corsair CORSAIR SABRE RGB PRO Gaming Mouse" "libinput Accel Profile Enabled" 0, 1, 0

# https://unix.stackexchange.com/questions/332573/how-to-make-xinput-commands-permanent
# Map mouse button 8 (top right) to button 2 (top left) and vice versa, run when changes to the mouse occur
while true; do
  NEW_MOUSEID=$(xinput | grep "Razer DeathAdder" | grep -o -E '[0-9]+' | head -n 1)
    if [ "$MOUSEID" != "$NEW_MOUSEID" ]; then
      MOUSEID=$NEW_MOUSEID
      if [ "$MOUSEID" != "" ]; then
        # xinput --set-button-map $MOUSEID 1 8 3 4 5 6 7 2 9 10 11 12
        xinput --set-prop "pointer:Razer Razer DeathAdder Essential White Edition" "Coordinate Transformation Matrix" 0.4 0.0 0.0 0.0 0.4 0.0 0.0 0.0 1.0
      fi
  fi
  sleep 2
done &

# natural scrolling for thinkpad touchpad
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Natural Scrolling Enabled' 1

# change brightness and color 
redshift -x
redshift -O 4000 # -b 0.9:0.9

# Start selfspy
# (pkill selfspy; rm ~/.selfspy/selfspy.pid.lock; cd ~/autojournal; nohup poetry run selfspy -n -v &> ~/.selfspy/selfspy.log &)

# Start ActivityWatch
# If activitywatch was installed from source:
# (sleep 5; cd ~/activitywatch; nohup poetry run aw-qt &> ~/activitywatch.log &) &
# If activitywatch was installed normally
# (https://docs.activitywatch.net/en/latest/getting-started.html):
# (sleep 5; nohup ~/activitywatch/aw-qt &> ~/activitywatch.log &) &

# Start auto screenshot utility.
# nohup /home/kovas/.virtualenvs/auto_screenshooter/bin/auto-screenshooter &> ~/auto_screenshooter_data/auto_screenshooter.log &

# Start copyq
nohup copyq &

nm-applet &

udiskie &

/usr/lib/xfce-polkit/xfce-polkit &

# Mount Google Drive
# See https://www.ostechnix.com/how-to-mount-google-drive-locally-as-virtual-file-system-in-linux/
# rclone mount --allow-non-empty googledrive: ~/google-drive/ &
# To unmount, do `fusermount -uz /data`

# Set up xrandr daemon for managing monitors.
# nohup /usr/lib/x86_64-linux-gnu/cinnamon-settings-daemon/csd-xrandr &
# TODO rewrite this script so it doesn't break on first launch.
# ~/bin/setup-monitors.bash forked

export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.poetry/bin:$PATH:$HOME/.cargo/bin:$HOME/google_dotfiles:/usr/local/bin"

# set background image
feh --bg-fill ~/wallpaper

# fix for gcert SSH_AUTH_SOCK not defined problem
eval $(ssh-agent)

if [[ `hostname` = 'frostyarch' ]]; then 
  qtile start
fi
