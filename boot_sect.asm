; this calls various bios routines and specifies
; different entry points to load the kernel based
; on previous routines

[org 0x7c00]                    ; specify memory read offset
kernel_offset   equ 0x1000      ; kernel offset for memory

    mov [boot_drive], dl        ; dl holds drive number from disc
    mov bp, 0x9000             ; load stack memory location
    mov sp, bp                  ; stack now points to '0x90000'

    mov bx, MSG_LOAD_REAL       ; Loading 16-bit real mode
    call print                  ; display info to user from bios
    call print_nl 

    call load_kernel            ; load the kernel from this call
    call switch_to_pm           ; after kernel loads, switch to PM
    jmp $                       ; never executed ...

%include './bios_print.asm'     ; bios routine for 16-bit print
%include './bios_hex.asm'       ; bios routine for hex conversion
%include './bios_disc.asm'      ; bios routine for disk reads
%include './bios_gdt.asm'       ; global descriptor routine
%include './boot_32_print.asm'  ; 32-bit printing mode
%include './boot_switch.asm'    ; code and data segmentation

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERN       ; bios routine to declare k-mode
    call print 
    call print_nl
    
    mov bx, kernel_offset       ; read data from disc to kernel
    mov dl, [boot_drive]        ; read data from drive to 'dl'
    mov dh, 2                   ; no of sectors to read
    call disc_load              ; Load data from disc to kernel
    ret

[bits 32]
begin_pm:                       ; Loading data in 32 bit mode
    mov ebx, MSG_LOAD_PROT      ; inform user of 32 bit switch
    call print_pm               ; protected mode call 
    call kernel_offset          ; call mem at kernel linker
    jmp $ 

boot_drive db 0 
MSG_LOAD_KERN db 'loading GrofOS kernel', 0
MSG_LOAD_PROT db 'loading GrofOS 32-bit protected mode', 0
MSG_LOAD_REAL db 'loading GrofOS 16-bit real mode', 0 

times 510 - ($-$$) db 0 
dw 0xaa55
