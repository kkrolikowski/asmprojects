; readfile -- Program display file contents on the screen.
; Arguments:
;   1) file path (mandatory)
;   2) number of lines (optional)
; If you don't provide second argument - whole file will be displayed
; Usage:
;   ./readfile simple.txt
;   ./readfile simple.txt 10
; ----------------------------------------------------------------------

section .data

; -----
; Constants

NULL                    equ 0       ; string termination
SYS_exit                equ 60      ; return to OS
EXIT_SUCCESS            equ 0       ; success code
LF                      equ 10      ; new line

; -----
; Error Codes
ENOENT                  equ -2      ; No such file or directory

; -----
; Messages
separator               db ": ", NULL
usage                   db "readfile quick help.", LF
                        db "If you need to display first-n lines from file specify second argument", LF
                        db "Usage: ./readfile simple.txt [n-lines]", LF, NULL
notFound                db "File not found.", LF, NULL

section .bss
fd                      resq 1      ; file descriptor

extern prints
extern openFile

section .text
global main
main:
    mov r12, rdi
    mov r13, rsi

    cmp r12, 2                      ; if (argc < 2)
    jl HelpMessage                  ; display help message and quit

    mov rdi, qword [r13+1*8]        ; argv[1] -- filepath
    call openFile

    cmp rax, ENOENT
    je FileNotFound

    jmp last

FileNotFound:
    mov rdi, qword [r13+1*8]
    call prints
    mov rdi, separator
    call prints
    mov rdi, notFound
    call prints
    jmp last

HelpMessage:
    mov rdi, usage
    call prints

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall