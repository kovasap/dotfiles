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
    # -exec printf "%q\n" '{}' \; 
    find "$path" $prune -not -wholename '*.git*' -not -wholename '*.hg*' "$@" \
        | sed -e 's,^\./,,' # remove ./ from front of paths
    # to escape or quote spaces in filenames:
    # sed 's/ /\\ /' # sed "s/^/\"/;s/$/\"/"
    [[ $path != "." ]]
do
    prune="-not ( -path $path -prune )" # prune the directory we just came from
    path="$(dirname $path)"
done
