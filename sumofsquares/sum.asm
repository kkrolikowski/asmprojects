; Simple program to compute the sum of squares
; from 1 to N.

;**********************************************
; Data declarations

section .data

;------------
; Define constants

EXIT_SUCCESS    equ 0       ; Successful operation
sys_EXIT        equ 60      ; call for code terminate

; Define data
n            dd 10          ; squares number to sum
SumOfSquares dq 0

;**********************************************
section .text
global _start
_start:
;-------------
; Compute the sum of squares from 1 to N
; Approach:
; for (i = 1; i < N; i++)
;    SumOfSquares += i*i;
    mov rbx, 1
    mov ecx, dword [n]
sumLoop:
    mov rax, rbx
    mul rax
    add qword [SumOfSquares], rax
    inc rbx
    loop sumLoop
;------------
; Done, terminate program,
last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall