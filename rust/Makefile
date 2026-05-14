BOOT     = ../common/boot.asm
LDSCRIPT = ../common/linker.ld

AS       = nasm
ASFLAGS  = -f elf32

LD       = ld
LDFLAGS  = -m elf_i386 -T $(LDSCRIPT)

RUSTC    = rustc
RFLAGS   = --target i686-unknown-linux-gnu \
           --edition 2024 \
           -C panic=abort \
           -C opt-level=2 \
           -C relocation-model=static \
           -C code-model=kernel \
           --emit=obj

OBJ      = boot.o kernel.o

all: kernel.elf

boot.o: $(BOOT)
	$(AS) $(ASFLAGS) $< -o $@

kernel.o: src/main.rs
	$(RUSTC) $(RFLAGS) $< -o $@

kernel.elf: $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $(OBJ)

iso/boot/grub/grub.cfg:
	mkdir -p iso/boot/grub
	echo 'menuentry "MyKernel" { multiboot /boot/kernel.elf }' > $@

mykernel.iso: kernel.elf iso/boot/grub/grub.cfg
	cp kernel.elf iso/boot/
	grub-mkrescue -o $@ iso/

run: kernel.elf
	qemu-system-i386 -kernel kernel.elf

run-iso: mykernel.iso
	qemu-system-i386 -cdrom mykernel.iso

clean:
	rm -f $(OBJ) kernel.elf mykernel.iso
	rm -rf iso/

.PHONY: all run run-iso clean
