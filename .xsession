#!/bin/sh
. ~/.profile  # necessary on Debian!
. ~/.xprofile
. ~/.xinitrc
# remove state file to avoid getting xmonad confused about number of monitors
rm ~/.xmonad/xmonad.state
exec xmonad
