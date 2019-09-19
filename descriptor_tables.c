
#include "common.h"
#include "descriptor_tables.h"

extern void gdt_flush(u32int);

static void init_gdt();
static void gdt_set_gate(s32int, u32int, u32int, u8int, u8int);

gdt_entry_t gdt_entries[5];
gdt_ptr_t gdt_ptr;
idt_entry_t idt_entries[256];
idt_ptr_t idt_ptr;
