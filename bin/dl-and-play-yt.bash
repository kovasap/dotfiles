#!/bin/bash

# Downloads and plays a youtube video from a URL copied to the clipboard

# Exit script if there is an error.
set -e

cd ~/Downloads
url=`xsel -b`
title=`wget -qO- "$url" | perl -l -0777 -ne 'print $1 if /<title.*?>\s*(.*?)(?: - youtube)?\s*<\/title/si'`
echo "Downloading $url with name $title..."
youtube-dl -o "$title" $url
xdg-open "$title"*
