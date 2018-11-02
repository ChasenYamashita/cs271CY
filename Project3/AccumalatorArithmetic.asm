TITLE Accumalator Arithmetic     (AccumalatorArithmetic.asm)

; Author: Chasen Yamashita
; Last Modified: 5/4/18
; OSU email address: yamashch@oregonstate.eduh
; Course number/section: CS271-400
; Project Number: 3                  Due Date: 5/6/18
; Description: The program first displays my name, then takes and displays the user' inputted name.
;				The program instructs the user to input negative integers, and will do so until a positive one
;				is found. Then, it will calculate the sum and product of those integers, display the amount
;				of integers, and say goodbye.
;				
;				Extra Credit: I unwittingly numbered the lines, if that counts

INCLUDE Irvine32.inc

LOWER_LIMIT		equ		-100

; (insert constant definitions here)

.data

MyName		BYTE	"Name: Chasen Yamashita ",0
ProgTitle	BYTE	"Program Title: Accumalator Arithmetic",0

PromptName	BYTE	"Please input your name: ",0
Welcome		BYTE	"Welcome, ",0

instruct1	BYTE	"Input only negative integers, -100 to -1 (inclusive). The sum and average of all integers will be calculated.",0
instruct2	BYTE	"Once all integers you would like to calculate have been input, enter any positive number.",0

warning		BYTE	"First input cannot be positive or below -100!",0
PromptInt	BYTE	"Inputting integer number ",0
colon		BYTE	": ",0

Result1		BYTE	"Integer Average: ",0
Result2		BYTE	"Integer Sum: ",0
Result3		BYTE	"Total number of integers input: ",0
Goodbye		BYTE	"Goodbye, ",0


username	BYTE	35 DUP(0)		; Stores user's input name
IntAvg		SDWORD	?				; Stores integer average
IntSum		SDWORD	?				; Stores integer sum
IntAmount	SDWORD	?				; Stores number of input integers


.code
main PROC

;Display the program title and programmerÅfs name

	mov		edx, OFFSET MyName
	call	WriteString
	call	CrLf

	mov		edx, OFFSET ProgTitle
	call	WriteString
	call	CrLf

;Prompts user for their name

	mov		edx, OFFSET PromptName
	call	WriteString

	mov		ecx, 35
	mov		edx, OFFSET username
	call	ReadString
	call	CrLf

;Welcomes user

	mov		edx, OFFSET welcome
	call	WriteString
	mov		edx, OFFSET username 
	call	WriteString
	call	CrLf

	jmp		Check

;WrongFirst is jumped to if the user's amount of negative integers input is zero.

WrongFirst:

	mov		edx, OFFSET warning
	call	WriteString
	call	CrLf
	jmp		Seeya

;Check is looped until a positive integer or integer below -100 is input. 
;A user's input is read, jumps to calculation of all ints if a positive or number below lower limit is called,
;and adds to the total sum in IntSum, as well as increments the amount of ints inputted.

Check:
	mov		edx, OFFSET PromptInt
	call	WriteString
	mov		eax, IntAmount				; EXTRA CREDIT: Lets the user know what int number they're entering
	add		eax, 1
	call	WriteDec
	mov		edx, OFFSET colon
	call	WriteString


	call	ReadInt			

	cmp		eax, -1				; Checks if greater than -1
	jg		Calc

	cmp		eax, LOWER_LIMIT	; Checks if less than -100
	jl		Calc

	add		IntSum, eax			; Sum

	inc		IntAmount			; Number of inputs

	jmp		Check


; Calculate Average, not before checking to see if there are no input intgeers

Calc:
	
	cmp		intAmount, 0 
	je		WrongFirst

	mov		edx,0				; Clears edx for remainder

	mov		eax, IntSum
	cdq								;Extends sign bit of eax into edx for signed division.
	mov		ebx, IntAmount

	idiv	ebx
	mov		IntAvg, eax


; Display product and sum

	mov		edx, OFFSET Result1 
	call	WriteString
	mov		eax, IntAvg
	call	WriteInt
	call	CrLf

	mov		edx, OFFSET Result2
	call	WriteString
	mov		eax, IntSum
	call	WriteInt
	call	CrLf

	mov		edx, OFFSET Result3
	call	WriteString
	mov		eax, IntAmount
	call	WriteDec
	call	CrLf
	call	CrLf

; Say Goodbye

Seeya:

	mov		edx, OFFSET goodbye
	call	WriteString
	mov		edx, OFFSET username 
	call	WriteString
	call	CrLf


	exit	; exit to operating system
main ENDP



END main
