#!/bin/bash

if [[ `hostname` = 'raspberrypi' ]]; then 
  echo 'no xinitrc'
  exit
fi

export CALIBRE_USE_DARK_PALETTE=1

# Make shift-caps enable caps lock (and just caps escape instead)
setxkbmap -option "caps:escape_shifted_capslock"

# Spawn xmenu when right clicking on the "desktop".
# When this program starts, it messes with qtile's ability to get the right
# click signal, so i'm disabling it for now (since I get the same effect from
# right clicking on the bar anyway).
# See details at https://www.reddit.com/r/qtile/comments/1kltu6g/mod_right_click_button3_cannot_be_bound_to_an/
# xclickroot -r ~/bin/run-xmenu.sh &

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

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
xinput --set-prop "pointer:Logitech G502 HERO Gaming Mouse" "libinput Accel Speed" -0.5
xinput --set-prop "pointer:Logitech G502 HERO Gaming Mouse" "libinput Accel Profile Enabled" 0, 1, 0
xinput --set-prop "pointer:Razer Razer Naga V2 HyperSpeed" "libinput Accel Speed" -0.3
xinput --set-prop "pointer:Razer Razer Naga V2 HyperSpeed" "libinput Accel Profile Enabled" 0, 1, 0
xinput --set-prop "pointer:Corsair CORSAIR SLIPSTREAM WIRELESS USB Receiver" "libinput Accel Speed" -0.3
xinput --set-prop "pointer:Corsair CORSAIR SLIPSTREAM WIRELESS USB Receiver" "libinput Accel Profile Enabled" 0, 1, 0




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

# Mount Google Drive
# See https://www.ostechnix.com/how-to-mount-google-drive-locally-as-virtual-file-system-in-linux/
# rclone mount --allow-non-empty googledrive: ~/google-drive/ &
# To unmount, do `fusermount -uz /data`

# Set up xrandr daemon for managing monitors.
# nohup /usr/lib/x86_64-linux-gnu/cinnamon-settings-daemon/csd-xrandr &

export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.poetry/bin:$PATH:$HOME/.cargo/bin:$HOME/google_dotfiles:/usr/local/bin"

# Without this Qt 5 apps have way too big text.
export QT_FONT_DPI=96

# Prevent fullscreen games from minimizing
export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0

# This is necessary to get GreenWithEnvy to run
# Follow instructions at https://wiki.archlinux.org/title/Locale for en_US.UTF-8
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# set background image
feh --bg-fill ~/wallpaper

# fix for gcert SSH_AUTH_SOCK not defined problem
eval $(ssh-agent)

# See .config/qtile/autostart.sh for programs that are autostarted that used to
# be started here.  I moved them so that their icons would appear in the
# started qtile session.

if [[ `hostname` = 'frostyarch' ]]; then 
  qtile start
  sleep 1
  ~/bin/setup-monitors.bash forked
fi
