; rdfile: program reads password from a password.txt and displays it on the screen

section .data

; -----
; Basic constants

SUCCESS                 equ 1
NOSUCCESS               equ 0
EXIT_SUCCESS            equ 0
MAXLEN                  equ 24                      ; maximum length of the password
NULL                    equ 0                       ; string termination
LF                      equ 10                      ; new line
STDOUT                  equ 1                       ; standard output (screen)

; -----
; System services

SYS_read                equ 0                       ; read() system call
SYS_write               equ 1                       ; write() system call
SYS_open                equ 2                       ; file open() system call
SYS_close               equ 3                       ; file close() system call
SYS_exit                equ 60                      ; exit() system call

; -----
; File settings

O_RDONLY                equ 000000q                 ; read only mode

; -----
; Variables for main

pwdfile                 db "password.txt", NULL
chars                   db 0                        ; password length

; -----
; Program output

statsmsg1               db LF, "Password is ", NULL
statsmsg2               db " characters long.", LF, NULL

; -----
; Error messages

ReadFileErrorMSG        db "Error reading password.txt file.", LF, NULL

section .bss

password                resb MAXLEN+1               ; password string
byteString              resb 5                      ; byte-sized string number

section .text

global _start
_start:

; -----
; Read data from password.txt file
; Save string into password variable
; Save characters count into chars variable

    mov rcx, chars
    mov rdx, MAXLEN
    mov rsi, password
    mov rdi, pwdfile
    call fread

; ------
; Check if file read operation was successful

    cmp rax, NOSUCCESS
    je ReadFileError

; -----
; Convert chars var. into a string

    mov rdi, byteString
    mov sil, byte [chars]
    call byte2s

; -----
; Print string from password var.

    mov rdi, password
    call prints

; -----
; Print simple string statistics

    mov rdi, statsmsg1
    call prints
    mov rdi, byteString
    call prints
    mov rdi, statsmsg2
    call prints

    jmp END

ReadFileError:
    mov rdi, ReadFileErrorMSG
    call prints

END:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall

; ---------------------------------------------------------------------------------
;                           FUNCTIONS

;-----------------------------------------------------------------------------------
; int fread(char *filename, char *pass, short maxlen, short *chrCount);
; return: SUCCESS if file was read correctly, NOSUCCESS if something went bad.

global fread
fread:
    push rbp
    mov rbp, rsp
    sub rsp, 25                                     ; allocate stack for local vars.
    push rbx
    push r12

; ------
; Save all args on the stack

    lea rbx, qword [rbp-25]
    mov qword [rbx], rdi                            ; save addr of filename
    mov qword [rbx+8], rsi                          ; save addr of dest string
    mov qword [rbx+16], rcx                         ; save address of pass. char count
    mov byte [rbx+24], dl                           ; save password max length val.

; -----
; Open password.txt file in read only mode

    mov rax, SYS_open
    mov rsi, O_RDONLY
    syscall

    cmp rax, 0                                      ; check if file open was successful
    jl FreadExitError

    mov r10, rax                                    ; save the file descriptor
    mov r8, qword [rbx+8]                           ; set pointer to the string array
    mov r12, 0                                      ; current character count

; -----
; Reading a file contents char by char

ReadFileLoop:
    mov rax, SYS_read
    mov rdi, r10
    lea rsi, byte [rbx+25]
    mov rdx, 1
    syscall

    cmp rax, 0                                      ; if read() return 0 - it's probably EOF
    je ReadFileLoopDone

    cmp r12b, byte [rbx+24]                         ; if we've reached a MAX char limit, we should skip
    jae ReadFileLoop                                ; string saving instructions and read whole file
    inc r12                                         ; increment character count

    mov al, byte [rbx+25]                           ; Save current character to the array
    mov byte [r8], al
    inc r8                                          ; update array index

    mov r9, qword [rbx+16]
    inc byte [r9]                                   ; update array array character count

    jmp ReadFileLoop

; -----
; End of File

ReadFileLoopDone:
    mov byte [r8], NULL                             ; put the NULL at the end of string
    jmp FreadExitSuccess

; -----
; Return error state

FreadExitError:
    mov rax, NOSUCCESS
    jmp FreadEnd

; -----
; Close file and return success state

FreadExitSuccess:
    mov rax, SYS_close
    mov rdi, r10
    syscall

    mov rax, SUCCESS

; -----
; Restore stack

FreadEnd:
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret

;-----------------------------------------------------------------------------------
; void prints(char *string);
; return: nothing

global prints
prints:
    push rbx

    mov rbx, rdi
    mov rdx, 0
CountLoop:
    cmp byte [rbx], NULL
    je CountDone
    inc rbx
    inc rdx
    jmp CountLoop

CountDone:
    cmp rdx, 0
    je printsDone

    mov rax, SYS_write
    mov rsi, rdi
    mov rdi, STDOUT
    syscall

printsDone:
    pop rbx
    ret

;-----------------------------------------------------------------------------------
; void byte2s(char *string, short num);
; return: nothing
; Function converts byte-sized number into a string

global byte2s
byte2s:
    push rbp
    mov rbp, rsp
    sub rsp, 9                                  ; local variables
    push rbx
    push r12

    lea rbx, qword [rsp-9]
    mov qword [rbx], rdi                        ; copy string address
    mov byte [rbx+8], sil                       ; copy number value

    mov r11, qword [rbx]                        ; pointer to string
    movzx rax, byte [rbx+8]                     ; push op. requires 64-bit values
    mov r10, 10                                 ; divisior
    mov rcx, 0                                  ; how many numbers do we have on the stack
    mov r12, 0                                  ; number of pop'ed from stack numbers

; -----
; Reverse numbers order by using stack

DivideLoop:
    mov rdx, 0
    div r10

    push rdx
    inc rcx

    cmp rax, 0
    ja DivideLoop

; -----
; Turning numbers into a characters by adding 48 (ASCII)

getValLoop:
    cmp r12, rcx
    je byte2sEnd

    pop rax
    add rax, 48                                 ; digit + 48 = ASCII representation
    mov byte [r11], al                          ; save character
    inc r11                                     ; update array index
    inc r12                                     ; update numbers count
    jmp getValLoop
    
byte2sEnd:
    mov byte [r11], NULL                        ; Terminate the string

    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret