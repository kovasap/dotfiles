#!/bin/sh
. ~/.profile  # necessary on Debian!
. ~/.xprofile
. ~/.xinitrc
exec xmonad
