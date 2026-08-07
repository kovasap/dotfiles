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

# ------------------------- Jujutsu -------------------------------

source <(COMPLETE=zsh jj)
alias jjl='jj log; jj status'
alias jjf='jj git fetch; jj new main'

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

# ------------------------- Vi Mode ------------------------- 

zplug "jeffreytse/zsh-vi-mode"

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

bindkey -M vicmd ^G edit-command-line

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
  alias ssh='kitten ssh'
fi

alias icat='kitten icat'


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

zplug "zsh-users/zsh-syntax-highlighting"

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

# bc - An arbitrary precision calculator language
function = {
  echo "$@" | bc -l
}

alias calc="="

# Don't feed long commands to a pager program.
unset LESS

path=("${(@)path:#"/home/kovas/.virtualenvs/qtile/bin"}")

zplug load

setopt no_nomatch
for d in $HOME/bin/*/bin; do export PATH="$PATH:$d"; done
setopt nomatch
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

source $ZSH/oh-my-zsh.sh

# Faster git add/commit/push
unalias gp
function gp {
    git add -u
    git commit -m "$1"
    git push
}

unalias gcl

# Make ctrl-w exit, just as it does for vim and chrome
# Note that I rebound ctrl+o to ctrl+w in ~/.config/kitty/kitty.conf
exit_zsh() { exit }
zle -N exit_zsh
bindkey '^O' exit_zsh

# ------------------------- Fuzzy Searching (FZF) ------------------------- 

# Source the fzf stuff after the vi mode plugin initializes, since it
# overwrites fzf settings.
zvm_after_init_commands+=('source <(fzf --zsh)')
bindkey -r "^T"
bindkey -r "^[c"
bindkey "^ " fzf-history-widget
bindkey "^R" fzf-history-widget

# ------------------------- Starship Prompt ------------------------- 

# See config file at ~/.config/starship.toml
eval "$(starship init zsh)"
