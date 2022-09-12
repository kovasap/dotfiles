# Setup fzf
# ---------
if [[ ! "$PATH" == */home/kovas/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/kovas/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/kovas/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/kovas/.fzf/shell/key-bindings.zsh"
export FZF_DEFAULT_OPTS='--bind=ctrl-k:up,ctrl-e:down'
