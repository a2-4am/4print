#!/bin/bash

# no command-line parameters
# just run this from the project root directory
# after making changes to any file in uncompressed-assets/FONTS-ORIGINAL/
# to rebuild the NuFX file containing 4am's backported fonts,
# in the desired order

indir="uncompressed-assets/FONTS-ORIGINAL"
out="FONTS3P/A.4AM.FONT.PACK.shk"
finalout="FONTS3P/A.4AM.FONT.PACK#E08002"

rm -f "$out"
cp2 create-file-archive "$out" || exit 1
ls -S "$indir"/FONT.* | while read -r f; do
    cp2 add --strip-paths --set-int=nufx-comp-alg:8 "$out" "$f"
done

mv "$out" "$finalout"
