#!/bin/bash
#
# Useful functions to add to the ENV_INFO array to add functionality to your
# prompt. For example adding the following to your local.conf.sh, or to another
# gem's environment.sh will include your git project's status in the prompt:
#
#   ENV_INFO+=("git_prompt")

# Upper-case hostname, for title
hostname_title() {
  tr '[:lower:]' '[:upper:]' <<<"$HOSTNAME"
}

# Prints the current time, in purple
time_prompt() {
  printf "$(pcolor PURPLE)%s$(pcolor)" "$(date +%I:%M:%S%p)"
}

# Prints the current branch, colored by status, of a Mercurial/Git repo
vc_prompt() {
  # do not try to get repo status when in citc clients - is very slow!
  if [[ $(pwd) == /google/src/cloud* ]]; then
    return 0
  fi
  local repo vc vc_and_repo
  vc_and_repo=$(_find_repo) || return 0
  repo=$(echo $vc_and_repo | cut -f1 -d+)
  vc=$(echo $vc_and_repo | cut -f2 -d+)
  cd "$repo" || return # so Mercurial/git don't have to do the same find we just did
  if [[ "$vc" == "hg" ]]; then
    local branch num_heads heads
    branch=$(hg branch 2> /dev/null) || return 0
    num_heads=$(hg heads --template '{rev} ' 2> /dev/null | wc -w) || return 0
    if (( num_heads > 1 )); then
      heads='*'
    fi

    local color=GREEN
    if [[ -n "$(hg stat --modified --added --removed --deleted)" ]]; then
      color=LRED
    elif [[ -n "$(hg stat --unknown)" ]]; then
      color=PURPLE
    fi
    printf "hg:$(pcolor $color)%s%s$(pcolor)" "$branch" "$heads"
  elif [[ "$vc" == "git" ]]; then
    local label
    # http://stackoverflow.com/a/12142066/113632
    label=$(git rev-parse --abbrev-ref HEAD 2> /dev/null) || return 0
    if [[ "$label" == "HEAD" ]]; then
      # http://stackoverflow.com/a/18660163/113632
      label=$(git describe --tags --exact-match 2> /dev/null)
    fi

    local color
    local status
    status=$(git status --porcelain | cut -c1-2)
    if [[ -z "$status" ]]; then
      color=GREEN
    elif echo "$status" | cut -c2 | grep -vq -e ' ' -e '?'; then
      color=RED # unstaged
    elif echo "$status" | cut -c1 | grep -vq -e ' ' -e '?'; then
      color=YELLOW # staged
    elif echo "$status" | grep -q '?'; then
      color=PURPLE # untracked
    fi
    printf "git:$(pcolor $color)%s$(pcolor)" "$label"
  fi
  cd - > /dev/null
} && bc::cache vc_prompt PWD

virtualenv_prompt() {
  if [[ $VIRTUAL_ENV != "" ]]; then
    # Strip out the path and just leave the env name
    echo "(${VIRTUAL_ENV##*/})"
  fi
}

# Prints the current screen session, if in one
screen_prompt() {
  if [[ -n "$STY" ]]; then
    printf "$(pcolor CYAN)%s$(pcolor)" "${STY#[0-9]*.}:${WINDOW}"
  fi
}
