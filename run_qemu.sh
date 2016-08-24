#!/bin/sh



kvm -m 4G -serial stdio -debugcon file:debug.log -global isa-debugcon.iobase=0x402 -vga std -kernel build/kernel.elf

