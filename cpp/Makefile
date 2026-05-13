CC      = clang++
CFLAGS  = --target=i386-elf -ffreestanding -fno-builtin \
          -fno-exceptions -fno-rtti -fno-stack-protector \
					-fno-pic -fno-pie -nostdlib -m32 -Wall -Wextra

AS      = nasm
ASFLAGS = -f elf32

LD      = ld
LDFLAGS = -m elf_i386 -T linker.ld

OBJ     = boot.o kernel.o

all: kernel.elf

%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

%.o: %.cpp
	$(CC) $(CFLAGS) -c $< -o $@

kernel.elf: $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $(OBJ)

iso/boot/grub/grub.cfg:
	mkdir -p iso/boot/grub
	echo 'menuentry "cpp kernel" { multiboot /boot/kernel.elf }' > $@

cppkernel.iso: kernel.elf iso/boot/grub/grub.cfg
	cp kernel.elf iso/boot/
	grub-mkrescue -o $@ iso/

run: kernel.elf
	qemu-system-i386 -kernel kernel.elf

run-iso: cppkernel.iso
	qemu-system-i386 -cdrom cppkernel.iso

clean:
	rm -f $(OBJ) kernel.elf
	rm -rf iso/

.PHONY: all clean
