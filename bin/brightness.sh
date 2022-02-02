#!/bin/sh

# This might be required:
# sudo chmod a+rw /sys/class/backlight/intel_backlight/brightness
# this directory is a symlink on my machine:
KEYS_DIR=/sys/class/backlight/intel_backlight
INC=10
MUL=2
 
test -d $KEYS_DIR || exit 0
 
MIN=1
MAX=$(cat $KEYS_DIR/max_brightness)
VAL=$(cat $KEYS_DIR/brightness)
 
if [ "$1" = down ]; then
# VAL=$((VAL-$INC))
  VAL=$((VAL*2/3))
else
# VAL=$((VAL+$INC))
  VAL=$((VAL*3/2+1))
fi
 
if [ "$VAL" -lt $MIN ]; then
  VAL=$MIN
elif [ "$VAL" -gt $MAX ]; then
  VAL=$MAX
fi
 
echo $VAL > $KEYS_DIR/brightness
