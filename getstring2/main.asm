; **********************************************************************
; this simple code have a intentional bug in string reading function
; Function doesn't validate string max length

; Data section

section .data

EXIT_SUCCESS            equ 0
SYS_exit                equ 60
STR_MAX                 equ 10
NULL                    equ 0
NL                      equ 10


limit           dd STR_MAX
prompt1         db "Enter string to process (MAX ", NULL
prompt2         db " numbers): ", NULL

prompt3         db "String entered", NL, "-------------------", NL, NULL
newLine         db NL, NULL

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

    mov rdi, prompt1
    call printString
    mov rdi, intstr
    call printString
    mov rdi, prompt2
    call printString

    mov rdi, buffer
    mov esi, dword [limit]
    call getString

    mov rdi, prompt3
    call printString
    mov rdi, buffer
    call printString
    mov rdi, newLine
    call printString


last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall