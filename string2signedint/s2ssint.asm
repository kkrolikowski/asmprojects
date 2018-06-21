; ***********************************************************************
;  Simple program that converts string with preceeding + or -
;  into a positive or negative number.
;
;  Algorithm
; ------------
; 1/ get first sign and chek if given number should be positive or not
; 2/ move to the next character and count all the numbers.
; 3/ starting from the last digit move to the first one and:
;   3a/ convert char to digit by subtract: 48
;   3b/ multiply by factor (initialy: 1)
;   3c/ push resulting value on the stack
;   3d/ increment digitsCount and factor *= 10
; 4/ while digitsCount > 0
;   4a/ pop value from stack
;   4b/ add to the sum
;   4c/ decrement digitsCount
; 5/ if resulting number is negative - multiply it by -1

; ***********************************************************************
;                       DATA SECTION


NULL            equ 0
EXIT_SUCCESS    equ 0
sys_EXIT        equ 60

section .data

string          db "-123450",NULL
integer         dd 0
factor          dd 1
negative        db 0


; ***********************************************************************
;                       CODE SECTION

section .text
global _start
_start:
    mov rsi, 0
    mov rcx, 0
; -----
; Determine number sign

    mov rbx, string
    cmp byte [rbx], "+"
    je CountNumbers
    mov byte [negative], 1

; -----
; Count the numbers

CountNumbers:
    inc rsi
    cmp byte [rbx+rsi], NULL
    je DigitizEmAll
    inc rcx
    jmp CountNumbers

; -----
; Turn characters into intigers

updateFactor:
    mov r8d, 10
    mov eax, dword [factor]
    mov edx, 0
    mul r8d
    mov dword [factor], eax

DigitizEmAll:
    dec rsi
    movzx eax, byte [rbx+rsi]

    sub eax, 48
    mov edx, 0
    mul dword [factor]
    push rax

    cmp rsi, 1
    jne updateFactor

; -----
; Obtain resulting integer

CalculateInteger:
    pop rax
    add dword [integer], eax
    loop CalculateInteger

    cmp byte [negative], 1
    jb last

    mov r8d, -1
    mov eax, dword [integer]
    cdq
    imul r8d
    mov dword [integer], eax

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall
