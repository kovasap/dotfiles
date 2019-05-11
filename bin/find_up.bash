#!/bin/bash
set -e
prune=""
path="$1"
# shift away the path param so that we can use the rest with $@
shift 1

# this is a do-while loop
while 
    # for debugging
    # echo "path is $path"
    # echo "prune is $prune"
    find "$path" $prune -not -wholename '*.git*' -not -wholename '*.hg*' "$@"
    [[ $path != "." ]]
do
    prune="-not ( -path $path -prune )"
    path="$(dirname $path)"
done
