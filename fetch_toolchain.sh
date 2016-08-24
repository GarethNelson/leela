#!/bin/bash
mkdir -p toolchain
pushd toolchains
./doit -a x86_64 -o `realpath ../toolchain` -f -c -j`nproc --all`
popd

