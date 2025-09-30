#! /bin/bash

# exit on error
set -e

BLACKLIST=

[ -f blacklist.lst ] && BLACKLIST=$( cat blacklist.lst )

./download.sh v2.1.5.1

# enter source folder
pushd indi-3rdparty

# Call script to apply patches
../apply-patches.sh

# get packages lists
LIBS=$( ls -d lib* )
DRVS=$( ls -d indi* )

# build and install libs
for lib in $LIBS; do
    for b in $BLACKLIST; do
        [ "$b" = "$lib" ] && continue 2 #skip blacklisted lib
    done

    # build package (and install it since it's a library)
    ../build-package.sh $lib install
done

for drv in $DRVS; do
    for b in $BLACKLIST; do
        [ "$b" = "$drv" ] && continue 2 #skip blacklisted drv
    done

    # build package
    ../build-package.sh $drv
done

popd #indi-3rdparty

# move packages to dest
mv *.deb ../
