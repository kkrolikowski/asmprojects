; core.asm -- includes basic universal functions for string manipulations
; ------------------------------------------------------------------------

section .data

; -----
; Constants

NULL                equ 0
SYS_write           equ 1
STDOUT              equ 1

section .text

global prints
prints:
    push rbx

    mov rbx, rdi
    mov rdx, 0
CountLoop:
    cmp byte [rbx], NULL
    je CountDone
    inc rbx
    inc rdx
    jmp CountLoop

CountDone:
    cmp rdx, 0
    je printDone

    mov rax, SYS_write
    mov rsi, rdi
    mov rdi, STDOUT
    syscall

printDone:
    pop rbx
    ret