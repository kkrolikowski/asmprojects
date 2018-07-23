; *************************************************************************
; Selection sort algorythm example

section .data

; -----
; Define constants

sys_EXIT        equ 60
EXIT_SUCCESS    equ 0

; -----
; Datasets definition

arr1        dd -136892,-917918,723697,228249,337102,277171,-305140,-461586,312808,-795873
len1        dd 10

section .text

; ----- function selsort(arr, len);
; * 1'st arg: arr - address: rdi
; * 2'nd arg: len - value: rsi
global selsort
selsort:
; -----
; Prologue
    push rbp
    mov rbp, rsp
    sub rsp, 4
    push rbx
    push r12
; Stack layout
; rbx    = small
; rbx+4  = index
    lea rbx, dword [rbp-4]
    mov r12, 0

OuterLoop:
    mov eax, dword [rdi+r12*4]
    mov dword [rbx], eax            ; small = arr(i)
    mov dword [rbx+4], r12d         ; index = i
    jmp Inner
Outer:    
    mov r10d, dword [rbx+4]         ; r10d = index
    mov r11d, dword [rdi+r12*4]     ; r11d = arr(i)
    mov dword [rdi+r10*4], r11d     ; arr(index) = arr(i)

    mov r10d, dword [rbx]
    mov dword [rdi+r12*4], r10d
    
    inc r12
    cmp r12, rsi
    jb OuterLoop
    jmp End

Inner:
    mov r10, r12                    ; j = i
Innerloop:
    mov eax, dword [rbx]            ; eax = small
    cmp dword [rdi+r10*4], eax      ; if ( arr(j) < small ) then
    jl NewSmall                     ; goto newSmall
    inc r10
    cmp r10, rsi
    jb Innerloop
    jmp Outer

NewSmall:
    mov eax, dword [rdi+r10*4]
    mov dword [rbx], eax
    mov dword [rbx+4], r10d
    inc r10
    cmp r10, rsi
    jb Innerloop
    jmp Outer
End:
; -----
; Epilogue
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
ret

global _start
_start:
    mov esi, dword [len1]
    mov rdi, arr1
    call selsort

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall