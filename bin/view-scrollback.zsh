#!/bin/zsh

# Check if in tmux session or not
if ! { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
  tmux capture-pane -S -
  tmux save-buffer scrollback.txt
else
  kitty @ get-text > scrollback.txt
fi

nvim scrollback.txt
