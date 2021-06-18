#!/bin/sh
set -e

if [ ! -d "linux" ]; then
    echo "start this script in the source root directory"
    exit 1
fi

CACHE_DIR="$PWD/3rdParty/buildCache/linux"
BUILD_DIR="$PWD/3rdParty/linux"
VCPKG_ROOT="$BUILD_DIR/vcpkg"

export XDG_CACHE_HOME=$CACHE_DIR/vcpkgcache

if [ ! -d $VCPKG_ROOT ]; then
    mkdir -p $BUILD_DIR
    git -C $BUILD_DIR clone https://github.com/JackBoosY/vcpkg -b dev/jack/for-test-only-wxwidgets-3
fi

git -C $VCPKG_ROOT pull
$VCPKG_ROOT/bootstrap-vcpkg.sh
$VCPKG_ROOT/vcpkg install freetype[core,bzip2,png] freeglut ftgl wxwidgets
$VCPKG_ROOT/vcpkg upgrade --no-dry-run
