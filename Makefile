CFLAGS = -m64 -DX64 -mcmodel=kernel -mtls-direct-seg-refs -mno-red-zone

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

build/%.o: kernel/%.c
	mkdir -p build
	$(CC) $(CFLAGS) -c -o $@ $<

build/%.o: kernel/%.S
	mkdir -p build
	$(CC) $(CFLAGS) -c -o $@ $<

build/kernel.elf: $(KERNEL_OBJS)

all: build/kernel.elf
