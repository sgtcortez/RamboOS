# clang linker
LINKER=ld.lld

BOOT_DIR    =./boot
KERNEL_DIR  =./kernel
DRIVERS_DIR =./drivers
BUILD_DIR   =./.build

# Link script used to set our kernel address at specific address
LINK_SCRIPT=link.ld

# Our system executable
EXECUTABLE=$(BUILD_DIR)/rambo-os.img

# Bootloader that is responsible for the operatin system startup
BOOTLOADER_BINARY=$(BOOT_DIR)/.build/bootloader.bin

# Our kernel binary, that will be loaded by the bootloader
KERNEL_BINARY=$(BUILD_DIR)/kernel.bin

# Other files that must be loaded with the kernel. Example: Drivers
OBJS=\
	$(KERNEL_DIR)/.build/kernel.o  \
	$(DRIVERS_DIR)/.build/screen.o

# Default recipe 
all: $(EXECUTABLE)

$(EXECUTABLE): compile_all $(KERNEL_BINARY)
	@cat $(BOOTLOADER_BINARY) $(KERNEL_BINARY) 1> $@

$(KERNEL_BINARY): $(LINK_SCRIPT)
# https://stackoverflow.com/questions/42301831/change-entry-point-with-gnu-linker
# PS -> Use -M to see the table that the link generated ...
	@$(LINKER) -o $@ --oformat binary -T$< -melf_i386 $(OBJS)

.PHONY: compile_all clean

run: $(EXECUTABLE)
	@qemu-system-x86_64 -m 1024M -drive file=$<,format=raw,index=0,if=ide

debug: $(EXECUTABLE)
# https://qemu-project.gitlab.io/qemu/system/gdb.html
# https://stackoverflow.com/questions/14242958/debugging-bootloader-with-gdb-in-qemu
	@qemu-system-x86_64 -s -S -m 1024M -drive file=$<,format=raw,index=0,if=ide &
	@gdb --quiet -ex "add-symbol-file $(KERNEL_DIR)/.build/kernel.o 0x100000" -ex "break kernel_main" -ex "target remote localhost:1234"

compile_all:	
	@make --silent --directory=$(BOOT_DIR) 
	@make --silent --directory=$(KERNEL_DIR) 
	@make --silent --directory=$(DRIVERS_DIR)

clean:
	@bash -c 'rm -Rf ${BUILD_DIR}/*.{img,bin}' 
	@make --silent --directory=$(BOOT_DIR) clean
	@make --silent --directory=$(KERNEL_DIR) clean	
	@make --silent --directory=$(DRIVERS_DIR) clean		