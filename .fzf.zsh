# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/google/home/kovas/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/usr/local/google/home/kovas/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/google/home/kovas/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/usr/local/google/home/kovas/.fzf/shell/key-bindings.zsh"
