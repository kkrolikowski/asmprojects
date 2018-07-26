; ******************************************************************************
; Program calculates simple statistics of a given integer arrays:
; sum, average, middle values, minimum and maximum.
; Program includes sorting function.

section .data

; -----
; Define constants

EXIT_SUCCESS        equ 0
sys_EXIT            equ 60

; -----
; Define datasets

arr1        dd -58347,44089,109502,-225582,898133,375601,793161,-520336,515823,-233378
len1        dd 10
sum1        dd 0
min1        dd 0
max1        dd 0
med1a       dd 0
med1b       dd 0
ave1        dd 0

arr2        dd 537134,-812835,386585,-704469,721080,252655,-525836,-583331,-758623,-372134
            dd -519827,-631685,-798531,-657627,715946,159617,-589392,-765286,651167,750069
            dd 17565,925047,-997726,855422,-908286,-866982,-507993
len2        dd 27
sum2        dd 0
min2        dd 0
max2        dd 0
med2a       dd 0
med2b       dd 0
ave2        dd 0

arr3        dd -754574,8678,617476,-705690,-982510,-73630,721822,187353,317520,-229877
            dd 800069,71735,530909,-508238,116546,-837469,630714,-394676,859316,-311041
            dd 990603,-501327,-133834,243714,-336724,-491410,-689137,-48905,-685627,189476
            dd -220231,236504,412745,-758602,893263,-999433,425769,-464500,-269247,-814035
            dd -268913,-539776,-877496,-270036,-410137,-440399,-711411,-710139,-38728,891566
len3        dd 50
sum3        dd 0
min3        dd 0
max3        dd 0
med3a       dd 0
med3b       dd 0
ave3        dd 0

arr4        dd -328251,954992,-435347,932192,315725,716260,955699,997953,-455546,827561
            dd -94336,-545872,-887723,-473202,-716772,-165234,771408,-184555,49187,300594
            dd 892724,648181,661188,-682932,157342,-740686,685121,-431076,-138288,117994
            dd -272218,87206,481869,744449,426810,457753,665637,494878,160047,923554
            dd -575986,-680843,-853508,614045,-14292,-153927,916911,-689974,-592324,-388071
            dd -894863,-212052,-177801,-562599,943492,-346762,177919,-870476,-731705,323458
            dd -467899,-736985,231218,172648,-3712,-405472,207097,892143,-656846,838835
            dd -454987,-516688,-192790,9873,-505167,-870648,-426764,-939118,250803,708166
            dd 113594,263063,-427147,-106243,-29738,-688998,-6681,-173296,-471681,978445
            dd 650242,213792,-214257,-11918,231331,-693610,565431,-281328,963933,740621
            dd -619552,-432596,566582
len4        dd 103
sum4        dd 0
min4        dd 0
max4        dd 0
med4a       dd 0
med4b       dd 0
ave4        dd 0

section .text
; ******************************************************************************
;                               FUNCTIONS

; -----
; HLL (C/C++) call: sort(arr, len);
; arr: reference, rdi
; len: value,     rsi
global sort
sort:
; -----
; Prologue

; Setting stack frame
    push rbp
    mov rbp, rsp
; stack reservation for 2 local vars.
    sub rsp, 8
; registers below have to be saved first
    push rbx
    push r12
; we will use this as a stack reference point
; small = [rbp]
; index = [rbp+4]
    lea rbx, [rbp-8]

; -----
; Function code

    mov r12, 0                      ; i = 0
Outer_pre:
    mov eax, dword [rdi+r12*4]
    mov dword [rbp], eax            ; small = arr(i)
    mov dword [rbp+4], r12d         ; index = i

Inner_settings:
    mov r11, r12                    ; j = i

Inner:
    mov eax, dword [rdi+r11*4]
    cmp eax, dword [rbp]            ; if arr(j) < small
    jl SmallerNumber                ; then set new small
    inc r11                         ; else j++
    cmp r11, rsi                    ; while j < len 
    jl Inner                        ;   get new array element
    jmp Outer_post                  ; when end of array is reached
                                    ; change array vals in Outer_post
SmallerNumber:
    mov dword [rbp], eax
    mov dword [rbp+4], r11d
    cmp r11, rsi
    jl Inner

Outer_post:
    mov r10d, dword [rdi+r12*4]     ; r10d = arr(i)
    mov r11d, dword [rbp+4]         ; r11d = index
    mov dword [rdi+r11*4], r10d     ; arr(index) = arr(i)
    mov r10d, dword [rbp]           ; r10d = small
    mov dword [rdi+r12*4], r10d     ; arr(i) = small
    inc r12                         ; i++
    cmp r12, rsi                    ; while i < len
    jb Outer_pre                    ;  go to next array element

; -----
; Epilogue
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
ret

; -----
; HLL (C/C++) call: stats(arr, len, sum, min, max, med1, med2, ave);
; arr:  reference, rdi
; len:  value,     rsi
; sum:  reference, rdx
; min:  reference, rcx
; max:  reference, r8
; med1: reference, r9
; med2: reference, stack
; ave:  reference, stack
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

    mov r12, 0                          ; i = 0
    mov rax, 0
SumLoop:
    add eax, [rdi+r12*4]                ; eax += arr(i)
    inc r12                             ; i++
    cmp r12, rsi                        ; while i < len
    jb SumLoop                          ;   update sum
    mov dword [rdx], eax                ; *sum = eax

    cdq                                 ; Average:
    idiv esi                            ; eax /= len
    mov rbx, qword [rbp+24]
    mov dword [rbx], eax                ; *rbx = eax

    mov r10d, dword [rdi]                ; min value
    mov dword [ecx], r10d
    mov r10d, dword [rdi+(rsi-1)*4]      ; max value
    mov dword [r8], r10d

; to obtain middle values we have to determine if given "len"
; is odd or even.
; if len is odd: med1 = med2
    mov eax, esi
    mov r10d, 2
    mov edx, 0
    div r10d
    cmp edx, 0
    je LenIsEven
    mov r10d, dword [rdi+rax*4]
    mov dword [r9], r10d                 ; med1 value
    mov rbx, [rbp+16]
    mov dword [rbx], r10d                ; med2 value
    jmp End

LenIsEven:
    mov r10d, dword [rdi+rax*4]
    mov rbx, [rbp+16]
    mov dword [rbx], r10d                ; *med2 = arr(len/2)
    mov r10d, dword [rdi+(rax-1)*4]      ; *med1 = arr(--len/2)
    mov dword [r9], r10d

End:
; -----
; Epilogue
    pop rbx
    pop r12
    pop rbp
ret

; ******************************************************************************
;                                 MAIN

global _start
_start:

; -----
; Dataset #1

; Sort arr1 array
    mov esi, dword [len1]
    mov rdi, arr1
    call sort

; Calculate statistics
    push ave1
    push med1b
    mov r9, med1a
    mov r8, max1
    mov rcx, min1
    mov rdx, sum1
    mov esi, dword [len1]
    mov rdi, arr1
    call stats
    add rsp, 16

; -----
; Dataset #2

; Sort arr2 array
    mov esi, dword [len2]
    mov rdi, arr2
    call sort

; Calculate statistics
    push ave2
    push med2b
    mov r9, med2a
    mov r8, max2
    mov rcx, min2
    mov rdx, sum2
    mov esi, dword [len2]
    mov rdi, arr2
    call stats
    add rsp, 16

; -----
; Dataset #3

; Sort arr3 array
    mov esi, dword [len3]
    mov rdi, arr3
    call sort

; Calculate statistics
    push ave3
    push med3b
    mov r9, med3a
    mov r8, max3
    mov rcx, min3
    mov rdx, sum3
    mov esi, dword [len3]
    mov rdi, arr3
    call stats
    add rsp, 16

; -----
; Dataset #4

; Sort arr4 array
    mov esi, dword [len4]
    mov rdi, arr4
    call sort

; Calculate statistics
    push ave4
    push med4b
    mov r9, med4a
    mov r8, max4
    mov rcx, min4
    mov rdx, sum4
    mov esi, dword [len4]
    mov rdi, arr4
    call stats
    add rsp, 16

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall