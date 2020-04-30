# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load ------------------------- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

source ~/.zplug/init.zsh

plugins+=(git)
plugins+=(vi-mode)
plugins+=(history-substring-search)
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
plugins+=(zsh-autosuggestions)

DISABLE_AUTO_TITLE="true"
ZSH_THEME="powerlevel10k/powerlevel10k"
source $ZSH/oh-my-zsh.sh

# --------------------------- Window Title -----------------------------------

function precmd () {
  # Show last commit's description for mercurial repositories
  hg_name=$(hg log -r . --template "{desc}" 2>/dev/null)
  # Show repo name for git repositories
  git_name=$(git config --local remote.origin.url 2>/dev/null | sed -n 's#.*/\([^.]*\)\.git#\1#p')
  # Print window title
  print -Pn "\e]0;$hg_name$git_name - $(hostname)\a"
}

# --------------------------- Prompt -----------------------------------

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ------------------------- Completion -------------------------------

# shift-tab accept the current suggestion
bindkey '^[[Z' autosuggest-accept

# ------------------------- Fuzzy Searching (FZF) ------------------------- 

source ~/.fzf/shell/completion.zsh
source ~/.fzf/shell/key-bindings.zsh
bindkey -r "^T"
bindkey -r "^[c"
bindkey "^ " fzf-history-widget

# ------------------------- Command History ------------------------- 

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# ------------------------- Vi Mode ------------------------- 

# Change cursor shape for different vi modes.
# See https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/vi-mode/vi-mode.plugin.zsh
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'

  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
  VI_KEYMAP=$KEYMAP
  zle reset-prompt
  zle -R
}
zle -N zle-keymap-select
# Use beam shape cursor for each new command.
_fix_cursor() {
   echo -ne '\e[5 q'
}
precmd_functions+=(_fix_cursor)

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Use system clipboard with vi mode
zplug "kutsan/zsh-system-clipboard"


# ------------------------- Kitty Support -------------------------
if [ -x "$(which kitty)" ]; then
  alias ssh='kitty +kitten ssh'
fi

alias icat='kitty +kitten icat'


# ------------------------- Python -------------------------
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/share/virtualenvwrapper/virtualenvwrapper.sh


# ------------------------- Google -------------------------

# Prompt
if [[ -d /google ]]; then
  source ~/zsh-async/async.zsh
  source ~/goog_prompt.zsh

  # go to citc clients
  alias cdg='cd /google/src/cloud/kovas'

  # fig status window
  alias hgw='watch --color -n 1 '\''hg st --color always; echo; hg xl --color always'\'

  # google tools
  alias perfgate=/google/data/ro/teams/perfgate/perfgate
  alias build_copier=/google/data/ro/projects/build_copier/build_copier
  alias lljob=/google/data/ro/projects/latencylab/clt/bin/lljob
  alias pyfactor=/google/data/ro/teams/youtube-code-health/pyfactor
  alias chamber_runner=/google/data/ro/teams/chamber/runner/live/runner.par

  # add gcloud stuff to PATH
  # source /usr/local/google/home/kovas/google-cloud-sdk/path.bash.inc

  alias bb="blaze build"
  alias bt="blaze test"

  # open all changed files in fig citc client (wrt last submitted code)
  function nvc() {
    # '\'' closes string, appends single quote, then opens string again
    # base_cl_cmd='hg log -r smart --template '\''{node}\n'\' | tail -1'
    base_cl_cmd='hg log -r p4base --template '\''{node}\n'\'
    num_splits=$(($COLUMNS / 80))
    # -ON opens in N vertical split windows
    nv -O$num_splits $(hg st -n --rev $(eval $base_cl_cmd) | sed 's/^google3\///')
  }

  export P4MERGE=vimdiff

  export START_DIRECTORY=$(p4 g4d chamber_regression_replication)

  source /etc/bash_completion.d/g4d
fi

# ------------------------- Miscellaneous -------------------------

alias nv='nvim'
# Make neovim the default editor for everything.
export VISUAL=nvim
export EDITOR=nvim

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# common ssh aliases
alias sd='ssh -o ServerAliveInterval=60 kovas.c.googlers.com'

# faster google certification
alias gcert='gcert; ssh kovas.c.googlers.com prodaccess'

# Faster mercurial startup time (see https://www.mercurial-scm.org/wiki/CHg)
alias hg='chg'

# Faster git add/commit/push
function gp {
    git add -u
    git commit -m "$1"
    git push
}

# Don't feed long commands to a pager program.
unset LESS


# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


zplug load

