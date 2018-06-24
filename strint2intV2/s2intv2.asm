; ***********************************************************************************
;  Program convers given string which includes a number with preceeding sign
;  (i.e. "+12345", "-12345") into a proper integer. program is based on the algoritm
;  from: https://github.com/kkrolikowski/asmprojects/blob/master/string2signedint/s2ssint.asm
;  Additionaly program includes some validations.
;    * first character should be "+" or "-"
;    * subsequent characters should represent numbers between 0 and 9
;    * string should be null terminated

; ***********************************************************************************
;                             DATA SECTION

NULL            equ 0                      ; NULL terminator
EXIT_SUCCESS    equ 0
sys_EXIT        equ 60
STRING_MAX      equ 12                     ; signed integer string with NULL terminator
                                           ; requires 12 characters in string
section .data

integer   dd 0                             ; resulted integer
factor    dd 1                             ; factor used in char2int conversion

isValid   db 1                             ; This flag is set to 0 when something is wrong
negative  db 0                             ; This flag is set to 1 when resulted integer should be negative
string    db "-11344",NULL                 ; Input string

; ***********************************************************************************
;                             CODE SECTION

section .text
global _start
_start:
  mov rsi, 0                              ; strIndex = 0
  mov rcx, 0                              ; digitsCount = 0
  mov r8, STRING_MAX                      ; STRING_MAX = 12
  mov rbx, string                         ; points at the first char in string

; -----
; First sign validation
; It Should be "+" or "-"

  cmp byte [rbx], "+"                     ; if first character is "+"
  je MoveToEnd                            ; start start start to count numbers
  cmp byte [rbx], "-"                     ; else if first character is "-"
  je isNegative                           ; set flag to 1 and then count numbers
  jmp StringInvalid                       ; else: String is invalid

isNegative:
  mov byte [negative], 1                  ; negative flag is on

; -----
; Obtain nuber of valid characters

MoveToEnd:
  inc rsi                                 ; strIndex++: move to the next character
  cmp byte [rbx+rsi], NULL                ; if *(rbx+strIndex) == NULL
  je char2int                             ;    start calculations
  cmp rsi, r8                             ; if strIndex > STRING_MAX
  jg StringInvalid                        ;    string is Invalid
  cmp byte [rbx+rsi], "0"                 ; Character should match the range
  jb StringInvalid                        ; "0" to "9" to satisfy criteria
  cmp byte [rbx+rsi], "9"
  ja StringInvalid
  jmp MoveToEnd

; -----
; This block is executed after the first iteration
; it ensures that factor is updateded each time

updateFactor:
  mov r8d, 10
  mov eax, dword [factor]
  mul r8d                                 ; factor *= 10
  mov dword [factor], eax

; -----
; This section executes our algoritm that will calculate proper
; inteter and will place on the stack

char2int:
  dec rsi                                 ; strIndex--
  movzx eax, byte [rbx+rsi]               ; eax = string[strIndex]
  sub eax, 48                             ; convert char to decimal value
  mov edx, 0
  mul dword [factor]                      ; multiply by actual factor
  push rax                                ; push result to stack
  inc rcx                                 ; digitsCount++
  cmp rsi, 1                              ; if we didn't reach first number in string
  jg updateFactor                         ; process with next char.

; -----
; In this section all we need to do is to sum all values from the stack

SumAll:
  pop rax
  add dword [integer], eax                ; integer += rax[digitsCount]
  loop SumAll                             ; digitsCount--

  cmp byte [negative], 1                  ; if negative flag was set
  je InverseNumber                        ; we should multiply integer by -1
  jmp last

; -----
; Optional block: inverting an integer

InverseNumber:
  mov r8d, -1
  mov eax, dword [integer]
  cdq
  imul r8d
  mov dword [integer], eax
  jmp last

; -----
; Optional block: isValid flag is off
; when one of the conditions will not met

StringInvalid:
  mov byte [isValid], 0

; -----
; End of the program

last:
  mov rax, sys_EXIT
  mov rdi, EXIT_SUCCESS
  syscall
