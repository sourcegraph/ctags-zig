#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"/..

export ZIG_TARGET="x86_64-linux"
export CTAGS_VERSION=f95bb3497f53748c2b6afc7f298cff218103ab90
export LIBXML_VERSION=e20f4d7a656e47553f9da9d594e299e2fa2dbe41
export LIBYAML_VERSION=f8f760f7387d2cc56a2fc7b1be313a3bf3f7f58c

function autoconfHostOS()
{
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unsupported host OS, good luck!"
        exit 1
    fi
}

function autoconfHostArch()
{
    if [[ "$(uname -m)" == "arm64" ]]; then
        echo "aarch64"
    elif [[ "$(uname -m)" == "aarch64" ]]; then
        echo "aarch64"
    else
        echo "x86_64"
    fi
}

function autoconfHost()
{
    echo "$(autoconfHostArch)-$(autoconfHostOS)"
}

function log()
{
    echo ":-------------------------------------------------------------------:"
    echo ": ctags-zig: $1"
    echo ":-------------------------------------------------------------------:"
}

function ensureDependency()
{
    dep_name=$1
    remote_url=$2
    version=$3
    if [ ! -d "../deps/$dep_name" ]; then
        log "cloning deps/$dep_name..."
        git clone $remote_url "../deps/$dep_name"
    else
        log "updating deps/$dep_name..."
        pushd "../deps/$dep_name"
        git fetch
        popd
    fi
    pushd "../deps/$dep_name"
    git reset --hard $version
    popd

    cp -R "../deps/$dep_name" ./
    pushd "$dep_name"
}

# For autoconf cross-compilation details see:
# https://www.gnu.org/software/autoconf/manual/autoconf-2.69/html_node/Hosts-and-Cross_002dCompilation.html
# https://www.gnu.org/software/autoconf/manual/autoconf-2.70/html_node/Specifying-Target-Triplets.html

export AUTOCONF_HOST="${AUTOCONF_HOST:-$(autoconfHost)}"

log "detected AUTOCONF_HOST: $AUTOCONF_HOST"

export SYSROOT=`pwd`/root
export CFLAGS="--sysroot=${SYSROOT} -I `pwd`/root/usr/local/include"
export CXXFLAGS="--sysroot=${SYSROOT} -I `pwd`/root/usr/local/include"
export LDFLAGS="--sysroot=${SYSROOT} -L${SYSROOT}/usr/local/lib"
export PKG_CONFIG_SYSROOT_DIR="${SYSROOT}"
export PKG_CONFIG_LIBDIR="${SYSROOT}/usr/lib/pkgconfig"

mkdir -p deps/

rm -rf work/
mkdir -p work/
pushd work/

source ../dev/build-libyaml.sh && popd
source ../dev/build-libxml.sh && popd
source ../dev/build-ctags.sh && popd

popd

mkdir -p out/$ZIG_TARGET
pushd out/$ZIG_TARGET

zig ar -M <<EOM
    CREATE libctags.a
    ADDLIB ../../root/usr/local/lib/libctags.a
    ADDLIB ../../root/usr/local/lib/libutil.a
    ADDLIB ../../root/usr/local/lib/libgnu.a
    ADDLIB ../../root/usr/local/lib/libxml2.a
    SAVE
    END
EOM

zig cc -target $ZIG_TARGET -o test ../../test.c libctags.a