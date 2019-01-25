;           Function used by args program
; ----------------------------------------------------

section .data

; -----
; Common constants

NULL                equ 0
STDOUT              equ 1
SYS_write           equ 1

section .text

; -----
; printString -- prints given string on the screen
; HLL call: printString(string);
; HLL Prototype: void printString(char *string);

global printString
printString:
    push rbx

    mov rbx, rdi
    mov rdx, 0
CountLoop:
    cmp byte [rbx], NULL
    je CountEnd

    inc rbx
    inc rdx
    jmp CountLoop

CountEnd:
    cmp rdx, 0
    je printDone

    mov rax, SYS_write
    mov rsi, rdi
    mov rdi, STDOUT
    syscall

printDone:
    pop rbx
    ret

; -----
; int2String -- converts integer into string
; HLL call: int2String(number, string);
; HLL prototype: void int2String(int number, char *string);

global int2String
int2String:
    push rbx
    push r12

    mov rbx, rsi
    mov r11, 0                      ; numbers pushed on stack
    mov r12, 0                      ; numbers pulled from stack
    mov r10, 10
    mov rax, rdi
DivideLoop:
    mov rdx, 0
    div r10
    push rdx
    inc r11
    cmp rax, 0
    je PopLoop
    jmp DivideLoop

PopLoop:
    cmp r12, r11
    je PopLoopDone
    pop rax
    inc r12
    add rax, 48
    mov byte [rbx], al
    inc rbx
    jmp PopLoop

PopLoopDone:
    mov byte [rbx], NULL

    pop r12
    pop rbx
    ret