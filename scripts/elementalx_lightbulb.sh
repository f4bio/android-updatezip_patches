#!/bin/sh

echo -e "\tunzipping... \c"
sh -c "7za x -y -o$WORKINGDIR $FILEIN system/etc/init.d/99elementalx > /dev/null"
echo -e "done!"

#echo -e "\tpatching... \c"
#sh -c "patch -s $WORKINGDIR/system/etc/init.d/99elementalx < $PATCHESDIR/99elementalx.patch"
#echo -e "done!"

commands="
#torch
chown system camera /sys/class/leds/led:flash_torch/brightness
chmod 0666 /sys/class/leds/led:flash_torch/brightness

exit 0"

echo -e "\tadding commands... \c"
TMPFILE="$(mktemp)"
sh -c "head -n -2 $WORKINGDIR/system/etc/init.d/99elementalx > $TMPFILE"
for line in "$commands"; do
	sh -c "echo '$line' >> $TMPFILE"
done
sh -c "cp $TMPFILE $WORKINGDIR/system/etc/init.d/99elementalx"
echo -e "done!"

echo -e "updating zip... \c"
sh -c "7za u $WORKINGDIR/$FILESIGNED $WORKINGDIR/system > /dev/null"
echo -e "done!"