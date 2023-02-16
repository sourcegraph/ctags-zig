#!/usr/bin/env bash
docker build -t ctags-zig-builder .
docker run -it -v $(pwd):/ctags-zig ctags-zig-builder
