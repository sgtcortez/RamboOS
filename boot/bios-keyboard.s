; --------------------------------------------
; --------------------------------------------
;           Keyboard Routines
; Some documentation about BIOS Keyboard routines
; There is a special section about it
; https://en.wikipedia.org/wiki/INT_16H
; --------------------------------------------
; --------------------------------------------

; --------------------------------------------
; BIOS Keyboard definitions
; --------------------------------------------
%define BIOS_READ_CHARACTER     0x00
%define BIOS_KEYBOARD_INTERRUPT 0x16

[BITS 16]

; This routine reads a character from the keyboard
; Returns:
;         AH -> Scan Code of the key pressed
;         AL -> ASCII character of the button pressed

read_key:
  MOV AH, BIOS_READ_CHARACTER
  INT BIOS_KEYBOARD_INTERRUPT
  RET