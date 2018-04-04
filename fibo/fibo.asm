;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;               Fibonacci numbers
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

section .data

; Constants
EXIT_SUCCESS    equ 0
sys_EXIT        equ 60
FIBO_MAX        equ 23

; Variables
max     dw  FIBO_MAX    ; How many fibonacci numbers we need
a       dw  0           ; First number - we start from 0
b       dw  1           ; Second number - always is 1
c       dw  0           ; Third will be the sum of a + b

section .bss
fibo    resw FIBO_MAX   ; fibo array

section .text
global _start
_start:
    mov cx, 0                    ; initialize counter register
    mov rsi, 0                   ; index = 0
    mov ax, word [a]
    mov word [fibo+rsi*2], ax    ; first fibonacci number (0)
    inc cx                       
    inc rsi                      ; index = 1
    
    mov ax, word [b]             ; c = 1
    mov word [fibo+rsi*2], ax    ; second fibonacci number (1)
    inc cx
    inc rsi                      ; index = 2
fiboLoop:
; c = b + a
    mov ax, word [b]    
    add ax, word [a]
    mov word [c], ax            
    mov word [fibo+rsi*2], ax   ; next fibonacci number
; a = b
    mov ax, word [b]
    mov word [a], ax
; b = c
    mov ax, word [c]
    mov word [b], ax

    inc cx                      ; loop counter++
    inc rsi                     ; array index++
    cmp cx, word [max]          ; if loop counter <= max
    jbe fiboLoop                ; ten continue

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall