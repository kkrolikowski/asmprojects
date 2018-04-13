;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;     Program calculates sun of 60 numbers and 
; calculates statistics: average, minimal, maximal
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

section .data

; Constants
EXIT_SUCCESS    equ 0
sys_EXIT        equ 60
MAX             equ 60

; Variables
list    dw 659,965,422,635,512,624,28,327,551,773
        dw 505,117,804,890,50,968,328,903,688,490
        dw 64,232,511,302,202,587,589,526,122,860
        dw 412,410,740,260,823,933,242,226,406,457
        dw 936,420,208,668,557,565,389,63,368,264
        dw 724,70,49,703,887,82,312,770,627,272
min     dw 0
max     dw 0
sum     dw 0
average dw 0

section .text
global _start
_start:
    mov rsi, 0                      ; index = 0
    mov rcx, MAX                    ; MAX = 60
    mov ax, word [list]
    mov word [min], ax
    mov word [max], ax
    mov ax, 0

; ----------
; Calculate the sum of all numbers
sumList:
    add ax, word [list+rsi*2]       ; ax += list[index]
    inc rsi                         ; index++
    loop sumList                    ; next if rcx != 0
    mov word [sum], ax
; ----------
; Find minimum and maximum
    mov rsi, 0
    mov rcx, MAX
searchList:
    mov ax, word [list+rsi*2]
    cmp ax, word [min]
    jb foundMin
    cmp ax, word [max]
    ja foundMax
    inc rsi
    loop searchList
; ----------
; Calculate the average
    mov ax, word [sum]
    mov dx, 0
    mov r8w, MAX
    div r8w
    mov word [average], ax 
    jmp last
foundMin:
    mov word [min], ax
    inc rsi
    loop searchList
foundMax:
    mov word [max], ax
    inc rsi
    loop searchList
last:
    mov rax, sys_EXIT
    mov rbx, EXIT_SUCCESS
    syscall