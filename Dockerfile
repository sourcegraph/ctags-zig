FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y install \
    build-essential autoconf libtool gperf pkg-config xz-utils wget git

RUN wget -c https://ziglang.org/builds/zig-linux-$(arch)-0.11.0-dev.1605+abc9530a8.tar.xz -O - | tar -xJ --strip-components=1 -C /usr/local/bin

RUN zig version

WORKDIR /ctags-zig
ENTRYPOINT ["/ctags-zig/build-x86_64-linux.sh"]