; func.asm -- contains functions used by the program.

section .data

; -----
; Constants

NULL                equ 0           ; string termination
LF                  equ 10          ; newline character
STDOUT              equ 1           ; Standard output (screen)
SYS_write           equ 1           ; write() syscall
INT_MAX             equ 10          ; maximum number of integers

; -----
; Variables

newline             db LF, NULL
colon               db ": ", NULL

section .text
; -----
; Function puts(). Prints string on the screen.
; HLL call: puts(string)
; Arguments:
;   1) string address (RDI)
; Returns:
;   nothing

global puts
puts:
    push rbx

    mov rbx, rdi
    mov rdx, 0
coutLoop:
    cmp byte [rbx], NULL
    je CountDone
    inc rdx
    inc rbx
    jmp coutLoop

CountDone:
    cmp rdx, 0
    je putsDone

    mov rax, SYS_write
    mov rsi, rdi
    mov rdi, STDOUT
    syscall

putsDone:
    pop rbx
    ret

; -----
; Function i2s(). Converts integer into string
; HLL call: i2s(number, string);
; Arguments:
;   1) integer value (RDI)
;   2) destination string address (RSI)
; Returns:
;   nothing

global i2s
i2s:
    push rbx
    push r12

    mov r10, 10
    mov rax, rdi
    mov rbx, rsi
    mov r11, 0
    mov r12, 0
DivideLoop:
    mov rdx, 0
    cmp rax, 0
    je PopLoop

    cmp r11, INT_MAX
    je PopLoop
    
    div r10
    push rdx
    inc r11
    jmp DivideLoop

PopLoop:
    cmp r12, r11
    je i2sDone
    pop rax
    add rax, 48
    mov byte [rbx], al
    inc rbx
    inc r12
    jmp PopLoop

i2sDone:
    mov byte [rbx], NULL
    pop r12
    pop rbx
    ret

; -----
; showArgs(). Prints on the screen all provided arguments
; HLL call: showArgs(argc, argv);
; Arguments:
;   1) arguments count (RDI)
;   2) arguments array (RSI)
; Returns:
;   nothing
global showArgs
showArgs:
    push rbp
    mov rbp, rsp
    sub rsp, 27
    push rbx
    push r12
    push r13

    lea rbx, byte [rbp-27]
    mov qword [rbx], rdi                    ; arguments count
    mov qword [rbx+8], rsi
    mov r13, qword [rbx+8]                  ; address of args array
    lea r12, qword [rbx+16]                 ; address of local intstring

    mov r8, 1
ArgsLoop:
    cmp r8, qword [rbx]
    je ArgsLoopEnd

    mov rdi, r8
    mov rsi, r12
    call i2s

    mov rdi, r12
    call puts
    mov rdi, colon
    call puts
    mov rdi, qword [r13+r8*8]
    call puts
    mov rdi, newline
    call puts
    inc r8
    jmp ArgsLoop

ArgsLoopEnd:
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret