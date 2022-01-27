#!/bin/bash
##sudo apt instal -y lynx && sudo pip3 install bandcamp-downloader##
echo "Copy Bandacmp Url e.g https://ARTIST.bandcamp.com/music"
read url
lynx -dump -listonly -nonumbers $url | grep "bandcamp.com/album" > bandcamp-link.txt ; sleep 1
for album in $(cat bandcamp-link.txt); do (bandcamp-dl -r --template "%{artist} - %{album}/%{track} - %{title}" $album); done
