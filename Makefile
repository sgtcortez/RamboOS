BOOT_DIR    =./boot
BUILD_DIR   =./.build

EXECUTABLE=$(BOOT_DIR)/.build/bootloader.bin

all: compile_all run

.PHONY: run compile_all clean

run: $(EXECUTABLE)
	@qemu-system-x86_64 -m 1024M -drive file=$<,format=raw,index=0,if=ide

compile_all:	
	@make --silent --directory=$(BOOT_DIR) 

clean:
	@rm -Rf ./build/*.img 
	@make --silent --directory=$(BOOT_DIR) clean