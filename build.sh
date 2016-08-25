#!/bin/bash
export PATH=$PWD/toolchain/x86_64-elf-5.3.0-Linux-x86_64/bin/:$PATH

echo Building xv6 kernel
make all

echo Building root filesystem image
mkdir -p build/sysroot
cp README.md build/sysroot/
cp build/kernel.elf build/sysroot/vmunix
virt-make-fs --type=ext2 build/sysroot fs.img
