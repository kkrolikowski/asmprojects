; stats.asm -- consists of sum and average functions

; -------------------------------------------------------
;                   DATA SECTION

section .data

; -------------------------------------------------------
;                   CODE SECTION

section .text

; -------------------------------------------------------
; Prototype: int lstSum(int lst[], int n);
; Function calculates sum of integers from a given list
;   HLL call: sum = lstSum(&lst, count);

global lstSum
lstSum:
    mov r10, 0                      ; array index: i = 0;
    mov eax, 0                      ; sum = 0
SumLoop:
    add eax, dword [rdi+r10*4]      ; sum += lst[i]
    inc r10                         ; inrement index: i++;
    cmp r10d, esi                   ; while index < n
    jb SumLoop                      ;   process with sumLoop

    ret

; -------------------------------------------------------
; Prototype: int lstAverage(int sum, int n);
; Function calculates average of integers based on given sum
; and integers count
;   HLL call: sum = lstAverage(sum, count);

global lstAverage
lstAverage:
    mov eax, edi                    ; average = sum
    cdq
    idiv esi                        ; average /= count

    ret