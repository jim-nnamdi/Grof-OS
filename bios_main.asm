[org 0x7c00]                            ; standard memory location offset

    mov bp, 0x80000                     ; set the base storage to an offset
    mov sp, bp                          ; let the stack pointer point to same memory

    mov bp, 0x90000                     ; since 'bp' is free now, let's read from it
    mov dh, 2                           ; number of sectors to read from disc
    call disc_load                      ; call the disc load bios routine

    mov dx, [0x90000]                   ; get the value in the memory
    call print_hex                      ; print the hexadecimal value
    call print_nl 
            
    mov dx, [0x90000 + 512]             ; get the second value from disc
    call print_hex

times 510-($-$$) db 0   ; bootloader needs 512 bytes of mem. so we pad the rest
dw 0xaa55               ; memory location offset for bootloader

times 256 dw '0xkern'
times 256 dw '0xface'