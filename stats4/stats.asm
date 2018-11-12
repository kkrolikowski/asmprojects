; stats.asm -- assembly stats() function. Calculates sum and average from
; a given array of integers
; Prototype: void stats(int [], int, &int, &int);
; HLL call: stats(array, len, &sum, &average);
; Function returns sum and average by reference.

;--------------------------------------------------------------------------
;                           DATA SECTION

section .data

;--------------------------------------------------------------------------
;                           CODE SECTION

section .text

global stats
stats:
    mov r11, 0                          ; array index: i = 0;
    mov eax, 0                          ; sum = 0
SumLoop:
    add eax, dword [rdi+r11*4]          ; sum += array[i];
    inc r11                             ; i++;
    cmp r11d, esi                       ; while i < array_length
    jl SumLoop                          ;   add new value
    mov dword [rdx], eax                ; return sum by reference

    cdq
    idiv esi                            ; average = sum / array_length
    mov dword [rcx], eax                ; return average by reference

    ret