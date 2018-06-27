; ******************************************************************
;  Program calculates average values and find min. and max values
;  from given example lists


; ******************************************************************
;                   MACROS

%macro aver 3
        mov eax, 0
        mov rsi, 0
        mov ecx, [%2]
        lea rbx, [%1]
    %%SumLoop:
        add eax, dword [rbx+rsi*4]
        inc rsi
        loop %%SumLoop
        
        cdq
        idiv dword [%2]
        mov dword [%3], eax
%endmacro

%macro minmax 4
        mov eax, dword [%1]
        lea rbx, [%1]
        mov dword [%3], eax
        mov dword [%4], eax
        mov ecx, dword [%2]
        mov rsi, 0
    %%SearchLoop:
        mov eax, dword [rbx+rsi*4]
        cmp eax, dword [%3]
        jl %%NewMin
        cmp eax, dword [%4]
        jg %%NewMax
        inc rsi
        loop %%SearchLoop
        jmp %%exit
    %%NewMin:
        mov dword [%3], eax
        inc rsi
        loop %%SearchLoop
    %%NewMax:
        mov dword [%4], eax
        inc rsi
        loop %%SearchLoop
    %%exit: 
%endmacro

; ******************************************************************
;                           DATA SECTION

section .data

; -----
; Define constants

EXIT_SUCCESS    equ 0
sys_EXIT        equ 60

; -----
; Define datasets

len             dd 20

list1           dd 231723,960939,-438856,-224403,-254972,36595,793545,939965,-444234,627113
                dd 491205,815355,916120,-349144,-779837,-746255,-212879,-358312,-307441,712539
aver1           dd 0
min1            dd 0
max1            dd 0

list2           dd 608850,-879617,736801,108729,-238214,609084,919030,638457,353857,541198
                dd -771524,935940,-259141,21990,-119471,819728,467351,9365,-56331,-525792
aver2           dd 0
min2            dd 0
max2            dd 0

list3           dd -952244,359497,537311,59571,-758477,615992,-322515,-903545,-613557,381898
                dd -898043,-386952,784088,439912,-997441,386822,-556508,-803284,-328380,-865382
aver3           dd 0
min3            dd 0
max3            dd 0

; ******************************************************************
;                           CODE SECTION

section .text
global _start
_start:
    
    aver list1, len, aver1
    aver list2, len, aver2
    aver list3, len, aver3

    minmax list1, len, min1, max1
    minmax list2, len, min2, max2
    minmax list3, len, min3, max3

last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall