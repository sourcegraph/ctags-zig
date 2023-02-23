# Do not invoke this script, use build.sh instead.

ensureDependency "libjansson" "https://github.com/akheron/jansson" $LIBJANSSON_VERSION
log "building deps/libjansson..."
set -x

autoreconf -i
./configure --host=$AUTOCONF_HOST \
    --prefix=/usr/local \
    --enable-static \
    CC="zig cc --target=$ZIG_TARGET" \
    CPP="zig cc -E" \
    AR="zig ar" \
    RANLIB="zig ranlib" \
    CC_FOR_BUILD=$(which cc)

make -j8 --load-average=8 CC="zig cc --target=$ZIG_TARGET" CXX="zig c++ --target=$ZIG_TARGET" V=1

make install DESTDIR=`pwd`/../../root
