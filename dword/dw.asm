;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Simple program demonstrating unsigned arithmetic
; operations on unsigned double words
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

section .data

; Constants
EXIT_SUCCESS    equ 0
sys_EXIT        equ 60

; Variables
dNum1   dd 1057232429
dNum2   dd 1075259370
dNum3   dd 887870354
dNum4   dd 893014848
qNum1   dq 1156182712198623205
dAns1   dd 0
dAns2   dd 0
dAns3   dd 0
dAns6   dd 0
dAns7   dd 0
dAns8   dd 0
qAns11  dq 0
qAns12  dq 0
qAns13  dq 0
dAns16  dd 0
dAns17  dd 0
dAns18  dd 0
dRem18  dd 0

section .text
global _start
_start:
; dAns1 = dNum1 + dNum2
    mov eax, dword [dNum1]
    add eax, dword [dNum2]
    mov dword [dAns1], eax
; dAns2 = dNum1 + dNum3
    mov eax, dword [dNum1]
    add eax, dword [dNum3]
    mov dword [dAns2], eax
; dAns3 = dNum3 + dNum4
    mov eax, dword [dNum3]
    add eax, dword [dNum4]
    mov dword [dAns3], eax
; dAns6 = dNum1 - dNum2
    mov eax, dword [dNum1]
    sub eax, dword [dNum2]
    mov dword [dAns6], eax
; dAns7 = dNum1 - dNum3
    mov eax, dword [dNum1]
    sub eax, dword [dNum3]
    mov dword [dAns7], eax
; dAns8 = dNum2 - dNum4
    mov eax, dword [dNum2]
    sub eax, dword [dNum4]
    mov dword [dAns8], eax
; qAns11 = dNum1 * dNum3
    mov eax, dword [dNum1]
    mov edx, 0
    mul dword [dNum3]
    mov dword [qAns11], eax
    mov dword [qAns11+4], edx
; qAns12 = dNum2 * dNum2
    mov eax, dword [dNum2]
    mov edx, 0
    mul dword [dNum2]
    mov dword [qAns12], edx
    mov dword [qAns12+4], edx
; qAns13 = dNum2 * dNum4
    mov eax, dword [dNum2]
    mov edx, 0
    mul dword [dNum4]
    mov dword [qAns13], eax
    mov dword [qAns13+4], edx
; dAns16 = dNum1 / dNum2
    mov eax, dword [dNum1]
    mov edx, 0
    div dword [dNum2]
    mov dword [dAns16], eax
; dAns17 = dNum3 / dNum4
    mov eax, dword [dNum3]
    mov edx, 0
    div dword [dNum4]
    mov dword [dAns17], eax
; dAns18 = qNum1 / dNum4
; dRem18 = qNum1 % dNum4
    mov eax, dword [qNum1]
    mov edx, dword [qNum1+4]
    div dword [dNum4]
    mov dword [dAns18], eax
    mov dword [dRem18], edx
last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall