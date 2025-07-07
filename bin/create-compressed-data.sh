#!/bin/bash

# no command-line parameters
# just run this from the project root directory
# after making changes to any file in uncompressed-assets/RES/
# to rebuild the NuFX file containing the original Print Shop
# program files, in the desired order, with the desired files
# selectively compressed

indir="uncompressed-assets/RES"
out="RES/REPRINT.DATA.shk"
finalout="RES/REPRINT.DATA#E08002"

rm -f "$out"
cp2 create-file-archive "$out" || exit 1

for f in "HELLO#060800" \
	"TPAGE#062000" \
	"SYSLIB#068800" \
	"MENULIB#066000" \
	"MAINPICS#064200" \
	"PRCOMS#061800"; do
    cp2 add --strip-paths --no-compress "$out" "$indir"/"$f" || exit 1
done

for f in "MENUS1#064000" \
	     "MENUS3#064000" \
	     "MENUS4#064000" \
	     "MENUS5#061000" \
	     "MENUS6#064000" \
	     "MENUS7#066300" \
	     "DRAW1#067800" \
	     "DRAW3#067800" \
	     "DRAW4#067800" \
	     "DRAW5#061100" \
	     "B#065600" \
	     "S#061000" \
	     "KSCOPE#064000" \
             "I1#066000" \
             "I2#066000" \
             "I3#066000" \
             "I4#066000" \
             "I5#066000" \
             "I6#066000" \
             "F1#066000" \
             "F2#066000" \
             "F3#066000" \
             "F4#066000" \
             "F5#066000" \
             "F6#066000" \
             "F7#066000" \
             "F8#066000"; do
    cp2 add --strip-paths --set-int=nufx-comp-alg:8 "$out" "$indir"/"$f"
done

mv "$out" "$finalout"
