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
    mov r10, 0                          ; list array index
    mov r11, 0                          ; sum of integers
CountLoop:
    add r11d, dword [rdi+r10*4]         ; sum += list[i]
    inc r10                             ; i++
    cmp r10d, esi                       ; while i < len
    jb CountLoop                        ;   execute countLoop

    mov dword [rdx], r11d               ; save sum of integers

; Calculate the average
    mov eax, r11d
    cdq
    idiv esi

    mov dword [rcx], eax                ; save average of integers

    ret