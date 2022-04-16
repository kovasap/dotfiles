#!/usr/bin/env bash

# Edit the currently active textarea in vim:
#   - take the current text in the textarea
#   - load it in vim
#   - user completes their edits and closes vim
#   - replace the text area with the newly edited text

tmpdir=$(mktemp -d)
trap "rm -rf $tmpdir" EXIT
cd $tmpdir

# Spam is necessary for this to consistently work, idk why.
xdotool key --clearmodifiers ctrl+a
xdotool key --clearmodifiers ctrl+a
xdotool key --clearmodifiers ctrl+a
xdotool key --clearmodifiers ctrl+a
xdotool key --clearmodifiers ctrl+a
xdotool key --clearmodifiers ctrl+a
xdotool key --clearmodifiers ctrl+a
xdotool key --clearmodifiers ctrl+x
xclip -r -o -selection clipboard > out
xdotool keyup mod
kitty --title nvim-textarea nvim "$tmpdir/out"
xclip -r -i -selection clipboard out
xdotool key --clearmodifiers ctrl+v
xdotool keyup mod
