; --------------------------------------------
; --------------------------------------------
;   GDT Routines
; GDT is needed to make the switch from
; real mode to protected mode
; Note, we are using Flat Protected mode, which
; means that, our base data segment is zero
; --------------------------------------------
; --------------------------------------------

; --------------------------------------------
; GDT and Protected Mode definitions
; --------------------------------------------
%define STACK_POSITION 0x9000
%define START_CODE_SEGMENT 0x08
%define START_DATA_SEGMENT 0x10
%define ZERO_BYTE 0x00
%define CODE_SEGMENT_DESCRIPTOR_TYPE 0x9A
%define DATA_SEGMENT_DESCRIPTOR_TYPE 0x92
%define SEGMENT_LIMIT 0xFFFF

; Each descriptor is exactly 8 bytes(64 bits) in size!
; Because of this, the code descriptor has offset 0x08
; and, the data descriptor has the offset 0x10

gdt_start_descriptors:

; Mandatory null descriptor
; Just fill 8 bytes with zero
gdt_null_descriptor:
  DD ZERO_BYTE
  DD ZERO_BYTE

; --------------------------------------------
; The CODE DESCRIPTOR
; --------------------------------------------
gdt_code_descriptor:
  ; Bits: 0-15
  ; It is not possible to use an address greater than 0xFFFF
  DW SEGMENT_LIMIT

  ; Bits: 16-39
  ; Attention, these bits are used with the bits: 56-63.
  ; Together, they make a 4 byte base address.
  ; These part here, is the 0-23

  ; The starting address. It has the same meaning of an segment register.
  ; For example, in real mode(16 bits) we can not access address that are bigger than: 2¹⁶-1
  ; So, we can use segment register to be able to bypass this limitation ...

  ; MOV BX, 0x4000
  ; MOV ES, BX
  ; MOV [ES:0xFE56], AX
  ; Will be translated to the physcal address: 0x4FE56

  ; When using GDT, we have the same idea, but, with another implementation ...
  DW ZERO_BYTE
  DB ZERO_BYTE

  ; Bits: 40-47
  ; The access byte
  DB CODE_SEGMENT_DESCRIPTOR_TYPE

  ; Bits: 48-55
  ; The granulatiry byte
  DB 0b11001111

  ; Bits: 56-63
  ; Attention, this part is the second part of the base address, it is the Bits 24-32
  DB ZERO_BYTE


; --------------------------------------------
; The DATA DESCRIPTOR
; --------------------------------------------
gdt_data_descriptor:
  DW SEGMENT_LIMIT
  DW ZERO_BYTE
  DB ZERO_BYTE
  DB DATA_SEGMENT_DESCRIPTOR_TYPE
  DB 0b11001111
  DB ZERO_BYTE

; The reason for this empty label, is because the assembler can calculate the end od the GDT
gdt_end:

gdt_descriptor:
  DW gdt_end - gdt_start_descriptors - 1 ; Size of the our GDT
  DD gdt_start_descriptors               ; Start of the GDT

; Defines some useful constants for GDT segment descriptors offset, which are what
; segments registers must contain when in protected mode
CODE_SEGMENT equ gdt_code_descriptor - gdt_start_descriptors
DATA_SEGMENT equ gdt_data_descriptor - gdt_start_descriptors

; Configures the GDT table
; Makes the switch to the 32 bits protected mode
gdt_install:

  PUSHA          ; Stores all the registers ...
	CLI 				   ; Before, set the GDT table, we need to deactivate all the interrupts

	LGDT [gdt_descriptor]  ; Load our GDT definitions inside GDTR

	MOV EAX, CR0		   ; Copy the current value of CR0
	OR  EAX, ONE		   ; The first bit of CRO
	MOV CR0, EAX		   ; Activates the protected environment bit

	; Should not use STI(reenable interrupts) here, if so, the processor will
  ; triple fault and reboot everytime ...

  POPA                    ; Restores all the registers ...
  RET                     ; Returns to the caller
