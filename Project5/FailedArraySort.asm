TITLE FailedArraySort    (FailedArraySort.asm)

; Author: Chasen Yamashita
; Last Modified:	5/23/18
; OSU email address: yamashch@oregonstate.eduh
; Course number/section: CS271-400
; Project Number: 5                 Due Date: 5/27/18
; Description: It's SUPPOSED to sort the array through selection sort, but I am unsure if I am switching elements incorrectly or iterating
;				through the array wrong. And I have no clue why the median only prints 0 when the array clearly has contents, what
;				a conundrum
;

INCLUDE Irvine32.inc

MIN				equ		10
MAX				equ		200
LO				equ		100
HI				equ		999

.data

MyName		BYTE	"Name: Chasen Yamashita ",0
ProgTitle	BYTE	"Program Title: Random Number Array",0

instruct1	BYTE	"Input a number 10 to 200 (inclusive) to generate pseudo-random numbers: ",0
warning		BYTE	"ERROR: Number must be from 10 to 200, and positive.",0
Unsorted	BYTE	"The unsorted random number array: ",0
Sorted		BYTE	"The sorted number list: ",0
Median		BYTE	"The median of the list is: ",0

request		DWORD	?						; user's input
array		DWORD	200 DUP(?)				; array to store random integers
lineCount	DWORD	0						; counts lines for printing

.code
main PROC

call	Randomize		; unique seed based on time

call	introduction

push	OFFSET request
call	GetUserData			

push	request
push	OFFSET array
call	FillArray

push	OFFSET array
push	request
push	OFFSET Unsorted
call	PrintArray

push	OFFSET array
push	request
call	SortList

push	OFFSET array
push	request
push	OFFSET Sorted
call	PrintArray

push	request
push	OFFSET array
call	PrintMedian

	exit	; exit to operating system
main ENDP


;---------------------------------------------------------
introduction PROC
;
; Introduces program and programmer name. 
; Parameters: N/A
; Returns: N/A
; Preconditions: MyName, ProgTitle
;---------------------------------------------------------


	mov		edx, OFFSET MyName
	call	WriteString
	call	CrLf

	mov		edx, OFFSET ProgTitle
	call	WriteString
	call	CrLf

	ret
introduction ENDP

;---------------------------------------------------------
GetUserData PROC
;
; Introduces program and programmer name. 
; Parameters: request's address
; Returns: request with user value.
; Preconditions: N/A
;---------------------------------------------------------

	push	ebp
	mov		ebp, esp

GetInput:

	mov		edx, OFFSET instruct1
	call	WriteString

	call	ReadDec		
	call	CrLf

	cmp		eax, MIN			;Validation if input is less than MIN
	jl		error

	cmp		eax, MAX			;Validation if input > MAX
	jg		error

	mov		ebx, [ebp+8]		;Address of request in ebx
	mov		[ebx], eax			;Stores user's value in request.

	pop		ebp					;restores ebp

	ret		4					;pops the pushed request address

error:
	mov		edx, OFFSET warning				; Gives warning
	call	WriteString
	call	CrLf
	jmp	GetInput

GetUserData ENDP

;---------------------------------------------------------
FillArray PROC
;
; Fills array with pseudo random numbers. 
; Parameters: request (value), and address of array.
; Returns: array initialised and given data.
; Preconditions: N/A
;
; Lecture 20 is used as a reference for this portion of code.
;---------------------------------------------------------

	push	ebp
	mov		ebp, esp

	mov		esi, [ebp+8]		; +4 is return address, and +8 is @list. +12 is request.
	mov		ecx, [ebp+12]		; loop counter request.

AddElement:

	mov		eax, HI
	inc		eax
	sub		eax, LO
	call	RandomRange			; Generates random number within range of HI - LO + 1, or 100 to 999. 

	add		eax, LO

	mov		[esi], eax
	add		esi, 4				;Moves to next array node
	loop	AddElement

	pop		ebp
	ret		8
FillArray ENDP

;---------------------------------------------------------
SortList PROC
;
; Uses Selection sort, comparing each int to each other and swapping if one is greater.
; Parameters: @array (+12), request (+8)
; Returns: Sorted elements for @array
; Preconditions: Array contains < 10 elements.
;---------------------------------------------------------
	
	push	ebp
	mov		ebp, esp

	mov		ecx, [ebp+8]		; Set outer loop counter, decrement
	dec		ecx

	mov		ebx, [ebp+12]		; ebx holds array pointer
	mov		edx, ecx		; holds request value, for inner loop counter

OuterLoop:
	
	mov		edi, [ebp+12]
	mov		esi, [ebp+12]				
	add		esi, 4				; Should be +4 for each DWORD element of the array...
	push	ecx
	mov		ecx, edx			; inner loop counter started

InnerLoop:

	mov		eax, [esi]
	cmp		eax, [edi]

	jg		NoSwitch

	push	edi				; Pass addresses of node to be switched
	push	esi				

	call	SwitchElements

NoSwitch:

	add		esi, 4
	add		edi, 4
	
	loop	InnerLoop
	pop		ecx
	loop	OuterLoop

	pop		ebp
	ret		8
SortList ENDP

;---------------------------------------------------------
SwitchElements PROC
;
; 
; Parameters: esi, and edi addresses, esi being the array with a greater index.
;		ebp is +4, esi +8, edi +12, another push makes each +4 more?
; Returns: 
; Preconditions: N/A
;---------------------------------------------------------

	push	ebp
	mov		ebp, esp

	mov		esi, [ebp+8]			;attempts to switch the values
	mov		edi, [ebp+12]			; of the parameters passed in, but for some reason fails.
	mov		ebx, [ebp+12]
	mov		eax, [ebp+8]
	mov		[esi], eax
	mov		[edi], ebx

	pop		ebp
	ret		8

SwitchElements ENDP

;---------------------------------------------------------
PrintMedian PROC
;
; 
; Parameters: +8 is request, +12 is @array
; Returns: Prints the middle element in the array
; Preconditions: N/A
;---------------------------------------------------------

	push	ebp
	mov		ebp, esp

	mov		eax, [ebp+12]				;Getting ready to divide request by 2
	mov		ebx, 2
	mov		ecx, 0
	mov		edx, 0
	div		ebx

	mov		ecx, eax

	PrintMed:

	add		esi, 4				;Moves to next array node
	loop	PrintMed


	mov		edx, OFFSET Median
	call	WriteString
	mov		eax, [esi]
	call	WriteDec
	call	Crlf

	pop		ebp
	ret		8
PrintMedian ENDP

;---------------------------------------------------------
PrintArray PROC
;
; Prints the content of the array and it's title, sorted or unsorted.
; Parameters: Sorted character string, value of request, and array address.
; Returns: None, prints only
; Preconditions: N/A
;---------------------------------------------------------

	push	ebp
	mov		ebp, esp

	mov		ecx, [ebp+12]			;+4 is ebp, +8 is title, +12 is request, +16 is @array
	mov		esi, [ebp+16]

	mov		edx, [ebp+8]			;Prints Title
	call	WriteString
	call	CrLf

	mov		ebx, 0

Printing:

	mov		eax, [esi]
	call	WriteDec
	mov		al, ' '
	call	WriteChar
	call	WriteChar

	
	inc		ebx
	cmp		ebx,10
	jge		PrintNewLine		; ebx used as counter for new lines


	add		esi, 4				;Moves to next array node
	loop	Printing

	jmp		FinishPrint

PrintNewLine:
	
	call	Crlf
	add		esi, 4
	mov		ebx, 0
	loop	Printing

FinishPrint:
	call	CrLf
	call	Crlf
	pop		ebp
	ret		12
PrintArray ENDP


END main
