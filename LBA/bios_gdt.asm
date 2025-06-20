; the global descriptor table permits the switch from the
; 16-bit real mode to the 32-bit protected mode which allows
; interrupts. device drivers and a full fledged kernel

gdt_start:
    dq 0              ; the gdt always start with a null descriptor of 8 bytes

gdt_code:               ; gdt for code descriptor
    dw 0xffff           ; code segment limit
    db 0,0,0 
    db 10011010b        ; access flags for lower bits 
    db 11001111b        ; access flags for upper bits
    db 0        

gdt_data:               ; data segment descriptor
    dw 0xffff           ; data segment limit
    db 0,0,0 
    db 10010010b        ; access flags for 'ds' lower bits
    db 11001111b        ; access flags for 'ds' higher bits 
    db 0            

gdt_end: equ $-gdt_start

gdt_descriptor:
    dw gdt_end - 1 
    dd gdt_start

idt_descriptor:
    dw 0 
    dd 0

CODE_SEG equ 0x08
DATA_SEG equ 0x10 