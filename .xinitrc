# this changes the mouse sensitivity (assuming the mouse is device 9
# as shown by xinput --list --short)
# this is a matrix that transforms mouse coordinates to screen coordinates
# by default it is: (no change between coordinates)
# xinput --set-prop 9 154 0.1 0.0 0.0 0.0 0.1 0.0 0.0 0.0 1.0
# see https://askubuntu.com/questions/172972/configure-mouse-speed-not-pointer-acceleration
# xinput --set-prop 9 154 0.7 0.0 0.0 0.0 0.7 0.0 0.0 0.0 1.0

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

~/bin/setup-monitors.bash forked

# set background image
feh --bg-fill ~/wallpaper

# Start selfspy
rm ~/.selfspy/selfspy.pid.lock
nohup /home/kovas/.virtualenvs/photos_calendar_sync/bin/selfspy -n -v &> ~/.selfspy/selfspy.log &

# fix for gcert SSH_AUTH_SOCK not defined problem
eval $(ssh-agent)
