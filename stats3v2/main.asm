; Simple program which calculates sum and average of a given list of integers
; Program uses two functions: lstSum() and lstAverage()

; *****************************************************************************
;                           DATA SECTION

section .data

; -----
; Basic constants

EXIT_SUCCESS            equ 0       ; success code
SYS_exit                equ 60      ; program termination

; -----
; Data sets

lst1                    dd -797154,-671544,-423281,777379,73146,199374,-906119,234274,301415,-264981
len1                    dd 10

lst2                    dd 463736,159899,-670726,171135,-556533,450340,447440,949669,958267,-292478
                        dd 902591,792513,52816,519801,189915,390592,-106540,-908176,-803342,158650
len2                    dd 20

lst3                    dd -705735,-42972,775358,653655,643270,-112812,588169,460062,-478467,793222,
                        dd -421174,650413,954961,788876,-490504,58322,-628832,-514950,-49517,82635,
                        dd -151026,411055,682807,-583109,439088,365352,-757601,-499971,-323619,-817577
len3                    dd 30

section .bss

sum1                    resd 1
ave1                    resd 1

sum2                    resd 1
ave2                    resd 1

sum3                    resd 1
ave3                    resd 1

extern lstSum
extern lstAverage

; *****************************************************************************
;                           CODE SECTION

section .text
global _start
_start:
; -----
; Processing dataset #1

                                    ; Calculate the sum
    mov rdi, lst1
    mov esi, dword [len1]
    call lstSum
    mov dword [sum1], eax
                                    ; Calculate the average
    mov edi, dword [sum1]
    mov esi, dword [len1]
    call lstAverage
    mov dword [ave1], eax

; -----
; Processing dataset #2

                                    ; Calculate the sum
    mov rdi, lst2
    mov esi, dword [len2]
    call lstSum
    mov dword [sum2], eax
                                    ; Calculate the average
    mov edi, dword [sum2]
    mov esi, dword [len2]
    call lstAverage
    mov dword [ave2], eax

; -----
; Processing dataset #3

                                    ; Calculate the sum
    mov rdi, lst3
    mov esi, dword [len3]
    call lstSum
    mov dword [sum3], eax
                                    ; Calculate the average
    mov edi, dword [sum3]
    mov esi, dword [len3]
    call lstAverage
    mov dword [ave3], eax

END:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall