;**************************************************************************
;             Program implements bubble sort algorythm
;**************************************************************************

section .data

EXIT_SUCCESS        equ 0
sys_EXIT            equ 60
MAX                 equ 100

lst             dd -91236,-78680,86732,-77536,3446,32335,51145,5377,54632,-99327
                dd -72443,-50162,7749,-54806,19246,-41451,28716,15749,90302,-73018
                dd -80322,-61953,75590,-45354,-22548,-2883,-12002,-38338,40724,9359
                dd -5129,-45230,-27089,35040,-73000,43209,-94461,-64391,23481,47760
                dd -72178,1524,-88062,57566,8399,47420,-47699,37272,-52586,3856
                dd 85592,55253,-59075,-84261,45397,40764,-60499,-32831,13886,-31405
                dd 4719,30813,84133,8632,20793,1196,-73752,-73831,99202,-61668
                dd -90748,68269,57780,-15680,86143,73074,-59569,-62140,-83630,20915
                dd 82538,87164,-23069,28137,-14577,62373,2230,-42263,-57353,18997
                dd -86739,30397,77305,-12307,4855,7439,75151,404,79529,-41925

swapped         db 0                    ; when swapped == 0 after full loop run,
                                        ; we can assume, that all data are sorted
section .text
global _start
_start:
    mov rcx, MAX                        ; MAX = 100
    jmp OuterLoop                       ; jump over Outer label.
Outer:
    cmp byte [swapped], 0               ; if swapped == 0:
    je last                             ;   we can assume, that all values are sorted
OuterLoop:
    dec rcx                             ; MAX = MAX - 1
    mov rsi, 0                          ; index = 0
    mov byte [swapped], 0               ; swapped = 0
    cmp rcx, 0                          ; if MAX == 0: 
    je last                             ;   quit the program (safety switch)      
    jmp InnerLoop                       ; go to inner loop
Inner:
    inc rsi                             ; index++
    cmp rsi, rcx                        ; if index == MAX:
    je Outer                            ;   go to outer loop
InnerLoop:
    mov eax, [lst+rsi*4]                ; eax = lst[index]
    mov r9d, [lst+(rsi+1)*4]            ; r9d = lst[index+1]
    cmp eax, r9d                        ; if eax > r9d:
    jg Swap                             ;   swap list values
    jmp Inner
Swap:
    mov r10d, dword [lst+(rsi+1)*4]     ; r10d = lst[index+1]
    mov dword [lst+(rsi+1)*4], eax      ; lst[index+1] = eax
    mov dword [lst+rsi*4], r10d         ; lst[index] = r10d
    mov byte [swapped], 1               ; swapped = 1
    jmp Inner                           ; continue with next pair
    
last:
    mov rax, sys_EXIT
    mov rdi, EXIT_SUCCESS
    syscall