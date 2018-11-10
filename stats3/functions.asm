; ---------------------------------------------------
; Functions source file

; ---------------------------------------------------
; Data section

section .data

; ---------------------------------------------------
; Code section

section .text

; ----------------------------------------------------
; Function stats. Calculates sum and average of a list
; of integers.
;   HLL call: stats(list, len, &sum, &ave);

global stats
stats:
    mov r10, 0
    mov r11, 0
CountLoop:
    add r11d, dword [rdi+r10*4]
    inc r10
    cmp r10d, esi
    jb CountLoop

    mov dword [rdx], r11d

    mov eax, r11d
    cdq
    idiv esi

    mov dword [rcx], eax

    ret