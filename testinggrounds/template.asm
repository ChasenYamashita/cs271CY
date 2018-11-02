TITLE Program Template     (template.asm)

; Author: Chasen Yamashita
; Last Modified:
; OSU email address: yamashch@oregonstate.eduh
; Course number/section: CS271-400
; Project Number:                   Due Date: 
; Description:

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

.code
main PROC

mov		al,00111100b
or		al,82h

mov		eax, al
call	WriteBin

	exit	; exit to operating system
main ENDP


END main
