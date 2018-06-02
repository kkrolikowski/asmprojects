; **********************************************************************
; Program tests if phrase is a palindrome, to achieve this goal
; some assumptions have to be made. We need to skip all punctation
; marks. For example. Let's assume, that we want to process a sentence:
; 	"A man, a plan, a canal - Panama!"
; we have to skip characters: space, comma, dash and exclamation mark.
; **********************************************************************

section .data

; -----
; Define constants

EXIT_SUCCESS		equ 0
sys_EXIT		equ 60

; -----
; Define data

phrase		db "A man, a plan, a canal - Panama!",0

space		db 32
comma		db 44
minus		db 45
exclamation	db 33
capital_Z	db 90					; if char <= capital_Z it's capital
palindrome	db 1

tmp			dq 0

section .text
global _start
_start:
	mov rsi, 0
	mov r8b, 0
	push rsi
	jmp toStack
isPunct:
	inc rsi
toStack:
	mov al, byte [phrase+rsi]
	cmp al, byte [space]
	je isPunct
	cmp al, byte [comma]
	je isPunct
	cmp al, byte [minus]
	je isPunct
	cmp al, byte [exclamation]
	je isPunct
	cmp al, r8b
	je StringEnd
	movzx rax, byte [phrase+rsi]
	push rax
	inc rsi
	jmp toStack

StringEnd:
	mov rsi, 0
	jmp fromStack

nextValue:
	inc rsi

fromStack:
	movzx al, [phrase+rsi]
	cmp al, byte [space]
	je nextValue
	cmp al, byte [comma]
	je nextValue
	cmp al, byte [minus]
	je nextValue
	cmp al, byte [exclamation]
	je nextValue

	movzx rax, byte [phrase+rsi]
	pop qword [tmp]
	cmp r8b, qword [tmp]
	je last
	cmp rax, qword [tmp]
	jne NotSameChar
	jmp nextValue

NotSameChar:
	cmp rax, qword [tmp]
	jl FindCapitalLetter
	jg FindSmallerLetter
	jmp NotPalindrome

FindCapitalLetter:
	add rax, 32
	cmp rax, qword [tmp]
	je nextValue

FindSmallerLetter:
	sub rax, 32
	cmp rax, qword [tmp]
	je nextValue
	
NotPalindrome:
	mov byte [palindrome], 0

last:
	mov rax, sys_EXIT
	mov rdi, EXIT_SUCCESS
	syscall
