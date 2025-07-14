#!/bin/bash
# sudo apt instal -y lynx && sudo pip3 install bandcamp-downloader
# Install https://github.com/prasmussen/gdrive/releases
echo "First arg should be e.g https://ARTIST.bandcamp.com"
rm -r bandcamp-music
mkdir bandcamp-music
cd bandcamp-music
# This gets stuff most of the time, but not always everything
# lynx -dump -listonly -nonumbers $1 | grep "/album/" > bandcamp-link.txt ; sleep 1
curl "$1/music" | grep -oPi "/album/[^&?'\"\s]+" | sed "s~^~$1~" > bandcamp-link.txt
cat bandcamp-link.txt
sleep 1
for album in $(cat bandcamp-link.txt); do (bandcamp-dl -r --base-dir . --template "%{artist} - %{album}/%{track} - %{title}" $album); done
rm bandcamp-link.txt

# This is my "music" dir in Google Drive
for d in *; do gdrive files upload --recursive --parent 1ahywjLw_cL4Tg1IJgl30jfpvmcvCZVs3 "$d"; done
