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
SUCCESS             equ 1
NOSUCCESS           equ 0

STDIN               equ 0           ; standard input (keyboard)
STDOUT              equ 1           ; standard output (screen)

; ------
; Sytem calls

SYS_read            equ 0           ; read() system call code
SYS_write           equ 1           ; write() system call code
SYS_close           equ 3           ; close() system call code
SYS_exit            equ 60          ; exit() system call code
SYS_creat           equ 85          ; creat() system call code

; -----
; File settings

O_CREAT             equ 0x40
S_IRUSR             equ 00400q
S_IWUSR             equ 00200q
S_IRGRP             equ 00040q
S_IROTH             equ 00004q

; -----
; String constants used in main

header              db "Program saves entered password to a file named: password.txt.", LF
                    db "Password should not exceed 24 characters.", LF, NULL
prompt              db "Enter password: ", NULL
EOL                 db LF, NULL     ; end of line
filename            db "password.txt", NULL

; Messages
ERR_Empty_String    db "String is empty!", LF, NULL
ERR_File_Write      db "Password file write error!", LF, NULL
OK_File_Write       db "Password file write done.", LF, NULL

section .bss
password            resb LIMIT+2    ; storage for provided password

section .text
global _start
_start:
; -----
; Display basic program informations

    mov rdi, header
    call prints

; -----
; Display prompt and get data from user

    mov rdi, prompt
    call prints
    mov rdi, password
    mov esi, LIMIT
    call gets

; -----
; If user didn't provide any input
; Display error message and end program

    cmp rax, 0
    je StringEmptyError

; -----
; Create and write password file
; with password provided by user

    mov rdi, filename
    mov rsi, password
    call fwrite

; -----
; Verify if file creating operation
; was successful or not.

    cmp rax, SUCCESS
    je WriteFileSuccess

    cmp rax, NOSUCCESS
    je WriteFileError

WriteFileSuccess:
    mov rdi, OK_File_Write
    call prints
    jmp End

WriteFileError:
    mov rdi, ERR_File_Write
    call prints
    jmp End

StringEmptyError:
    mov rdi, ERR_Empty_String
    call prints

; -----
; End program

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

; ----------------------------------------------------------------
;       int fwrite(char *filename, char *strpass);
; Args: address of filename string (rdi), address of password string (rsi)
; Return: if filewrite operation is successful -> SUCCESS else -> NOSUCCESS
global fwrite
fwrite:
    push rbp
    mov rbp, rsp
    sub rsp, 8
    push rbx

    lea rbx, [rbp-8]
    mov qword [rbx], rsi            ; copy filename string address
    mov rdx, 0                      ; number of characters in string

    mov r9, rsi                     ; temporary string pointer

; -----
; Count all characters in string

passChrCountLoop:
    cmp byte [r9], NULL
    je passChrCountDone
    inc r9
    inc rdx                         ; RDX is needed later in the write syscall
    jmp passChrCountLoop

passChrCountDone:
    cmp rdx, 0                      ; if somehow string was empty
    je fwriteERROR                  ; we should return error state

; -----
; Open / create  a file
; Previous file will be overwriten
; RDI value is passed from a calling function (main)

    mov rax, SYS_creat
    mov rsi, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH
    syscall

    cmp rax, 0                      ; if file creation error occured
    jl fwriteERROR                  ; we should return error state

    mov r10, rax                    ; save opened file descriptor

; -----
; Write a given string to a file descriptor saved in R10 register
; RDX was set during character counting

    mov rax, SYS_write
    mov rdi, r10
    mov rsi, qword [rbx]
    syscall

    cmp rax, 0                      ; if file write error occured
    jl fwriteERROR                  ; we should return error state

; -----
; Close a file when done

    mov r10, rax
    mov rax, SYS_close
    mov rdi, r10
    syscall

    jmp fwriteDone
    
fwriteERROR:
    mov rax, NOSUCCESS
    jmp fwriteDone

fwriteSUCCESS:
    mov rax, SUCCESS

fwriteDone:
    pop rbx
    mov rsp, rbp
    pop rbp
    ret