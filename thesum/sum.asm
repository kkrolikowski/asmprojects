;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;               Sum of numbers
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

section .data

; Constants
EXIT_SUCCESS        equ 0
sys_EXIT            equ 60
MAX                 equ 60

; Variables
list    dw  1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
        dw  21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40
        dw  41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60

section .text
global _start
_start:
    mov rcx, MAX                    ; How many numbers to sum
    mov rsi, 0                      ; loop index
sum:
    add ax, word [list+rsi*2]       ; ax += list[index]
    inc rsi                         ; index++
    loop sum                        ; sum next if rcx != 0
last:
    mov rax, sys_EXIT
    mov rbx, EXIT_SUCCESS
    syscall