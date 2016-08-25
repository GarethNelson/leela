CFLAGS = -DX64 -mcmodel=large -mtls-direct-seg-refs -mno-red-zone -Ikernel/include -Ibuild/sysroot/usr/include -nostdlib -lgcc -ffreestanding -Wall -fPIC
LDFLAGS = -nodefaultlibs
CC = x86_64-elf-gcc
LD = x86_64-elf-ld
OBJCOPY = x86_64-elf-objcopy
OBJDUMP = x86_64-elf-objdump

KERNEL_OBJS :=\
        build/console.o\
        build/exec.o\
        build/ioapic.o\
        build/kalloc.o\
        build/kbd.o\
        build/lapic.o\
        build/main.o\
        build/mp.o\
        build/acpi.o\
        build/picirq.o\
        build/proc.o\
        build/spinlock.o\
        build/string.o\
        build/swtch64.o\
        build/syscall.o\
        build/sysproc.o\
        build/timer.o\
        build/trapasm64.o\
        build/trap.o\
        build/uart.o\
        build/vectors.o\
        build/vm.o\
        build/vm64.o\
	build/sysroot/usr/lib/no-red-zone/libc.a\
	build/sysroot/usr/lib/no-red-zone/libm.a\
	build/sysroot/usr/lib/no-red-zone/libnosys.a

build/entryother.o: kernel/entryother.S
	$(CC) $(CFLAGS) -fno-pic -nostdinc -Ikernel/include -o $@ -c $<
	$(CC) $(CFLAGS) -N -e start -Ttext 0x7000 -o build/bootblockother.o build/entryother.o

build/initcode.o: kernel/initcode.S
	$(CC) $(CFLAGS) -nostdinc -Ikernel/include -o build/initcode.o -c kernel/initcode64.S
	$(CC) $(CFLAGS) -N -e start -Ttext 0 -o build/initcode.out build/initcode.o

build/%.o: kernel/%.c
	mkdir -p build
	$(CC) $(CFLAGS) -c -o $@ $<

build/%.o: kernel/%.S
	mkdir -p build
	$(CC) $(CFLAGS) -c -o $@ $<

build/vectors.o: build/vectors.S
	$(CC) $(CFLAGS) -c -o $@ $<

build/vectors.S: kernel/vectors64.pl
	$< >$@

build/entryother: build/entryother.o
	$(OBJCOPY) -S -O binary -j .text build/bootblockother.o build/entryother

build/initcode: build/initcode.o
	$(OBJCOPY) -S -O binary -j .text build/initcode.out build/initcode

build/kernel.elf: $(KERNEL_OBJS) build/entry64.o build/entryother build/initcode
	$(LD) $(LDFLAGS) -T kernel/kernel64.ld -o $@ build/entry64.o $(KERNEL_OBJS) -b binary build/entryother build/initcode
	$(OBJDUMP) -t build/kernel.elf | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > build/kernel.sym
	

all: build/kernel.elf
