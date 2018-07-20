; ***********************************************************************************************
; Program implements stats1 function.
; Function stats1() calculates sum and average values of a given array.
; Prototype: void stats1(int * arr, unsigned int len, int * sum, int * ave);

; ***********************************************************************************************
;                               DATA SECTION

section .data

; -----
; Define constants

EXIT_SUCCESS        equ 0
sys_EXIT            equ 60

; -----
; Define datasets

arr1        dd -903924,-854419,-106076,-73473,433776,501989,571226,655632,688017,866811
len1        dd 10
sum1        dd 0
ave1        dd 0

arr2        dd 319444,-246296,-200374,335422,-702952,933033,-866842,-319906,-935425,-10120
            dd -782223,-81188,745885,-775478,-104017,-406746,414313,248343,145772,183551
len2        dd 20
sum2        dd 0
ave2        dd 0

arr3        dd -958646,852211,-560937,305099,531014,190844,-578698,-488311,-123134,625077
            dd -406827,431978,10576,-82718,709216,-607495,496763,-328508,445024,486672
            dd 409609,275593,556067,138844,109237,-469336,819621,-972766,-542119,-219056
len3        dd 30
sum3        dd 0
ave3        dd 0

; ***********************************************************************************************
;                               CODE SECTION

section .text

; ***********************************************************************************************
;                               FUNCTIONS DEFINITION

; -----
; HLL (C/C++) call
; ==========
; stats1(arr, len, sum, ave);
; arr, address - rdi
; len, value   - rsi
; sum, address - rdx
; ave, address - rcx

global stats1
stats1:
; -----
; Prologue

    push r12

; -----
; Calculate sum of array

    mov r12, 0
    mov eax, 0
sumLoop:
    add eax, dword [rdi+r12*4]
    inc r12
    cmp r12, rsi
    jb sumLoop

    mov r12, rdx
    mov dword [r12], eax

; -----
; Calculate average

    cdq
    idiv esi
    mov r12, rcx
    mov dword [r12], eax

; -----
; Epilogue

    pop r12
ret

; ***********************************************************************************************
;                               MAIN FUNCTION

global _start
_start:

; -----
; Data set #1

    mov rcx, ave1
    mov rdx, sum1
    mov esi, dword [len1]
    mov rdi, arr1
    call stats1

; -----
; Data set #2

    mov rcx, ave2
    mov rdx, sum2
    mov esi, dword [len2]
    mov rdi, arr2
    call stats1

; -----
; Data set #3

    mov rcx, ave3
    mov rdx, sum3
    mov esi, dword [len3]
    mov rdi, arr3
    call stats1

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall