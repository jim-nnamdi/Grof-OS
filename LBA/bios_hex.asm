; bios routine for printing hex values
; assume values are stored in dx register
print_hex:
    pusha 
    mov cx, 0               ; initialise the value of 'cx' to 0

hex_loop:
    cmp cx, 4               ; check if 'cx' has value of 4
    je end_hex              ; if 4 then we're done reading hex values

    mov ax, dx              ; move value stored in 'dx' to 'ax'
    and ax, 0x000f          ; read the Least significant byte value from 'ax'
    add ax, 0x30            ; convert 0 - 9 to '0' - '9'
    cmp al, 0x39            ; check if value returned is 'A' - 'F'
    jle step2               ; if value is <= 9 move to next step
    add al, 7               ; add '8' to value if > '9'

step2:
    mov bx, hex_out + 5     ; buffer where the value should be stored 
    sub bx, cx 
    mov [bx], al            ; get the value from 'al' and feed to 'bx'
    ror dx, 4               ; 0x4123 & so on till it's been all attended to

    add cx, 1               ; increment to the next character to be printed
    jmp hex_loop            ; loop the entire process

    
%include "./bios_print.asm"

end_hex:
    mov bx, hex_out 
    call print 

hex_out: db '0x0000', 0