# This changes the mouse sensitivity via a matrix that transforms mouse
# coordinates to screen coordinates.
# see https://askubuntu.com/questions/172972/configure-mouse-speed-not-pointer-acceleration
xinput --set-prop "pointer:Razer Razer DeathAdder Essential White Edition" "Coordinate Transformation Matrix" 0.4 0.0 0.0 0.0 0.4 0.0 0.0 0.0 1.0

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

# auto lock screen using securelock after a certain time
# https://g3doc.corp.google.com/company/teams/i3/index.md?cl=head#locking-your-screen
# exec --no-startup-id env LOCKED_BY_SESSION_IDLE=true xautolock -time 1 -locker /usr/share/goobuntu-desktop-files/xsecurelock.sh
# xautolock -time 10 -locker ~/bin/screensaver.sh &

# change brightness and color temperature
redshift -O 3000 -b 0.9:0.9

# hide mouse pointer after idling
# unclutter -idle 10 -root -grab &

# Start selfspy
(pkill selfspy; rm ~/.selfspy/selfspy.pid.lock; cd ~/autojournal; nohup poetry run selfspy -n -v &> ~/.selfspy/selfspy.log &)

# Start ActivityWatch
(sleep 5; cd ~/activitywatch; nohup poetry run aw-qt &> ~/activitywatch.log &) &

# Start auto screenshot utility.
nohup /home/kovas/.virtualenvs/auto_screenshooter/bin/auto-screenshooter &> ~/auto_screenshooter_data/auto_screenshooter.log &

# Start copyq
nohup copyq &

# Mount Google Drive
# See https://www.ostechnix.com/how-to-mount-google-drive-locally-as-virtual-file-system-in-linux/
rclone mount --allow-non-empty googledrive: ~/google-drive/ &
# To unmount, do `fusermount -uz /data`

# Set up xrandr daemon for managing monitors.
# nohup /usr/lib/x86_64-linux-gnu/cinnamon-settings-daemon/csd-xrandr &
~/bin/setup-monitors.bash forked

# set background image
feh --bg-fill ~/wallpaper

# fix for gcert SSH_AUTH_SOCK not defined problem
eval $(ssh-agent)
