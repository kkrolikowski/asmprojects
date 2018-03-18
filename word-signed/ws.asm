;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Simple program demonstrating basic arithmetic on
; signed word sized values.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

section .data

; Constants
EXIT_SUCCESS    equ 0
sys_EXIT        equ 60

; Variables
wNum1   dw 3435
wNum2   dw -20481
wNum3   dw 14971
wNum4   dw -20189
dNum1   dd -165246192
wAns1   dw 0
wAns2   dw 0
wAns3   dw 0
wAns6   dw 0
wAns7   dw 0
wAns8   dw 0
dAns11  dd 0
dAns12  dd 0
dAns13  dd 0
wAns16  dw 0
wAns17  dw 0
wAns18  dw 0
wRem18  dw 0

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
; wAns6 = wNum1 - wNum2
    mov ax, word [wNum1]
    sub ax, word [wNum2]
    mov word [wAns6], ax
; wAns7 = wNum1 - wNum3
    mov ax, word [wNum1]
    sub ax, word [wNum2]
    mov word [wAns7], ax
; wAns8 = wNum2 - wNum4
    mov ax, word [wNum2]
    sub ax, word [wNum4]
    mov word [wAns8], ax
; dAns11 = wNum1 * wNum3
    mov ax, word [wNum1]
    cwd
    imul word [wNum3]
    mov word [dAns11], ax
    mov word [dAns11+2], dx
; dAns12 = wNum2 * wNum2
    mov ax, word [wNum2]
    cwd
    imul word [wNum2]
    mov word [dAns12], ax
    mov word [dAns12+2], dx
; dAns13 = wNum2 * wNum4
    mov ax, word [wNum2]
    cwd
    imul word [wNum4]
    mov word [dAns13], ax
    mov word [dAns13+2], dx
; wAns16 = wNum1 / wNum2
    mov ax, word [wNum1]
    cwd
    idiv word [wNum2]
    mov word [wAns16], ax
; wAns17 = wNum3 / wNum4
    mov ax, word [wNum3]
    cwd
    idiv word [wNum4]
    mov word [wAns17], ax
; wAns18 = dNum1 / wNum4
; wRem18 = dNum1 % wNum4
    mov ax, word [dNum1]
    mov dx, word [dNum1+2]
    idiv word [wNum4]
    mov word [wAns18], ax
    mov word [wRem18], dx
last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS