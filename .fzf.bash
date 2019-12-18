# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/google/home/kovas/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/usr/local/google/home/kovas/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/google/home/kovas/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/usr/local/google/home/kovas/.fzf/shell/key-bindings.bash"
