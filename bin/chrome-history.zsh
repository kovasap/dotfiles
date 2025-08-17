# Search chrome history with fzf
# https://junegunn.kr/2015/04/browsing-chrome-history-with-fzf/
# Supply arg to script for which numbered chrome profile to search.
c () {
  local cols sep
  cols=$(( $(tput cols) / 3 ))
  sep='{::}'

  if [ $# -eq 0 ]
    then
      cp -f ~/.config/google-chrome/Default/History /tmp/h
    else
      cp -f ~/.config/google-chrome/Profile\ $1/History /tmp/h
  fi

  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
     from urls order by visit_count desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
  # absolute fzf path is necessary when running this from qtile for some reason
  /home/kovas/.fzf/bin/fzf --ansi --multi |
  sed 's#.*\(https*://\)#\1#' |
  xargs xdg-open
}

c $1
