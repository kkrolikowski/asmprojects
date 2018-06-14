; ******************************************************************
; Simple program that converts intiger into a string. 
; Algorythm:
; Part1: divide integer by 10 and push remainder on the stack
;        untill integer value is > 0, increment digits count
; Part2: pop values from the stack and add 0x30 to it. It will
;        turn integer into a char untill digits count is > 0
;        put NULL at the end of the string array

; ******************************************************************
; Data section

; -----
; Define constants

NULL            equ 0                           ; Last character in the string
EXIT_SUCCESS    equ 0                           ; code for success
sys_EXIT        equ 60                          ; call code for exit
char0           equ 48                          ; value used to convert from integer to char

; -----
; Define data

section .data
intVal          dd 41380                        ; integer to be converted

section .bss
intString       resb 10                         ; resulting string

; ******************************************************************
; Code section

section .text
global _start
_start:
    mov eax, dword [intVal]
    mov rcx, 0                                  ; Digits = 0
    mov r8d, 10                                 ; value used for division

; -----
; Part 1: push remainders on stack

pushLoop:
    mov edx, 0
    div r8d                                     ; intVal /= 10
    push rdx                                    ; push remainder onto the stack
    inc rcx                                     ; Digits++
    cmp eax, 0                                  ; if (intVal > 0)
    jne pushLoop                                ;   next iteration

    mov rsi, 0                                  ; idx = 0
    mov rbx, intString                          ; string pointer

; -----
; Part 2: convert digits into char

popLoop:
    pop rax                                     ; get integer from stack
    add al, char0                               ; convert it to char by adding 0x30
    mov byte [rbx+rsi], al                      ; save it in intString[idx]
    inc rsi                                     ; idx++
    loop popLoop                                ; if (Digits > 0)
                                                ;   Digits-- and get next value
    mov byte [rbx+rsi], NULL                    ; end char array with NULL to create
                                                ; valid string
last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall