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
sys_EXIT			equ 60

; -----
; Define data

phrase			db "A man, a plan, a canal - Panama!",0			; our test sentence ended up with null sign.

; -----
; Required ASCII table characters

space			db 32											; ASCII decimal code for space sign
comma			db 44											; ASCII decimal code for comma sign
minus			db 45											; ASCII decimal code for minus sign
exclamation		db 33											; ASCII decimal code for exclamation mark

; -----
; Helper variables
ispalindrome	db 1											; indicates that sentence is a palindrome (1) or not (0)
tmp				dq 0											; used for holding a value from stack

; *************************************************************
; 							Start of Code

section .text
global _start
_start:
	mov rsi, 0													; index of a character array
	push rsi													; let's place null sign on the top of the stac
	jmp toStack													; now we can proceed with all letters

; -----
; Loading values onto the stack

isPunct:
	inc rsi

toStack:
	mov al, byte [phrase+rsi]									; get next character
	cmp al, byte [space]										; Check if current sign is not equal to the following signs
	je isPunct													; We are looking for only alphabet letters
	cmp al, byte [comma]
	je isPunct
	cmp al, byte [minus]
	je isPunct
	cmp al, byte [exclamation]
	je isPunct
	cmp al, 0													; We also need to check if current sign isn't an end of string
	je StringEnd												; if so, wee have to move forward to the next operations
													
	movzx rax, byte [phrase+rsi]								; Now we have to convert current value to 64-bit in order
	push rax													; to pushing it onto stack
	inc rsi														; After that we can proceed with next character
	jmp toStack													; in the next loop iterations

; -----
; Loading values from the stack

StringEnd:
	mov rsi, 0													; We have to move to the begining of the string								
	jmp fromStack												; before reading data from stack

nextValue:
	inc rsi

fromStack:

; -----
; Skipping required characters

	mov al, [phrase+rsi]										; Just as in the first section we need to skip all required
	cmp al, byte [space]										; characters in string before we will be able to compare values
	je nextValue												; from the string and from the stack
	cmp al, byte [comma]
	je nextValue
	cmp al, byte [minus]
	je nextValue
	cmp al, byte [exclamation]
	je nextValue

; -----
; Data comparision

	movzx rax, byte [phrase+rsi]								; again, data from the string array are 8-bit long so they need to be
	pop qword [tmp]												; converterd to 64-bit
	cmp qword [tmp], 0											; if we have reached the null character - we can stop the program
	je last
	cmp rax, qword [tmp]										; If a given character from stack is not equal to the current one from
	jne NotSameChar												; the string we need to make additional verification
	jmp nextValue

NotSameChar:
	cmp rax, qword [tmp]
	jl FindCapitalLetter										; if we have a lowercase letter we should find if we have corresponding uppercase
	jg FindSmallerLetter										; if we have a uppercase letter we should find if we have corresponding lowercase
	jmp NotPalindrome											; if not a given sentence is not a palindrome and we can end program

FindCapitalLetter:
	add rax, 32													; adding 32 to the given uppercase gives us lowercase
	cmp rax, qword [tmp]										; now we can compare values again.
	je nextValue

FindSmallerLetter:
	sub rax, 32													; suntracting 32 from the given lowercase gives us uppercase
	cmp rax, qword [tmp]										; now we can compare values again.
	je nextValue

NotPalindrome:
	mov byte [ispalindrome], 0									; when one of the characters doesn't match we set flag to 0

last:
	mov rax, sys_EXIT
	mov rdi, EXIT_SUCCESS
	syscall
