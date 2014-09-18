#!/bin/sh

ext4=(
	"format(\"ext4\", \"EMMC\", \"/dev/block/platform/msm_sdcc.1/by-name/system\", \"0\", \"/system\");"
	"mount(\"ext4\", \"EMMC\", \"/dev/block/platform/msm_sdcc.1/by-name/system\", \"/system\");"
	)
f2fs=(
	"run_program(\"/sbin/mkfs.f2fs\", \"/dev/block/platform/msm_sdcc.1/by-name/system\");"
	"run_program(\"/sbin/busybox\", \"mount\", \"/system\");"
	)
	
echo -e "\tunzipping... \c"
sh -c "7za x -y -o$WORKINGDIR $FILEIN META-INF/com/google/android/updater-script > /dev/null"
echo -e "done!"
	
echo -e "\tchanging commands... \c"
sed -i -e "s#${ext4[0]}#${f2fs[0]}#" "$WORKINGDIR/META-INF/com/google/android/updater-script"
sed -i -e "s#${ext4[1]}#${f2fs[1]}#" "$WORKINGDIR/META-INF/com/google/android/updater-script"
echo -e "done!"

echo -e "updating zip... \c"
sh -c "7za u $WORKINGDIR/$FILESIGNED $WORKINGDIR/META-INF > /dev/null"
echo -e "done!"