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
ret

; ******************************************************************************
;                                 MAIN

global _start
_start:

; -----
; Dataset #1
    mov esi, dword [len1]
    mov rdi, arr1
    call sort

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall