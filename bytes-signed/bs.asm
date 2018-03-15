;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Example program to demonstrate arithmetic operations
; on signed byte sized values
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

section .data

; Constants
EXIT_SUCCESS    equ 0
sys_EXIT        equ 60

; Variables
bNum1   db -63
bNum2   db -55
bNum3   db  58
bNum4   db   2
bAns1   db 0
bAns2   db 0
bAns3   db 0
bAns6   db 0
bAns7   db 0
bAns8   db 0
wAns11  dw 0
wAns12  dw 0
wAns13  dw 0

section .text
global _start
_start:
; bAns1 = bNum1 + bNum2
    mov al, byte [bNum1]
    add al, byte [bNum2]
    mov byte [bAns1], al
; bAns2 = bNum1 + bNum3
    mov al, byte [bNum1]
    add al, byte [bNum3]
    mov byte [bAns2], al
; bAns3 = bNum3 + bNum4
    mov al, byte [bNum3]
    add al, byte [bNum4]
    mov byte [bAns3], al
; bAns6 = bNum1 - bNum2
    mov al, byte [bNum1]
    sub al, byte [bNum2]
    mov byte [bAns6], al
; bAns7 = bNum1 - bNum3
    mov al, byte [bNum1]
    sub al, byte [bNum3]
    mov byte [bAns7], al
; bAns8 = bNum2 - bNum4
    mov al, byte [bNum2]
    sub al, byte [bNum4]
    mov byte [bAns8], al
; wAns11 = bNum1 * bNum3
    mov al, byte [bNum1]
    mov ah, 0
    imul byte [bNum3]
    mov word [wAns11], ax
; wAns12 = bNum2 * bNum2
    mov al, byte [bNum2]
    mov ah, 0
    imul byte [bNum2]
    mov word [wAns12], ax
; wAns13 = bNum2 * bNum4
    mov al, byte [bNum2]
    mov ah, 0
    imul byte [bNum4]
    mov word [wAns13], ax
last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS