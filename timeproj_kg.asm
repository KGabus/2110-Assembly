INCLUDE PCMAC.INC

EXTRN GETDEC:NEAR
EXTRN PUTUDEC:NEAR

.model small
.586
.stack 100h
.data
	hours db ?
	minutes dw ?
	seconds dw ?
	
	totalSecs dw ?
	
	SIXTY db 60d
	toMins dw 60d
	SIXTYSQU dw 3600d
	
	newLine db 13, 10, '$'
	againPrompt db 'Would you like to go again? $'
	
	prompt db 'Enter your time in hours minutes and seconds: $'
	print1 db 'Your time is: $'
	secondsPrint db ' seconds $'
	minutesPrint db ' minutes $'
	hoursPrint db ' hours $'
	andPrint db 'and $'
	orPrint db 'or $'
	
.code
Time	PROC
_Begin
top:sPutStr newLine
	mov hours, 0
	mov minutes, 0
	mov seconds, 0
	mov totalSecs, 0 
	
	_PutStr prompt 
	Call GetDec
	mul SIXTYSQU 
	add totalSecs, ax 
	
	Call GetDec 
	mul SIXTY 
	add totalSecs, ax 

	Call GetDec 
	add totalSecs, ax 
	
	sPutStr newLine
	sPutStr print1
	mov ax, totalSecs
	Call PUTUDEC
	sPutStr secondsPrint
	sPutStr orPrint
	sPutStr newLine
	
	mov ax, totalSecs
	div toMins 
	Call PUTUDEC
	sPutStr minutesPrint  
	sPutStr andPrint
	mov minutes, ax 
	mov seconds, dx 
	mov ax, dx 
	Call PUTUDEC
	sPutStr secondsPrint 
	sPutStr orPrint
	sPutStr newLine
	
	mov ax, minutes 
	div SIXTY
	mov ch, ah 
	xor ah, ah 
	Call PUTUDEC 
	sPutStr hoursPrint
	mov al, ch 
	Call PUTUDEC
	sPutStr minutesPrint 
	sPutStr andPrint
	xor ax, ax 
	mov ax, seconds 
	Call PUTUDEC
	_PutStr secondsPrint 
	
  again:
	_PutStr newLine
	sPutStr againPrompt
	_GetCh
	and al, 11011111b
	cmp al, 59h			;compare to Y
	je top
	cmp al, 4Eh			;compare to N
	je finish
	jmp again
	
finish:

_Exit 0

Time ENDP
END Time 