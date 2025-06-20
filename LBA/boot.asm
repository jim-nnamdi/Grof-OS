[bits 16]
[org 0x7c00]

jmp short start_boot
nop 

start_boot:
    xor ax, ax 
    mov ds, ax 
    mov es, ax 
    mov ss, ax 
    mov sp, 0x7c00 

load_loader:
    mov si, read_packet
    mov word[si], 0x10          ; packet size is 16 bytes
    mov word [si + 2], 0x05     ; sector count is 5 sectors
    mov word [si + 4], 0x7e00   ; offset for kernel access 
    mov word [si + 6], 0x00     ; segment to read from (segment << 4 + offset)
    mov dword[si + 8], 0x01     ; LBA disk to read from sector '0' is for MBR
    mov dword[si + 12],0x00     ; LBA size to read from
    
    mov ah, 0x42                ; extended read service
    int 0x13                    ; bios disk i/o service
    jc disc_error 

    jmp  0x7e00                 ; jump to kernel memory offset

%include "./bios_print.asm"

disc_error:
    mov al, DISK_ERR 
    mov ah, 0x0e
    call print 
    call print_nl
    jmp $


; disk address packet structure
read_packet: times 16 db 0
DISK_ERR: db 'disk read error', 0

; pad the remaining 64 bytes of 510 with 0
; the boot sector reads about 446 bytes of data ...
times 0x1be - ($-$$) db 0 

; some bios would want to read valid partition entries
; we need to treat our image as a hard disk drive
; so we need to define these entries. also remember we
; have 4 partitions with 16 bytes each totalling 64 bytes

db 0x80                 ; bootable partition
db 0,2,0                ; first sector of the Cylinder head sector data 
db 0xF0                 ; type of sector such as custom os or unused fs 
db 0xFF, 0xFF, 0xFF     ; second sector of the cylinder head sector 
dd 1
dd (20*16*63 - 1)

times (16 * 3) db 0 
dw 0xaa55