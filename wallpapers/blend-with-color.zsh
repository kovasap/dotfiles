#!/bin/zsh

file=$1
extension="${file##*.}"                     # get the extension
filename="${file%.*}"                       # get the filename

convert $file -fill '#1d1808' -colorize 50% "${filename}-blended.${extension}"
