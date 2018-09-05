; ******************************************************************************************************
;                                  String to integer converter.


; ******************************************************************************************************
;                                   DATA SECTION

section .data

; -----
; Define constants

sys_EXIT            equ 60
EXIT_SUCCESS        equ 0
NULL                equ 0
TRUE                equ 1
FALSE               equ 0

; -----
; Define datasets

string1          db "12345678", NULL
integer1         dd 0

string2          db "-12345678", NULL
integer2         dd 0

string3          db "1", NULL
integer3         dd 0

string4          db "1234567890", NULL
integer4         dd 0

string5          db "12345dda67890", NULL
integer5         dd 0

string6          db "12345678dupa", NULL
integer6         dd 0

string7          db "dupa12345678", NULL
integer7         dd 0

string8          db "-1234567890", NULL
integer8         dd 0

string9          db "-2", NULL
integer9         dd 0

; ******************************************************************************************************
;                                   CODE SECTION

section .text

; -----
; Function string to integer
; Prototype: bool str2int(char * string, int * number);
; string: by address: rdi
; number: by address: rsi

global str2int
str2int:
; -----
; Prologue
    push rbp
    mov rbp, rsp
    sub rsp, 12
    push r12
    push rbx

; -----
; Function code

; Local variables
    lea rbx, [rbp-12]
    mov dword [rbx], 0              ; sum = 0
    mov dword [rbx+4], 1            ; factor = 1
    mov dword [rbx+8], TRUE         ; status = TRUE

    mov r12, 0                      ; string index initialization
    mov r10, 10                     ; factor step

; Check if a given string represents negative number

    cmp byte [rdi], 45
    je isNegative
    jmp MoveToEnd

isNegative:
    inc r12

; Moving to last character in string. Validation is included
; if character is less than "0" or greater than "9" function
; should return FALSE
MoveToEnd:
    cmp byte [rdi+r12], 48
    jb NaN
    cmp byte [rdi+r12], 57
    ja NaN
    inc r12
    cmp byte [rdi+r12], NULL
    jne MoveToEnd

    dec r12
Char2Int:

; Character to integer conversion
; number = string[i] -48
    movzx eax, byte [rdi+r12]
    sub eax, 48

; number *= factor
    mov edx, 0
    mul dword [rbx+4]

; sum += number
    add dword [rbx], eax
    mov eax, dword [rbx+4]

; factor *= 10
    mov edx, 0
    mul r10d
    mov dword [rbx+4], eax

; i--
    dec r12
    mov eax, dword [rbx]

; Verify if given string represents negative number
    cmp byte [rdi+r12], 45
    je InverseNumber

; if i >= 0 continue with processing
    cmp r12, 0
    jge Char2Int
    jmp SumReturn

InverseNumber:
    mov r10d, -1
    imul r10d

SumReturn:    
    mov dword [rsi], eax
    mov eax, dword [rbx+8]
    jmp End

NaN:
    mov dword [rbx+8], FALSE
    mov eax, dword [rbx+8]
; -----
; Epilogue
End:
    pop rbx
    pop r12
    mov rsp, rbp
    pop rbp
ret

global _start
_start:
    mov rsi, integer1
    mov rdi, string1
    call str2int

    mov rsi, integer2
    mov rdi, string2
    call str2int

    mov rsi, integer3
    mov rdi, string3
    call str2int

    mov rsi, integer4
    mov rdi, string4
    call str2int

    mov rsi, integer5
    mov rdi, string5
    call str2int

    mov rsi, integer6
    mov rdi, string6
    call str2int

    mov rsi, integer7
    mov rdi, string7
    call str2int

    mov rsi, integer8
    mov rdi, string8
    call str2int

    mov rsi, integer9
    mov rdi, string9
    call str2int

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall