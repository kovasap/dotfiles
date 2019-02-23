# this changes the mouse sensitivity (assuming the mouse is device 9
# as shown by xinput --list --short)
# this is a matrix that transforms mouse coordinates to screen coordinates
# by default it is: (no change between coordinates)
# xinput --set-prop 9 154 0.1 0.0 0.0 0.0 0.1 0.0 0.0 0.0 1.0
# see https://askubuntu.com/questions/172972/configure-mouse-speed-not-pointer-acceleration
xinput --set-prop 9 154 0.7 0.0 0.0 0.0 0.7 0.0 0.0 0.0 1.0

# auto lock screen using securelock after a certain time
# https://g3doc.corp.google.com/company/teams/i3/index.md?cl=head#locking-your-screen
# exec --no-startup-id env LOCKED_BY_SESSION_IDLE=true xautolock -time 1 -locker /usr/share/goobuntu-desktop-files/xsecurelock.sh
xautolock -time 5 -locker /usr/share/goobuntu-desktop-files/xsecurelock.sh &

# set up multiple monitors
xrandr --output DP-2 --auto --output DP-4 --auto --right-of DP-2
