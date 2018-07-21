; ************************************************************************
; Program implements function with 8 args thus full call frame is required
; Assumption: arrays should be sorted in ascending order
; HLL call: stats2(arr, len, min, med1, med2, max,sum,ave);
; In case of even arr elements med1 and med2 are the middle values.
; In case of odd arr elements med1 = med2.
; `****************


; ************************************************************************
;                       DATA SECTION

; -----
; Define constants

EXIT_SUCCESS        equ 0
sys_EXIT            equ 60

section .data

; -----
; Define datasets

arr1        dd -947865,-913974,-866598,-803566,-474768,-256798,-62371,249619,539705,863129
len1        dd 10
min1        dd 0
max1        dd 0
med1a       dd 0
med1b       dd 0
sum1        dd 0
ave1        dd 0

; ************************************************************************
;                       CODE SECTION

section .text

; ************************************************************************
;                       FUNCTION DEFINITIONS

; ----- function stats2()
; HLL (C/C++) call
; stats2(arr, len, min, med1, med2, max,sum,ave);
; * arr:  address - rdi     (1'st argument)
; * len:  value   - rsi     (2'nd argument)
; * min:  address - rdx     (3'rd argument)
; * med1: address - rcx     (4'th argument)
; * med2: address - r8      (5'th argument)
; * max:  address - r9      (6'th argument)
; * sum:  address - stack   (7'th argument)
; * ave:  address - stack   (8'th argument)

global stats2
stats2:

; -----
; Prologue

; setting a stack frame pointer
    push rbp
    mov rbp, rsp
    push r12

; -----
; Minimal value

    mov r12d, dword [rdi]
    mov dword [rdx], r12d

; -----
; Maximal value

    mov r12d, dword [rdi+(rsi-1)*4]
    mov dword [r9], r12d

; -----
; Median values
    mov r10d, 2
    mov eax, esi
    mov edx, 0
    div r10d
    cmp edx, 0
    je evenArray

; Not even array elements    
    mov r12d, dword [rdi+rax*4]
    mov dword [rcx], r12d
    mov dword [r8], r12d
    jmp sumArray

; Even array elements
evenArray:
    mov r12d, dword [rdi+rax*4]
    mov dword [r8], r12d
    dec rax
    mov r12d, dword [rdi+rax*4]
    mov dword [rcx], r12d

; -----
; Sum of array elements

sumArray:
    mov r12, 0
    mov eax, 0
sumLoop:
    add eax, dword [rdi+r12*4]
    inc r12
    cmp r12, rsi
    jb  sumLoop

    mov r12, [rbp+16]
    mov dword [r12], eax

; -----
; Average of array elements
    
    cdq
    idiv esi
    mov r12, [rbp+24]
    mov dword [r12], eax

; -----
; Epilogue
    pop r12
    pop rbp
ret

global _start
_start:

; -----
; Dataset #1
    push ave1
    push sum1
    mov r9, max1
    mov r8, med1b
    mov rcx, med1a
    mov rdx, min1
    mov esi, dword [len1]
    mov rdi, arr1
    call stats2
    add rsp, 16

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall