; **************************************************************
;  Simple program that reverses values in an array using stack
; **************************************************************

section .data

; -----
; Define constants

EXIT_SUCCESS        equ 0
sys_EXIT            equ 60
LIMIT               equ 10

; -----
; Define data

lst                 dq 1,2,3,4,5,6,7,8,9,10

section .text
global _start
_start:
    mov rsi, 0                  ; index = 0
    mov rcx, LIMIT              ; LIMIT = 10

; Loading data to stack
toStack:
    push qword [lst+rsi*8]      ; push to stack lst[index]
    inc rsi                     ; index++   
    loop toStack                ; until (index < LIMIT)

    mov rsi, 0                  ; index = 0
    mov rcx, LIMIT              ; LIMIT = 10

; Popping values from stack reverses the order
fromStack:              
    pop qword [lst+rsi*8]       ; pop from stack lst[index]
    inc rsi                     ; index++
    loop fromStack              ; until (index < LIMIT)

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall