#!/bin/bash

# $1 = input .dsk file with PS fonts
# $2 = output .shk file
mkdir -p tmp
chmod 777 tmp
rm -f tmp/*
cp2 catalog "$1" | grep -E "FONT\." | cut -c48- | while read -r dosfilename; do
    cp2 extract --preserve=naps --exdir=tmp/ "$1" "$dosfilename"
    fname=$(cd tmp/ && ls && cd ./..)
    chmod 666 tmp/"$fname" || exit 1
    shortname=$(echo "$fname" | tr " " ".")
    mv tmp/"$fname" tmp/"$shortname"
    cp2 add --overwrite --from-naps --strip-paths --set-int=nufx-comp-alg:8 "$2" tmp/"$shortname"
    rm tmp/"$shortname" || exit 1
done
rmdir tmp
