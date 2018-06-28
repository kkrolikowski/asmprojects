; ***********************************************************************
;       Example program that multiplies each array element by 2
;               macro: arrmul <list> <num>


; ***********************************************************************
;                       MACRO DEFINITIONS

%macro arrmul 2
        mov eax, 0
        mov rsi, 0
        mov r8d, 2
        mov ecx, dword [%2]
        lea rbx, [%1]
    %%multiply:
        mov eax, dword [rbx+rsi*4]
        cdq
        imul r8d
        mov dword [rbx+rsi*4], eax
        inc rsi
        loop %%multiply
%endmacro

; ***********************************************************************
;                       DATA DEFINITIONS

; -----
; Define constants

EXIT_SUCCESS            equ 0
sys_EXIT                equ 60

; -----
; Define datasets

section .data

limit           dd 20

list1           dd 920796,-823419,388304,-192208,657908,569370,-469349,-303140,-593488,236207
                dd 575281,36598,323806,713642,13983,-202795,-724108,-661137,-737234,804663
list2           dd 49583,-378567,-661021,-37112,948361,-510711,511628,-76408,112688,-529399
                dd -565870,678667,684764,-755202,68413,727128,490499,-278634,102283,400385
list3           dd 451420,831870,-880885,804129,-128234,-573125,84500,-382728,-607842,822637
                dd -647905,441162,-909350,-646622,757422,-620403,691983,606337,115357,462315

; ***********************************************************************
;                       CODE DEFINITIONS

section .text
global _start
_start:

    arrmul list1, limit
    arrmul list2, limit
    arrmul list3, limit

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall