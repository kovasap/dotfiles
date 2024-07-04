# Setup fzf
# ---------
if [[ ! "$PATH" == */home/kovas/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/kovas/.fzf/bin"
fi

source <(fzf --zsh)
