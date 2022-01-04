/*
    Our entry point
*/
ENTRY(kernel_main)


SECTIONS {

    /*
    text address, same idea as the ORG directive
     in NASM
    */
    . = 0x1000;
    .text : {
        /*
            put everything that is into the section .text.kernel at first
        */
        *(.text.kernel);
        *(.text*);
    }

    /*
        Output the data sections
     */
    .data : {
        *(.data*);
    }

    .rodata : {
        *(.rodata*);
    }
}