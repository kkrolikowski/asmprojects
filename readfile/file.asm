; file related functions. This file contains functions for:
;           open, read, close file operations
; -----------------------------------------------------------

section .data

; -----
; Constants

SYS_read                equ 0       ; read() syscall
SYS_write               equ 1       ; write() syscall
SYS_open                equ 2       ; file open services
SYS_close               equ 3       ; file close
O_RDONLY                equ 0       ; readonly access
STDOUT                  equ 1       ; standard output (screen)
LF                      equ 10      ; newline character

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

; -----
; readLines() -- reads number of lines from file
; HLL call: readLines(fd, n);
; Arguments:
;   1) file descriptor (RDI)
;   2) n-lines (RSI)
; Returns:
;   nothing
global readLines
readLines:
    push rbp
    mov rbp, rsp
    sub rsp, 13
    push rbx
    push r12
    push r13

    lea rbx, dword [rbp-13]
    mov qword [rbx], rdi
    mov dword [rbx+8], esi
    lea r13, byte [rbx+12]

    mov r12, 0
readLoop:
    cmp dword [rbx+8], -1
    je ReadFile
    
    cmp r12d, dword [rbx+8]
    je readEnd

ReadFile:
    mov rax, SYS_read
    mov rdi, qword [rbx]
    mov rsi, r13
    mov rdx, 1
    syscall

    cmp rax, 0
    je readEnd

    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, r13
    mov rdx, 1
    syscall

    cmp byte [r13], LF
    je CountLine
    jmp readLoop

CountLine:
    inc r12
    jmp readLoop

readEnd:
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret