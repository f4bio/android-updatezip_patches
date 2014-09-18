#!/bin/sh

echo -e "checking for tools... \c"
if [ ! -e "$(command -v java)" ]; then echo "'java' not found" && return 1; fi
if [ ! -e "$(command -v 7za)" ]; then echo "'7za' not found" && return 1; fi
if [ ! -e "$(command -v md5sum)" ]; then echo "'md5sum' not found" && return 1; fi
if [ ! -e "$(command -v patch)" ]; then echo "'patch' not found" && return 1; fi
if [ ! -f "$TOOLSDIR/signapk.jar" ]; then echo "'signapk.jar' not found in $TOOLSDIR" && return 1; fi
echo -e "done!"

echo -e "removing old files which may interfere... \c"
if [ -f "$FILEBASEDIR/$FILESIGNED" ]; then rm "$FILEBASEDIR/$FILESIGNED"; fi
if [ -f "$FILEBASEDIR/$FILESIGNED.md5" ]; then rm "$FILEBASEDIR/$FILESIGNED.md5"; fi
echo -e "done!"
