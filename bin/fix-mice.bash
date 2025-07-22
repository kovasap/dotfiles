#!/bin/bash

# This changes the mouse sensitivity via a matrix that transforms mouse
# coordinates to screen coordinates.
# see https://askubuntu.com/questions/172972/configure-mouse-speed-not-pointer-acceleration
xinput --set-prop "pointer:Razer Razer DeathAdder Essential White Edition" "Coordinate Transformation Matrix" 0.4 0.0 0.0 0.0 0.4 0.0 0.0 0.0 1.0
# The coordinate transformation matrix sometimes leads to to the cursor jumping to the top corner, 
# see https://unix.stackexchange.com/a/639730/537424.
# Use of acceleration with the selected "flat" profile works to get around
# this, since I don't care about using acceleration myself.
# Closer to 0 is more sensitive.
xinput --set-prop "pointer:Corsair CORSAIR SABRE RGB PRO Gaming Mouse" "libinput Accel Speed" -0.2
xinput --set-prop "pointer:Corsair CORSAIR SABRE RGB PRO Gaming Mouse" "libinput Accel Profile Enabled" 0, 1, 0
xinput --set-prop "pointer:Logitech G502 HERO Gaming Mouse" "libinput Accel Speed" -0.5
xinput --set-prop "pointer:Logitech G502 HERO Gaming Mouse" "libinput Accel Profile Enabled" 0, 1, 0
xinput --set-prop "pointer:Razer Razer Naga V2 HyperSpeed" "libinput Accel Speed" -0.3
xinput --set-prop "pointer:Razer Razer Naga V2 HyperSpeed" "libinput Accel Profile Enabled" 0, 1, 0
xinput --set-prop "pointer:Corsair CORSAIR SLIPSTREAM WIRELESS USB Receiver" "libinput Accel Speed" -0.3
xinput --set-prop "pointer:Corsair CORSAIR SLIPSTREAM WIRELESS USB Receiver" "libinput Accel Profile Enabled" 0, 1, 0
# Need to do this loop and set by id because xinput cannot handle multiple
# devices with the same id
# See https://stackoverflow.com/questions/18755967/how-to-make-a-program-that-finds-ids-of-xinput-devices-and-sets-xinput-some-set/18756948#18756948
for id in `xinput --list|grep 'Corsair CORSAIR DARKSTAR RGB WIRELESS Gaming Mouse'|perl -ne 'while (m/id=(\d+)/g){print "$1\n";}'`; do
  notify-send -t 50000  "Mouse with id $(id) fixed"
  xinput --set-prop $id "libinput Accel Speed" -0.25
  xinput --set-prop $id "libinput Accel Profile Enabled" 0, 1, 0
done
