# This changes the mouse sensitivity via a matrix that transforms mouse
# coordinates to screen coordinates.
# see https://askubuntu.com/questions/172972/configure-mouse-speed-not-pointer-acceleration
xinput --set-prop "pointer:Razer Razer DeathAdder Essential White Edition" "Coordinate Transformation Matrix" 0.4 0.0 0.0 0.0 0.4 0.0 0.0 0.0 1.0

# natural scrolling for thinkpad touchpad
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Natural Scrolling Enabled' 1

# auto lock screen using securelock after a certain time
# https://g3doc.corp.google.com/company/teams/i3/index.md?cl=head#locking-your-screen
# exec --no-startup-id env LOCKED_BY_SESSION_IDLE=true xautolock -time 1 -locker /usr/share/goobuntu-desktop-files/xsecurelock.sh
xautolock -time 10 -locker ~/bin/screensaver.sh &

# change brightness and color temperature
redshift -O 3000 -b 0.9:0.9

# hide mouse pointer after idling
# unclutter -idle 10 -root -grab &

# Start selfspy
pkill selfspy
rm ~/.selfspy/selfspy.pid.lock
nohup /home/kovas/.virtualenvs/photos_calendar_sync/bin/selfspy -n -v &> ~/.selfspy/selfspy.log &

# Start ActivityWatch
(cd ~/activitywatch; nohup poetry run aw-qt &> ~/activitywatch.log &)

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
