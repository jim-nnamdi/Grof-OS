[bits 16]
[org 0x7e00]

kern_start:

load_kernel:
    mov si, read_packet 
    mov word[si], 0x10             ; packet size of disk address packet
    mov word[si + 2], 0x05         ; sector count and we start from six 
    mov word[si + 4], 0x00         ; offset of disk address packet 
    mov word[si + 6], 0x1000       ; segment from the DAP ...

    mov dword[si + 8], 0x06         ; LBA number of sectors
    mov dword[si + 12],0x00

    mov ah, 0x42 
    int 0x13 
    jc read_error

set_video_mode:
    mov ax, 0x03            ; AH=0x00 use BIOS VIDEO - SET VIDEO MODE service.
                            ; AL=0x03 use the base address to print at 0xB8000.
    int 0x10                ; Call the service.
    call switch_to_pm

%include "./bios_gdt_switch.asm"
%include "./bios_print.asm"

read_error:
    mov bx, READ_ERR 
    mov ah, 0x0e 
    call print 
    call print_nl 

end:
    hlt 
    jmp end

read_packet: times 16 db 0 
READ_ERR: db 'read error occurred', 0