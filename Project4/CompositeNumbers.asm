TITLE Composite Numbers     (template.asm)

; Author: Chasen Yamashita
; Last Modified: 5/12/18
; OSU email address: yamashch@oregonstate.eduh
; Course number/section: CS271-400
; Project Number: 4                  Due Date: 5/13/18
; Description: Prints an amount composite numbers chosen by the user, from 1 to 400. Will prompt the user again
;				if they input a number not within the range of 1-400, and will iterate through integers linearly, 
;				printing what is determined to be a composite number.

INCLUDE Irvine32.inc

UPPER_LIMIT		equ		400

.data

MyName		BYTE	"Name: Chasen Yamashita ",0
ProgTitle	BYTE	"Program Title: Composite Numbers",0

instruct1	BYTE	"Input a number 1 to 400 (inclusive) of composite numbers you wish to see: ",0
warning		BYTE	"ERROR: Number must be from 1 to 400, and positive.",0
goodbye		BYTE	"Finished printing, goodbye.",0
spaces		BYTE	"   ",0

UserInt		DWORD	?						; user's input
valid		DWORD	?						; indicates whether data is valid
compnum		DWORD	3						; Holds the composite or prime number to be checked
HalfInt		DWORD	?						; Holds half of UserInt

check		DWORD	?						; validate check
linecount	DWORD	0						; counts the amount of numbers a line

.code
main PROC

	call	introduction
	call	getUserData



	call	showComposites
	call	farewell

	exit	; exit to operating system
main ENDP

;
;Name of program and programmer
;
introduction PROC

	mov		edx, OFFSET MyName
	call	WriteString
	call	CrLf

	mov		edx, OFFSET ProgTitle
	call	WriteString
	call	CrLf

	ret
introduction ENDP

;
;Get user input and loop for proper input
;
getUserData PROC

GetInput:

	mov		edx, OFFSET instruct1
	call	WriteString

	call	ReadDec		
	call	CrLf

	mov		UserInt, eax

	call	Validate

	cmp		check, 1
	jg		GetInput

	ret
getUserData ENDP


;
;
;Check if input is greater than 400 or less than 0
;
Validate PROC

	cmp		UserInt, 0
	jle		error

	cmp		UserInt, UPPER_LIMIT
	jg		error

nonerror:

	ret

error:

	mov		edx, OFFSET warning				; Gives warning, and returns check with 2
	call	WriteString
	call	CrLf
	
	mov		check, 2
	jmp		nonerror

Validate ENDP




;
;Prints composite numbers
;
showComposites PROC

	mov		ecx, UserInt
	
IncrementComp:

	inc		compnum				;iterates through all integers

	call	isComposite
	cmp		check, 2			;if check is 2, prints the composite number, jumps back if not.
	jne		IncrementComp

	inc		linecount
	cmp		linecount, 10
	je		NewLine
	jmp		ContinuePrint

NewLine:
	call	CrLf
	mov		linecount, 0

ContinuePrint:

	mov		eax, compnum
	call	WriteDec
	mov		edx, OFFSET spaces	;Adds spaces between numbers
	call	WriteString
	loop	IncrementComp
	
	ret

showComposites ENDP


;
;Checks if number is composite or prime
;
isComposite PROC
	
	pushad

	mov		eax, compnum		;First checks for all even numbers, where 2 is a guarantee factor.
	mov		ebx, 2				;Dividing by 4, 6, etc. isn't necessary since they also have 2 as a factor.
	xor		edx, edx 
	div		ebx
	
	cmp		edx, 0
	je		CompFound			;if 0 remainder, it is a composite number.

	inc		ebx

	call	FindHalf			;Obtains half of compnum 


FindFactor:

	mov		eax, compnum
	xor		edx, edx
	div		ebx

	cmp		edx, 0				;jumps to CompFound if the remainder is 0.
	je		CompFound

	add		ebx, 2					;Increments the divisor for the next loop.
	cmp		ebx, halfInt
	jg		CompNotFound		;jumps out of process if the divisor becomes higher than half of compnum.
	jmp		FindFactor

CompFound:

	mov		check, 2
	jmp		Leaving

CompNotFound:

	mov		check, 1	

Leaving:

	popad
	ret

isComposite ENDP



;
;Finds half of current number being checked for composite, to terminate the loop in isComposite.
;The reasoning being that a number cannot be divided by something greater than its half for an integer product.
;
FindHalf PROC

	pushad

	mov		eax, compnum
	mov		ebx, 2
	xor		edx, edx 
	div		ebx

	mov		HalfInt, eax

	popad

	ret

FindHalf ENDP



;
;Say Goodbye
;
farewell PROC

	call	CrLf
	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLf

	ret
farewell ENDP

END main
