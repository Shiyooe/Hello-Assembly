# Makefile for SimpleOS

ASM = nasm
CC = gcc
LD = ld

ASMFLAGS = -f bin
CFLAGS = -m32 -ffreestanding -nostdlib -fno-pie -fno-stack-protector -O2
LDFLAGS = -m elf_i386 -Ttext 0x1000 --oformat binary

all: os.img

boot.bin: boot.asm
	$(ASM) $(ASMFLAGS) boot.asm -o boot.bin

kernel_entry.o: kernel.asm
	$(ASM) -f elf32 kernel.asm -o kernel_entry.o

kernel.o: kernel.c
	$(CC) $(CFLAGS) -c kernel.c -o kernel.o

kernel.bin: kernel_entry.o kernel.o
	$(LD) $(LDFLAGS) kernel_entry.o kernel.o -o kernel.bin

os.img: boot.bin kernel.bin
	cat boot.bin kernel.bin > os.img
	# Pad to 1.44MB for floppy disk image
	truncate -s 1440K os.img

run: os.img
	qemu-system-i386 -fda os.img

clean:
	rm -f *.bin *.o os.img

.PHONY: all run clean