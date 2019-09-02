# load gem config
source ~/ProfileGemPure/load.sh

##################################
# GOOGLE SPECIFIC OPTIONS
##################################

if [ -d /google ]; then
  # go to citc clients
  alias cdg='cd /google/src/cloud/kovas'

  # open all changed files in fig citc client (wrt last submitted code)
  nvc() {
    # '\'' closes string, appends single quote, then opens string again
    # base_cl_cmd='hg log -r smart --template '\''{node}\n'\' | tail -1'
    base_cl_cmd='hg log -r p4base --template '\''{node}\n'\'
    # -O4 opens in 4 vertical split windows
    nv -O4 $(hg st -n --rev $(eval $base_cl_cmd) | sed 's/^google3\///')
  }


  alias hgw='watch --color -n 1 '\''hg xl --color always; echo; hg st --color always'\'

  # prompt for prodaccess if needed
  prodcertstatus --quiet || { printf '\nNeed to prodaccess...\n'; prodaccess; }

  export P4MERGE=vimdiff

  alias perfgate=/google/data/ro/teams/perfgate/perfgate
  alias build_copier=/google/data/ro/projects/build_copier/build_copier
  alias lljob=/google/data/ro/projects/latencylab/clt/bin/lljob
  g4d chamber_regression_replication
fi
