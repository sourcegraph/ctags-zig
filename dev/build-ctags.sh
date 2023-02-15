# Do not invoke this script, use build.sh instead.

ensureDependency "ctags" "https://github.com/universal-ctags/ctags" $CTAGS_VERSION
log "building deps/ctags..."

log "./autogen.sh"
./autogen.sh

./configure --host=$AUTOCONF_HOST \
    --prefix=/usr/local \
    --enable-static \
    --disable-seccomp \
    --disable-pcre2 \
    --disable-json \
    --disable-iconv \
    CC="zig cc --target=$ZIG_TARGET" \
    CPP="zig cc -E" \
    AR="zig ar" \
    RANLIB="zig ranlib" \
    CC_FOR_BUILD=$(which cc)

make -j8 --load-average=8 CC="zig cc --target=$ZIG_TARGET" CXX="zig c++ --target=$ZIG_TARGET" V=1

make install DESTDIR=`pwd`/../../root

# ctags is not designed to be used as a library, but we do so anyway.
mkdir -p ../../root/usr/local/lib
cp *.a ../../root/usr/local/lib/
cp gnulib/libgnu.a ../../root/usr/local/lib/
