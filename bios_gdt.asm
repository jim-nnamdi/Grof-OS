
; the global descriptor table permits the switch from the
; 16-bit real mode to the 32-bit protected mode which allows
; interrupts. device drivers and a full fledged kernel

gdt_start:                  ; the labels are important for size calculations and
                            ; memory allocation
    dd 0x0
    dd 0x0                  ; the gdt requires a null descriptor of 8 bytes for a start

; global descriptor for the code segment
gdt_code:
    dw 0xffff          ; segment limit
    dw 0x0            ; segment base 
    db 0x0            
    db 10011010b       ; access flags for first bits
    db 11001111b       ; access flags for last upper '7' bits
    db 0x0 

gdt_data:
    dw 0xffff          ; segment limit
    dw 0x0            ; segment base
    db 0x0            
    db 10011010b       ; access flags for first bits
    db 11001111b       ; access flags for last upper bits
    db 0x0

gdt_end:

gdt_descriptor:             ; the gdt needs a 6 bytes initialisation proc
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start   ; code segment 
DATA_SEG equ gdt_data - gdt_start   ; data segment