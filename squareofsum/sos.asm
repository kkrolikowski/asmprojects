;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Program calculates square of sum of numbers
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

section .data

; Constants
EXIT_SUCCESS    equ 0
sys_EXIT        equ 60

; Variales
square  dw 0        ; square of sum
max     db 18       ; maximal limit for word-sized square        

section .text
global _start
_start:
    mov cl, 1
    mov al, 0
countLoop:
    add al, cl
    inc cl
    cmp cl, byte [max]      ; continue to sum if max
    jbe countLoop           ; is not reached
    mov ah, 0
    mul al                  ; square the result
    mov word [square], ax
last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall