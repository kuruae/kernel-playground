/* linker.ld */

/* targeting 32-bit x86 */
OUTPUT_FORMAT(elf32-i386)

/* The symbol we will jump to */
ENTRY(_start)

SECTIONS
{
    /* Start placing sections at 1MB physical */
    /* the dot is the current address */
    . = 0x00100000;


    .text :
    {
        /* KEEP stops the linker from running gc on this */
        /* *(.multiboot) means: gather .multiboot from ALL input .o files */
        KEEP(*(.multiboot))   /* multiboot header MUST come first */
        *(.text)              /* all code */
        *(.text.*)
    }

    /* read-only data */
    .rodata :
    {
        *(.rodata)
        *(.rodata.*)
    }

    /* read-write data */
    .data :
    {
        *(.data)
        *(.data.*)
    }

    .bss :
    {
        *(COMMON)
        *(.bss)
        *(.bss.*)
    }
}
