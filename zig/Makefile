LDSCRIPT = ../common/linker.ld
BOOT     = ../common/boot.asm

all: boot.o
	zig build

boot.o: $(BOOT)
	nasm -f elf32 $< -o $@

run: all
	qemu-system-i386 -kernel zig-out/bin/kernel

iso/boot/grub/grub.cfg:
	mkdir -p iso/boot/grub
	echo 'menuentry "Zig Kernel" { multiboot /boot/kernel.elf }' > $@

zigkernel.iso: all iso/boot/grub/grub.cfg
	cp zig-out/bin/kernel iso/boot/kernel.elf
	grub-mkrescue -o $@ iso/

run-iso: zigkernel.iso
	qemu-system-i386 -cdrom zigkernel.iso

clean:
	rm -rf zig-out zig-cache iso/ zigkernel.iso boot.o

re: clean all

.PHONY: all run run-iso clean
