;  enable print operations in 16-bit real mode

print:
    pusha                   ; move all general purpose registers to the stack

start:
    mov al, [bx]            ; move the value in the base register to 'al'
    cmp al, 0x0             ; check if the value in 'al' is 0 which is null terminator
    je end                  ; jump to the end if value is 0

    mov ah, 0x0e            ; bios teletype output interrupt
    int 0x10                ; bios video interrupt for screen

    add bx, 1               ; increment the value of bx for string ops
    jmp start               ; iterate through the string again

end:
    popa                    ; free the registers from the stack memory
    ret                     

print_nl:
    mov al, 0x0a            ; bios new line interrupt
    mov ah, 0x0e            ; bios teletype output interrupt
    int 0x10                ; bios video interrupt for screen
    mov al, 0x0d            ; carriage return 
    int 0x10
    ret