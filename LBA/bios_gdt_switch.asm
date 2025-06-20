; after the global descriptor table has been defined
; we need to make the switch from real mode to protected mode

switch_to_pm:
    cli                         ; clear interrupts
    lgdt [gdt_descriptor]       ; load the global descriptor
    lidt [idt_descriptor]
    mov eax, cr0                ; load the control register to 'eax'
    or eax, 0x1                 ; set the protected bit active to '0x1'
    mov cr0, eax                ; switch the value back to control register
    jmp CODE_SEG:pm_entry    ; jump far to the protected mode

%include "./bios_gdt.asm"
%include "./kprint.asm"
        
[bits 32]
pm_entry:
    ; in protected mode segment registers are meaningless
    ; so we set them to the data descriptor segment
    mov ax, DATA_SEG 
    mov ds, ax
    mov es, ax 
    mov ss, ax 
    mov fs, ax 
    mov gs, ax 

    mov esp, 0x7c00 

    jmp 0x08:0x10000 
    jmp $
