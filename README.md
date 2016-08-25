directory layout:

build.sh           - run this to build the whole system
DESIGN             - random design notes
fetch_toolchain.sh - fetches and builds a gcc+binutils toolchain
kernel             - xv6 kernel source
Makefile           - kernel makefile
newlib             - port of newlib to kernel space (yes, kernel space)
README.md          - this file
TODO               - list of stuff that's not done yet
toolchains         - scripts for building toolchains

Build dependencies:
   cmake
   gcc and friends
   libguestfs tools
   wget
   git

