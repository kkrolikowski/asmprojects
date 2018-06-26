; *******************************************************************
;  Simple program that calculated average values for given lists
;  Program utilizes macro "aver", with following specification:
;       aver <list> <num_of_items> <average>

; *******************************************************************
;                        MACRO DEFS

%macro aver 3
        mov eax, 0
        mov rsi, 0
        mov ecx, dword [%2]
        lea rbx, [%1]

    %%sumLoop:
        add eax, dword [rbx+rsi*4]
        inc rsi
        loop %%sumLoop

        cdq
        idiv dword [%2]
    mov dword [%3], eax
%endmacro

; *******************************************************************
;                        DATA SECTION

section .data

; -----
; Define constants

EXIT_SUCCESS            equ 0
sys_EXIT                equ 60


; -----
; Define data sets

list1           dd -176,597,-1191,14,647,492,-413,404,146,-721,-266,-379
items1          dd 12
aver1           dd 0

list2           dd 594,-445,987,1034,1001,-649,-1194,327,1058,605,-309,727
items2          dd 12
aver2           dd 0

list3           dd 1185,6,-605,862,-1003,725,-1063,662,1081,-788,472,836
items3          dd 12
aver3           dd 0

; *******************************************************************
;                        CODE SECTION

section .text
global _start
_start:

    aver list1, items1, aver1
    aver list2, items2, aver2
    aver list3, items3, aver3

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall