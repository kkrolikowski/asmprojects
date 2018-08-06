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

LIMIT1              equ 10
LIMIT2              equ 27
LIMIT3              equ 50
LIMIT4              equ 103

; -----
; Define datasets

arr1        dd 166385,967607,990658,993821,238646,828663,252564,456113,821465,661955
len1        dd LIMIT1
sum1        dd 0
ave1        dd 0
med1a       dd 0
med1b       dd 0
min1        dd 0
max1        dd 0
stddev1     dq 0

arr2        dd 825373,413344,27796,452413,225138,130508,143819,911391,807530,474160
            dd 112475,560041,564563,708558,533203,792120,760586,350077,361273,787146
            dd 590363,951099,154863,993315,850135,859848,508577
len2        dd LIMIT2
sum2        dd 0
ave2        dd 0
med2a       dd 0
med2b       dd 0
min2        dd 0
max2        dd 0
stddev2     dq 0

arr3        dd 764349,346173,221497,666767,522227,786310,326038,535366,640309,817633
            dd 252193,84710,14778,873471,71108,473824,136385,972460,217750,860345
            dd 889903,247292,219998,390794,832126,516599,738627,352682,489389,676391
            dd 964608,553562,28378,255555,280786,223678,670347,800690,476055,228036
            dd 959461,287420,384638,163449,523288,627809,110755,756699,711652,453295
len3        dd LIMIT3
sum3        dd 0
ave3        dd 0
med3a       dd 0
med3b       dd 0
min3        dd 0
max3        dd 0
stddev3     dq 0

arr4        dd 989249,171155,266482,370332,207119,161217,284018,727406,1286,823093
            dd 108696,550114,683339,832115,234334,414677,424880,350104,197121,362649
            dd 711314,797377,332662,690026,844134,832056,187087,486857,992318,950276
            dd 387704,32074,404131,513307,619370,501013,919442,176147,881955,858676
            dd 398837,166572,294745,884619,198724,186211,562846,602738,619082,99260
            dd 31788,503404,16094,984531,894268,603424,640042,366922,868777,479056
            dd 785357,618399,186862,741792,11483,97799,232290,898237,284668,495305
            dd 4928,716515,936857,403276,281129,457584,455881,450783,768284,794685
            dd 575421,21172,248129,280481,302384,557988,792137,867253,840874,188816
            dd 346109,501888,542191,444079,334771,868726,817898,729075,655719,434300
            dd 769501,824263,668281
len4        dd LIMIT4
sum4        dd 0
ave4        dd 0
med4a       dd 0
med4b       dd 0
min4        dd 0
max4        dd 0
stddev4     dq 0

section .bss

sqrt1       resd LIMIT1
sqrt2       resd LIMIT2
sqrt3       resd LIMIT3
sqrt4       resd LIMIT4

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

; -----
; Dataset #1
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

; -----
; Dataset #2
    mov esi, dword [len2]
    mov rdi, arr2
    call sort

    push med2b
    push med2a
    mov r9, max2
    mov r8, min2
    mov rcx, ave2
    mov rdx, sum2
    mov esi, dword [len2]
    mov rdi, arr2
    call stats
    add rsp, 16

    mov edx, dword [len2]
    mov rsi, sqrt2
    mov rdi, arr2
    call sqrtArr

    mov rcx, stddev2
    mov edx, dword [ave2]
    mov esi, dword [len2]
    mov rdi, arr2
    call deviation

; -----
; Dataset #3
    mov esi, dword [len3]
    mov rdi, arr3
    call sort

    push med3b
    push med3a
    mov r9, max3
    mov r8, min3
    mov rcx, ave3
    mov rdx, sum3
    mov esi, dword [len3]
    mov rdi, arr3
    call stats
    add rsp, 16

    mov edx, dword [len3]
    mov rsi, sqrt3
    mov rdi, arr3
    call sqrtArr

    mov rcx, stddev3
    mov edx, dword [ave3]
    mov esi, dword [len3]
    mov rdi, arr3
    call deviation

; -----
; Dataset #4
    mov esi, dword [len4]
    mov rdi, arr4
    call sort

    push med4b
    push med4a
    mov r9, max4
    mov r8, min4
    mov rcx, ave4
    mov rdx, sum4
    mov esi, dword [len4]
    mov rdi, arr4
    call stats
    add rsp, 16

    mov edx, dword [len4]
    mov rsi, sqrt4
    mov rdi, arr4
    call sqrtArr

    mov rcx, stddev4
    mov edx, dword [ave4]
    mov esi, dword [len4]
    mov rdi, arr4
    call deviation

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall