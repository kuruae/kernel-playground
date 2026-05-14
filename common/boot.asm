bits 32

extern kmain

section .multiboot
align 4
    dd 0x1BADB002           ; magic
    dd 0x0                  ; flags
    dd -(0x1BADB002 + 0x0)  ; checksum

; stack
section .bss
align 16
stack_bottom:
    resb 16384              ; 16KB stack
stack_top:

; entry point
section .text
global _start               ; make _start visible to the linker

_start:
    mov esp, stack_top      ; set up the stack pointer

    ; push ebx              ; multiboot info struct pointer
    ; push eax              ; multiboot magic

    call kmain              ; jump into C function

    ; if kmain returns, hang (shouldnt happen)
.hang:
    cli                     ; disable interrupts
    hlt                     ; halt the CPU
    jmp .hang               ; loop 
