; Simple demonstration of commandline arguments
; ------------------------------------------------
; Usage: ./args one two 24 three
; Program prints given args on the screen

section .data

; -----
; Basic constants

NULL                equ 0       ; string terminate
EXIT_SUCCESS        equ 0       ; success code
LF                  equ 10      ; new line character
SYS_exit            equ 60      ; exit system call

; -----
; Variables

newLine             db LF, NULL
space               db " ", NULL
colon               db ": ", NULL
bar                 db "--------------------------------------------------", LF, NULL
title               db "Command Line Arguments Example", LF, NULL
agsProvided         db "Total arguments provided: ", NULL
progName            db "The name used to start the program: ", NULL
argsAre             db "The arguments are:", LF, NULL

section .bss

intstr              resb 11     ; space for hold string with number

extern printString
extern int2String

section .text

global main
main:

; -----
; Saving commandline args

    mov r12, rdi
    mov r13, rsi
    mov r8, 0

; -----
; Print top bar and program description
; followed by newline

    mov rdi, bar
    call printString
    mov rdi, title
    call printString
    mov rdi, newLine
    call printString

; -----
; Print information how many arguments were provided

    mov rdi, agsProvided
    call printString
    mov rdi, r12
    mov rsi, intstr
    call int2String                 ; we need to convert integer to string

    mov rdi, intstr
    call printString
    mov rdi, newLine
    call printString

; -----
; Print name of executable
    mov rdi, progName
    call printString

    mov rdi, qword [r13]            ; it's under argv[0]
    call printString
    mov rdi, newLine
    call printString

; -----
; Print all given arguments
    mov rdi, newLine
    call printString
    mov rdi, argsAre
    call printString

    inc r8
PrintArgsLoop:
    cmp r8, r12
    je end

    mov rdi, space
    call printString
    
    mov rdi, r8
    mov rsi, intstr
    call int2String

    mov rdi, intstr
    call printString
    mov rdi, colon
    call printString

    mov rdi, qword [r13+r8*8]
    call printString

    mov rdi, newLine
    call printString
    
    inc r8
    jmp PrintArgsLoop
    
end:
    mov rdi, newLine
    call printString
    mov rdi, bar
    call printString

    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall