; ------------------------------------------------------------------
; funcions used in the program
;   1)  int lstSum(int lst[], int len);
;   2)  int lstAverage(int sum, int len);

;-------------------------------------------------------------------
;                       DATA SECTION

section .data

;-------------------------------------------------------------------
;                       CODE SECTION

section .text

; -----
; lstSum() calculates sum of all integer from the list
;   HLL call: sum = lstSum(&lst, len);

global lstSum
lstSum:
    mov r10, 0
    mov eax, 0
SumLoop:
    add eax, dword [rdi+r10*4]
    inc r10
    cmp r10d, esi
    jb SumLoop

    ret

; -----
; lstAverage calculates Average value based on given sum
; and array length.
;   HLL call: ave = lstAverage(sum, len);

global lstAverage
lstAverage:
    mov eax, edi
    cdq
    idiv esi

    ret