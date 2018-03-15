;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Example program to demonstrate arithmetic operations
; on signed byte sized values
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

section .data

; Constants
EXIT_SUCCESS    equ 0
sys_EXIT        equ 60

section .text
global _start
_start:
last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS