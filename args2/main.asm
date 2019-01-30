; ----------------------------------------------------------------
;           argsprint - prints all arguments on the screen
;           Usage: ./argsprint one 2 three .. n

section .data

; -----
; Constants

NULL                    equ 0           ; string termination
LF                      equ 10          ; newline
SYS_exit                equ 60          ; exit() syscall
EXIT_SUCCESS            equ 0           ; success code

; -----
; Messages

bar                     db "--------------------------------------------------", LF, NULL
title                   db "Command Line Arguments Example", LF, NULL
newline                 db LF, NULL
argsProvied             db "Total arguments provided: ", NULL
progName                db "The name used to start the program: ", NULL
argsList                db "The arguments are:", LF, NULL

section .bss

intstring               resb 11

; Functions

extern puts
extern i2s
extern showArgs

section .text
global main
main:

; -----
; get arguments from stdin

    mov r12, rdi
    mov r13, rsi

; -----
; Display top bar and program title

    mov rdi, bar
    call puts
    mov rdi, title
    call puts
    mov rdi, newline
    call puts

; -----
; Convert arg count to string

    mov rdi, r12
    mov rsi, intstring
    call i2s

; -----
; Display argument count information

    mov rdi, argsProvied
    call puts
    mov rdi, intstring
    call puts
    mov rdi, newline
    call puts

; -----
; Display program name information

    mov rdi, progName
    call puts
    mov rdi, qword [r13]
    call puts
    mov  rdi, newline
    call puts
    mov  rdi, newline
    call puts

; -----
; Display list of provided arguments

    mov rdi, argsList
    call puts
    mov rdi, r12
    mov rsi, r13
    call showArgs

; -----
; Display bottom bar

    mov rdi, newline
    call puts
    mov rdi, bar
    call puts

; -----
; End of program

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall