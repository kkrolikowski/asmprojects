; ***********************************************************************
;  Simple program that converts string with preceeding + or -
;  into a positive or negative number.
;  For example: 123450 = 0*1 + 5*10 + 4*100 + 3*1000 + 2*10000 + 1*100000
;  Algorithm
; ------------
; 1/ get first sign and chek if given number should be positive or not
; 2/ move to the next character and count all the numbers.
; 3/ starting from the last digit move to the first one and:
;   3a/ convert char to digit by subtract: 48
;   3b/ multiply by factor (initialy: 1)
;   3c/ push resulting value on the stack
;   3d/ increment digitsCount and factor *= 10
; 4/ while digitsCount > 0
;   4a/ pop value from stack
;   4b/ add to the sum
;   4c/ decrement digitsCount
; 5/ if resulting number is negative - multiply it by -1

; ***********************************************************************
;                       DATA SECTION


NULL            equ 0
EXIT_SUCCESS    equ 0
sys_EXIT        equ 60

section .data

string          db "-123450",NULL           ; example string to convert
integer         dd 0                        ; resulting integer
factor          dd 1                        ; factor used in converstions
negative        db 0                        ; indicates if given string will be negative


; ***********************************************************************
;                       CODE SECTION

section .text
global _start
_start:
    mov rsi, 0                                ; stringIndex = 0
    mov rcx, 0                                ; digitsCount = 0
; -----
; Determine number sign

    mov rbx, string                           ; set pointer at the begining of a string
    cmp byte [rbx], "+"                       ; check if string is postive
    je CountNumbers                           ; if yes - proceed with processing
    mov byte [negative], 1                    ; if no - set negative flag to no
                                              ; and afer that continue with processing
; -----
; Count the numbers

CountNumbers:
    inc rsi                                   ; move to the first / next number in string
    cmp byte [rbx+rsi], NULL                  ; check if we reached end of string
    je DigitizEmAll                           ; if not - convert a char into a integer
    inc rcx                                   ; increment digitsCount
    jmp CountNumbers                          ; process next character

; -----
; Turn characters into intigers

updateFactor:
    mov r8d, 10                               ; on every subsequent iteration we should update
    mov eax, dword [factor]                   ; factor 10 times it's previous value
    mov edx, 0
    mul r8d
    mov dword [factor], eax                   ; factor *= 10

DigitizEmAll:
    dec rsi                                   ; first step is to move backwards from the NULL sign
    movzx eax, byte [rbx+rsi]                 ; now we can read proper character

    sub eax, 48                               ; 1/ if we remove 48 from the ASCII char value we will get
    mov edx, 0                                ;    we will get  proper digit
    mul dword [factor]                        ; 2/ digit *= factor
    push rax                                  ; push resulting value

    cmp rsi, 1                                ; we should stop on character first character following sign char
    jne updateFactor                          ; after that we can continue with the last thing

; -----
; Assemble resulting integer

CalculateInteger:
    pop rax                                 ; get value from stack
    add dword [integer], eax                ; integer += val
    loop CalculateInteger                   ; while digitsCount > 0 continue with procedure

    cmp byte [negative], 1                  ; if integer should be positive - end the program
    jb last
                                            ; if not
    mov r8d, -1                             ; we have to multiply resulting integer by -1
    mov eax, dword [integer]                ; to convert number into negative
    cdq
    imul r8d
    mov dword [integer], eax

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall
