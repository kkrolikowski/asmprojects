; func.asm -- contains functions used by the program.

section .data

; -----
; Constants

NULL                equ 0           ; string termination
LF                  equ 10          ; newline character
STDOUT              equ 1           ; Standard output (screen)
SYS_write           equ 1           ; write() syscall
INT_MAX             equ 10          ; maximum number of integers

; -----
; Variables

newline             db LF, NULL
colon               db ": ", NULL

section .text
; -----
; Function puts(). Prints string on the screen.
; HLL call: puts(string)
; Arguments:
;   1) string address (RDI)
; Returns:
;   nothing

global puts
puts:
    push rbx

    mov rbx, rdi
    mov rdx, 0                      ; number of characters to print

; Now we have to obtain how many charaters string has
coutLoop:
    cmp byte [rbx], NULL            ; stop counting when string ends.
    je CountDone
    inc rdx
    inc rbx
    jmp coutLoop

CountDone:
    cmp rdx, 0                      ; if string was empty, we skip write() syscall
    je putsDone

; Display given string on the screen
    mov rax, SYS_write
    mov rsi, rdi
    mov rdi, STDOUT
    syscall

putsDone:
    pop rbx
    ret

; -----
; Function i2s(). Converts integer into string
; HLL call: i2s(number, string);
; Arguments:
;   1) integer value (RDI)
;   2) destination string address (RSI)
; Returns:
;   nothing

global i2s
i2s:
    push rbx
    push r12

    mov r10, 10                     ; divisior
    mov rax, rdi                    ; provided number
    mov rbx, rsi                    ; destination string
    mov r11, 0                      ; numbers pushed on stack
    mov r12, 0                      ; numbers popped from stack

; Algorithm below:
; Divide integer by 10 and push on stack remainder untill result
; of division is greater than 0.
DivideLoop:
    mov rdx, 0
    cmp rax, 0
    je PopLoop

; Ensure that we won't overflow character array
    cmp r11, INT_MAX
    je PopLoop

    div r10
    push rdx
    inc r11
    jmp DivideLoop

; Algorithm below:
;   1) get from stack number, 
;   2) convert it into character by adding 48
;   3) save it in the next array field
;   4) repeat untill current number cout is less then
;       number of values stored on stack. 
PopLoop:
    cmp r12, r11
    je i2sDone
    pop rax
    add rax, 48
    mov byte [rbx], al
    inc rbx
    inc r12
    jmp PopLoop

i2sDone:
    mov byte [rbx], NULL
    pop r12
    pop rbx
    ret

; -----
; showArgs(). Prints on the screen all provided arguments
; HLL call: showArgs(argc, argv);
; Arguments:
;   1) arguments count (RDI)
;   2) arguments array (RSI)
; Returns:
;   nothing
global showArgs
showArgs:
    push rbp
    mov rbp, rsp
; We need to reserve 27 bytes on the stack
; * 11 bytes for character array
; * 8 bytes for addres of argv from main
; * 8 bytes for address of local string
    sub rsp, 27
    push rbx
    push r12
    push r13

    lea rbx, byte [rbp-27]
    mov qword [rbx], rdi                    ; arguments count
    mov qword [rbx+8], rsi
    mov r13, qword [rbx+8]                  ; address of args array
    lea r12, qword [rbx+16]                 ; address of local intstring

    mov r8, 1                               ; this will skip argv[0]
ArgsLoop:
    cmp r8, qword [rbx]                     ; check the argc
    je ArgsLoopEnd

; Inside this loop we want to prefix each arg with:
; 1: arg1,
; 2: arg2.... and so on. So we have to convert curent arg number into string each time
    mov rdi, r8
    mov rsi, r12
    call i2s

    mov rdi, r12
    call puts
    mov rdi, colon
    call puts
    mov rdi, qword [r13+r8*8]               ; Display argv[i]
    call puts
    mov rdi, newline
    call puts
    inc r8                                  ; i++
    jmp ArgsLoop

ArgsLoopEnd:
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret