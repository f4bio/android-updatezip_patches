#!/bin/sh

commands="#!/system/bin/sh

#torch
chown system camera /sys/class/leds/led:flash_torch/brightness
chmod 0666 /sys/class/leds/led:flash_torch/brightness

exit 0"

echo -e "\tadding init.d script... \c"
TMPFILE="$(mktemp)"
for line in "$commands"; do
	sh -c "echo '$line' > $TMPFILE"
done
sh -c "mkdir -p $WORKINGDIR/system/etc/init.d/"
sh -c "cp $TMPFILE $WORKINGDIR/system/etc/init.d/99lightbulb"
echo -e "done!"

echo -e "updating zip... \c"
sh -c "7za u $WORKINGDIR/$FILESIGNED $WORKINGDIR/system > /dev/null"
echo -e "done!"