#include "kernel.h"

char *KERNEL_LOADED    = "The RamboOS Kernel Developer successfully loaded into main memory!";

#include "../drivers/screen.h"

// Our bootloader will load the code, and give the execution
// to this main
void kernel_main(void) {

    clear_screen();

    const int total_colors = 10;

    int colors[total_colors];
    colors[0] = 0x0F;
    colors[1] = 0x0E;
    colors[2] = 0x0D;
    colors[3] = 0x0C;
    colors[4] = 0x0B;
    colors[5] = 0x0A;
    colors[6] = 0x09;
    colors[7] = 0x08;
    colors[8] = 0x07;
    colors[9] = 0x06;

    for (int index = 0; index < total_colors; index++) {
        print_at(KERNEL_LOADED, colors[index], index, 0);
    }

    // We can not return to the CPU.
    // It means that the kernel execution must never end!
    while (1) {
    }
}
