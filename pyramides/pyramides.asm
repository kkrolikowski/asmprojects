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
MAX             equ 10                                      ; Number of pyramides to calculate
; ----------
; Variables
aSides          dw 474,155,251,388,125,17,25,482,456,29     ; pyramide base side length
heights         dw 494,132,112,449,298,410,257,63,343,53    ; pyramide height
tmp             dd 0                                        ; temp. variable used in calculations

sumOfVolumes    dq 0                                        ; sum of volumes of all pyramides
sumOfAreas      dq 0                                        ; sum of areas of all pyramides
averageVolume   dq 0                                        ; average pyramide volume
averageArea     dq 0                                        ; aerage  pyramide area

minArea         dq 0                                        ; smallest pyramide area
maxArea         dq 0                                        ; largest pyramide area
minVolume       dq 0                                        ; smallest pramide volume
maxVolume       dq 0                                        ; largest pyramide volume

section .bss
baseAreas       resd MAX                                    ; array baseAreas[MAX]
sideAreas       resq MAX                                    ; array sideAreas[MAX]
pyramidAreas    resq MAX                                    ; array pyramidAreas[MAX]
pyramidVolumes  resq MAX                                    ; array pyramidVolumes[MAX]

section .text
global _start
_start:
    mov rsi, 0                                              ; index = 0                    
    mov r8, 0                                               ; array offset
    mov rcx, MAX                                            ; set loop limit

; ----------
; Pyramides basis
; Base(n) = a(n)^2
calcBase:                                                   ; 
                                                            ; while (index < MAX)
    mov ax, word [aSides+rsi*2]                             ; {
    mov dx, 0                                               ;    baseAreas[index] = aSides[index] * aSides[index];
    mul ax                                                  ;    index++;
    mov word [baseAreas+r8*2], ax                           ; }
    inc r8                                                  ;
    mov word [baseAreas+r8*2], dx
    inc rsi
    inc r8
    loop calcBase

; ----------
; Reset loop   
    mov rsi, 0                                              ; index = 0
    mov r8, 0                                               ; array offset
    mov rcx, MAX                                            ; set loop limit

; ----------
; Pyramides side areas
; Side(n) = (a(n)/2 * h(n)) * 4
    mov r9w, 2
    mov r10d, 4
calcSides:                                                  ;
    mov ax, word [aSides+rsi*2]                             ; while (index < MAX)
    mov dx, 0                                               ; {
    div r9w                                                 ;    sideAreas[index] = (aSides[index] / 2 * heights[index]) * 4;
    mul word [heights+rsi*2]                                ;    index++;
    mov word [tmp], ax                                      ; }
    mov word [tmp+2], dx                                    ;
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
    mov rsi, 0                                              ; index = 0;
    mov rcx, MAX                                            ; set loop limit

; ----------
; Pyramides areas
; Area(n) = SideArea(n) + BaseArea(n)
calcAreas:                                                  ; 
                                                            ; while (index < MAX)
    mov eax, dword [baseAreas+rsi*4]                        ; {
    add rax, qword [sideAreas+rsi*8]                        ;    pyramidAreas[index] = sideAreas[index] + baseAreas[index];
    mov qword [pyramidAreas+rsi*8], rax                     ;    index++;
    inc rsi                                                 ; }
    mov rax, 0                                              ;
    loop calcAreas

; ----------
; Reset loop
    mov rsi, 0                                              ; index = 0;
    mov rcx, MAX                                            ; set loop limit

; ----------
; Pyramides volume
; Volume(n) = (baseArea(n)/3) * height(n)
    mov r8d, 0
    mov r9d, 3
calcVolumes:                                                ;
    mov eax, dword [baseAreas+rsi*4]                        ; while (index < MAX)
    mov edx, 0                                              ; {
    div r9d                                                 ;    pyramidVolumes[index] = (baseAreas[index] / 3) * heights[index];
    movzx r10d, word [heights+rsi*2]                        ;    index++;
    mov edx, 0                                              ; }
    mul r10d                                                ;
    mov dword [pyramidVolumes+r8d*4], eax
    inc r8d
    mov dword [pyramidVolumes+r8d*4], edx
    inc r8d
    inc rsi
    loop calcVolumes

; ----------
; Reset loop
    mov rsi, 0                                              ; index = 0;
    mov rcx, MAX                                            ; set loop limit

; ----------
; Sum of Volumes
    mov rax, 0
sumVolumes:                                                 ;
    add rax, qword [pyramidVolumes+rsi*8]                   ; while (index < MAX)
    inc rsi                                                 ;    sumOfVolumes += pyramidVolumes[index++];
    loop sumVolumes                                         ;
    mov qword [sumOfVolumes], rax 
; ----------
; Average volume
    mov r8, MAX                                             ;
    mov rdx, 0                                              ;
    div r8                                                  ; averageVolume = sumOfVolumes / MAX
    mov qword [averageVolume], rax                          ;

; ----------
; Reset loop
    mov rsi, 0                                              ; index = 0;
    mov rcx, MAX                                            ; set loop limit

; ----------
; Sum of areas
    mov rax, 0
SumAreas:                                                   ;
    add rax, qword [pyramidAreas+rsi*8]                     ; while (index < MAX)
    inc rsi                                                 ;    sumOfAreas += pyramidAreas[index++];
    loop SumAreas                                           ;
    mov qword [sumOfAreas], rax                             
; ----------
; Average area
    mov rdx, 0                                              ;
    div r8                                                  ; averageArea = sumOfAreas / MAX
    mov qword [averageArea], rax                            ;

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