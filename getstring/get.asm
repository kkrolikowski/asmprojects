; Example program wich get string from user and print the contents
; on the console. Program accept first 50 characters

; -------------------------------------------------------------------

section .data

; -----
; Basic constants

LF              equ 10      ; end of line
NULL            equ 0       ; end of string
EXIT_SUCCESS    equ 0       ; success code

STDIN           equ 0       ; standard input
STDOUT          equ 1       ; standard output
STDERR          equ 2       ; standard error

SYS_read        equ 0       ; read() system call
SYS_write       equ 1       ; write() system call
SYS_exit        equ 60      ; exit() system call

MAX_SIZE        equ 50      ; maximum line size

; -----
; Things for main.

header          db "Program prints out max 50 characters. Any characters above this limit will be skipped", LF, NULL
bye             db "Bye.", LF, NULL
prompt          db "Enter text (empty line - quit): ", NULL
message         db "Text entered: ", NULL
newLine         db LF, NULL

section .bss
line            resb MAX_SIZE

section .text
global _start
_start:

; -----
; Welcome message

    mov rdi, header
    call printString

TheLoop:

; -----
; Prompt for string

    mov rdi, prompt
    call printString

; -----
; Get string from keyboard

    mov rdi, line
    mov rsi, MAX_SIZE
    call getString
    mov r8, rax                 ; Number of characters entered

; -----
; string prefix

    mov rdi, message
    call printString

; -----
; String provided by user with additional newline

    mov rdi, line
    call printString

    mov rdi, newLine
    call printString

; -----
; Clear the buffer

    mov rdi, line
    mov rsi, MAX_SIZE
    call clearString

; -----
; Continue loop while user provides input
    cmp r8, 0
    ja TheLoop

; -----
; End program

    mov rdi, bye
    call printString

END:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall

; ------------------------------------------------------------------
;                    Functions code

; ------------------------------------------------------------------
;                   void printString(char * string);
; Arguments:
;   rdi: addr of string
; Rerurns:
;   nothing

global printString
printString:
    push rbx
    
    mov rbx, rdi                        ; save addr of string to print
    mov rdx, 0                          ; count = 0
strCountLoop:
    cmp byte [rbx], NULL                ; if chr != NULL
    je strCountDone                     ;   stop counting
    inc rbx                             ; else get next chr
    inc rdx                             ;   count++
    jmp strCountLoop

strCountDone:
    cmp rdx, 0                          ; if count == 0
    je prtDone                          ;   end function

    mov rax, SYS_write                  ; call write()
    mov rsi, rdi                        ; set string addr
    mov rdi, STDOUT                     ; set standard output (screen)
    syscall                             ; call the kernel

prtDone:
    pop rbx
    ret

; ------------------------------------------------------------------
;                   void getString(char * string, int len);
; Arguments:
;   rdi: addr of string
;   rsi: string length
; Rerurns:
;   nothing

global getString
getString:
    push rbp
    mov rbp, rsp
    sub rsp, 13
    push rbx
    push r12
    
    lea rbx, [rbp-13]
    mov qword [rbx], rdi        ; 1'st arg: string addr
    mov dword [rbx+8], esi      ; 2'nd arg: string length
    mov r12, 0                  ; char count
getLoop:
    mov rax, SYS_read
    mov rdi, STDIN
    lea rsi, byte [rbx+12]
    mov rdx, 1
    syscall
    
    mov r11, qword [rbx]
    mov al, byte [rbx+12]
    
    cmp al, LF
    je readDone

    cmp r12d, dword [rbx+8]
    jae getLoop

    mov byte [r11+r12], al
    inc r12
 
    jmp getLoop

readDone:
    mov byte [r11+r12], NULL
    mov rax, r12
    
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret

; ------------------------------------------------------------------
;                   void clearString(char * string, int len);
; Arguments:
;   rdi: addr of string
;   rsi: string length
; Rerurns:
;   nothing

global clearString
clearString:
    push r12

    mov r12, 0
clrLoop:
    mov byte [rdi+r12], NULL
    inc r12
    cmp r12, rsi
    jb clrLoop

    pop r12
    ret