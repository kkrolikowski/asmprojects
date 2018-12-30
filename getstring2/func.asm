; ****************************************************
; this file contains function for read string from keyboard
; and print string on the screen

section .data

NULL            equ 0
STDOUT          equ 1
SYS_write       equ 1

section .text

; --------
; printString(string)

global printString
printString:
    push rbx

    mov rbx, rdi
ReadLoop:
    cmp byte [rbx], NULL
    je printStringDone

    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, rbx
    mov rdx, 1
    syscall

    inc rbx
    jmp ReadLoop

printStringDone:
    pop rbx
ret


; --------
; getString(buffer, limit)

global getString
getString:
ret

; --------
; Int to string function.
; number is limited to int (32-bit) size
; HLL call: i2s(number, strout);
; Returns:
;   -1 if given integer was negative
;    1 on success
global i2s
i2s:
    push r12

; check if integer is negative
    cmp edi, 0
    jl IsNegative

    mov r10d, 10                ; divisior
    mov r12, 0                  ; numbers pushed on stack
    mov r11, 0                  ; numbers popped from stack and string index
    mov eax, edi
PushLoop:
    cmp eax, 0                  ; if 0 we can assume, that all numbers are processed
    je PopLoop                  ; and we can start with building a string
    mov rdx, 0
    div r10d
    push rdx
    inc r12
    jmp PushLoop

PopLoop:
    cmp r11, r12                ; if both counters are equal, then we have complete string
    je IntStrDone
    pop rax

    add al, 48                  ; adding 48 (ASCII: 0) gives a ASCII representation of given number
    mov byte [rsi+r11], al
    inc r11
    jmp PopLoop

IntStrDone:
    mov byte [rsi+r11], NULL    ; when done: terminate a string
    mov rax, 1                  ; return 1
    jmp i2sDone
IsNegative:
    mov rax, -1                 ; if number is negative: return -1
i2sDone:
    pop r12
ret