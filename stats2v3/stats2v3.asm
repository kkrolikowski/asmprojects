; *********************************************************************************
; Stats2v3 includes the following:
; * sorting
; * calculations: sum array elements, average, min, max, median values
; * square root estimation
; * standard deviation

section .data

; -----
; Define constants

sys_EXIT            equ 60
EXIT_SUCCESS        equ 0

LIMIT1              equ 11
LIMIT2              equ 27
LIMIT3              equ 50
LIMIT4              equ 103

; -----
; Define datasets

arr1        dd 166385,967607,990658,993821,238646,828663,252564,456113,821465,661955,16
len1        dd LIMIT1
sum1        dd 0
ave1        dd 0
med1a       dd 0
med1b       dd 0
min1        dd 0
max1        dd 0
stddev1     dq 0

section .bss
sqrt1       resd LIMIT1

section .text

; -----
; HLL (C/C++): sort(arr, len)
; * 1'st arg: arr, address, rdi
; * 2'nd arg: len,   value, rsi
global sort
sort:
; Prologue
    push rbp
    mov rbp, rsp                            ; set the frame pointer
    sub rsp, 8                              ; reserve 8 bytes on the stack 
    push rbx
    push r12
    lea rbx, [rbp-8]                        ; setting a reference point to local vars.
; -----
; Local variables
; small: [rbx]
; index: [rbx+4]

; Function code
    mov r12, 0                              ; i = 0
    mov eax, 0
OuterFOR_part1:                             ; for i = 0 to i < len
    mov eax, dword [rdi+r12*4]
    mov dword [rbx], eax                    ; small = arr[i]
    mov dword [rbx+4], r12d                 ; index = i

    mov r11, r12                            ; j = i
InnerFOR:
    mov eax, dword [rdi+r11*4]
    cmp eax, dword [rbx]                    ; if arr[j] < small
    jl NewSmall                             ;  update small value
    inc r11                                 ; j++
    cmp r11, rsi                            ; while j < small
    jb InnerFOR                             ; continue with inner loop
    jmp OuterFor_part2                      ; else switch numbers in array

NewSmall:
    mov eax, dword [rdi+r11*4]
    mov dword [rbx], eax                    ; small = arr(j)
    mov dword [rbx+4], r11d                 ; index = j
    inc r11                                 ; j++
    cmp r11, rsi                            ; while j < len
    jb InnerFOR                             ; goto InnerFOR

OuterFor_part2:
    mov r11d, dword [rbx+4]
    mov r10d, dword [rdi+r12*4]
    mov dword [rdi+r11*4], r10d             ; arr(index) = arr(i)

    mov r11d, dword [rbx]
    mov dword [rdi+r12*4], r11d             ; arr(i) = small
    inc r12                                 ; i++
    cmp r12, rsi                            ; while i < len
    jb OuterFOR_part1                       ; continue with loop

; Epilogue
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
ret

; -----
; HLL call (C/C++): stats(arr, len, sum, ave, min, max, med1, med2);
; 1'st arg: arr,  address, rdi
; 2'nd arg: len,  value,   rsi
; 3'rd arg: sum,  address, rdx
; 4'th arg: ave,  address, rcx
; 5'th arg: min,  address, r8
; 6'th arg: max,  address, r9
; 7'th arg: med1, address, stack
; 8'th arg: med2, address, stack
global stats
stats:
; -----
; Prologue
    push rbp
    mov rbp, rsp
    push r12
    push rbx

; -----
; Function code

; Minimal value
    mov r12d, dword [rdi]
    mov dword [r8], r12d

; Maximal value
    mov r12d, dword [rdi+(rsi-1)*4]
    mov dword [r9], r12d

; Sum of all array elements
    mov eax, 0
    mov r12, 0
SumLoop:
    add eax, dword [rdi+r12*4]
    inc r12
    cmp r12, rsi
    jb SumLoop
    mov dword [rdx], eax

; Average array value
    cdq
    idiv esi
    mov dword [rcx], eax

; -----
; Median values, if array is odd: med1 = med2

