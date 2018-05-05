;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Program calculates the total lateral surface area
; and volumes of set of pyramides. 
; Also calculates the minimum, maximum, sum and averages
; for the total surface areas and volumes. 
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

section .data

; ----------
; Constants
EXIT_SUCCESS    equ 0
sys_EXIT        equ 60
MAX             equ 10
; ----------
; Variables
aSides          dw 474,155,251,388,125,17,25,482,456,29
heights         dw 494,132,112,449,298,410,257,63,343,53
tmp             dd 0

sumOfVolumes    dq 0
sumOfAreas      dq 0
averageVolume   dq 0
averageArea     dq 0

minArea         dq 0
maxArea         dq 0
minVolume       dq 0
maxVolume       dq 0

section .bss
baseAreas       resd MAX
sideAreas       resq MAX
pyramidAreas    resq MAX
pyramidVolumes  resq MAX 

section .text
global _start
_start:
    mov rsi, 0                      
    mov r8, 0
    mov rcx, MAX

; ----------
; Pyramides basis
; Base(n) = a(n)^2
calcBase:
    mov ax, word [aSides+rsi*2]
    mov dx, 0
    mul ax
    mov word [baseAreas+r8*2], ax
    inc r8
    mov word [baseAreas+r8*2], dx
    inc rsi
    inc r8
    loop calcBase

; ----------
; Reset loop   
    mov rsi, 0
    mov r8, 0
    mov rcx, MAX

; ----------
; Pyramides side areas
; Side(n) = (a(n)/2 * h(n)) * 4
    mov r9w, 2
    mov r10d, 4
calcSides:
    mov ax, word [aSides+rsi*2]
    mov dx, 0
    div r9w
    mul word [heights+rsi*2]
    mov word [tmp], ax
    mov word [tmp+2], dx
    mov eax, dword [tmp]
    mov edx, 0
    mul r10d
    mov dword [sideAreas+r8*4], eax
    inc r8
    mov dword [sideAreas+r8*4], edx
    inc rsi
    inc r8
    loop calcSides

; ----------
; Reset loop
    mov rsi, 0
    mov rcx, MAX

; ----------
; Pyramides areas
; Area(n) = SideArea(n) + BaseArea(n)
calcAreas:
    mov eax, dword [baseAreas+rsi*4]
    add rax, qword [sideAreas+rsi*8]
    mov qword [pyramidAreas+rsi*8], rax
    inc rsi
    mov rax, 0
    loop calcAreas

; ----------
; Reset loop
    mov rsi, 0
    mov rcx, MAX

; ----------
; Pyramides volume
; Volume(n) = (baseArea(n)/3) * height(n)
    mov r8d, 0
    mov r9d, 3
calcVolumes:
    mov eax, dword [baseAreas+rsi*4]
    mov edx, 0
    div r9d
    movzx r10d, word [heights+rsi*2]
    mov edx, 0
    mul r10d
    mov dword [pyramidVolumes+r8d*4], eax
    inc r8d
    mov dword [pyramidVolumes+r8d*4], edx
    inc r8d
    inc rsi
    loop calcVolumes

; ----------
; Reset loop
    mov rsi, 0
    mov rcx, MAX

; ----------
; Sum of Volumes
    mov rax, 0
sumVolumes:
    add rax, qword [pyramidVolumes+rsi*8]
    inc rsi
    loop sumVolumes
    mov qword [sumOfVolumes], rax 
; ----------
; Average volume
    mov r8, MAX
    mov rdx, 0
    div r8
    mov qword [averageVolume], rax

; ----------
; Reset loop
    mov rsi, 0
    mov rcx, MAX

; ----------
; Sum of areas
    mov rax, 0
SumAreas:
    add rax, qword [pyramidAreas+rsi*8]
    inc rsi
    loop SumAreas
    mov qword [sumOfAreas], rax
; ----------
; Average area
    mov rdx, 0
    div r8
    mov qword [averageArea], rax

; Reset counter
    mov rcx, MAX
    mov rsi, 0

; Find min and max area
    mov rax, qword [pyramidAreas]
    mov qword [minArea], rax
    mov qword [maxArea], rax
    
    mov rax, qword [pyramidVolumes]
    mov qword [minVolume], rax
    mov qword [maxVolume], rax

MinMaxArea:
    mov rax, qword [pyramidAreas+rsi*8]
    cmp rax, qword [minArea]
    jb newMinArea
    cmp rax, qword [maxArea]
    ja newMaxArea
    inc rsi
    loop MinMaxArea

; Reset counter
    mov rcx, MAX
    mov rsi, 0

    jmp MinMaxVolume
newMinArea:
    mov qword [minArea], rax
    jmp MinMaxArea
newMaxArea:
    mov qword [maxArea], rax
    jmp MinMaxArea

MinMaxVolume:
    mov rax, qword [pyramidVolumes+rsi*8]
    cmp rax, qword [minVolume]
    jb newMinVolume
    cmp rax, qword [maxVolume]
    ja newMaxVolume
    inc rsi
    loop MinMaxVolume
    jmp last
newMinVolume:
    mov qword [minVolume], rax
    jmp MinMaxVolume
newMaxVolume:
    mov qword [maxVolume], rax
    jmp MinMaxVolume

last:
    mov rax, sys_EXIT
    mov rbx, EXIT_SUCCESS
    syscall