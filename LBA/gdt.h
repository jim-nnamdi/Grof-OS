#include "stdint.h"

/*
    the global descriptor access flags for the 
    kernel segments are very key and follow a 
    certain structure such as checking if a certain
    segment is present (P) and then checking the descriptor
    privilege level (DPL) furthermore, it checks if it's a 
    code / data segment and moves to the second bit level which
    then checks if the bit is executable, checks the bit direction
    if it grows downwards or upwards (1, 0) and then checks if it's readable / writable and if it has been accessed or not

    references as regarding the code is shown in "gdt.c" file ...
*/
struct gdt_entry_struct{
    uint16_t limit;
    uint16_t basel;
    uint8_t  basem;
    uint8_t  access;
    uint8_t  flags;
    uint8_t  baseh;
}__attribute__((packed));

struct gdt_ptr_struct{
    uint16_t limit;
    unsigned int base;
}__attribute__((packed));

void gdt_init();
void set_gdt_gate(uint32_t num, uint32_t base, uint32_t limit, uint32_t access, uint32_t gran);