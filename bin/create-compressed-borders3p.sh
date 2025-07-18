#!/bin/bash

# no command-line parameters
# just run this from the project root directory
# after making changes to any file in uncompressed-assets/BORDERS3P/

indir="uncompressed-assets/BORDERS3P"
out="BORDERS3P/THIRD.PARTY.shk"
finalout="BORDERS3P/THIRD.PARTY#E08002"

rm -f "$out"
cp2 create-file-archive "$out" || exit 1

while read -r filename; do
    cp2 add --overwrite --from-naps --strip-paths --set-int=nufx-comp-alg:8 "$out" "$indir/$filename#067800" || exit 1
done < "$indir"/catalog.txt

mv "$out" "$finalout"
