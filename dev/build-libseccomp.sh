# Do not invoke this script, use build.sh instead.

ensureDependency "libseccomp" "https://github.com/seccomp/libseccomp" $LIBSECCOMP_VERSION
log "building deps/libseccomp..."

log "./autogen.sh"
./autogen.sh

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
