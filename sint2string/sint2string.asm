; *****************************************************************
;  Simple program which can convert signed integer into a string.
;  Additional requirement is: if we have an integer > 0 we have to
;  put preceding + sign. Negative integers are preceded by -
;
; Algorithm:
; 1) Determine if integer is positive or negative
; 1a) if integer is positive:
;     * set first character in resulting string to "+"
;     * set multiplier to: 1
; 1b) if integer is negative:
;     * set first character in resulting string to "-"
;     * set multiplier to: -1
; 2) while integer is greater then 0 divide it by 10
; 2a) push remainter to stack
; 2b) increment digitCount
; 3) while digitCount is greater then 0
; 3a) pop value from stack
; 3b) multiply it by multiplier (to ensure we have positive number)
; 3c) add 0x30 to get the ASCII character
; 3d) put character to the next character array field
; 3e) decrement digitCount
; 4) Add NULL character at the end to create string properly


; *****************************************************************
; Data section

NULL            equ 0                       ; string end
EXIT_SUCCESS    equ 0                       
sys_EXIT        equ 60

section .data
integer         dd 53473                    ; sample integer

section .bss
string          resb 10                     ; string result

; *****************************************************************
; Code section

section .text
global _start
_start:
    mov eax, dword [integer]
    mov rcx, 0                              ; digitsCount = 0
    mov r8d, 10                             ; to obtain reversed order of an integer
                                            ; we need to sequentialy divide it by 10
    cmp eax, 0                              ; if given integer is positive, we have to
    jg isPositive                           ; jump to isPositive label
    mov r9b, -1                             ; if integer is negative, we need to set multiplier
    mov byte [string], "-"                  ; to -1 and set first character in string to "-"
    inc rsi
    jmp pushLoop

isPositive:
    mov r9b, 1                              ; if given integer is positive we have to
    mov byte [string], "+"                  ; force multiplier = 1 and set first character
    inc rsi                                 ; in string to "+"

; -----
; Push integers on stack

pushLoop:
    cdq
    idiv r8d                                ; integer /= 10
    push rdx                                ; push remainter on the stack
    inc rcx                                 ; digitsCount++
    cmp eax, 0                              ; if (integer > 0)
    jne pushLoop                            ;    goto pushLoop

    mov rbx, string                         ; set the string pointer

; -----
; pop integers from stack

popLoop:
    pop rax                                 ; get value from stack
    imul r9b                                ; multiply it by 1 (or -1)
    add al, 48                              ; add 0x30 to get the ASCII char
    mov byte [rbx+rsi], al                  ; and save it in the array
    inc rsi
    loop popLoop                            ; while digitsCount > 0 goto popLoop
    mov byte [rbx+rsi], NULL                ; set the NULL at the end of string.

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall