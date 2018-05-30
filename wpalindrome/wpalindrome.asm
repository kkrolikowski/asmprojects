; ************************************************************
;  Simple program that test if a given string is a palindrome 
; ************************************************************

section .data

; -----
; Define constants

EXIT_SUCCESS        equ 0
sys_EXIT            equ 60

; -----
; Define data

string          db "hannah"             ; example string
palindrome      db 1                    ; 1 - string is a palindrome,
                                        ; 0 - string is not a palindrome
section .text
global _start
_start:
    mov rsi, 0                          ; string index
    mov r8, 1                           ; ASCII 0x1: SOH character 
    mov r9, 0                           ; ASCII 0x0: NULL character
    mov rax, 0                          ; very first thing is to
    push rax                            ; put null character on the stack
toStack:
    movzx rax, byte [string+rsi]        ; now we can put every single character
    cmp r8, rax                         ; on the stack until SOH character
    je endofString                      ; is encountered. If so, we can end the process
    push rax
    inc rsi
    jmp toStack

endofString:
    mov rsi, 0

fromStack:                              ; since we have whole string on the stack
    pop rax                             ; order of characters is revered. So all
    cmp rax, r9                         ; we have to do is compare every character
    je last                             ; from the stack with corresponding character
    movzx r10, byte [string+rsi]        ; from the given string.
    cmp rax, r10
    jne notPalindrome                   ; when comparision gives negative value, we
    inc rsi                             ; can set palindrome flag to 0 and end whole
    jmp fromStack                       ; process
notPalindrome:
    mov byte [palindrome], 0
last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall