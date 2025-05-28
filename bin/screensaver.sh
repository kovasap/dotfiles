#!/bin/sh

if [[ $(hostname) == 'frostyarch' ]]; then
  # See https://wiki.archlinux.org/title/Display_Power_Management_Signaling#Runtime_settings
  sleep 1
  xset dpms force standby
else
  /usr/share/goobuntu-desktop-files/xsecurelock.sh
fi
