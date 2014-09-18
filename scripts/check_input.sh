#!/bin/sh

echo -e "checking input... \c"
sh -c "7za t -y $FILEIN > /dev/null"
if [ "$?" -ne 0 ]; then echo "'$FILEIN' is not a valid 'update.zip' " && return 1; fi
echo -e "done!"