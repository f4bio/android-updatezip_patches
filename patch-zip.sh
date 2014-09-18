#!/bin/sh

while [[ $# > 1 ]]
do
key="$1"
shift

case $key in
    -l|--lightbulb)
    export LIGHTBULB=true
    ;;
    -f|--f2fsall)
    export F2FSALL=true
    ;;
    *)
            # unknown option
    ;;
esac
done

[[ ! -f "$1" ]] && echo "no such file '$1'" && exit 1

################################
# setup
######
export BASEDIR="$(realpath $(dirname $0))"
export TOOLSDIR="$BASEDIR/tools"
export SCRIPTSDIR="$BASEDIR/scripts"
export PATCHESDIR="$BASEDIR/patches"
export PATH="$PATH:$TOOLSDIR"
export WORKINGDIR="$(mktemp -d)"
echo -e "### checking environment ###"
source "$BASEDIR/scripts/check_environment.sh"
if [ $? -eq 1 ]; then echo "failed!" && exit 1; fi

export FILEIN="$1"
export FILENAME="$(basename $FILEIN)"
export EXTENSION="${FILENAME##*.}"
export FILENAME="${FILENAME%.*}"
export FILEBASEDIR="$(realpath $(dirname $FILEIN))"
export FILESIGNED="$FILENAME-patched-signed.$EXTENSION"
echo -e "### checking input ###"
source "$BASEDIR/scripts/check_input.sh"
if [ $? -eq 1 ]; then echo "failed!" && exit 1; fi

export SIGNAPK="java -jar $TOOLSDIR/signapk.jar $TOOLSDIR/publickey.x509.pem $TOOLSDIR/privatekey.pk8"
sh -c "cp $FILEIN $WORKINGDIR/$FILESIGNED"
################################

echo -e "### f2fsall ###"
if [ "$F2FSALL" ]; then
	sh -c "$SCRIPTSDIR/any_f2fsall.sh"
else
	echo -e "\t -> skipped!"
fi

echo -e "### lightbulb ###"
if [ "$LIGHTBULB" ]; then
	sh -c "$SCRIPTSDIR/elementalx_lightbulb.sh"
else
	echo -e "\t-> skipped!"
fi

echo -e "signing zip... \c"
sh -c "$SIGNAPK $WORKINGDIR/$FILESIGNED $FILEBASEDIR/$FILESIGNED"
if [ $? -eq 0 ]; then echo -e "done!"; else echo -e "failed!" && exit 1; fi

echo -e "final touches... \c"
sh -c "md5sum $FILEBASEDIR/$FILESIGNED > $FILEBASEDIR/$FILESIGNED.md5"
if [ $? -eq 0 ]; then echo -e "done!"; else echo -e "failed!" && exit 1; fi

echo -e "cleaning up the mess... \c"
rm -rf "$WORKINGDIR"
if [ $? -eq 0 ]; then echo -e "done!"; else echo -e "failed!" && exit 1; fi

echo "all done! your files are in: $FILEBASEDIR"
