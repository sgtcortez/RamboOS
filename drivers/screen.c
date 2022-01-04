#include "screen.h"

/**
 * This is the memory address
 * that the vga buffer is loaded
 * http://www.osdever.net/FreeVGA/vga/vgamem.htm
 */
#define VIDEO_MEMORY_ADDRESS_BASE  0xB8000
#define VIDEO_MEMORY_ADDRESS_LIMIT 0xBFFFF

// Vga screen
#define VGA_HEIGHT          25
#define VGA_WIDTH           80
#define BYTES_USED_PER_CELL 2
#define GET_STARTING_CELL(row, column) \
    ((volatile unsigned char *)VIDEO_MEMORY_ADDRESS_BASE + BYTES_USED_PER_CELL * (row * VGA_WIDTH + column));

void clear_screen(void) {
    volatile unsigned char *video_pointer = (volatile unsigned char *)VIDEO_MEMORY_ADDRESS_BASE;
    for (int address = VIDEO_MEMORY_ADDRESS_BASE, cell = 0; address < VIDEO_MEMORY_ADDRESS_LIMIT; address++, cell += 2) {
        *(video_pointer + cell)     = ' ';
        *(video_pointer + cell + 1) = 0x00;
    }
}

void print_at(char *pointer, int attributes, unsigned int row, unsigned int column) {

    volatile unsigned char *video_pointer = GET_STARTING_CELL(row, column);
    while (*pointer) {
        *video_pointer       = *pointer;
        *(video_pointer + 1) = attributes;
        video_pointer += 2;
        pointer++;
    }
}
