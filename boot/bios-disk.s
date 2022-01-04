; --------------------------------------------
; --------------------------------------------
;           DISK Routines
; Some documentation about BIOS DISK routines
; There is a special section about it
; https://en.wikipedia.org/wiki/INT_13H
; --------------------------------------------
; --------------------------------------------

; --------------------------------------------
; BIOS Disk definitions
; --------------------------------------------
%define DISK_RESET_SECTOR   0x00
%define DISK_READ_SECTOR    0x02
%define DISK_WRITE_SECTOR   0x03
%define BIOS_DISK_INTERRUPT 0x13

[ BITS 16 ]

; --------------------------------------------
; This routine reads a sector of the hard disk.
; There is some registers that should have
; some informations
; Input:
;       AL -> Number of sectors to read
;       CH -> Cylinder Number
;       CL -> Sector
;       DH -> Head
;       DL -> Drive to read
; Note: You must set the buffer address to store the results
; Example:
;       MOV BX, 0xA000  ; Set the buffer address
;       MOV ES, BX      ; ES is the SEGMENT_ADDRESS
;       MOV BX, 0x1234  ; BX the offset
; In this case, the buffer starts at address: 0xA000 + 0x1234
; That, CPU will translate to the physical address: 0xA1234.
; This is the calc that CPU does: SEGMENT_ADDRESS * 16(in decimal) + offset
; ES -> Extra Data Segment Register
; After this, you might consider execute the code that you loaded, in this case, you
; can do something like: JMP ES
;
; Returns:
;        AL -> Sectors actual read
; --------------------------------------------
read_hard_disk_sector:
  PUSH AX                          ; Stores the number of sectors requests
  CALL reset_disk
  MOV AH, DISK_READ_SECTOR         ; Read sectors from disk
  INT BIOS_DISK_INTERRUPT          ; Call BIOS
  JC .read_disk_error              ; Carry flag is set in case of an error
  POP DX                           ; Pop the request number of sectors to DL
  CMP AL, DL                       ; If not equal, should warn ...
  JNE .read_sectors_number_error   ; Could not read the requested sectors number ...
  RET                              ; Everythin OK, returns to the caller

.read_disk_error:
  MOV SI, disk_error_msg           ; Moves the disk message error to SI
  CALL print_string                ; Prints the information to the video
  CLI                              ; Deactivates the interrupts
  HLT                              ; Halts the system

.read_sectors_number_error:
  MOV SI, disk_sectors_count_read  ; Moves the disk message sectors count to SI
  CALL print_string                ; Prints the information to the video
  CLI                              ; Deactivates the interrupts
  HLT                              ; Halts the system

; Reset the current disk state, just to garantee that we will read it
; from a fresh way
reset_disk:
  MOV AH, DISK_RESET_SECTOR        ; Sets the reset disk routine
  INT BIOS_DISK_INTERRUPT          ; Call BIOS
  JC .reset_disk_error             ; In case of error
  RET                              ; Return to the caller

.reset_disk_error:
  MOV SI, disk_reset_error_msg     ; Moves the message that could not reset the disk
  CALL print_string                ; Prints the information to the video
  CLI                              ; Deactivates the interrupts
  HLT                              ; Halt the system
