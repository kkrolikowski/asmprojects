;*************************************************************************************
; Program demonstrates a few operations on a predefined list of integers. To perform
; these we have a 100-element array consisting signed double-words. (32-bit).
; We will start with performing following operations on all array elements:
; * calculate sum and average
; * find the minimum, maximum and the middle value (note: values are unsorted)
; Next we will handle negative numbers. For all negative numbers we will
; * find sum, count and average
; The same thing with all numbers evenly divisible by three.
; * find sum, count and average

section .data

EXIT_SUCCESS        equ 0
sys_EXIT            equ 60
LIMIT               equ 100

list                dd 13756,47637,45233,-20834,65610,-34332,-73428,92080,40119,54796
                    dd 16572,-53765,-69600,4791,7752,60100,-49387,4388,88920,80858
                    dd 74319,49409,-2756,-86291,91314,-23972,-97748,27977,53754,-10833
                    dd -29679,-7237,-3249,80225,97582,27174,51334,46828,8083,90284
                    dd -82040,-37094,-34327,87816,-96843,46056,23169,37432,64105,-67083
                    dd -50029,-63195,-40011,58816,-25297,-54207,-97233,-29254,-33815,93921
                    dd 54440,63842,-89808,76716,50293,-10325,-48801,-68197,-99076,-85153
                    dd 22432,-87598,-36221,34174,-47458,7434,56465,-96489,-60375,-70437
                    dd 57571,48742,8797,-61853,60984,-38131,-53912,-23978,-94681,88812
                    dd -80839,-21715,75424,15819,-80149,10398,-340,-63272,-49474,85524

sum_all             dd 0

section .text
global _start
_start:
    mov ecx, LIMIT                      ; initialize loop settings
    mov rsi, 0                          ; LIMIT = 10, index = 0

SumListItems:
    add eax, dword [list+rsi*4]         ; eax += list[index]
    inc rsi                             ; index++ 
    loop SumListItems                   ; loop until index < LIMIT
    mov dword [sum_all], eax            ; sum_all = eax

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall