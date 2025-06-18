; after the global descriptor is triggered and the code and data
; segments are set, then we need to perform the switch and call
; the global descriptor already set.

[bits 16]
switch_to_pm:
    cli                     ; clear interrupts because we don't need them in 32 bit mode
    lgdt [gdt_descriptor]   ; load the global descriptor table 
    mov eax, cr0 
    or eax, 0x1             ; set the protected mode of the control register to true
    mov cr0, eax 
    jmp CODE_SEG:init_pm 

[bits 32]
init_pm:                    ; switched to 32-bit at this point
    mov ax, DATA_SEG        ; set the data segment and pass values to other segments
    mov ds, ax 
    mov ss, ax 
    mov es, ax 
    mov fs, ax 
    mov gs, ax 

    mov ebp, 0x90000 
    mov esp, ebp 

    call begin_pm