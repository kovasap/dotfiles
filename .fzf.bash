# Setup fzf
# ---------
if [[ ! "$PATH" == */home/kovas/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/kovas/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/kovas/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/kovas/.fzf/shell/key-bindings.bash"
