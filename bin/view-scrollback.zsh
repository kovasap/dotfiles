#!/bin/zsh

# Check if in tmux session or not
if ! { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
  # It's also possible to supply `-` instead of a number to -S for infinite
  # capture, although sometimes this leads to truncation anyway.  I've found
  # it's better to just capture the last 10000 lines like this to avoid loosing
  # some of the most recent lines.
  tmux capture-pane -S -10000
  tmux save-buffer ~/scrollback.txt
else
  kitty @ get-text > ~/scrollback.txt
fi

nvim ~/scrollback.txt
