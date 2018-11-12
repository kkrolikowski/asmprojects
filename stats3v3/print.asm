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

    lea rbx, qword [rbp-8]
    mov r11, 10
    mov r12, 0

    cmp edi, 0
    jl AddMinus
    mov dword [rbx], edi
    mov dword [rbx+4], 0
    jmp PrepareNumber

AddMinus:
    mov byte [rsi], "-"
    inc rsi

    mov r10, -1
    mov eax, edi
    imul r10d
    mov dword [rbx], eax
    mov dword [rbx+4], edx

PrepareNumber:
    mov rax, qword [rbx]

PushLoop:
    mov rdx, 0
    div r11
    push rdx
    inc r12
    cmp rax, 0
    ja PushLoop

    mov r10, 0
PopLoop:
    pop rax
    add rax, 48
    mov byte [rsi], al
    inc rsi
    inc r10
    cmp r10, r12
    jb PopLoop
    mov byte [rsi], NULL
    
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret