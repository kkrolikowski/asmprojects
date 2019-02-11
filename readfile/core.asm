; core.asm -- includes basic universal functions for string manipulations
; ------------------------------------------------------------------------

section .data

; -----
; Constants

NULL                equ 0
SYS_write           equ 1
STDOUT              equ 1

section .text

; -----
; prints() -- prints given string on  the screen
; HLL call: prints(string);
; Arguments:
;   1) string (rdi)
; Returns:
;   nothing

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
    je printDone

    mov rax, SYS_write
    mov rsi, rdi
    mov rdi, STDOUT
    syscall

printDone:
    pop rbx
    ret

; -----
; s2int() -- converts string into integer
; HLL call: num = s2int(string);
; Arguments:
;   1) string, (RDI)
; Returns:
;   int number on success
;   -1: on negative string
;   -2: on invalid string

global s2int
s2int:
    push rbx
    push r11
    push r12

    mov rbx, rdi
    cmp byte [rbx], "-"
    je NegativeError
    cmp byte [rbx], "0"
    je InvalidString

    mov r8, 1                           ; actual divisior
    mov r9, 10                          ; divisior factor
    mov r10, 0                          ; characters on stack
    mov r11, 0                          ; characters from stack
    mov r12, 0                          ; integer to return

VerifyLoop:
    cmp byte [rbx], NULL
    je PushNum
    cmp byte [rbx], "0"
    jb InvalidString
    cmp byte [rbx], "9"
    ja InvalidString

    inc rbx
    jmp VerifyLoop

PushNum:
    mov rbx, rdi
PushNumLoop:
    cmp byte [rbx], NULL
    je MakeNum
    mov al, byte [rbx]
    push rax

    inc rbx
    inc r10
    jmp PushNumLoop

MakeNum:
    pop rax
    sub al, 48
    mul r8
    add r12b, al
    inc r11
MakeNumLoop:
    cmp r11, r10
    je s2intSuccess
    mov rax, r8
    mul r9
    mov r8, rax

    pop rax
    inc r11
    sub al, 48
    mul r8
    add r12b, al
    jmp MakeNumLoop

s2intSuccess:
    mov rax, r12
    jmp s2intEnd
NegativeError:
    mov rax, -1
    jmp s2intEnd
InvalidString:
    mov rax, -2

s2intEnd:
    pop r12
    pop r11
    pop rbx
    ret