TITLE Name and Math   (namemath.asm)

; Author: Chasen Yamashita
; Last Modified: 4/12/18
; OSU email address: yamashch@oregonstate.eduh
; Course number/section: CS271-400
; Project Number: 1                Due Date: 4/15/18
; Description: This program will display my name and program title, 
;   and will prompt the user to input two numbers. This input will be added, 
;   subtracted, multiplied and divided, before exiting the program. 
;
;	Extra Credit 2 was included, to prevent faulty answers should Input 1 be less than 2.

INCLUDE Irvine32.inc

.data
input1		DWORD	0	; first user input int
input2		DWORD	0	; second user input int
sum			DWORD	0	; sum of one and two
prod		DWORD	0	; product of one and two
diff		DWORD	0	; difference of one and two
quot		DWORD	0	; quotient of one and two
remain		DWORD	0	; remainder from division

intro		BYTE	"Hello, my name is Chasen Yamashita.",0
prompt_1	BYTE	"Please input the first integer to be calculated: ",0
prompt_2	BYTE	"Second integer: ",0
rem			BYTE	" Remainder ",0
goodbye		BYTE	"Goodbye!",0
compar		BYTE	"Error: first input is less than second. Please make sure",0

add1		BYTE	"+",0
subtract	BYTE	"-",0
divide		BYTE	"/",0
multiply	BYTE	"*",0
equal		BYTE	"=",0

.code
main PROC

;Introduce self/name

	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf

;Prompt for two numbers

	mov		edx, OFFSET prompt_1
	call	WriteString

	call	ReadDec			; Calls for first integer
	mov		input1, eax

	mov		edx, OFFSET prompt_2
	call	WriteString

	call	ReadDec			; Calls for second integer
	mov		input2, eax

;BONUS - Check to see Int 1 is bigger than 2
	
	mov	eax, input1
	mov	ebx, input2
	.IF ebx > eax
		mov		edx, OFFSET compar		; Exits program if comparison is true
		call	WriteString
		call	CrLf
		exit
	.ENDIF

;Do Math

	mov		eax, input1		; Adding
	add		eax, input2		
	mov		sum, eax

	mov		eax, input1		; subtracting
	sub		eax, input2		
	mov		diff, eax

	mov		eax, input1		; multiply
	imul	eax, input2
	mov		prod, eax
	
	mov		eax, input1		; division
	mov		edx, 0
	;mov		edx, input2
	idiv	input2
	mov		quot, eax
	mov		remain, edx

;Report mathematical results

	mov		eax, input1		; Reporting Sum
	call	WriteDec
	mov		edx, OFFSET add1
	call	WriteString
	mov		eax, input2
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, sum
	call	WriteDec
	call	CrLf


	mov		eax, input1		; Reporting Difference
	call	WriteDec
	mov		edx, OFFSET subtract
	call	WriteString
	mov		eax, input2
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, diff
	call	WriteDec
	call	CrLf

	mov		eax, input1		; Reporting Product
	call	WriteDec
	mov		edx, OFFSET multiply
	call	WriteString
	mov		eax, input2
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, prod
	call	WriteDec
	call	CrLf

	mov		eax, input1		; Reporting Quotient
	call	WriteDec
	mov		edx, OFFSET divide
	call	WriteString
	mov		eax, input2
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, quot
	call	WriteDec
	mov		edx, OFFSET rem
	call	WriteString
	mov		eax, remain
	call	WriteDec
	call	CrLf

;say goodbye

	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLf

	exit	; exit to operating system

main ENDP

END main
