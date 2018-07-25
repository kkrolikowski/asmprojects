; *************************************************************************
; Selection sort algorithm example
; This is implemented by selsort() function which gets two args.
; 1'st: reference to array
; 2'nd: array length
; Algorithm:
;   begin
;     for i = 0 to len-1
;       small = arr(i)
;       index = i
;       for j = i to len-1
;         if ( arr(j) < small ) then
;           small = arr(j)
;           index = j
;         end_if
;       end_for
;       arr(index) = arr(i)
;       arr(i) = small
;     end_for
;   end_begin

section .data

; -----
; Define constants

sys_EXIT        equ 60
EXIT_SUCCESS    equ 0

; -----
; Datasets definition

arr1        dd -136892,-917918,723697,228249,337102,277171,-305140,-461586,312808,-795873
len1        dd 10

arr2        dd 248813,867865,-15904,-42751,-794044,-76014,-807036,-315225,-118647,-850665
            dd -657097,-777578,-445833,-134578,-426669,221600,-561335,-691851,-981015,752190
            dd 490304,392637,714052,366885,645901
len2        dd 25

arr3        dd 398705,-39036,-891879,-592393,-28975,-191118,-477413,850423,827436,948616
            dd 137868,315419,-242841,-677660,285900,-603900,239962,-552480,253888,-557434
            dd -485525,-645680,915614,960896,889238,691878,327866,739103,467873,244427
            dd 334276,-671328,-710603,-480949,251640,904549,-293627,18040,-31480,-969301
            dd 487797,35917,-771025,-850373,-206055,-868512,174342,261075,9914,230877
len3        dd 50

section .text

; ----- function selsort(arr, len);
; * 1'st arg: arr - address: rdi
; * 2'nd arg: len - value: rsi
; HLL (C/C++) call: selsort(arr, len);

global selsort
selsort:
; -----
; Prologue

; Setting the stack frame
    push rbp
    mov rbp, rsp

; We need 8 bytes on the stack for local variables:
; * small - [rbx]
; * index - [rbx+4]
    sub rsp, 8
    push rbx
    push r12
    lea rbx, dword [rbp-8]
    
    mov r12, 0                      ; i = 0
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
    mov dword [rdi+r12*4], r10d     ; arr(i) = small
    
    inc r12                         ; i++
    cmp r12, rsi                    ; if i < len
    jb OuterLoop                    ; then goto OuterLoop, else
    jmp End                         ; end function

Inner:
    mov r10, r12                    ; j = i
Innerloop:
    mov eax, dword [rbx]            ; eax = small
    cmp dword [rdi+r10*4], eax      ; if ( arr(j) < small ) then
    jl NewSmall                     ; goto newSmall
    inc r10                         ; j++
    cmp r10, rsi                    ; if j < len
    jb Innerloop                    ; then goto InnerLoop
    jmp Outer                       ; else - goto Outer

NewSmall:
    mov eax, dword [rdi+r10*4]      
    mov dword [rbx], eax            ; small = arr(j)
    mov dword [rbx+4], r10d         ; index = j
    inc r10                         ; j++
    cmp r10, rsi                    ; if j < len
    jb Innerloop                    ; then goto InnerLoop
    jmp Outer                       ; else goto Outer
End:
; -----
; Epilogue

; restore saved registers
    pop r12                         
    pop rbx
    
; clear local variables
    mov rsp, rbp
    pop rbp
ret

global _start
_start:

; -----
; Dataset #1
    mov esi, dword [len1]
    mov rdi, arr1
    call selsort

; -----
; Dataset #2
    mov esi, dword [len2]
    mov rdi, arr2
    call selsort

; -----
; Dataset #3
    mov esi, dword [len3]
    mov rdi, arr3
    call selsort

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall