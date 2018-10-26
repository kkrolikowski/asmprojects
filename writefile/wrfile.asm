; Example program which demonstrates file write syscall
; Program prompts user for entering a password (clear text)
; and then save provided string to a file named: password.txt

section .data

; -----
; Basic constants

EXIT_SUCCESS        equ 0           ; success termination code
NULL                equ 0           ; string termination
LF                  equ 10          ; newline

STDOUT              equ 1           ; standard output (screen)

; ------
; Sytem calls

SYS_write           equ 1           ; write() system call code
SYS_exit            equ 60          ; exit() system call code

; -----
; String constants used in main

header              db "Program saves entered password to a file named: password.txt", LF, NULL
prompt              db "Enter password: ", NULL

section .bss
section .text
global _start
_start:
    mov rdi, header
    call prints
    mov rdi, prompt
    call prints
    
End:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
; ----------------------------------------------------------------
;                           FUNCTIONS

; ----------------------------------------------------------------
;       void prints(char *str);
; Args: address of a string (rdi)
; Return: nothing
global prints
prints:
    push rbx

    mov rbx, rdi                    ; save string addr to rbx
    mov rdx, 0                      ; count = 0
countLoop:                          ; HLL procedure:
    cmp byte [rbx], NULL            ; while (*chr != NULL)
    je countDone                    ; {
    inc rbx                         ;   chr++;
    inc rdx                         ;   count++;
    jmp countLoop                   ; }

countDone:
    cmp rdx, 0                      ; if string was empty
    je printDone                    ; just end this function

; -----
; Performing write() syscall

    mov rax, SYS_write              ; set syscall code
    mov rsi, rdi                    ; provide string address
    mov rdi, STDOUT                 ; where string should be written
    syscall                         ; call the kernel

printDone:
    pop rbx
    ret

global gets
gets:
    ret

global fwrite
fwrite:
    ret