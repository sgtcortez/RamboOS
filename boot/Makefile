# The Assembly Compiler/Translator
ASM_C=nasm

# NASM flags to be used when translating to machine code
ASM_FLAGS=

BUILD_DIR=./.build

BOOTLOADER=$(BUILD_DIR)/bootloader.bin

all: $(BOOTLOADER)

$(BOOTLOADER): bootloader.s
	@$(ASM_C) $(ASM_FLAGS) -f bin -o $@  $<

clean:
	@rm -Rf $(BUILD_DIR)/*.bin