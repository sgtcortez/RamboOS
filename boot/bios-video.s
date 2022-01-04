; --------------------------------------------
; --------------------------------------------
;           BIOS Video Routines
; Some documentation about BIOS Video routines
; There is a special section about it
; https://en.wikipedia.org/wiki/INT_13H
; --------------------------------------------
; --------------------------------------------

; --------------------------------------------
; BIOS Video definitions
; --------------------------------------------
%define BIOS_VIDEO_ROUTINE_INTERRUPT 0x10
%define VIDEO_WRITE_CHARACTER_TTY    0x0E
%define CARRIAGE_RETURN_CODE         0x0D
%define LINE_FEED_CODE               0x0A
%define PAGE_NUMBER                  0x00

; --------------------------------------------
; Routine to print the string to TTY
; Note: The string must end with the ASCII NULL BYTE: 0
; Since, we use the instruction LODSB, you must put
; the reference of the string into the SI index register
; --------------------------------------------
print_string:
  LODSB                                ; Loads from memory(in case, from processor cache line), and put into AL and increment the index
  OR  AL, AL                           ; Does we have any bit that is not zero?
  JZ      .END_STRING                  ; No, end the print
  MOV AH, VIDEO_WRITE_CHARACTER_TTY    ; Teletype output routine required
  MOV BH, PAGE_NUMBER                  ; Page number to output
  INT     BIOS_VIDEO_ROUTINE_INTERRUPT ; Bios Video Interrupt
  JMP     print_string                 ; Does a loop

.END_STRING:
  ; Just return from the code that called print_string
  RET

; --------------------------------------------
; This routine, just print a character
; to the video and returns
; --------------------------------------------
print_character:
  MOV AH, VIDEO_WRITE_CHARACTER_TTY ; Teletype output routine required
  MOV BH, PAGE_NUMBER               ; Sets page number, for now, always zero
  MOV CX, 1                         ; Number of times to write the character
  INT BIOS_VIDEO_ROUTINE_INTERRUPT  ; Bios Video Interrupt
  RET                               ; Returns to the line that called this routine

; --------------------------------------------
; This routine just sets the cursor to the next line
; --------------------------------------------
line_feed:
  PUSHA                             ; Pushes all registers to stack
  MOV AL, CARRIAGE_RETURN_CODE      ; Sets carriage return code
  CALL print_character              ; Prints the character
  MOV AL, LINE_FEED_CODE            ; Sets line feed code
  CALL print_character              ; Prints the character
  POPA                              ; Returns all the original values of the registers from stack
  RET                               ; Returns to the line that called this routine
