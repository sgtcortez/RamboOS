# Our C compiler
CC=clang

# https://stackoverflow.com/questions/39807710/unexpected-output-when-printing-directly-to-text-video-memory
C_FLAGS=-nostdlib -ffreestanding -std=c11 -m32 -g

BUILD_DIR=./.build

KERNEL=$(BUILD_DIR)/kernel.o

all: $(KERNEL)

$(KERNEL): kernel.c kernel.h
	@$(CC) $(C_FLAGS) -c $< -o $@

.PHONY: clean

clean:
	@rm -Rf $(KERNEL)