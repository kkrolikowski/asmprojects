;**************************************************************************************
; Program demonstrates various operations on a list of unsigned integers including:
; * find the minimum, maximum, sum and average
; * find the minimum, maximum, sum and average for numbers that are divisible by 3
;**************************************************************************************

section .data

; Constants
EXIT_SUCCESS        equ 0
sys_EXIT            equ 60
LIMIT               equ 100                         ; Numer of list elements

; Variables
list        dd 48272,58356,84260,85036,87892,66686,65157,34419,83447,50058
            dd 44801,71156,5301,67539,15950,94450,89460,29266,42707,16201
            dd 29084,32271,4435,97879,42782,56312,52343,86857,61157,84809
            dd 34341,87071,71305,34829,26199,84089,4445,38135,73608,42451
            dd 60178,82348,87328,68532,30800,98553,24373,38692,66375,5449
            dd 84834,92148,68876,35747,76203,17048,48198,48085,36877,50487
            dd 77536,4204,52388,77671,57599,60667,86152,91230,4583,33314
            dd 19200,78303,78642,79549,15123,89025,56425,47991,6973,95238
            dd 56662,68541,57234,40933,83662,36541,76550,56357,82257,97151
            dd 2660,26378,20526,52386,28106,10888,21601,91082,32318,58614

sum_all     dd 0                                    ; sum of all integers
sum_divby3  dd 0                                    ; sum of integers divisible by 3
ave_all     dd 0                                    ; average of all integers
min         dd 0                                    ; minimal list value
max         dd 0                                    ; maximal list value
tmp         dd 0                                    ; temporary variable used for calculations
med         dd 0                                    ; median list value (without sorting)

section .text
global _start
_start:

; Find the median value (without prior sorting)
    mov rax, LIMIT                                  ; obtain the number of all items
    mov r8, 2                                       ; assume that we have a even numbers
    mov rdx, 0                                      ; let's find the middle index
    div r8                                          ; * index = LIMIT / 2
    mov rsi, rax                                    ; now let's find the first middle value
    mov rax, 0                                      ;
    mov eax, dword [list+rsi*4]                     ; * tmp = list[index]
    mov dword [tmp], eax                            ; the second middle value
    dec rsi                                         ; * index--;
    mov eax, dword [list+rsi*4]                     ; * eax = list[index];
    add eax, dword [tmp]                            ; Now let's sum those two values and divide them by two
    mov edx, 0                                      ; * eax += list[index]
    div r8d                                         ; * eax /= 2
    mov dword [med], eax                            ; To get our middle value: med = eax

    mov ecx, LIMIT
    mov r9, LIMIT
    mov rsi, 0                                      ; index = 0;
    mov eax, 0

    mov r8d, 3
calcSumDiv3:
    mov eax, dword [list+rsi*4]
    mov edx, 0
    div r8d
    cmp edx, 0
    je SumDiv3
    inc rsi
    loop calcSumDiv3
    
    mov ecx, LIMIT
    mov rsi, 0                                      ; index = 0;
    mov eax, 0   
    jmp calcTotalSum

SumDiv3:
    mov eax, dword [list+rsi*4]
    add dword [sum_divby3], eax
    inc rsi
    loop calcSumDiv3
    
    mov ecx, LIMIT
    mov rsi, 0
    mov eax, 0

; -----
; Calculate the sum of all integers

calcTotalSum:                                       ; while (index < LIMIT)
    add eax, dword [list+rsi*4]                     ; {
    inc rsi                                         ;    sum_all += list[index];    
    loop calcTotalSum                               ;    index++;
    mov dword [sum_all], eax                        ; }
; -----
; Calculate the average value of all integes
    mov edx, 0                                      ;
    mov r8d, LIMIT                                  ; ave_all = sum_all / LIMIT
    div r8d                                         ;
    mov dword [ave_all], eax

; Reset loop settings
    mov ecx, LIMIT
    mov rsi, 0                                      ; index = 0;

; Calculate minimum and maximum values
    mov eax, dword [list]                           ; 
    mov dword [min], eax                            ; min = list[0];
    mov dword [max], eax                            ; max = list[0];
FindMinMax:                                         ;
    mov eax, dword [list+rsi*4]                     ; while (index < LIMIT)
    cmp eax, dword [min]                            ; {
    jb NewMin                                       ;    if (list[index] < min)
    cmp eax, dword [max]                            ;    {
    ja NewMax                                       ;       min = list[index]; 
    inc rsi                                         ;    }
    loop FindMinMax                                 ;    if (list[index] > max)
    jmp last                                        ;    {
NewMin:                                             ;       max = list[index];
    mov dword [min], eax                            ;    }
    inc rsi                                         ;    index++;
    loop FindMinMax                                 ; }
NewMax:
    mov dword [max], eax
    inc rsi
    loop FindMinMax

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall