#!/bin/zsh

echo "Trying to take screenshot!"
mkdir ~/screenshots
cd ~/screenshots
# Only take a screenshot if the computer was used in the last 15 minutes.
if [[ $( xprintidle ) -lt 900000 ]];
then
  # We are using the computer, so should take a screenshot.  We don't want to
  # take a screenshot when the computer isn't being used.
  scrot
  echo "Screenshot taken!."
  # gphotos-uploader-cli
else
  echo "Computer idle, no screenshot taken."
fi
