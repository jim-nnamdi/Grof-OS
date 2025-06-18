; so here we're assuming our data would be stored
; in the dx register dx = 0x1234

print_hex:
    pusha 
    mov cx, 0                      ; set the count register to 0

hloop:
    cmp cx, 4                       ; check if the iteration is 4 already
    je end                          ; if equals to 4 we're done

    mov ax, dx                      ; move the value in 'dx' to 'ax'
    and ax, 0x000f                  ; mask out the LSB bit of the hex value               
    add ax, 0x30                    ; convert 0-9 to '0' - '9' Ascii value
    cmp al, 0x39                    ; check if the value is >= 9
    jle step2                       ; move to step2 if its 'A' - 'F'
    add al, 7                       

step2:
    mov bx, hex_out + 5             ; we have hex_out + 5 (because of the null terminator)
    sub bx, cx                      ; reduce one of the iterables
    mov [bx], al                    ; send the value in 'al' to [bx]
    ror dx, 4                       ; 0x4123 -> 0x4312 -> 0x4321 -> 0x1234 ...

    add cx, 1                       ; move to the next char to print
    jmp hloop                       ; continue iteration

end:
    mov bx, hex_out                 ; when the value in 'cx' is 0x04
    call print                      ; print the value stored in hex_out memory ...

hex_out:
    db '0x0000', 0