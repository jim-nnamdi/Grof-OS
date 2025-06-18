
[bits 32]                           ; bios routine to print in 32 bit mode ...
video_mem           equ 0xb8000     ; memory mapping for video memory
white_on_black      equ 0x000f      ; color & char mapping 

print_pm:
    pusha 
    mov edx, video_mem

print_start:
    mov al, [ebx]
    mov ah, white_on_black
    cmp al, 0x00 
    je print_end 

    mov [edx], ax                   ; move the character and color to 'edx'
    add ebx, 1
    add edx, 2

    jmp print_start

print_end:
    popa 
    ret 