#!/bin/bash
# sudo apt instal -y lynx && sudo pip3 install bandcamp-downloader
# Install https://github.com/prasmussen/gdrive/releases
echo "First arg should be e.g https://ARTIST.bandcamp.com/music"
rm -r bandcamp-music
mkdir bandcamp-music
cd bandcamp-music
lynx -dump -listonly -nonumbers $1 | grep "bandcamp.com/album" > bandcamp-link.txt ; sleep 1
for album in $(cat bandcamp-link.txt); do (bandcamp-dl -r --base-dir . --template "%{artist} - %{album}/%{track} - %{title}" $album); done
rm bandcamp-link.txt

# This is my "music" dir in Google Drive
gdrive upload -r -p 1ahywjLw_cL4Tg1IJgl30jfpvmcvCZVs3 **
