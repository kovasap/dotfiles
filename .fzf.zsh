# Setup fzf
# ---------
if [[ ! "$PATH" == *.fzf/bin* ]]; then
  fzf_bin=~/.fzf/bin/
  PATH="${PATH:+${PATH}:}${fzf_bin}"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source ~/.fzf/shell/completion.zsh 2> /dev/null

# Key bindings
# ------------
source ~/.fzf/shell/key-bindings.zsh
export FZF_DEFAULT_OPTS='--bind=ctrl-k:up,ctrl-e:down'
