# ctags-zig: universal-ctags built with Zig

This uses Zig as a C/C++ compiler to build universal-ctags in a hermetic build environment, cross-compiling to most major OSs.

## Building

### Via Docker

```sh
./build-all-docker.sh
```

### Natively (macOS or Linux)

Make sure you have:

* A recent (nightly) version of Zig
* Linux: `apt-get install build-essential autoconf libtool gperf pkg-config`
* macOS: `brew install autoconf automake libtool coreutils`

Run `./build-all.sh`

**Important**: `libseccomp` can only be built from a Linux host machine, so if building under macOS then Linux ctags binaries produced will not have seccomp.

## Results

You can `find out` to see the build results:

```
ctags-zig % find out 
out
out/x86_64-macos
out/x86_64-macos/test
out/x86_64-macos/libctags.a
out/aarch64-macos
out/aarch64-macos/test
out/aarch64-macos/libctags.a
out/x86_64-linux
out/x86_64-linux/test
out/x86_64-linux/libctags.a
```

## Usage

`test.c` shows usage, it is a tiny program which invokes `ctags_cli_main`
