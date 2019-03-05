# $Id: //depot/google3/googledata/corp/puppet/goobuntu/common/modules/shell/files/bash/skel.bashrc#5 $
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|xterm-256color) color_prompt=yes;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# useful history searching alias
alias hgrep='history | grep'
# make history infinite
HISTSIZE= 
HISTFILESIZE=
# ignore duplicate commands in history
HISTCONTROL=ignoreboth:erasedups
# always give option to edit history commands before executing them
shopt -s histverify

export PATH=$PATH:~/bin

# use vi mode for command line editing
set -o vi
# when in vi command mode, yy will copy the current line to the clipboard
_xyank() {
  echo "$READLINE_LINE" | xclip -selection clipboard
}
bind -m vi -x '"yy": _xyank'

# useful tip about dmenu
# since starting last month, I've noticed that dmenu is often very slow to start. From reading /var/log/apt/history.log and /var/log/dpkg.log, it seems like some apt or dpkg command is automatically run between 30 and 100 times per day - some significant percent of those modify binaries. dmenu keeps a cache and, if any directory in your path has changed since that file was last written, it updates the cache at that time. You can read the dmenu_path script to see the details.
# so, the trivial solution is just to run dmenu_path after every dpkg invocation. Run this to tell dpkg to to update your dmenu cache every time something installs a package.
#
# echo "post-invoke='sudo -u $USER dmenu_path > /dev/null'" > /etc/dpkg/dpkg.cfg.d/dmenu-path-update-hook
#
# That seems to have solved the problem for me. Some sort of inotify watch would be more thorough as it would catch changes due to reasons other than package installs, so if you heavily use (e.g.) hackage, you may want that. This has been good enough for me lately.

# load gem config
source ~/ProfileGem/load.sh

source /usr/share/virtualenvwrapper/virtualenvwrapper.sh

# fix for gcert SSH_AUTH_SOCK not defined problem
eval $(ssh-agent &> /dev/null)

# ssh into google work desktop
alias sd='ssh -o ServerAliveInterval=60 mrc.sea.corp.google.com'

# for personal server
if [ "$(hostname)" = "kserv" ]; then
  export PATH=$HOME/.rccontrol-profile/bin:$PATH  # added by rccontrol installer
fi

##################################
# TIPS (should move to more visible place)
##################################
# use pmount/pumount to mount usb sticks

##################################
# GOOGLE SPECIFIC OPTIONS
##################################

if [ -d /google ]; then
  # go to citc clients
  alias cdg='cd /google/src/cloud/kovas'

  # prompt for prodaccess if needed
  prodcertstatus --quiet || { printf '\nNeed to prodaccess...\n'; prodaccess; }

  export P4MERGE=vimdiff

  alias perfgate=/google/data/ro/teams/perfgate/perfgate
  alias build_copier=/google/data/ro/projects/build_copier/build_copier
  alias lljob=/google/data/ro/projects/latencylab/clt/bin/lljob
fi
