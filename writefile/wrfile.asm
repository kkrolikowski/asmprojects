; Example program which demonstrates file write syscall
; Program prompts user for entering a password (clear text)
; and then save provided string to a file named: password.txt

section .data

; -----
; Basic constants

EXIT_SUCCESS        equ 0           ; success termination code
NULL                equ 0           ; string termination
LF                  equ 10          ; newline
LIMIT               equ 24          ; password length

STDIN               equ 0           ; standard input (keyboard)
STDOUT              equ 1           ; standard output (screen)

; ------
; Sytem calls

SYS_read            equ 0           ; read() system call code
SYS_write           equ 1           ; write() system call code
SYS_exit            equ 60          ; exit() system call code

; -----
; String constants used in main

header              db "Program saves entered password to a file named: password.txt.", LF
                    db "Password should not exceed 24 characters.", LF, NULL
prompt              db "Enter password: ", NULL
EOL                 db LF, NULL     ; end of line

; Error messages
ERR_Empty_String    db "String is empty!", LF, NULL

section .bss
password            resb LIMIT+2    ; storage for provided password

section .text
global _start
_start:
    mov rdi, header
    call prints
    
    mov rdi, prompt
    call prints
    mov rdi, password
    mov esi, LIMIT
    call gets

    cmp rax, 0
    je StringEmptyError

    mov rdi, password
    call prints
    mov rdi, EOL
    call prints

    jmp End

StringEmptyError:
    mov rdi, ERR_Empty_String
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

; ----------------------------------------------------------------
;       int gets(char *str, int len);
; Args: address of a string (rdi), max password length (rsi)
; Return: Number of characters in string 
global gets
gets:
    push rbp
    mov rbp, rsp
    sub rsp, 17
    push rbx
    push r12

; -----
; Stack map:
; rbx[0-7]   (64-bit): destination string array address
; rbx[8-11]  (32-bit): maximum string length
; rbx[12]    (8-bit):  single character read from standard input
; rbx[13-16] (32-bit): total characters count provided from standard input

    lea rbx, [rbp-17]
    mov qword [rbx], rdi            ; save dest. string address
    mov dword [rbx+8], esi          ; save max string length
    mov dword [rbx+13], 0           ; characters read

    mov r12, 0                      ; string array index (i=0)
    inc dword [rbx+8]               ; avoid decreased string limit
getChrLoop:
; -----
; Get single character from standard input
    mov rax, SYS_read               ; set the read() syscall
    mov rdi, STDIN                  ; set standard input descriptor
    lea rsi, byte [rbx+12]          ; set the address of memory to hold character
    mov rdx, 1                      ; characters count to read
    syscall                         ; call the kernel

; -----
; Check if we've reached the end of user input
    cmp byte [rbx+12], LF           ; if user hits 'enter', line feed character encounters
    je getChrDone                   ; then we are done with input processing

; -----
; If we've reached max character limit, then we should
; clear the input from trailing characters.
    inc dword [rbx+13]              ; increment total characters count
    mov r11d, dword [rbx+13]        
    cmp r11d, dword [rbx+8]
    jae getChrLoop

; -----
; Save current character in a destination string array
    mov al, byte [rbx+12]
    mov r10, qword [rbx]
    mov byte [r10+r12], al
    inc r12                         ; increment array index
    jmp getChrLoop                  ; go for next character

    mov byte [r10+r12], NULL        ; when all is done, set NULL at the end od string

getChrDone:
    mov rax, r12                    ; return number of characters read.
    
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret

global fwrite
fwrite:
    ret