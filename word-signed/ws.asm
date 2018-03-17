;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Simple program demonstrating basic arithmetic on
; signed word sized values.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

section .data

; Constants
EXIT_SUCCESS    equ 0
sys_EXIT        equ 60

; Variables
wNum1   dw 24765
wNum2   dw -9989
wNum3   dw -27772
wNum4   dw 10455
wAns1   dw 0
wAns2   dw 0
wAns3   dw 0

section .text
global _start
_start:
; wAns1 = wNum1 + wNum2
    mov ax, word [wNum1]
    add ax, word [wNum2]
    mov word [wAns1], ax
; wAns2 = wNum1 + wNum3
    mov ax, word [wNum1]
    add ax, word [wNum3]
    mov word [wAns2], ax
; wAns3 = wNum3 + wNum4
    mov ax, word [wNum3]
    add ax, word [wNum4]
    mov word [wAns3], ax
last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS