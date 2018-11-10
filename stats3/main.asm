; stats3: program calculates sum and average of a given list of integers

; -----------------------------------------------------------------------
;                           DATA SECTION

section .data

; -----
; Basic constants

EXIT_SUCCESS            equ 0       ; success code
SYS_exit                equ 60      ; program termination code

; -----
; Variables for main

lst1                    dd -491579,626151,-395663,-678719,-925182,-382018,734199,-546025
cnt1                    dd 8

lst2                    dd 280827,843992,621808,920395,-699368,-97717,-493291,-329278,391079,942950
cnt2                    dd 10

lst3                    dd -546732,785522,-572170,-171938,346217,-151118,721212,52463,170554,860007
                        dd -654279,-385807
cnt3                    dd 12

section .bss

sum1                    resd 1
ave1                    resd 1
sum2                    resd 1
ave2                    resd 1
sum3                    resd 1
ave3                    resd 1

extern stats

section .text
global _start
_start:
    mov rdi, lst1                   ; data set #1
    mov esi, dword [cnt1]
    mov rdx, sum1
    mov rcx, ave1
    call stats

    mov rdi, lst2                   ; data set #2
    mov esi, dword [cnt2]
    mov rdx, sum2
    mov rcx, ave2
    call stats

    mov rdi, lst3                   ; data set #3
    mov esi, dword [cnt3]
    mov rdx, sum3
    mov rcx, ave3
    call stats

END:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall