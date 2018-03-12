;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Simple program demonstating arithmetic operations
; on byte sized variables
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

section .data

; Constants
EXIT_SUCCESS    equ 0
sys_EXIT        equ 60

; Variables
bNum1   db 60
bNum2   db 50
bAns1   db 0

section .text
global _start
_start:
; bAns1 = bNum1 + bNum2
    mov al, byte [bNum1]
    add al, byte [bNum2]
    mov byte [bAns1], al
last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall