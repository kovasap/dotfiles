#!/bin/bash

. ~/.profile  # necessary on Debian!
. ~/.xprofile

if [[ `hostname` = 'raspberrypi' ]]; then 
  exec /usr/bin/x-session-manager
  exit
fi

export QT_FONT_DPI = 192

# remove state file to avoid getting xmonad confused about number of monitors
# rm ~/.xmonad/xmonad.state
# exec xmonad
exec /home/kovas/qtile/qtile-venv-entry
