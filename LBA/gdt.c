#include "gdt.h"

extern gdt_flush(void *);
struct gdt_entry_struct gdt_entries[5];
struct gdt_ptr_struct gdt_ptr;

void gdt_init()
{
    gdt_ptr.limit = (sizeof(struct gdt_entry_struct) * 5) - 1;
    gdt_ptr.base = &gdt_entries;
    set_gdt_gate(0,0,0,0,0);

     /*
        the global descriptor table defines some parameters
        specifically for the access bits which is 0x9A first
        0x9A converts to 1001 1010b. the first bit is the present bit, which shows that the segment is present (1). and the second and third bit defines the DPL (Descriptor privilege level) and since this is the kernel segment we define it as (00) the user segment has other values such as (3)
        then the next level is for declaring what type of segment
        we're working with (code or data segment which is set to 1)
        the first process gives us our 9 ... 

        then for A, we look at the executable bit, is this executable ? then we set to (1) or (0), we check the direction bit, could be (0) or (1), then we check if its readable / writable, we set that figure too, then we check 
    */ 
   set_gdt_gate(1, 0, 0xffffffff, 0x9a, 0xcf);  /* kernel code */
   set_gdt_gate(2, 0, 0xffffffff, 0x92, 0xcf);  /* kernel data */
   set_gdt_gate(3, 0, 0xffffffff, 0xfa, 0xcf);  /* usersc code */
   set_gdt_gate(4, 0, 0xffffffff, 0xf2, 0xcf);  /* usersc data */

   gdt_flush(&gdt_ptr);
}

void set_gdt_gate(uint32_t num, uint32_t base, uint32_t limit, uint32_t access, uint32_t gran)
{
    gdt_entries[num].basel = (base & 0xffff);
    gdt_entries[num].basem = (base >> 16) & 0xff;
    gdt_entries[num].baseh = (base >> 24) & 0xff;

    /* just like the base we're masking the value */
    /* of limit to the memory size of 16 bit val */
    gdt_entries[num].limit = (limit & 0xffff);
    gdt_entries[num].flags = (limit >> 16) & 0x0f;
    gdt_entries[num].flags |= (gran & 0xf0);

    gdt_entries[num].access = access;
}
