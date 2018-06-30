; ****************************************************************************************
;  String to integer converter using dedicated macro. Program can produce positive and
;  negative integers as well. Characters validation is included here. We assune that
;  input string is null-terminated. Which is normal for all proper strings.


%macro str2int 2
        mov rsi, 0                          ; characters count in the string
        mov rcx, 0                          ; numbers on stack
        mov r8d, 10                         ; multiply factor step
        mov r9d, 1                          ; current factor value
        mov r10b, 0                         ; string sign flag: 0 - positive, 1 - negative
        mov r11, 0                          ; this value determines string index value
                                            ; at we should stop processing string characters
                                            ; - 0: when string holds positive number
                                            ; - 1: when string holds negative number
        lea rbx, [%1]                       ; first value in the string
        
        ; Check if given number string is negative
        cmp byte [rbx], "-"
        je %%Negative
        
        ; Check if first char is a number, if not: we skip all the macro
        cmp byte [rbx], "0"
        jl %%END
        cmp byte [rbx], "9"
        ja %%END

        jmp %%NumbersCount

    %%Negative:                             ; when string is negative
        mov r10b, 1                         ; set sign flag to 1: to indicate negative number
        inc rsi                             ; set index to the next string char.
        inc r11                             ; set the string processing limit from 0 -> 1

    ; At this point w should obtain how many numbers we have to process. One assumption is made
    ; here. We expect, that every string is null-terminated.
    %%NumbersCount:
        cmp byte [rbx+rsi], NULL
        je %%Char2int

        ; Simple validation: when one of the characters does not represents a number we invalidate
        ; all string and skip the rest. As the result resulting integer will be 0
        cmp byte [rbx+rsi], "0"
        jl %%END
        cmp byte [rbx+rsi], "9"
        ja %%END
        inc rsi
        jmp %%NumbersCount

    ; Every new calculation needs a new multiply factor:
    ; Example: 123 = 3*1 + 2*10 + 1*100
    %%NewFactor:
        mov eax, r9d
        mov edx, 0
        mul r8d
        mov r9d, eax

    ; This is a heart of all program.
    ; * conversion from ASCII to decimal
    ; * multiply by current factor
    ; * push result on the stack
    %%Char2int:
        dec rsi
        movzx eax, byte [rbx+rsi]
        sub eax, 48
        imul r9d
        push rax
        inc rcx
        cmp rsi, r11
        jne %%NewFactor

    ; At this moment w have all needed values on the stack
    ; All we need to do is to sum all the values together
    %%BuildInteger:
        pop rax
        add dword [%2], eax
        loop %%BuildInteger

        ; One more thing. We need to verify if resulted number should be negative
        cmp r10b, 1
        je %%InverseNumber
        jmp %%END

    ; To produce negative number we are multiplying it by -1
    %%InverseNumber:
        mov eax, dword [%2]
        mov r9d, -1
        imul r9d
        mov dword [%2], eax
    %%END:
%endmacro

; ****************************************************************************************
;                                   DATA SECTION

; -----
; Constants definitions

NULL            equ 0
EXIT_SUCCESS    equ 0
sys_EXIT        equ 60

; -----
; Data sets

section .data

; Correct positive number
string1         db "12345",NULL
integer1        dd 0

; Correct negative number
string2         db "-12345",NULL
integer2        dd 0

; Incorrect string. integer3 will be 0
string3         db "x12345",NULL
integer3        dd 0

; Incorrect string. integer4 will be 0
string4         db "1xx23",NULL
integer4        dd 0

; ****************************************************************************************
;                                   CODE SECTION

section .text
global _start
_start:
    
    str2int string1, integer1
    str2int string2, integer2
    str2int string3, integer3
    str2int string4, integer4

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall