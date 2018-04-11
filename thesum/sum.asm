;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;               Sum of numbers
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

section .data

; Constants
EXIT_SUCCESS        equ 0
sys_EXIT            equ 60
MAX                 equ 60

; Variables
list    dw  28,49,50,63,64,70,82,117,122,202
        dw  208,226,232,242,260,264,272,302,312,327
        dw  328,368,389,406,410,412,420,422,457,490
        dw  505,511,512,526,551,557,565,587,589,624
        dw  627,635,659,668,688,703,724,740,770,773
        dw  804,823,860,887,890,903,933,936,965,968

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