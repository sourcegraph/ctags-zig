
## Via Docker

```sh
./build-all-docker.sh
```

## Natively (macOS or Linux)

Make sure you have:

* A recent (nightly) version of Zig
* Linux: `apt-get install build-essential autoconf libtool gperf pkg-config`
* macOS: `brew install autoconf automake libtool coreutils`

Run `./build-all.sh`

**Important**: `libseccomp` can only be built from a Linux host machine, so if building under macOS then Linux ctags binaries produced will not have seccomp.
