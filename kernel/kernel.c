#include "kernel.h"

char *KERNEL_LOADED    = "The RamboOS Kernel Developer successfully loaded into main memory!";

/**
 * This is the memory address
 * that the vga buffer is loaded
 * http://www.osdever.net/FreeVGA/vga/vgamem.htm
 */
#define VIDEO_MEMORY_ADDRESS_BASE  0xB8000


// Our bootloader will load the code, and give the execution
// to this main
void kernel_main(void) {

    const int total_colors = 5;

    int colors[total_colors];
    colors[0] = 0x0F;
    colors[1] = 0x0E;
    colors[2] = 0x0D;
    colors[3] = 0x0C;
    colors[4] = 0x0B;

    const int size = 67;
    char *ptr = (char *) VIDEO_MEMORY_ADDRESS_BASE;    
    int video_screen = 0;
    for (int index = 0; index < size; index++) {
        *(ptr+video_screen) = KERNEL_LOADED[index]; 
        // https://www.fountainware.com/EXPL/vga_color_palettes.htm
        *(ptr+video_screen+1) = colors[index % total_colors];
        video_screen+=2;
    }

    // We can not return to the CPU.
    // It means that the kernel execution must never end!
    while (1) {
    }
}
