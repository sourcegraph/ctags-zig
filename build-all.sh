#!/usr/bin/env bash
set -euo pipefail

rm -rf out/ # since we are building everything all at once
./build-x86_64-linux.sh
