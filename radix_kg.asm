Include PCMAC.INC 

.model small
.586
.stack 100h
.data
	MAXNUM equ 10
	GetInputString db MAXNUM
	charCount db ?
	inputString  db MAXNUM DUP ('$')
	
	RadStrLength db 1 
	
	ir dw 0				;input radix
	ot dw 0				;output radix 
	opA dw ?			;operand A
	opB dw ?			;operand B
	
	isOpNeg db ? 
	result dw ?
	quot dw ?
	rem dw ?
	
	TEN dw 10
	
	
	newLine	 db 13, 10, '$'
	againPrompt db 'Would you like to go again? $'
	negSign db '-$'
	again db 'Try again: $'
	invalidStr  db 'Invalid Character', 13, 10, '$'
	invalidRadix db 'Invalid Radix entered. Please enter a radix between 2 and 35.', 13, 10, '$'
	invalidRadChar db 'You have entered a character that is not valid within your input radix.', 13, 10,
					  'Press "R" to enter a new radix or "X" to quit: $'
	
	letterString db '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
	
	radixString db 35 DUP ('$')
	
	promptInRad db 'Enter your input radix: $' 
	promptOutRad db 'In what radix would you like your answer? $'
	promptOpA db 'Enter your first operand: $'
	promptOpB db 'Enter your second operand: $'
	out1 db '	Output Radix: $'
	out2 db '	Decimal: $'
	
	addStr db 'A+B= $'
	subString db 'A-B= $'
	mulStr db 'A*B= $'
	divStr db 'A/B= $'
	powStr db 'A^B= $'
	opBis0 db 'Division by zero is not a thing.$'
	remainder db ' remainder $'
	
	
.code
Radix	PROC
	_Begin
	Call main 
Radix ENDP

main PROC	
  top:
	mov opA, 0 
	mov opB, 0 
	_PutStr newLine
	_PutStr promptInRad
	Call getNumber
	mov ir, bx 
	Call validRadixCheck
	Call radixStringGen
	_PutStr promptOutRad
	Call getNumber 
	mov ot, bx 
	Call validRadixCheck

	sPutStr promptOpA
	Call getOperand
	mov opA, bx 
	sPutStr promptOpB
	Call getOperand 
	mov opB, bx 
	
	add bx, opA 			;add 
	mov result, bx 
	sPutStr addStr
	sPutStr newLine
	sPutStr out1 
	mov bx, ot 
	Call printNumber
	sPutStr out2 
	mov bx, TEN
	Call printNumber
	_PutStr newLine
	
	mov ax, opA 			;subtract
	sub ax, opB
	mov result, ax 
	sPutStr subString
	sPutStr newLine
	sPutStr out1 
	mov bx, ot 
	Call printNumber
	sPutStr out2 
	mov bx, TEN
	Call printNumber
	_PutStr newLine
	
	mov ax, opA				;multiply 
	imul opB 
	mov result, ax 
	sPutStr mulStr
	sPutStr newLine
	sPutStr out1 
	mov bx, ot 
	Call printNumber
	sPutStr out2 
	mov bx, TEN
	Call printNumber
	_PutStr newLine
	
	xor dx, dx				;divide 
	mov ax, opA
	cmp opB, 0 
	jne divide
	_PutStr opBis0
	
  divide:  
	cmp ax, 0 
	jl divide2
	idiv opB 
	mov result, ax
	mov quot, ax 
	mov rem, dx 
	jmp printdiv
	
  divide2:
	neg ax 
	cmp bx, 0 
	jl divide3
	idiv opB
	neg ax 
	mov result, ax
	mov quot, ax 
	mov rem, dx 
	jmp printdiv 					
	
  divide3:
	neg opB
	div opB
	mov result, ax 
	mov quot, ax 
	mov rem, dx 
	
	
  printdiv:
	sPutStr divStr
	sPutStr newLine
	sPutStr out1 
	mov bx, ot 
	Call printNumber
	sPutStr remainder
	mov ax, rem 
	mov result, ax  
	Call printNumber
	sPutStr out2 
	mov bx, TEN
	mov ax, quot 
	mov result, ax  
	Call printNumber
	sPutStr remainder
	mov ax, rem 
	mov result, ax 
	Call printNumber
	_PutStr newLine
	
	cmp opB, 0 						;exponent 
	jg exp 
	jl negExp
	_PutStr powStr
	_PutStr newLine
	_PutStr out1
	_PutCh '1'
	_PutStr out2
	_PutCh '1'
	
	xor cx, cx  
	xor dx, dx 
	
  negExp:
	neg opB 
  exp:
	mov cx, opB
	mov ax, 1
  expLoop:
	mul opA 
	dec cx 
	cmp cx, 0 
	jne expLoop
	
  expPrint:
	mov result, ax 
	mov bx, ot 
	sPutStr powStr
	sPutStr newLine
	sPutStr out1 
	Call printNumber
	mov bx, TEN 
	sPutStr out2
	Call printNumber
	
	_PutStr newLine
	_PutStr newLine
	_PutStr newLine

  goAgain:
	sPutStr againPrompt
	_GetCh
	and al, 11011111b
	cmp al, 59h			;compare to Y
	je top 
	cmp al, 4Eh			;compare to N
	je finish
	sPutStr newLine
	jmp goAgain
  finish:
	_Exit 0

