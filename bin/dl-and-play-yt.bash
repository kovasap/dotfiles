#!/bin/bash

# Downloads and plays a youtube video from a URL copied to the clipboard

# Exit script if there is an error.
set -e

cd ~/Downloads
youtube-dl `xsel -b`
xdg-open "`ls -tr *mp4 | tail -1`"
