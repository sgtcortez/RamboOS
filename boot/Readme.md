# Summary

- [Introduction](#Introduction)
- [Bios Routines](#Bios-Routines)   
    + [Video Routines](#Video-Routines)    
    + [Disk Routines](#Disk-Routines)
- [Bootloaders](#Bootloaders)
- [Useful information about NASM](#Useful-information-about-NASM)

# Introduction

This directory, contains the source code that is responsible to load the kernel, and gives the execution to it.    
It is loaded by BIOS to the memory address: `0x7C00`.   

# Bios Routines

Since **BIOS** is the firware that is embedded into the mother board, it has full acknowledge of the available hardware.   
So, it provides some abstractions to use in form of routines ...   

- ## Video Routines

- ## Disk Routines

# Bootloaders

For educational purposes, I am using single boot loader ... Because is simpler(at least for now ...).   
The bios just load the first 512 of the first sector into memory and gives the execution to it.  

Then, I print some information messages, and load the kernel at the address 0x1000 and gives the execution to it.

- GDT table

    The GDT table, is the heart of protected mode ...   
    Since, we start at real mode(full control of the processor and memory), we need to configure the GDT to tell to processor the limits and privilegies from processs(user processes) that will run on the system ...

- CR0 Control Register

    CR0 is the primary control register. It is 32 bits, any bit means something ...
    
    | Bit | Description | 
    | :-: | :-: |
    | 0 | Protected Environment. If *1*, puts the system into protected mode. *0*(default) the processor is in real mode |

# Useful information about NASM 

The [ORG](https://www.nasm.us/doc/nasmdoc8.html#section-8.1.1) is a special directive, which tells NASM to assume that the program begins at the *address*.    
**Example:**    
```asm
; Tells nasm to assume that the program is at the address 0x7C00
ORG 0x7C00 
```