#ifndef __KERNEL_H__
#define __KERNEL_H__

/**
 * This is the main function of our operating system ...
 * The bootloader will load us here
 */
void kernel_main(void) __attribute__((section(".text.kernel")));

#endif
