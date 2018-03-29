;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;               Fibonacci numbers
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

section .data

; Constants
EXIT_SUCCESS    equ 0
sys_EXIT        equ 60

; Variables
max     dw  10      ; How many fibonacci numbers we need
a       dw  0       ; First number - we start from 0
b       dw  1       ; Second number - always is 1
c       dw  0       ; Third will be the sum of a + b

section .text
global _start
_start:
    mov cx, 0           ; initialize counter register
    mov ax, word [a]    ; c = 0
    mov word [c], ax
    inc cx
    
    mov ax, word [b]    ; c = 1
    mov word [c], ax
    inc cx
fiboLoop:
; c = b + a
    mov ax, word [b]    
    add ax, word [a]
    mov word [c], ax
; a = b
    mov ax, word [b]
    mov word [a], ax
; b = c
    mov ax, word [c]
    mov word [b], ax
    inc cx
; if counter is less than max, continue counting
    cmp cx, word [max]
    jb fiboLoop

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall