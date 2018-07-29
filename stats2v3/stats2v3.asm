; *********************************************************************************
; Stats2v3 includes the following:
; * sorting
; * calculations: sum array elements, average, min, max, median values
; * square root estimation
; * standard deviation

section .data

; -----
; Define constants

sys_EXIT            equ 60
EXIT_SUCCESS        equ 0

LIMIT1              equ 10
LIMIT2              equ 27
LIMIT3              equ 50
LIMIT4              equ 103

; -----
; Define datasets

arr1        dd 735811,-819390,-297710,-919907,355,846065,755150,-877904,-6247,-430880
len1        dd LIMIT1
sum1        dd 0
ave1        dd 0
med1a       dd 0
med1b       dd 0
min1        dd 0
max1        dd 0
stddev1     dd 0

section .bss
sqrt1       resd LIMIT1

section .text

; -----
; HLL (C/C++): sort(arr, len)
; * 1'st arg: arr, address, rdi
; * 2'nd arg: len,   value, rsi
global sort
sort:
; Prologue
    push rbp
    mov rbp, rsp                            ; set the frame pointer
    sub rsp, 8                              ; reserve 8 bytes on the stack 
    push rbx
    push r12
    lea rbx, [rbp-8]                        ; setting a reference point to local vars.
; -----
; Local variables
; small: [rbx]
; index: [rbx+4]

; Function code
    mov r12, 0                              ; i = 0
    mov eax, 0
OuterFOR_part1:                             ; for i = 0 to i < len
    mov eax, dword [rdi+r12*4]
    mov dword [rbx], eax                    ; small = arr[i]
    mov dword [rbx+4], r12d                 ; index = i

    mov r11, r12                            ; j = i
InnerFOR:
    mov eax, dword [rdi+r11*4]
    cmp eax, dword [rbx]                    ; if arr[j] < small
    jl NewSmall                             ;  update small value
    inc r11                                 ; j++
    cmp r11, rsi                            ; while j < small
    jb InnerFOR                             ; continue with inner loop
    jmp OuterFor_part2                      ; else switch numbers in array

NewSmall:
    mov eax, dword [rdi+r11*4]
    mov dword [rbx], eax                    ; small = arr(j)
    mov dword [rbx+4], r11d                 ; index = j
    inc r11                                 ; j++
    cmp r11, rsi                            ; while j < len
    jb InnerFOR                             ; goto InnerFOR

OuterFor_part2:
    mov r11d, dword [rbx+4]
    mov r10d, dword [rdi+r12*4]
    mov dword [rdi+r11*4], r10d             ; arr(index) = arr(i)

    mov r11d, dword [rbx]
    mov dword [rdi+r12*4], r11d             ; arr(i) = small
    inc r12                                 ; i++
    cmp r12, rsi                            ; while i < len
    jb OuterFOR_part1                       ; continue with loop

; Epilogue
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
ret

global stats
stats:
ret

global sqrt
sqrt:
ret

global deviation
deviation:
ret

global _start
_start:
    mov esi, dword [len1]
    mov rdi, arr1
    call sort

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall