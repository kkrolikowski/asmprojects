; Example program which print to the console predefined strings

; ---------------------------------------------------------------

section .data

LF              equ 10          ; newline
NULL            equ 0           ; end of string
EXIT_SUCCESS    equ 0           ; code for success

STDOUT          equ 1           ; standard output (screen)
SYS_write       equ 1           ; write() syscall
SYS_exit        equ 60          ; terminate program

name            db "Winnie dePooh", LF, NULL
address         db "1337 Ashdown Forest", LF
                db "England", LF, NULL
email           db "winniethepooh@gmail.com", LF, NULL

section .text
global _start
_start:

; -----
; Print name

    mov rdi, name
    call printString

; -----
; Print address

    mov rdi, address
    call printString

; -----
; Print email
    mov rdi, email
    call printString

; -----
; End program

progEnd:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall

; ***************************************************************
; Generic function that print string on the screen

global printString
printString:
    push rbx

    mov rbx, rdi                ; save address of a string
    mov rdx, 0                  ; count = 0
strCountLoop:
    cmp byte [rbx], NULL        ; while string[i] != NULL
    je strCountDone             ;   continue counting
    inc rbx                     ; next char
    inc rdx                     ; count++
    jmp strCountLoop

strCountDone:
    cmp rdx, 0                  ; check if string wasn't empty
    je prtDone

; -----
; Print string on the screen

    mov rax, SYS_write          ; write() syscall
    mov rsi, rdi                ; address of string to print
    mov rdi, STDOUT             ; descriptor of standard output
    syscall                     ; call the kernel (rdx set above)

prtDone:
    pop rbx
ret