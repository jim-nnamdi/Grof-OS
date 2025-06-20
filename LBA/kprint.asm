[bits 32]
video_mem       equ 0xb8000         ; vga mem location
white_on_blue   equ 0x1f            ; color & character

print_32:
    pusha 
    mov edx, video_mem              ; set 'dx' to vga location

print_start:
    mov al, [ebx]                   ; fetch value from base register
    mov ah, white_on_blue           ; 32 bit call to fetch val
    cmp al, 0x0 
    je print_end 

    mov [edx], al                   ; return color & char value
    add ebx, 1                      ; next character to print
    add edx, 2                      ; next color cell eqv 2 bytes

    jmp print_start                 ; loop and increment process

print_end:
    popa 
    ret 