# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/google/home/kovas/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/usr/local/google/home/kovas/.fzf/bin"
elif [[ ! "$PATH" == */home/kovas/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/kovas/.fzf/bin"
fi

source <(fzf --zsh)
