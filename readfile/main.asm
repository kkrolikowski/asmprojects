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
negativeError           db "ERROR: argument cannot be negative", LF, NULL
InvalidError            db "ERROR: line number is invalid.", LF, NULL

section .bss
fd                      resq 1      ; file descriptor
lines                   resd 1      ; how many lines display

extern prints                       ; print string on screen
extern openFile                     ; file open
extern closeFile                    ; file close
extern s2int                        ; string to integer
extern readLines                    ; read lines from file

section .text
global main
main:
; Commandline args
    mov r12, rdi                     ; argc
    mov r13, rsi                     ; *argv[]

    cmp r12, 2                      ; if (argc < 2)
    jl HelpMessage                  ; display help message and quit

; Open a file
    mov rdi, qword [r13+1*8]        ; argv[1] -- filepath
    call openFile

; Check if file exists
    cmp rax, ENOENT
    je FileNotFound

; Save file descriptor
    mov qword [fd], rax

; Check if number of lines was provided
    cmp r12, 2
    ja OptionalArg

; Read whole file
; -1 is a magick arg, that tells function to read whole file
    mov rdi, qword [fd]
    mov rsi, -1
    call readLines

    jmp last
    
OptionalArg:
; convert second argument to integer
    mov rdi, qword [r13+2*8]
    call s2int

; Errors handled:
;   * lines count cannot be negative
;   * lines count cannot start with 0
;   * lines count must contain only numbers

    cmp rax, -1
    je NegativeArg
    cmp rax, -2
    je InvalidNumber

; Read lines from file
    mov rdi, qword [fd]
    mov rsi, rax
    call readLines

; Close a file
    mov rdi, qword [fd]
    call closeFile

    jmp last

; ----------------------------------------------
;   ERROR handling

NegativeArg:
    mov rdi, negativeError
    call prints
    jmp last

InvalidNumber:
    mov rdi, InvalidError
    call prints
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

; -----
; Program end
last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall