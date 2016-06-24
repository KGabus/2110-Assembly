Include PCMAC.INC 

.model small
.586
.stack 100h
.data
	MAXNUM equ 10
	GetInputString db MAXNUM
	charCount db ?
	inputString  db MAXNUM DUP ('$')
	
	newLine	 db 13, 10, '$'
	
	promptInRad db 'Enter your input radix: ' 
	promptOutRad db 'In what radix would you like your answer? '
	
.code
Radix	PROC
	_Begin
	_PutStr promptInRad
	call getNumber
	mov InRad, bx 
	
	












	mov ax, 4c00h
	int 21h


Name ENDP

getNumber PROC
	_GetCh
	cmp al, 0Dh
	je functions
	sub al, 30h
	CBW
	xchg ax, bx
	mul TEN
	add ax, bx 
	mov bx, ax 
	jmp inputLoop
	ret
getNumber ENDP	
	
	

END Radix