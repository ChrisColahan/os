[org 0x7C00] 			;set the origin to where the bootloader is loaded into

;set up stack
mov bp, 0xFFFF  		;set bottom of stack
mov sp, bp      		;set stack top to the base

mov si, real_mode_message
call print_string

mov si, loading_kernel_message
call print_string

;load C kernel into 0x7E00
mov al, 9 				;read 9 sectors
mov bx, kernel_entry 	;read them into our kernel jump point (0x7E00)
call read_from_disk

;enable A20 line for input if not already enabled
in al, 0x92
or al, 2
out 0x92, al

;switch to 32-bit protected mode
call switch_to_pm

jmp kill ;Hang if anything gets here (switch fails)

;include utility functions
%include "src/functions.asm"
%include "src/pm_functions.asm"
%include "src/32bit_functions.asm"

[bits 32]
;32 bit code here!!!!!!

BEGIN_PM:
  mov esi, protected_mode_message
  call print_string_32

  ; jump into the C kernel
  jmp kernel_entry
  jmp $

[bits 16]

real_mode_message       db "hello from 16-bit mode",0
loading_kernel_message	db "loading kernel from disk to address 0x7E00",0
protected_mode_message  db "hello from 32-bit mode!!!!!!!!!",0

;pad and add special boot sector number at 512 bytes
times 510-($-$$) db 0
dw 0xAA55

;place to jump into kernel. kernel is loaded here
kernel_entry:

