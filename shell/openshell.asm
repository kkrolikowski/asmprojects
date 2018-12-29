; *************************************************************
; Simple asm code that open new shell

; Data section

section .data

EXIT_SUCCESS            equ 0
SYS_exit                equ 60
SYS_exec                equ 59

; Code section

section .text

global _start
_start:
; clear rax register with NULLs and push it on stack
    xor rax, rax
    push rax
    mov rbx, 0x68732f6e69622f2f     ; //bin/sh in hex
    push rbx

; exec command from stack
    mov al, SYS_exec
    mov rdi, rsp
    syscall

; When shell process will end we can end program
last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall