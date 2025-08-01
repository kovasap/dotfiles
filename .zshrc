# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# Uncomment to profile zsh startup
# zmodload zsh/zprof

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

source ~/.zplug/init.zsh

plugins+=(git)
plugins+=(vi-mode)
plugins+=(history-substring-search)
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
plugins+=(zsh-autosuggestions)

DISABLE_AUTO_TITLE="true"

source $ZSH/oh-my-zsh.sh

# --------------------------- Window Title -----------------------------------

# Currently seems to be overridden by something else...
function precmd () {
  # Show last commit's description for mercurial repositories
  hg_name=$(hg log -r . --template "{desc}" 2>/dev/null | sed 's/`//g')
  # Show repo name for git repositories
  git_name=$(git config --local remote.origin.url 2>/dev/null | sed -n 's#.*/\([^.]*\)\.git#\1#p')
  # Print window title
  print -Pn "\e]0;$hg_name$git_name - $(hostname)\a"
}

# --------------------------- P10K Prompt -----------------------------------

zplug romkatv/powerlevel10k, as:theme, depth:1

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# TODO Check out this:
# https://medium.com/@henrebotha/how-to-write-an-asynchronous-zsh-prompt-b53e81720d32

# ------------------------- Completion -------------------------------

# ctrl-l accept the current suggestion by word
bindkey '^L' forward-word
# ctrl-n accept the current suggestion entirely
bindkey '^N' autosuggest-accept
# shift-tab accept the current suggestion entirely
# bindkey '^[[Z' autosuggest-accept

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

# ------------------------- Fuzzy Searching (FZF) ------------------------- 

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
bindkey -r "^T"
bindkey -r "^[c"
bindkey "^ " fzf-history-widget


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

# bindkey -M vicmd 'k' history-substring-search-up
# bindkey -M vicmd 'j' history-substring-search-down

bindkey -M vicmd 'e' down-line-or-history


# Use system clipboard with vi mode
zplug "kutsan/zsh-system-clipboard"

# Allow home/end keys in vi-mode, as well as other things.
# Taken from https://github.com/ohmyzsh/ohmyzsh/issues/7330
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi


# ------------------------- Kitty Support -------------------------
if [ -x "$(which kitty)" ]; then
  alias ssh='kitty +kitten ssh'
fi

alias icat='kitty +kitten icat'


# ------------------------- Python -------------------------
# Requires `sudo apt install virtualenvwrapper` or `pip install virtualenvwrapper`
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3

if [[ $(hostname) == *googlers* || $(hostname) == *kovas2* ]]; then
  source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
else
  source /usr/bin/virtualenvwrapper.sh
fi


# ------------------------- Google -------------------------

# Prompt
if [[ -a ~/google_dotfiles/google-zshrc ]]; then
  source ~/google_dotfiles/google-zshrc
fi

# ------------------------- Miscellaneous -------------------------

source ~/gemini_api_key.zsh

# Open scrollback in vim
bindkey -s '^S' '~/bin/view-scrollback.zsh\n' 

# Make ctrl-w exit, just as it does for vim and chrome
bindkey -s '^W' '^D'

# Control-backspace to go by word
bindkey '^W' backward-kill-word

zplug "zsh-users/zsh-syntax-highlighting", defer:2

unsetopt autocd

_update_lastdir() {
  echo $PWD > ~/lastdir
}

# Swap two files
function swap()         
{
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE && mv "$2" "$1" && mv $TMPFILE "$2"
}

add-zsh-hook chpwd _update_lastdir

alias nv='nvim'
# Make neovim the default editor for everything.
export VISUAL=nvim
export EDITOR=nvim

# This is necessary to get GreenWithEnvy to run
# Follow instructions at https://wiki.archlinux.org/title/Locale for en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Faster mercurial startup time (see https://www.mercurial-scm.org/wiki/CHg)
alias hg='chg'

# Faster git add/commit/push
unalias gp
function gp {
    git add -u
    git commit -m "$1"
    git push
}

unalias gcl

# bc - An arbitrary precision calculator language
function = {
  echo "$@" | bc -l
}

alias calc="="

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

path=("${(@)path:#"/home/kovas/.virtualenvs/qtile/bin"}")

zplug load

for d in $HOME/bin/*/bin; do export PATH="$PATH:$d"; done
export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.poetry/bin:$PATH:$HOME/.cargo/bin:$HOME/google_dotfiles:/usr/local/bin:/usr/games"
if [[ $(hostname) == *googlers* ]]; then
  # eval "$(~/.linuxbrew/bin/brew shellenv)"
elif [[ $(hostname) == *raspberrypi* ]]; then
  # do nothing
elif [[ $(hostname) == frostyarch ]]; then
  # do nothing
else
  # eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Uncomment to profile zsh startup
# zprof

# Anything in the RUN env var will be executed on startup.
eval "$RUN"
# source ~/powerlevel10k/powerlevel10k.zsh-theme
