# Makefile to build boot.img with boot sector, loader, and kernel

# Tools
NASM = nasm
GCC = i386-elf-gcc
LD = i386-elf-ld
QEMU = qemu-system-i386
DD = dd

# Files
BOOT_ASM = boot.asm
LOADER_ASM = kernel.asm
KERNEL_C = kernel.c

BOOT_BIN = boot.bin
LOADER_BIN = loader.bin
KERNEL_OBJ = kernel.o
KERNEL_BIN = kernel.bin
IMG = boot.img

.PHONY: all run clean

all: $(IMG)

$(BOOT_BIN): $(BOOT_ASM)
	$(NASM) -f bin -o $@ $<

$(LOADER_BIN): $(LOADER_ASM)
	$(NASM) -f bin -o $@ $<

$(KERNEL_OBJ): $(KERNEL_C)
	$(GCC) -m32 -ffreestanding -c $< -o $@

$(KERNEL_BIN): $(KERNEL_OBJ)
	$(LD) -Ttext 0x10000 -o $@ $< --oformat=binary -nostdlib

$(IMG): $(BOOT_BIN) $(LOADER_BIN) $(KERNEL_BIN)
	# Create empty disk image (if not exist)
	truncate -s 0 $(IMG)
	# Write boot sector
	$(DD) if=$(BOOT_BIN) of=$(IMG) bs=512 count=1 conv=notrunc
	# Write stage 2 loader at sector 1
	$(DD) if=$(LOADER_BIN) of=$(IMG) bs=512 count=5 seek=1 conv=notrunc
	# Write kernel binary at sector 6
	$(DD) if=$(KERNEL_BIN) of=$(IMG) bs=512 count=5 seek=6 conv=notrunc
	# Write zero padding at sector 11
	$(DD) if=/dev/zero of=$(IMG) bs=512 count=1 seek=11 conv=notrunc

run: $(IMG)
	$(QEMU) -drive format=raw,file=$(IMG)

clean:
	rm -f $(BOOT_BIN) $(LOADER_BIN) $(KERNEL_OBJ) $(KERNEL_BIN) $(IMG)
