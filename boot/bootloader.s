; --------------------------------------------
; This file the bootloader first stage
; This file is responsible to print some initial
; information and then, load and execute the kernel
; Note: The code must fit in at most 510 bytes ...
; this is because, the byte 510 and 511 are reserved
; to the magic number.
; If, not set, BIOS will not load the sector to the
; main memory and transfer the execution ...

; --------------------------------------------
; Boot Sector definitions
; --------------------------------------------
%define BOOT_LOADER_BASE_ADDRESS     0x7C00
%define BOOT_SECTOR_SIGNATURE        0xAA55

; --------------------------------------------
; Kernel Definitions
; --------------------------------------------
%define KERNEL_LOAD_ADDRESS 0x1000

; --------------------------------------------
; Others definitions
; --------------------------------------------
%define ZERO_BYTE           0x00
%define ONE                 0x01
%define STACK_START_ADDRESS 0x90000

; TODO: It is not good to hardcode it, because, since we are adding
; more and more code, we will need to load more and more sectors ...
%define SECTORS_TO_LOAD 0x01


; bootloader absolute memory address
; It is defined that BIOS will load us at this memory address
; ORG means ORIGIN
; The function of ORG is to specify the origin address which nasm will assume
; the program begins when, it is loaded into memory
ORG BOOT_LOADER_BASE_ADDRESS

; We start at 16 bits real mode
[ BITS 16 ]

; --------------------------------------------
; Bootloader Entry Point
; It must be the first routine in this file!
; Since, we are not using a linker, this MUST be the first label, otherwise
; the BIOS can not load our bootloader
; --------------------------------------------
_start:
  ; start section
  JMP bootloader

; Initial message that will be shown to the screen
initial_message:
  ; Initial bootloader message
  DB "Welcome to RamboOS!", ZERO_BYTE

ask_key_press:
  DB "Please, press any key to continue ...", ZERO_BYTE
disk_error_msg:
  DB "Could not read data from disk ... Aborting ...", ZERO_BYTE
disk_sectors_count_read:
  DB "Could not read the number of sectors requested ... Aborting ...", ZERO_BYTE

disk_reset_error_msg:
  DB "Could not reset the disk ... Aborting ...", ZERO_BYTE

; The boot disk drive that we are
; It will work for floppy, hard disk, cds ...
boot_disk_drive:
  ; Bios load the boot drive at the DL register
  RESB 0

; --------------------------------------------
; This routine prints a welcome message
; and load the second stage bootloader
; that is on the second sector
; --------------------------------------------
bootloader:

  ; We need to do this, because, if not, since the stack grows backwards, we would overwrite the bootloader address.
  MOV BP, 0x9000          ; Sets the stack base pointer
  MOV SP, BP              ; Sets the stack pointer

  ; BIOS stores our boot drive in DL, so, its good to save this
  ; into memory for later use
  MOV [boot_disk_drive], DL

  CALL line_feed          ; To starts from a fresh line

  XOR AX, AX              ; Zero this register
  MOV SI, initial_message ; Moves the message pointer to the string index
  CALL print_string       ; Calls the print function
  CALL line_feed          ; Advance to the next line

  ; Reads the next sector(currently, we are at the first sector)
  ; Because, bios will load the first sector of a drive
  ; which contains the BIOS magic number
	MOV		AL, SECTORS_TO_LOAD			; read N sectors
	MOV		CH, 0					          ; We are reading the second sector past us, so its still on track 1
	MOV		CL, 2					          ; sector to read (The second sector). Sectors start from 1, and, since
                                ; our boot sector is the first sector, we load the next one
	MOV		DH, 0					          ; Disk Head number
  MOV   DL, [boot_disk_drive]   ; Boot drive

  XOR BX, BX                    ; Zero the BX
  MOV ES, BX                    ; Move 0 to Extra Data Segment

  ; Move the address SECOND_SECTOR_MEMORY_ADDRESS, so
  ; our buffer points to 0x00:SECOND_SECTOR_MEMORY_ADDRESS
  ; So, the next bootloader will be loaded at address
  ; 0x00 * 16 + offset
  ; In this case, BIOS will load our second sector(which contains the kernel code)
  ; into: 0x00 * 16 + 0x1000 = 0x00 + 0x1000 = 0x1000
  MOV BX, KERNEL_LOAD_ADDRESS

  CALL read_hard_disk_sector       ; Calls the function that read from disk and
                                   ; stores the loaded sector into Extra Data Segment at address 0x1000

  CALL line_feed                   ; Breaks a line
  MOV SI, ask_key_press            ; Moves the string to the source index register
  CALL print_string                ; Prints the message that ask the user to press a key
  CALL read_key                    ; Calls the function. There is no need to do something with the value
                                   ; so, we just ignore it.

  CALL gdt_install                 ; Installs the GDT and makes the switch to protected mode

  JMP CODE_SEGMENT:load_kernel     ; Makes a JUMP to the load kernel routine


; Includes files that are used while booting the system
%include "./bios-disk.s"
%include "./bios-video.s"
%include "./gdt.s"
%include "./bios-keyboard.s"

; When, we execute this routine, we will be in 32 bits protected mode
[BITS 32]
load_kernel:

  ; Once, in protected mode, we need to reset the segment registers
  ; to avoid future problems ...
  MOV AX, START_DATA_SEGMENT
  MOV DS, AX
  MOV ES, AX
  MOV FS, AX
  MOV GS, AX
  MOV SS, AX

  ; The start address of the stack
  MOV ESP, STACK_START_ADDRESS
  MOV EBP, STACK_START_ADDRESS



  ; The Code Segment(CS) still has the last segment address used in real mode.
  ; So, we make this FAR Jump to force the processor to clean his cache and segments ...
  ; Just remember that we set the GDT table, and, our code descriptor is the eight byte
  ; from the start of the GDT
  ; So, we jump to the 0x08(which, is the code segment)
  JMP START_CODE_SEGMENT:KERNEL_LOAD_ADDRESS

  ; In case the kernel returns ...
  ; It must not happen, but, can happen ...
  ; We halt the system
  HLT

; --------------------------------------------
; --------------------------------------------
; Note, the code below, should be there
; you must not do anything else below !
; anything that you wish to do, should be above
; from here
; We pad the rest of sector available with zero
; because, we need to put the suffix:
; 0xAA at byte 510 and 0x55 at byte 511
; --------------------------------------------
; --------------------------------------------
TIMES 510 - ( $ - $$ ) DB ZERO_BYTE

; Boot sector signature 0xAA55
; It mus be the byte 510 and 511!
; Otherwise, the bios will not load our sector
DW BOOT_SECTOR_SIGNATURE



