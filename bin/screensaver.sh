#!/bin/sh

if [[ $(hostname) == 'frostyarch' ]]; then
  xset dpms force standby
else
  /usr/share/goobuntu-desktop-files/xsecurelock.sh
fi