; First, we need to obtain if array is odd or even
    mov rax, rsi
    mov rdx, 0
    mov r12, 2
    div r12
    
    mov r12d, dword [rdi+rax*4]
    mov rbx, qword [rbp+24]
    mov dword [rbx], r12d
    
    cmp rdx, 0
    je ARRisEVEN

; When array is odd
    mov rbx, qword [rbp+16]
    mov dword [rbx], r12d
    jmp END

ARRisEVEN:
    mov r12d, dword [rdi+(rax-1)*4]
    mov rbx, qword [rbp+16]
    mov dword [rbx], r12d

; -----
; Epilogue
END:
    pop rbx
    pop r12
    pop rbp
ret

; -----
; HLL call (C/C++): sqrtArr(arr1, arr2, len);
; Function will take every item from arr1, then calculate square root estimation
; and place result in arr2 under the same place.
; 1'st arg: arr1 (src arr): address, rdi
; 2'nd arg: arr2 (dst arr): address, rsi
; 3'rd arg: len:            value,   rdx
global sqrtArr
sqrtArr:
; Prologue
    push rbp
    mov rbp, rsp
    sub rsp, 12
    push r12
    push rbx
    lea rbx, [rbp-12]

; Function code
    mov r12, 0                  ; src and dst array index
    mov dword [rbx], 50         ; iterations limit
    mov dword [rbx+4], edx      ; saving arrays length

    mov eax, 0
ArrayLoop:
    mov r11, 0                  ; actual iteration number
    mov dword [rbx+8], 1
    jmp SQRT_Loop
    inc r12
    cmp r12d, dword [rbx+4]
    jb ArrayLoop
    jmp SQRT_END

SQRT_Loop:
    mov r10, 2
    mov eax, dword [rdi+r12*4]
    cdq
    idiv dword [rbx+8]
    add eax, dword [rbx+8]
    cdq
    idiv r10d
    mov dword [rbx+8], eax
    inc r11
    cmp r11d, dword [rbx]
    jb SQRT_Loop
    mov dword [rsi+r12*4], eax
    inc r12
    cmp r12d, dword [rbx+4]
    jb ArrayLoop

SQRT_END:
; Epilogue
    pop rbx
    pop r12
    mov rsp, rbp
    pop rbp
ret

; -----
; HLL call (C/C++): deviation(arr, len, ave, stddev);
; 1'st arg: integer array - address: rdi
; 2'nd arg: array length  - value:   rsi
; 3'rd arg: average value - value:   rdx
; 4'th arg: std deviation - address: rcx
global deviation
deviation:
; Prologue
    push rbp
    mov rbp, rsp
    sub rsp, 12
    push rbx
    push r12
; Function code
    lea rbx, [rbp-12]                ; local variable for tmp
    mov qword [rbx], 0
    mov dword [rbx+8], edx           ; local copy of average
    mov r12, 0
    mov eax, 0
    mov r8, 0                        ; local sum
STDDEV_LOOP:
    mov eax, dword [rdi+r12*4]
    sub eax, dword [rbx+8]
    imul eax
    mov dword [rbx], eax
    mov dword [rbx+4], edx
    add r8, qword [rbx]
    inc r12
    cmp r12, rsi
    jb STDDEV_LOOP
    mov rax, r8
    cqo
    idiv rsi

    mov r12, 50
    mov r11, 0
    mov r10, 2
    mov qword [rcx], 1
    mov qword [rbx], rax
SQUARE_ROOT:
    mov rax, qword [rbx]
    cqo
    idiv qword [rcx]
    add rax, qword [rcx]
    cqo
    idiv r10
    mov qword [rcx], rax
    inc r11
    cmp r11, r12
    jb SQUARE_ROOT
    
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
    call sort

    push med1b
    push med1a
    mov r9, max1
    mov r8, min1
    mov rcx, ave1
    mov rdx, sum1
    mov esi, dword [len1]
    mov rdi, arr1
    call stats
    add rsp, 16

    mov edx, dword [len1]
    mov rsi, sqrt1
    mov rdi, arr1
    call sqrtArr
    
    mov rcx, stddev1
    mov edx, dword [ave1]
    mov esi, dword [len1]
    mov rdi, arr1
    call deviation

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall