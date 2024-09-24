#!/bin/bash

. ~/.profile  # necessary on Debian!
. ~/.xprofile

if [[ `hostname` = 'raspberrypi' ]]; then 
  exec /usr/bin/x-session-manager
  exit
fi

source ~/.bashrc
source ~/.xinitrc

qtile start -c /home/kovas/.config/qtile/config.py