main ENDP

validityCheck PROC 			;checks for numbers and letters 
	cmp al, 30h
	jl invalid
	cmp al, 39h
	jle endvc 
	cmp al, 41h
	jl invalid 
	cmp al, 5Ah
	jle endvc 
	cmp al, 61h
	jl invalid 
	cmp al, 7Ah
	jle endvc
	cmp al, 2Dh
	je endvc 
	
  invalid:
	_PutStr newLine
    _PutStr invalidStr
	jmp main 
  
  endvc:
	ret 
validityCheck ENDP 

validRadixCheck PROC
	cmp bx, 0 
	jne check 
	cmp ir, 0 
	jle invalidRad
	ret 
  check:
	cmp bx, 2
	jl invalidRad 
	cmp bx, 35 
	jg invalidRad  
	ret
  
  invalidRad:
	cmp bx, 28h
	je quit
	cmp bx, 48h
	je quit 
	_PutStr invalidRadix
	jmp main 
	
  quit: _Exit 0 	
	
	ret 
validRadixCheck ENDP
	
validWithinRadix PROC
	xor cx, cx 
	mov si, offset radixString
	sub si, 1 
	mov cl, RadStrLength				
  f1loop:
	cmp al, 39h
	jle mainLoop
	and al, 11011111b
   mainLoop:
	cmp al, [si]
	je done 
	dec cl
	inc si
	jcxz notFound
	jmp f1loop
	
  notFound:
	_PutStr newLine
	_PutStr InvalidRadChar
  loopNF:	
	_GetCh
	sPutStr newLine
	and al, 11011111b
	cmp al, 58h
	je quit1 
	cmp al, 52h
	je main
	_PutStr newLine
	_PutStr invalidStr
	_PutStr again 
	jmp loopNF
	
  quit1: _Exit 0 
  done:
	ret
validWithinRadix ENDP

getOperand PROC 				;gets operand in input radix Number is in bx.
	xor bx, bx 
  opLoop:
	_GetCh
	cmp al, 2Dh 
	je negative
	cmp al, 0Dh
	je endLoop
	call validWithinRadix 
	cmp al, 39h 
	jg letter  
  number:
	sub al, 30h
	jmp math 
  letter:
	and al, 11011111b  ;captalize
	sub al, 37h
  math:
    CBW
	xchg ax, bx
	mul ir
	add ax, bx 
	mov bx, ax 
	jmp opLoop
  
  negative:
	mov isOpNeg, 1
	jmp opLoop
  
  endLoop:
	cmp isOpNeg, 1 
	jne opDone 
	neg bx 
	
  opDone:
	mov isOpNeg, 0 
	sPutStr newLine
	ret
getOperand ENDP
	
radixStringGen PROC
	mov si, offset letterString
	mov di, offset radixString
	sub si, 1
	sub di, 1 
	xor cx, cx 
	mov cx, ir 
	add cx, 1
	
  copyString:
	mov al, [si]
	mov [di], al
	inc si
	inc di
	inc RadStrLength
	dec cx 
	cmp cx, 0 
	jg copyString
	
	ret
radixStringGen ENDP 

getNumber PROC			;reads a decimal number from keyboard. Number is in bx. 
	xor bx, bx 

  loopTop: 
	_GetCh
	cmp al, 0Dh
	je endLoop1
	call validityCheck 
	cmp al, 31h
	sub al, 30h
	CBW
	xchg ax, bx
	mul TEN
	add ax, bx 
	mov bx, ax 
	jmp loopTop
  endLoop1:
	sPutStr newLine
	ret
getNumber ENDP

printNumber PROC		;prints a number to the screen in any desired radix. Put radix in bx before call 
	pusha
	xor cx, cx 
	mov ax, result  
	cmp ax, 0 
	jge printLoop
	sPutCh '-'
	neg ax
	
  printLoop:
	xor dx, dx 
	div bx 
	push dx 
	inc cx 
	cmp ax, 0 
	jnz printLoop
	
  pop_lb:
	pop dx 
	cmp dx, 9
	jle keepGoing
	add dx, 7 
  keepGoing:
	add dx, 30h 
	mov ah, 02h
	int 21h
	dec cx 
	jcxz printed 
	jmp pop_lb 
  printed:
	popa
	ret 
printNumber ENDP 

END Radix