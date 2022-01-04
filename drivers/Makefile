# Our C compiler
CC=clang

# https://stackoverflow.com/questions/39807710/unexpected-output-when-printing-directly-to-text-video-memory
C_FLAGS=-std=c11 -m32 -g

BUILD_DIR=./.build

KEYBOARD=$(BUILD_DIR)/screen.o

all: $(KEYBOARD)

$(KEYBOARD): screen.c screen.h
	@$(CC) $(C_FLAGS) -c $< -o $@

.PHONY: clean

clean:
	@rm -Rf $(KEYBOARD)