; **********************************************************************
; this simple code have a intentional bug in string reading function
; Function doesn't validate string max length

; Data section

section .data

EXIT_SUCCESS            equ 0
SYS_exit                equ 60
STR_MAX                 equ 10

limit           dd STR_MAX

section .bss

buffer          resb STR_MAX+2
intstr          resb 11

extern printString
extern getString
extern i2s

section .text
global _start
_start:
    mov edi, dword [limit]
    mov rsi, intstr
    call i2s
    
last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall