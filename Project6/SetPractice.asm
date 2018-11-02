TITLE Set Practice     (SetPractice.asm)

; Author: Chasen Yamashita
; Last Modified:
; OSU email address: yamashch@oregonstate.eduh
; Course number/section: CS271-400
; Project Number: 6B                  Due Date:    6/10/18
; Description:

INCLUDE Irvine32.inc

MacroWriteString MACRO text

	push	edx
	mov		edx,OFFSET text
	call	WriteString
	pop		edx

ENDM

; (insert constant definitions here)

.data

MyName			BYTE	"Name: Chasen Yamashita ",0
ProgTitle		BYTE	"Program Title: Set Practice",0
Instruction		BYTE	"You'll be provided with a combinations problem. Input your answer, using numbers only.",0

promptOne		BYTE	"Number of elements in the set:  ",0
promptTwo		BYTE	"Number of elements to choose from the set:  ",0
promptThree		BYTE	"How many ways can you choose? Input answer:   ",0

correct			BYTE	"Correct!",0
incorrect		BYTE	"Incorrect...",0

finalOne		BYTE	"There are ",0
finalTwo		BYTE	" combinations of ",0
finalThree		BYTE	" items from a set of ",0

notherone		BYTE	"Another problem? (y/n): ",0
goodbye			BYTE	"Goodbye!",0
invalidchar		BYTE	"Please enter y or n only: "
yesyes          BYTE    "y",0
nono	        BYTE    "n",0

CurrProb		BYTE	"Problem ",0

input			BYTE	?						; stores y or n
request			DWORD	?						; user's answer
probCount		DWORD	0						; problem number

n				DWORD	?						;   Factorials to be calculated
r				DWORD	?						;   
answer			DWORD	?						; stores the result the user needs to calculate.
result			DWORd	?						; stores user's response.		


.code
main PROC

	call	Randomize		; unique seed based on time
	call	introduction

Drill:



	call	CrLf
	call	CrLf
	inc		probCount
	MacroWriteString	CurrProb
	mov		eax, probCount
	call	WriteDec
	call	CrLf

	
	push	OFFSET r
	push	OFFSET n
	call	showProblem

	push	OFFSET answer
	call	getData

	push	n
	push	r
	push	OFFSET result
	call	combinations

	call	CrLf

	push	n
	push	r
	push	answer
	push	result
	call	showResults

ReadUserCharacter:

	call	ReadChar 
	mov		input, al

   
	or      al, 20h        
	cmp     al, yesyes     ;compare to "y"
	je      Drill
	cmp     al, nono      ;compare to "n"
	je      Exiting


Invalid:
	
	call	CrLf
	MacroWriteString	invalidchar
	call	CrLf
	jmp		ReadUserCharacter

Exiting:
	
	call	CrLf
	call	CrLf
	MacroWriteString	goodbye
	call	CrLf

	exit	; exit to operating system
main ENDP

;---------------------------------------------------------
introduction PROC
;
; Prints the program name, programmer name, and instructions.
; Parameters: n/a
; Returns: None, prints only
; Preconditions: N/A
;---------------------------------------------------------
	
	MacroWriteString	MyName
	call	CrLf

	MacroWriteString	ProgTitle
	call	CrLf
	call	CrLf

	MacroWriteString	Instruction
	call	CrLf

	ret
introduction ENDP



;---------------------------------------------------------
showProblem PROC
;
; Generates random number and prints n and r, the amount of sets and elements 
; to choose from the set.
; Parameters: n is +8, r is +12.
; Returns: n and r contain new values
; Preconditions: N/A
;---------------------------------------------------------

	push	ebp
	mov		ebp, esp

	mov		esi, [ebp+8]

	mov		eax, 9
	call	RandomRange
	add		eax, 3
	mov		[esi], eax


	mov		edi, [ebp+12]

	call	RandomRange
	inc		eax
	mov		[edi], eax

	MacroWriteString	promptOne
	mov		eax, [esi]
	call	WriteDec
	call	CrLf

	MacroWriteString	promptTwo
	mov		eax, [edi]
	call	WriteDec
	call	CrLf

	MacroWriteString	promptThree

	pop		ebp
	ret		8

showProblem ENDP

;---------------------------------------------------------
getData PROC
;
; Gets the user's response to the problem.
; Parameters: +8 is answer.
; Returns: answer contains user's input.
; Preconditions: N/A
;---------------------------------------------------------

	push	ebp
	mov		ebp, esp

	mov		esi, [ebp+8]
	call	ReadDec
	mov		[esi], eax

	pop		ebp
	ret		4

getData ENDP



;---------------------------------------------------------
combinations PROC
;
; Calculates n! / (r! * (n-r)!). Calls Factorial 3 times.
; 
;
; Parameters: +8 is address of result (the correct answer), 
;             +12 is r, +16 is n
; Returns: result stores the correct answer.
; Preconditions: n and r are within correct ranges.
;---------------------------------------------------------

	push	ebp
	mov		ebp, esp

	mov		esi, [ebp+8]			;esi points to result

	mov		ebx, [ebp+12]
	mov		[esi], ebx				;r! is calculated
	pushad
	push	[ebp+8]
	call	factorial
	popad
	mov		ecx, [esi]				;stores r! in edx

	mov		eax, [ebp+16]			;calculates (n-r)!
	sub		eax, ebx
	mov		[esi], eax
	pushad
	push	[ebp+8]
	call	factorial
	popad


	mov		eax, [esi]				; Finds product of r! * (n-r)!
	mov		ebx, ecx				; ecx = r!, and eax = (n-r)!
	mul		ebx


	mov		ebx, [ebp+16]			; finding n!
	mov		[esi], ebx
	pushad
	push	[ebp+8]
	call	factorial
	popad							; n! is stored in [ebp+8], or result. 
									; eax holds the other part of the problem.


	mov		ebx, eax				; divides n! / (r! * (n-r)!)
	mov		eax, [esi]
	mov		ecx, 0
	mov		edx, 0
	div		ebx
		
	mov		[esi], eax				;stores final result in result

	pop		ebp
	ret		12

combinations ENDP


;---------------------------------------------------------
factorial PROC
;
; Calculates the factorial of a passed in variable address.
; Parameters: +8 is the address of a integer variable.
; Returns: None, prints only
; Preconditions: N/A
;---------------------------------------------------------

	push	ebp
	mov		ebp, esp

	mov		edi, [ebp+8]

	mov		ecx, [esi]
	dec		ecx
	mov		eax, [esi]
	mov		ebx, [esi]

	cmp		eax, 1
	jle		leaving

looping:

	dec		ebx
	mul		ebx
	loop	looping

	mov		[edi], eax

leaving:

	pop		ebp
	ret		4

factorial ENDP


;---------------------------------------------------------
showResults PROC
;
; 
; Parameters: +8 is result, +12 is answer, +16 is r, +20 is n.
; Returns: None, prints only
; Preconditions: N/A
;---------------------------------------------------------

	push	ebp
	mov		ebp, esp

	mov		eax, [ebp+8]
	cmp		eax, [ebp+12] 

	je		Hooray

	MacroWriteString	incorrect
	call	CrLf

	jmp		ShowAnswer


Hooray:

	MacroWriteString	Correct
	call	CrLf


ShowAnswer:

	MacroWriteString	finalOne
	mov		eax, [ebp+8]
	call	WriteDec
	MacroWriteString	finalTwo
	mov		eax, [ebp+16]
	call	WriteDec
	MacroWriteString	finalThree
	mov		eax, [ebp+20]
	call	WriteDec

	call	CrLf
	MacroWriteString	notherone

	pop		ebp
	ret		16

showResults ENDP




END main
