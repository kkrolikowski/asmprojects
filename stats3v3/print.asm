; print.asm -- functions designed for displaing text on the screen

; -------------------------------------------------------------------
;                       DATA SECTION

section .data

; -----
; Basic constants

NULL                equ 0               ; string terminate
SYS_write           equ 1               ; write() syscall.
STDOUT              equ 1               ; output on the screen

; -------------------------------------------------------------------
;                       CODE SECTION

section .text

; -------------------------------------------------------------------
; Prototype: void print(char *string);
; Function prints on the screen given string
;   HLL call: print(string);

global print
print:
    push rbx

    mov rbx, rdi                        ; set pointer to string
    mov rdx, 0                          ; characters count
CharCountLoop:
    cmp byte [rbx], NULL                ; if (*pstr == NULL)
    je CharCountLoopDone                ;   quit counting
    inc rbx                             ; next character
    inc rdx                             ; count++
    jmp CharCountLoop

CharCountLoopDone:
    cmp rdx, 0                          ; if string is empty
    je PrintStringDone                  ;   skip printing

; -----
; Print given string on the screen

    mov rax, SYS_write
    mov rsi, rdi
    mov rdi, STDOUT
    syscall

PrintStringDone:
    pop rbx
    ret

; -------------------------------------------------------------------
; Prototype: void int2string(int number, char *stringout);
; Function converts given number into string and save it in stringout
;   HLL call: int2string(number, string);

global int2string
int2string:
    push rbp
    mov rbp, rsp
    sub rsp, 8
    push rbx
    push r12

    lea rbx, qword [rbp-8]                  ; 64-bit local variable for number
    mov r11, 10                             ; divisior: used in conversion
    mov r12, 0                              ; numbers on the stack

    cmp edi, 0                              ; if number is negative
    jl AddMinus                             ; add minus to the string
    mov dword [rbx], edi
    mov dword [rbx+4], 0
    jmp PrepareNumber

AddMinus:
    mov byte [rsi], "-"                     ; add minus to the string
    inc rsi                                 ; update string index

; Inverse number by multiplying by -1
    mov r10, -1
    mov eax, edi
    imul r10d
; result of multiplication will be 64-bit, we need to conbine it in the
; memory - local variable
    mov dword [rbx], eax
    mov dword [rbx+4], edx

PrepareNumber:
    mov rax, qword [rbx]                    ; restore number into rax register

; Divide number by 10 and push reminder to stack until result is greater than 0.
; This algorithm will reverse numbers. It will helpful when assembling a string.
PushLoop:
    mov rdx, 0
    div r11                                 ; divide by 10
    push rdx                                ; push reminder
    inc r12                                 ; increment numbers count
    cmp rax, 0                              ; check if result > 0
    ja PushLoop

    mov r10, 0                              ; pop counter

; Values from the stack will be poped in reverse order. Every value will be converted to
; ASCII by adding 48 (dec.) to it. After that - converted value will be saved in the next
; string array field.
PopLoop:
    pop rax                                 ; retrieve value from stack
    add rax, 48                             ; add 48 to it
    mov byte [rsi], al                      ; save a converted value in string
    inc rsi                                 ; update string position
    inc r10                                 ; update pop counter
    cmp r10, r12                            ; if pop counter is less than push counter
    jb PopLoop                              ;   retrieve next value
    mov byte [rsi], NULL                    ; Terminate string with NULL
    
; End of function. Restore stack and return to calling function.
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret