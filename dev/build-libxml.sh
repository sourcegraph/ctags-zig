# Do not invoke this script, use build.sh instead.

ensureDependency "libxml" "https://github.com/GNOME/libxml2" $LIBXML_VERSION
log "building deps/libxml..."

log "./autogen.sh"
./autogen.sh

./configure --host=$AUTOCONF_HOST \
    --prefix=/usr/local \
    --enable-static \
    --without-zlib \
    --without-lzma \
    --without-readline \
    --without-iconv \
    CC="zig cc --target=$ZIG_TARGET" \
    CPP="zig cc -E" \
    AR="zig ar" \
    RANLIB="zig ranlib" \
    CC_FOR_BUILD=$(which cc)

make -j8 --load-average=8 CC="zig cc --target=$ZIG_TARGET" CXX="zig c++ --target=$ZIG_TARGET" V=1

make install DESTDIR=`pwd`/../../root
rm `pwd`/../../root/usr/local/include/libxml
ln -s `pwd`/../../root/usr/local/include/libxml2/libxml `pwd`/../../root/usr/local/include/libxml