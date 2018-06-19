; ***************************************************************************
; Simple program that can converts number in form of string to integer form.
;
; Algorithm.
; -----------
; 1) move to the last character and increment digitsCount.
; 1a) copy digitsCount to SaveDigitsCount
; 2) get it's ASCII value
; 3) set multiplier = 1
; 3) subtract from it 0x30
; 4) multiply digit by multiplier
; 5) push digit on stack
; 6) multiplier *= 10
; 7) decrement digitsCount
; 8) while digitsCount > 0 continue with procedure
; 9) while SaveDigitsCount > 0 pop value from stack
; 10) sum this value to the resulting integer


; ***************************************************************************
; Data section

; -----
; Define constants

NULL            equ 0
EXIT_SUCCESS    equ 0
sys_EXIT        equ 60

; -----
; Define data

section .data

string          db "41275",NULL                 ; example string with number
integer         dd 0                            ; resulting integer
factor          dd 1                            ; value of a multiplier

; ***************************************************************************
; Code section

section .text
global _start
_start:
    mov rbx, string                             ; set string pointer at start of the string
    mov rsi, 0                                  ; character count start with 0
    mov r8d, 10                                 ; multiplier value
    mov rcx, 0                                  ; digitsCount = 0

; -----
; Obtaining number of characters to process

CountDigitsLoop:
    cmp byte [rbx+rsi], NULL                    ; while (ch != NULL)
    je ConvertToDigit                           ;   charCount++;
    inc rsi
    jmp CountDigitsLoop

; -----
; Process characters in string from the last one to the first one

ConvertToDigit:
    dec rsi                                     ; skipping NULL
    movzx eax, byte [rbx+rsi]                   
    sub eax, 48                                 ; obtain integer from ASCII table
    mul dword [factor]                          ; multiply by factor = factor * 10
    push rax                                    ; push resulting number on stack

; -----
; Determine actual factor

    mov eax, dword [factor]
    mul r8d
    mov dword [factor], eax

    inc rcx                                     ; increment digitsCount
    cmp rsi, 0                                  ; if (characterCount != 0)
    jne ConvertToDigit                          ;   process next char

; -----
; Assemble resulting integer

IntegerSum:
    mov edx, 0
    mov eax, 0
SumLoop:
    pop rdx                                     ; get int from stack
    add rax, rdx                                ; while (digitsCount > 0)
    loop SumLoop                                ;    integer += int_from_stack
    mov dword [integer], eax

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall