
; bios routine for printing values
; and for newline rendering ...
print:
    pusha           ; move all general purpose registers to stack

start:  
    mov al, [bx]    ; fetch value from memory in 'bx'
    cmp al, 0x0     ; check if val returned is null terminated
    je ends         ; we're done print value

    mov ah, 0x0e    ; bios interrupt for teletype output
    int 0x10        ; bios interrupt for video
    
    add bx, 1       ; increment next char in 'bx' register 
    jmp start       ; loop the start routine

ends:
    popa            ; remove all registers from stack
    ret             ; return from stack

print_nl:           ; print a newline character
    mov al, 0x0a    ; newline ascii char
    mov ah, 0x0e    ; bios teletype output interrupt
    int 0x10        ; bios video interrupt for display
    mov al, 0x0d    ; carriage return ascii character
    int 0x10        
    ret             ; return the string
