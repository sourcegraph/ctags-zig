# Do not invoke this script, use build.sh instead.

ensureDependency "libpcre2" "https://github.com/PCRE2Project/pcre2" $LIBPCRE2_VERSION
log "building deps/libpcre2..."

# pcre2 upstream already supports building with Zig (they provide a build.zig file) so
# we do not need to do much
zig build -Dtarget=$ZIG_TARGET

cp zig-out/include/pcre2.h ../../root/usr/local/include
cp zig-out/lib/libpcre2.a ../../root/usr/local/lib
