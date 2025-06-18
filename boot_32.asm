[org 0x7c00]

    mov bp, 0x90000             ; set offset for stack pointer
    mov sp, bp 

    mov bx, MSG_REAL_MODE 
    call print 
    call print_nl 

    call switch_to_pm           ; convert to protected mode

    jmp $                       ; its never executed

%include "./bios_print.asm"
%include "./boot_switch.asm"
%include "./boot_32_print.asm"

[bits 32]
begin_pm:
    mov ebx, MSG_PROT_MODE
    call print_pm
    jmp $

MSG_REAL_MODE db 'switching to real mode', 0 
MSG_PROT_MODE db ' switching to protected mode', 0    


times 510 - ($ - $$) db 0 
dw 0xaa55

