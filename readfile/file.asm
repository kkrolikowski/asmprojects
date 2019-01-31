; file related functions. This file contains functions for:
;           open, read, close file operations
; -----------------------------------------------------------

section .data

; -----
; Constants

SYS_open                equ 2       ; file open services
O_RDONLY                equ 0       ; readonly access

section .text
global openFile
openFile:
    mov rax, SYS_open
    mov rsi, O_RDONLY
    syscall
    ret