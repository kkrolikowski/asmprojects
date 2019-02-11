; file related functions. This file contains functions for:
;           open, read, close file operations
; -----------------------------------------------------------

section .data

; -----
; Constants

SYS_open                equ 2       ; file open services
SYS_close               equ 3       ; file close
O_RDONLY                equ 0       ; readonly access

section .text
global openFile
openFile:
    mov rax, SYS_open
    mov rsi, O_RDONLY
    syscall
    ret

global closeFile
closeFile:
    mov rax, SYS_close
    syscall
    ret