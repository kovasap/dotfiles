#!/bin/sh

/usr/share/goobuntu-desktop-files/xsecurelock.sh

# The lock screen resets my capslock/esc mapping, so we reset it here
xmodmap -e "clear lock"
xmodmap -e "keycode 9 = Caps_Lock NoSymbol Caps_Lock"
xmodmap -e "keycode 66 = Escape NoSymbol Escape"
