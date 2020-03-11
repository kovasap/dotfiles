#!/bin/sh
. ~/.profile  # necessary on Debian!
. ~/.xprofile
# remove state file to avoid getting xmonad confused about number of monitors
rm ~/.xmonad/xmonad.state
exec xmonad
