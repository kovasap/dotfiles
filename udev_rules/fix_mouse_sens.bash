#!/bin/bash

# This script runs in the background when given no arguments, otherwise runs
# normally.  See https://unix.stackexchange.com/questions/612686/udev-not-running-xinput-command-inside-script
if [[ $1 ]]
then
  echo foreground >> /tmp/testt.log
  xenv="env DISPLAY=:0 XAUTHORITY=/home/kovas/.Xauthority"
  $xenv /usr/bin/xinput --set-prop "pointer:Razer Razer DeathAdder Essential White Edition" "Coordinate Transformation Matrix" 0.4 0.0 0.0 0.0 0.4 0.0 0.0 0.0 1.0
else
  echo background >> /tmp/testt.log
  /usr/local/bin/fix_mouse_sens.bash an_argument &
fi
