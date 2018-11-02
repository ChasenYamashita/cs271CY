TITLE Factorial Loops     (FactorialLoops.asm)

; Author: Chasen Yamashita
; Last Modified:
; OSU email address: yamashch@oregonstate.eduh
; Course number/section: CS271-400
; Project Number: 2                  Due Date: 4/22/18
; Description: The program obtains a user's string input, accepts user input for an unsigned integer,
;				decrements the integer if it is greater than 10, uses a counted loop to calculate, and
;				finds the factorial. The factorial and user's name is printed.

INCLUDE Irvine32.inc

.data

promptName	BYTE	"Please input your name: ",0
welcome		BYTE	"Welcome,  ",0
inputOne	BYTE	"Select an integer of 10 or lower:  ",0
finding		BYTE	"Finding the Factorial...",0
result		BYTE	"The factorial of ",0
result2		BYTE	" is ",0
goodbye		BYTE	"Goodbye, ",0
AboveTen	BYTE	"Decrementing, integer greater than 10...",0

username	BYTE	35 DUP(0)		; Stores user's input name
IntInput	DWORD	?				; Stores user's input integer
factor		DWORD	?				; Stores final factorial
revDec		BYTE	0				; To prevent the decrementing message from printing
									;	multiple times, this is set to 1 once.


.code
main PROC

;Prompts user for their name

	mov		edx, OFFSET promptName
	call	WriteString

	mov		ecx, 35
	mov		edx, OFFSET username
	call	ReadString
	call	CrLf

;Prints user name

	mov		edx, OFFSET welcome
	call	WriteString
	mov		edx, OFFSET username 
	call	WriteString
	call	CrLf

;Prompts user for an integer of 10 or less, not negative.

	mov		edx, OFFSET inputOne
	call	WriteString

	call	ReadDec			
	mov		IntInput, eax
	jmp		postloop

;post-loop check here, decrements from integer if greater than 10.

decrementcall:
			
	cmp		revDec, 0
	jne		decrement				; jumps straight to decrement if the message string AboveTen
									; was already called.

	mov		revDec, 1
	mov		edx, OFFSET AboveTen
	call	WriteString
	call	CrLf

decrement:

	dec		IntInput			; Reduces input by just one, as 10 is the max.

postloop:
	mov		eax, IntInput
	cmp		eax, 10
	jg		decrementcall


;jumps to results if input is 1

	mov		eax, IntInput
	cmp		eax, 1
	je		FacOne


;counted loop that finds the factorial of integer.

	mov		edx, OFFSET finding 
	call	WriteString
	call	CrLf

	mov		ecx, IntInput		; sets counter for loop to be 
	mov		eax, IntInput		; value to be multiplied by decremented ebx.
	mov		ebx, IntInput		;
	dec		ecx

countloop:
	
	dec		ebx			;
	mul		ebx		
	loop	countloop	; loops countloop for every integer below IntInput

	mov		factor, eax		;stores factorial



;Setting factorial if input = 1

	jmp		final

FacOne:
	mov		factor, 1


;print results

final:

	mov		edx, OFFSET result
	call	WriteString
	mov		eax, IntInput
	call	WriteDec
	mov		edx, OFFSET result2
	call	WriteString
	mov		eax, factor
	call	WriteDec
	call	CrLf

;reprint name

	mov		edx, OFFSET goodbye 
	call	WriteString
	mov		edx, OFFSET username 
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main