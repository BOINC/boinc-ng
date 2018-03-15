#/bin/sh -e

#
# See: http://boinc.berkeley.edu/trac/wiki/AndroidBuildClient#
#

# Script to compile Libcurl for Android

COMPILECURL="yes"
CONFIGURE="yes"
MAKECLEAN="yes"

CURL="${CURL_SRC:-$HOME/src/curl-7.48.0}" #CURL sources, required by BOINC

export ANDROID_TC="${ANDROID_TC:-$HOME/android-tc}"
export ANDROIDTC="${ANDROID_TC_MIPS64:-$ANDROID_TC/mips64}"
export TCBINARIES="$ANDROIDTC/bin"
export TCINCLUDES="$ANDROIDTC/mips64el-linux-android"
export TCSYSROOT="$ANDROIDTC/sysroot"

export PATH="$TCBINARIES:$TCINCLUDES/bin:$PATH"
export CC=mips64el-linux-android-gcc
export CXX=mips64el-linux-android-g++
export LD=mips64el-linux-android-ld
export CFLAGS="--sysroot=$TCSYSROOT -DANDROID -D__ANDROID_API__=21 -Wall -I$TCINCLUDES/include -O3 -fomit-frame-pointer -fPIE"
export CXXFLAGS="--sysroot=$TCSYSROOT -DANDROID -Wall -funroll-loops -fexceptions -O3 -fomit-frame-pointer -fPIE"
export LDFLAGS="-L$TCSYSROOT/usr/lib64 -L$TCINCLUDES/lib64 -llog -fPIE -pie"
export GDB_CFLAGS="--sysroot=$TCSYSROOT -Wall -g -I$TCINCLUDES/include"

cache_dir=""
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --cache_dir)
        cache_dir="$2"
        shift
        ;;
        *)
        echo "unrecognized option $key"
        ;;
    esac
    shift # past argument or value
done

if [ "x$cache_dir" != "x" ]; then
    PREFIX="$cache_dir/mips64el-linux-android"
else
    PREFIX="$TCINCLUDES"
fi

FLAGFILE="${PREFIX}/_done"
if [ -e "${FLAGFILE}" ]; then
    echo "libcurl seems already to be present in ${PREFIX}"
    return 0
fi

# Prepare android toolchain and environment
./build_androidtc_mips64.sh
if [ $? -ne 0 ]; then exit 1; fi

if [ -n "$COMPILECURL" ]; then
echo "==================building curl from $CURL================================="
cd "$CURL"
if [ -n "$MAKECLEAN" ]; then
make distclean
fi
if [ -n "$CONFIGURE" ]; then
./configure --host=mips64el-linux --prefix="$PREFIX" --libdir="$PREFIX/lib" --disable-shared --enable-static --with-random=/dev/urandom
if [ $? -ne 0 ]; then exit 1; fi
fi
make
if [ $? -ne 0 ]; then exit 1; fi
make install
if [ $? -ne 0 ]; then exit 1; fi
touch ${FLAGFILE}
echo "========================curl done================================="
fi
