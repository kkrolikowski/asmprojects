;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;               Sum of squares
; program is scaled to fit into 16-bit result
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

section .data

; Constants
EXIT_SUCCESS    equ 0
sys_EXIT        equ 60

; Variables
limit       dw 45
sum         dw  0

section .text
global _start
_start:
    mov cx, 1
    mov ax, cx
calctulate:
    mul al
    add word [sum], ax
    inc cx
    mov ax, cx
    cmp cx, word [limit]
    jbe calctulate
last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall