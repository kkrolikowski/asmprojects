; ***************************************************************************
; Simple integer to ascii converter. Function int2str is described by the
; following prototype: void int2str(int number, char *string, int maxlen);

section .data

; -----
; Define constants

sys_EXIT            equ 60
EXIT_SUCCESS        equ 0
NULL                equ 0
STRINGMAX           equ 12

; -----
; Define data

maxlen       dd STRINGMAX
number1      dd -123456
number2      dd 12
number3      dd -1234567890
number4      dd 1234567890
number5      dd -2
number6      dd 1234567

section .bss
string1      resb STRINGMAX
string2      resb STRINGMAX
string3      resb STRINGMAX
string4      resb STRINGMAX
string5      resb STRINGMAX
string6      resb STRINGMAX

section .text

; -----
; HLL call (C/C++): int2str(number, string, maxlen);
; 1'st arg: integer to convert,         value:  rdi
; 2'nd arg: resulting string,           adress: rsi
; 3'rd arg: max numbers to process,     value:  rdx
global int2str
int2str:
; Prologue
    push rbp
    mov rbp, rsp
    sub rsp, 4
    push rbx
    push r12
    push r13

; Function code
    lea rbx, [rbp-4]
    mov dword [rbx], edx    ; max numbers to process
    mov r11, 0              ; numbers count
    mov r12, 0              ; string index
    
; -----
; Stage #1: Obtain a sign of a given integer

    mov eax, edi
    cmp eax, 0
    jl isNegative
    mov r13b, "+"
    mov r10d, 10
    jmp PushLoop

isNegative:
    mov r10d, -1
    imul r10d
    mov r13b, "-"
    mov r10d, 10

; -----
; Stage #2: Push value on the stack

PushLoop:
    cdq
    idiv r10d
    push rdx
    inc r11
    cmp eax, 0
    ja PushLoop

; -----
; Stage #3: Obtaining padding size

    mov r10d, dword [rbx]
    sub r10d, r11d
    sub r10d, 2
    cmp r10d, 0
    je AddSign
    
; -----
; Stage #4: Add padding

Padding:
    mov byte [rsi+r12], " "
    inc r12
    cmp r12, r10
    jb Padding

; -----
; Stage #5: Add a sign

AddSign:
    mov byte [rsi+r12], r13b
    inc r12

; -----
; Stage #5: Pop values from stack

    mov r10d, 0
PopLoop:
    pop rax
    inc r10d
    add rax, 48
    mov byte [rsi+r12], al
    inc r12
    cmp r10d, r11d
    jb PopLoop
    mov byte [rsi+r12], NULL
    
; Epilogue
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
ret

global _start
_start:
    mov edx, dword [maxlen]
    mov rsi, string1
    mov edi, dword [number1]
    call int2str

    mov edx, dword [maxlen]
    mov rsi, string2
    mov edi, dword [number2]
    call int2str
    
    mov edx, dword [maxlen]
    mov rsi, string3
    mov edi, dword [number3]
    call int2str

    mov edx, dword [maxlen]
    mov rsi, string4
    mov edi, dword [number4]
    call int2str

    mov edx, dword [maxlen]
    mov rsi, string5
    mov edi, dword [number5]
    call int2str

    mov edx, dword [maxlen]
    mov rsi, string6
    mov edi, dword [number6]
    call int2str

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall