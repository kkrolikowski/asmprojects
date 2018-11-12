; Example program that calculates sum and average of given integer list
; and print the results on the screen.

; -----------------------------------------------------------------------
;                           DATA SECTION

; -----
; Basic constants

NULL                    equ 0       ; string termination
LF                      equ 10      ; new line
EXIT_SUCCESS            equ 0       ; exit code with success
SYS_exit                equ 60      ; code for terminate
INT_MAX                 equ 10      ; maximal count of numbers in unsigned integer

; ----
; Datasets

lst1                    dd -521403,485388,666371,-408318,-181197,-36616,66241,397340,703373,-766359
                        dd -176280,-149735,-910680,-990855,-645616,4304,-240516,-852542,49734,478250
                        dd -913908,227271,-915835,889741,550464,933752,250752,-395690,-366997,768292
                        dd 485784,-902755,-343793,-714010,23470,-755448,816283,471070,517948,-991367
                        dd 752609,527868,-361654,-581157,583119,446816,-63351,-64810,-937294,945801
                        dd 37190,-966666,-830702,-986526,911962,-738746,-455949,-11205,-80453,-568166
                        dd -914102,-489521,-618199,471532,226244,671805,337774,461330,999073,-340718
                        dd 319216,-908012,382886,-621739,-162725,603668,538851,-246081,-139218,966987
                        dd 494456,787603,699389,410461,-224951,606718,776849,-758323,182614,-886108
                        dd -943175,208418,539036,-105265,929762,840932,-870910,-667397,284330,-573613
len1                    dd 100

lst2                    dd -901294,951310,-925183,-324754,436071,-862921,40043,-801978,162655,-551538
                        dd 394421,-390484,345114,-837334,583098,-558201,-917969,601474,993044,-706052
                        dd -962914,-489510,576150,-615786,-871383,-311305,401383,-797523,-808436,11303
                        dd 404925,-74214,-978498,637184,-880771,43213,-510103,-601737,631111,-937177
                        dd 516553,865621,-506622,-128380,-723441,-117848,93642,-715330,-785895,597260
len2                    dd 50

lst3                    dd -413711,-569451,555085,524064,-341537,60718,-415499,518345,-503860,-731282
len3                    dd 10

; -----
; Messages

header                  db "Calculation Results.", LF, NULL
list1_sum_prefix        db "lst1 Sum: ", NULL
list1_ave_prefix        db ", Average: ", NULL
list2_sum_prefix        db LF, "lst2 Sum: ", NULL
list2_ave_prefix        db ", Average: ", NULL
list3_sum_prefix        db LF, "lst3 Sum: ", NULL
list3_ave_prefix        db ", Average: ", NULL
NewLine                 db LF, NULL

section .bss

sum1                    resd 1
ave1                    resd 1
sum2                    resd 1
ave2                    resd 1
sum3                    resd 1
ave3                    resd 1

intstring               resb INT_MAX+2      ; two additional fields for sign and NULL character

; -----------------------------------------------------------------------
;                           CODE SECTION

extern lstSum
extern lstAverage
extern print
extern int2string

section .text

global _start
_start:
; -----
; Datasets calculations

; -----
; Dataset #1

                                            ; calculate sum
    mov rdi, lst1
    mov esi, dword [len1]
    call lstSum
    mov dword [sum1], eax
                                            ; calculate average
    mov edi, dword [sum1]
    mov esi, dword [len1]
    call lstAverage
    mov dword [ave1], eax

; -----
; Dataset #2

                                            ; calculate sum
    mov rdi, lst2
    mov esi, dword [len2]
    call lstSum
    mov dword [sum2], eax
                                            ; calculate average
    mov edi, dword [sum2]
    mov esi, dword [len2]
    call lstAverage
    mov dword [ave2], eax

; -----
; Dataset #3

                                            ; calculate sum
    mov rdi, lst3
    mov esi, dword [len3]
    call lstSum
    mov dword [sum3], eax
                                            ; calculate average
    mov edi, dword [sum3]
    mov esi, dword [len3]
    call lstAverage
    mov dword [ave3], eax

; -----
; Display results

; Message header
    mov rdi, header
    call print

;------------------------------------------ ; DATA SET #1
; Display sum information
    mov rdi, list1_sum_prefix
    call print                              ; display message prefix
    mov edi, dword [sum1]
    mov rsi, intstring
    call int2string                         ; convert sum integer to string
    mov rdi, intstring
    call print                              ; display sum number

; Display average information
    mov rdi, list1_ave_prefix
    call print                              ; display message prefix
    mov edi, dword [ave1]
    mov rsi, intstring
    call int2string                         ; convert average integer to string
    mov rdi, intstring
    call print                              ; display average number

;------------------------------------------ ; DATA SET #2
; Display sum information
    mov rdi, list2_sum_prefix
    call print                              ; display message prefix
    mov edi, dword [sum2]
    mov rsi, intstring
    call int2string                         ; convert sum integer to string
    mov rdi, intstring
    call print                              ; display sum number

; Display average information
    mov rdi, list2_ave_prefix
    call print                              ; display message prefix
    mov edi, dword [ave2]
    mov rsi, intstring
    call int2string                         ; convert average integer to string
    mov rdi, intstring
    call print                              ; print average number

;------------------------------------------ ; DATA SET #3
; Display sum information
    mov rdi, list3_sum_prefix
    call print                              ; display message prefix
    mov edi, dword [sum3]
    mov rsi, intstring
    call int2string                         ; convert sum integer to string
    mov rdi, intstring
    call print                              ; display sum number

; Display average information
    mov rdi, list3_ave_prefix
    call print                              ; display message prefix
    mov edi, dword [ave3]
    mov rsi, intstring
    call int2string                         ; convert average integer to string
    mov rdi, intstring
    call print                              ; display average number

; Display newline at the end
    mov rdi, NewLine
    call print
    
END:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall