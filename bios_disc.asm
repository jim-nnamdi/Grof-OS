; computer goes into power on self test and needs
; to load the os and kernel but the bios cannot do it
; we delegate that task to the bootloader to handle it

disc_load:
    pusha                   ; move all registers to the stack
    push dx                 ; using 'dx' to store extra data
                            ; 'dh' stores sector number 'dl' stores drive number

    mov ah, 0x02            ; bios read interrupt
    mov al, dh              ; how many sectors do we want to read
    mov cl, 0x02            ; start reading from the second sector first sector is the boot sector
    mov ch, 0x00            ; cylinder number for current sector
    mov dh, 0x00            ; disc head number for current sector

    int 0x13
    jc disc_error           ; if there's a carry flag there's an error

    pop dx                  ; return the number of sectors read
    cmp al, dh              ; is it equal to what we have in 'al'
    jne sector_error        ; if not equal it's a sector error

    popa 
    ret 

disc_error:
    mov bx, DISC_ERRORS      ; routine to read disk errors and return them
    call print 
    call print_nl
    mov dh, ah 
    call print_hex
    jmp disc_loop

    popa                     ; free all the registers from the stack memory
    ret 

disc_loop:
    jmp $

; routine to read the errors from the sector
; if the numbers read are != sector number in 0x02
sector_error:
    mov bx, SECTOR_ERRORS 
    call print 

DISC_ERRORS: db 'error reading from disc', 0 
SECTOR_ERRORS: db 'invalid number of sectors', 0