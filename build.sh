#!/bin/bash
set -e
export PATH=$PWD/toolchain/x86_64-elf-5.3.0-Linux-x86_64/bin/:$PATH

echo Building newlib for kernel
mkdir -p newlib/build
mkdir -p build/sysroot
pushd newlib/build
CFLAGS="-fPIC -mcmodel=large" .././configure --target=x86_64-elf-xv6 --prefix=/usr CC_FOR_TARGET=x86_64-elf-gcc AS_FOR_TARGET=x86_64-elf-gcc LD_FOR_TARGET=x86_64-elf-ld AR_FOR_TARGET=x86_64-elf-ar RANLIB_FOR_TARGET=x86_64-elf-ranlib CFLAGS="-fPIC -mcmodel=large"
make all
make DESTDIR=`realpath ../../build/sysroot` install
popd

cp -ar build/sysroot/usr/x86_64-elf-xv6/* build/sysroot/usr/

echo Building xv6 kernel
make all

echo Building root filesystem image
mkdir -p build/sysroot
cp README.md build/sysroot/
cp build/kernel.elf build/sysroot/vmunix
virt-make-fs --type=ext2 build/sysroot fs.img
