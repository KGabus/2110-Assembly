INCLUDE PCMAC.INC

.model small
.586
.stack 100h
.data
	prompt DB 'Please enter your password: $'
	goodPass DB 'Your password is secure.', 13, 10, '$'
	noLow DB 'Your password lacks a lowercase character.', 13, 10, '$'
	noUp  DB 'Your password lacks an uppercase character.', 13, 10, '$'
	noNum DB 'Your password lacks a numerical value.', 13, 10, '$'
	noSym DB 'Your password lacks a special character.', 13, 10, '$'
	tooShort DB 'Your password is too short.', 13,10, '$'
	tooLong  DB 'Your password is too long.', 13, 10, '$'
	invalidChar DB 'You have entered an invalid character.', 13, 10, '$'
	goAgain	 DB 'Would you like to enter another password?', 13, 10, '$'
	newLine	 DB 13, 10, '$'
	
	hasLow	 DB 0
	hasUp	 DB 0
	hasNum   DB 0
	hasSym   DB 0
	reqCount  DB 0
	
.code
Password   PROC

_Begin
	
main_loop: sPutStr newLine

	xor cx, cx					;clear counters for next password
	mov hasLow, 0
	mov hasUp, 0 
	mov hasNum, 0
	mov hasSym, 0 
	mov reqCount, 0 
	
	sPutStr prompt				;prompt user for password
next_char: _GetCh noEcho
	xor ah, ah
	cmp al, 0Dh
	jne lowercase				;if the enter key wan't pushed, check for the various types of characters
	sPutStr newLine
	cmp cx, 8d					;check length of valid characters
	jb tooFew					
	cmp cx, 20d
	ja tooMany
	inc reqCount				;only increments if cx was between 8 and 20
checkLow:
	XOR cx,cx					;reset cx so it can be used to count the filled reqirements
	cmp hasLow, 0				;outputs specific error messages
	jne hasLC
	sPutStr noLow				
checkUp: 
	cmp hasUp, 0
	jne hasUC
	sPutStr noUp
checkNum: 
	cmp hasNum, 0
	jne hasNumber
	sPutStr noNum
checkSym: 
	cmp hasSym, 0
	jne hasSymbol
	sPutStr noSym
checkReqs: 
	cmp reqCount, 5
	jl again
	sPutStr goodPass
	jmp again
	
again: sPutStr goAgain
	_GetCh
	and al, 11011111b			;makes the character uppercase
	cmp al, 59h					;compare to Y
	je main_loop
	cmp al, 4Eh					;compare to N
	je finish
	sPutStr newLine
	jmp again
	
finish:	
_Exit 0
	
	
hasSymbol: inc reqCount			
	jmp checkReqs
hasNumber: inc reqCount
	jmp checkSym
hasUC: inc reqCount
	jmp checkNum
hasLC: inc reqCount
	jmp checkUp
tooMany: sPutStr tooLong		;tell the user their password is too long
	jmp checkLow
tooFew: sPutStr tooShort		;tell the user their password is too short	
	jmp checkLow
	
lowercase: cmp al, 'a'			;check for lower case letter
	jb uppercase
	cmp al, 'z'
	ja invalid
	inc hasLow						 
	_PutCh '*'
	inc cx						;used to count characters
	jmp next_char				;character was a lowercase letter, get next character
	
uppercase: cmp al, 'A'
	jb number
	cmp al, 'Z'
	ja invalid
	inc hasUp
	_PutCh '*'
	inc cx
	jmp next_char				;character was an uppercase letter, get next character
	
number: cmp al, 30h
	jb symbol
	cmp al, 39h
	ja invalid
	inc hasNum
	_PutCh '*'
	inc cx
	jmp next_char				;character was a number
	
symbol: cmp al, 3Ah
	jb symbol2
	cmp al, 40h 
	ja invalid
	inc hasSym
	_PutCh '*'
	inc cx
	jmp next_char				;character was a symbol 
	
symbol2: cmp al, 20h
	jb invalid
	cmp al, 2Fh
	ja invalid
	inc hasSym
	_PutCh '*'
	inc cx
	jmp next_char				;character was a symbol
	
invalid: 
	sPutStr newLine
	sPutStr invalidChar			;invalid character was entered
	jmp again

Password ENDP
END Password