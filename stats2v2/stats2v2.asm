; ******************************************************************************
; Program calculates simple statistics of a given integer arrays:
; sum, average, middle values, minimum and maximum.
; Program includes sorting function.

section .data

; -----
; Define constants

EXIT_SUCCESS        equ 0
sys_EXIT            equ 60

; -----
; Define datasets

arr1        dd -58347,44089,109502,-225582,898133,375601,793161,-520336,515823,-233378
len1        dd 10
sum1        dd 0
min1        dd 0
max1        dd 0
med1a       dd 0
med1b       dd 0
ave1        dd 0

arr2        dd 537134,-812835,386585,-704469,721080,252655,-525836,-583331,-758623,-372134
            dd -519827,-631685,-798531,-657627,715946,159617,-589392,-765286,651167,750069
            dd 17565,925047,-997726,855422,-908286,-866982,-507993
len2        dd 27
sum2        dd 0
min2        dd 0
max2        dd 0
med2a       dd 0
med2b       dd 0
ave2        dd 0

section .text
; ******************************************************************************
;                               FUNCTIONS

; -----
; HLL (C/C++) call: sort(arr, len);
; arr: reference, rdi
; len: value,     rsi
global sort
sort:
; -----
; Prologue

; Setting stack frame
    push rbp
    mov rbp, rsp
; stack reservation for 2 local vars.
    sub rsp, 8
; registers below have to be saved first
    push rbx
    push r12
; we will use this as a stack reference point
; small = [rbp]
; index = [rbp+4]
    lea rbx, [rbp-8]

; -----
; Function code

    mov r12, 0                      ; i = 0
Outer_pre:
    mov eax, dword [rdi+r12*4]
    mov dword [rbp], eax            ; small = arr(i)
    mov dword [rbp+4], r12d         ; index = i

Inner_settings:
    mov r11, r12                    ; j = i

Inner:
    mov eax, dword [rdi+r11*4]
    cmp eax, dword [rbp]
    jl SmallerNumber
    inc r11
    cmp r11, rsi
    jl Inner
    jmp Outer_post

SmallerNumber:
    mov dword [rbp], eax
    mov dword [rbp+4], r11d
    cmp r11, rsi
    jl Inner

Outer_post:
    mov r10d, dword [rdi+r12*4]     ; r10d = arr(i)
    mov r11d, dword [rbp+4]         ; r11d = index
    mov dword [rdi+r11*4], r10d     ; arr(index) = arr(i)
    mov r10d, dword [rbp]           ; r10d = small
    mov dword [rdi+r12*4], r10d     ; arr(i) = small
    inc r12
    cmp r12, rsi
    jb Outer_pre

; -----
; Epilogue
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
ret

; -----
; HLL (C/C++) call: stats(arr, len, sum, min, max, med1, med2, ave);
; arr:  reference, rdi
; len:  value,     rsi
; sum:  reference, rdx
; min:  reference, rcx
; max:  reference, r8
; med1: reference, r9
; med2: reference, stack
; ave:  reference, stack
global stats
stats:
; -----
; Prologue
    push rbp
    mov rbp, rsp
    push r12
    push rbx

; -----
; Function code

    mov r12, 0
    mov rax, 0
SumLoop:
    add eax, [rdi+r12*4]
    inc r12
    cmp r12, rsi
    jb SumLoop
    mov dword [rdx], eax

    cdq
    idiv esi
    mov rbx, qword [rbp+24]
    mov dword [rbx], eax

    mov r10d, dword [rdi]                ; min value
    mov dword [ecx], r10d
    mov r10d, dword [rdi+(rsi-1)*4]      ; max value
    mov dword [r8], r10d

    mov eax, esi
    mov r10d, 2
    mov edx, 0
    div r10d
    cmp edx, 0
    je LenIsEven
    mov r10d, dword [rdi+rax*4]
    mov dword [r9], r10d                 ; med1 value
    mov rbx, [rbp+16]
    mov dword [rbx], r10d                ; med2 value
    jmp End

LenIsEven:
    mov r10d, dword [rdi+rax*4]
    mov rbx, [rbp+16]
    mov dword [rbx], r10d
    mov r10d, dword [rdi+(rax-1)*4]
    mov dword [r9], r10d

End:
; -----
; Epilogue
    pop rbx
    pop r12
    pop rbp
ret

; ******************************************************************************
;                                 MAIN

global _start
_start:

; -----
; Dataset #1

; Sort arr1 array
    mov esi, dword [len1]
    mov rdi, arr1
    call sort

; Calculate statistics
    push ave1
    push med1b
    mov r9, med1a
    mov r8, max1
    mov rcx, min1
    mov rdx, sum1
    mov esi, dword [len1]
    mov rdi, arr1
    call stats
    add rsp, 16

; -----
; Dataset #2

; Sort arr1 array
    mov esi, dword [len2]
    mov rdi, arr2
    call sort

; Calculate statistics
    push ave2
    push med2b
    mov r9, med2a
    mov r8, max2
    mov rcx, min2
    mov rdx, sum2
    mov esi, dword [len2]
    mov rdi, arr2
    call stats
    add rsp, 16

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall