CFLAGS = -DX64 -mcmodel=kernel -mtls-direct-seg-refs -mno-red-zone -Ikernel/include -nostdlib -lgcc -ffreestanding -fbuiltin
LDFLAGS = -nodefaultlibs
CC = x86_64-elf-gcc
LD = x86_64-elf-ld
OBJCOPY = x86_64-elf-objcopy

KERNEL_OBJS :=\
        build/bio.o\
        build/console.o\
        build/exec.o\
        build/file.o\
        build/fs.o\
        build/ide.o\
        build/ioapic.o\
        build/kalloc.o\
        build/kbd.o\
        build/lapic.o\
        build/log.o\
        build/main.o\
        build/mp.o\
        build/acpi.o\
        build/picirq.o\
        build/pipe.o\
        build/proc.o\
        build/spinlock.o\
        build/string.o\
        build/swtch64.o\
        build/syscall.o\
        build/sysfile.o\
        build/sysproc.o\
        build/timer.o\
        build/trapasm64.o\
        build/trap.o\
        build/uart.o\
        build/vectors.o\
        build/vm.o\
        build/vm64.o

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

build/entryother: build/entryother.o
	$(OBJCOPY) -S -O binary -j .text build/bootblockother.o build/entryother

build/initcode: build/initcode.o
	$(OBJCOPY) -S -O binary -j .text build/initcode.out build/initcode

build/kernel.elf: $(KERNEL_OBJS) build/entry64.o build/entryother build/initcode
	$(LD) $(LDFLAGS) -T kernel/kernel64.ld -o $@ build/entry64.o $(KERNEL_OBJS) -b binary build/entryother build/initcode

all: build/kernel.elf
