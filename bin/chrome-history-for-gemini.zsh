# Supply arg to script for which numbered chrome profile to search.
c () {
  if [ $# -eq 0 ]
    then
      cp -f ~/.config/google-chrome/Default/History /tmp/h
    else
      cp -f ~/.config/google-chrome/Profile\ $1/History /tmp/h
  fi

  sqlite3 /tmp/h "SELECT
  urls.title
FROM
  urls
WHERE
  urls.last_visit_time >= (
    (CAST(strftime('%s', 'now', '-30 days') AS INTEGER) + 11644473600) * 1000000
  )
ORDER BY
  urls.last_visit_time DESC;" > ~/history_titles.txt

  gemini -p "Give a detailed summary of the web activity in the history_titles.txt file in the current directory, giving a bulletted list of examples for each category of activity you find."
}

c $1
