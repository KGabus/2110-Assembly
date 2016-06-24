;Strings Project
INCLUDE PCMAC.INC

EXTRN GETDEC:NEAR
EXTRN PUTUDEC:NEAR

.model small
.586
.stack 100h
.data
	canUndo db 0
	userEntry db ?
	MAXCHAR equ 51
	GetInputString db MAXCHAR
	charCount db ?
	inputString  db MAXCHAR DUP ('$')
	previous db MAXCHAR DUP ('$')
	MAXNUM equ 3
	GetFunct db MAXNUM
	numCount db ?
	functNum db MAXNUM DUP ('$')
	TEN db 10
	newLine	 db 13, 10, '$'
	prompt db 'Please enter a string no more than 50 characters.', 13, 10, '$'
	select db 'Please select a function.', 13, 10, 'Function: $'
	invalidEntry db 'Invalid Entry.', 13, 10, '$'
	
	f1prompt  db 'Enter a character: $'
	f1prompt1 db 'The first "$'
	f1prompt2 db '" is located in position $'
	f1prompt3 db ' of the string:', 13, 10, '$'
	f1prompt4 db 'The entered character is not in the string: ', 13, 10, '$'
	f2prompt  db 'Enter a character: $'
	f2prompt1 db 'The character "$'
	f2prompt2 db '" appears $'
	f2prompt3 db ' times in the string: $'
	f3prompt1 db 'The string has a length of $'
	f4prompt1 db 'There are $'
	f4prompt2 db ' characters in the string: $'
	f5prompt1 db 'Character to replace: $'
	f5prompt2 db 'New character: $'
	f5prompt3 db 'After character replacement, your string is: $'
	f6prompt1 db 'Capalitizing each letter of: ', 13, 10, '$'
	f6prompt2 db 'yeilds: ', 13,10,'$'
	f7prompt1 db 'De-Capalitizing each letter of: ', 13, 10, '$'
	f7prompt2 db 'yeilds: ', 13,10,'$'
	f8prompt1 db 'Toggling the case of each letter of the string: ', 13, 10, '$'
	f8prompt2 db 'yeilds: ', 13,10,'$'
	f9prompt  db 'New string: $'
	f10prompt db 'The string has been restored to: $'
	f10prompt1 db 'Error: Either you have just selected this function or have yet to enter and modify a string.', 13, 10, '$'
	f0prompt  db 'The program has been exited.$'
	
	menu  db 'Function 1: Determine the location of the first occurence of user entered character in the string.', 13, 10,  
			 'Function 2: Find the number of occurences of a user entered character in the string.', 13, 10, '$'
	menu2 db 'Function 3: Find the length of the string.', 13, 10,
			 'Function 4: Find the number of characters in the string.', 13, 10, '$'
	menu3 db 'Function 5: Replace all occurences of user entered character with another user entered character.', 13, 10,
			 'Function 6: Capalitize all the letters in the string.', 13, 10, '$'
	menu4 db 'Function 7: Make each letter of the string lower case.', 13, 10,
			 'Function 8: Toggle the case of each letter.', 13, 10, '$'
	menu5 db 'Function 9: Input a new string.', 13, 10, 
	         'Function 10: Undo the last modification to the string.', 13, 10, '$'
 	menu6 db 'Function 100: Output the menu.', 13, 10,
			 'Function 0: Exit the program.', 13, 10, '$'
			
.code
Main	PROC
	_Begin
	_PutStr prompt
	_GetStr GetInputString
	_PutCh 10
	
	mov si, offset inputString
	mov di, offset previous 
	sub si, 1
	sub di, 1 
	mov cl, charCount
	
  copyString:
	mov al, byte [si]
	mov byte [di], al
	inc si
	inc di
	dec cx 
	cmp cx, 0
	jg copyString
	sPutStr newLine
	sPutStr menu
	sPutStr menu2
	sPutStr menu3
	sPutStr menu4
	sPutStr menu5
	sPutStr menu6
	
MainLoop:
	_PutStr newLine
	_PutStr select
	xor ax, ax
	xor bx, bx 
	
  inputLoop:
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
	
  functions:
	sPutStr newLine 
	cmp bx, 0
	je Function0
	cmp bx, 1
	je Function1
	cmp bx, 2
	je Function2
	cmp bx, 3 
	je Function3
	cmp bx, 4
	je Function4
	cmp bx, 9
	je Function9
	cmp bx, 10d
	je Function10
	cmp bx, 100d
	je Function100
	
duplicate:
	mov si, offset inputString
	mov di, offset previous 
	sub si, 1
	sub di, 1 
	mov cl, charCount
	
  copyString1:
	mov al, byte [si]
	mov byte [di], al
	inc si
	inc di
	dec cx 
	cmp cx, 0
	jg copyString1

	cmp bx, 5 
	je Function5
	cmp bx, 6
	je Function6
	cmp bx, 7
	je Function7
	cmp bx, 8
	je Function8
	
invalid:
	_PutStr newLine
	_PutStr invalidEntry	
	jmp Function100

Function1: ;find first occurence of user entered search term. 0 indexed
	_PutStr f1prompt
	_GetCh
	sPutStr newLine
	mov bx, 0 						;position counter
	mov si, offset inputString
	sub si, 1 
	mov cl, charCount				;prevents unnecessary looping
  f1loop:
	cmp al, byte [si]
	je f1print
	dec cl
	inc si
	inc bx
	jcxz f1done
	jmp f1loop
  
  f1print:
	sPutStr f1prompt1
	mov userEntry, al
	sPutCh userEntry
	sPutStr f1prompt2
	mov ax, bx
	call PUTUDEC
	_PutStr f1prompt3
	_PutStr inputString
	_PutStr newLine
	jmp MainLoop
	
  f1done:							;character isn't in string 
	_PutStr f1prompt4
	_PutStr inputString
	_PutStr newLine
	jmp MainLoop

Function2: ;find the number of time a user entered letter is in the string
	_PutStr f2prompt
	_GetCh 
	sPutStr newLine
	xor ah, ah 
	xor bx, bx
	mov si, offset inputString
	sub si, 1 
	mov cl, charCount
  f2loop:
	cmp al, byte [si]
	je increment
	dec cl
	inc si
	jcxz f2done
	jmp f2loop
	
  increment:
	inc bx
	dec cl
	inc si
	jcxz f2done
	jmp f2loop
	
  f2done:
	mov userEntry, al
	_PutStr f2prompt1
	_PutCh userEntry
	_PutStr f2prompt2
	mov ax, bx
	call PUTUDEC
	_PutStr f2prompt3
	_PutStr inputString
	_PutStr newLine
	jmp MainLoop
 	
Function3: 	;outputs total string length
	_PutStr f3prompt1
	xor ax, ax
	mov al, charCount
	call PUTUDEC
	_PutStr newLine
	jmp MainLoop
	
Function4: ;find number of characters (spaces, letters, numbers)
	_PutStr f4prompt1
	xor ah, ah 
	xor bx, bx
	mov si, offset inputString
	sub si, 2 
	mov cl, charCount
  f4loop:
	inc si
	jcxz f4done
	dec cx
	mov dl, byte [si]
    cmp dl, 20h
	je increase
	cmp dl, 'z'
	jg f4loop
	cmp dl, 'a'
	jge increase 
	cmp dl, 'Z'
	jg f4loop
	cmp dl, 'A'
	jge increase
	cmp dl, '9'
	jg f4loop
	cmp dl, '0'
	jge increase
	jmp f4loop
	
  increase:
	inc bx
	jmp f4loop
	
  f4done:
	mov ax, bx
	call PUTUDEC
	_PutStr f4prompt2
	_PutStr inputString
	_PutStr newLine
	jmp MainLoop
	

Function5: ;gets two symbols from user. swaps sym 1 for sym 2. case sensitive
	mov canUndo, 1
	_PutStr f5prompt1
	_GetCh 
	mov dl, al
	sPutStr newLine
	sPutStr f5prompt2
	xor ax, ax
	_GetCh
	sPutStr newLine
	mov si, offset inputString
	sub si, 1 
	mov cl, charCount
  f5loop:
	cmp dl, byte [si]
	je swap 
	dec cl
	inc si
	jcxz f5done
	jmp f5loop
	
  swap:
	mov byte [si], al
	dec cl
	inc si 
	jcxz f5done
	jmp f5loop
	
  f5done:
	_PutStr f5prompt3
	_PutStr inputString
	_PutStr newLine
	jmp MainLoop
	
Function6: ;capitalize the string
	mov canUndo, 1
	_PutStr f6prompt1
	_PutStr inputString
	_PutStr newLine
	_PutStr f6prompt2
	mov si, offset inputString
	sub si, 2
	mov cl, charCount
  f6loop:
	jcxz f6done 
	dec cx 
	inc si
	mov al, byte [si]
	cmp al, 'a'
	jb f6loop
	cmp al, 'z'
	ja f6loop
	and al, 11011111b
	mov byte [si], al 
	jmp f6loop
	
  f6done:
	_PutStr inputString
	_PutStr newLine
	jmp MainLoop

Function7: ;uncapitalize the string
	mov canUndo, 1
	_PutStr f7prompt1
	_PutStr inputString
	_PutStr newLine
	_PutStr f7prompt2
	mov si, offset inputString
	sub si, 2
	mov cl, charCount
	
  f7loop:
	jcxz f7done 
	dec cx 
	inc si
	mov al, byte [si]
	cmp al, 'A'
	jb f7loop
	cmp al, 'Z'
	ja f7loop
	or al, 00100000b
	mov byte [si], al 
	jmp f7loop
	
  f7done:
	_PutStr inputString
	_PutStr newLine
	jmp MainLoop

Function8: ;toggle case
	mov canUndo, 1 
	_PutStr f8prompt1
	_PutStr inputString
	_PutStr newLine
	_PutStr f8prompt2
	mov si, offset inputString
	sub si, 2
	mov cl, charCount
  f8loop:
	jcxz f8done
	dec cx
	inc si
	mov al, byte [si]
	cmp al, 'A'
	jb f8loop
	cmp al, 'Z'
	ja lower
	or al, 00100000b
	mov byte [si], al
	jmp f8loop
   lower:
	cmp al, 'a'
	jb f8loop
	cmp al, 'z'
	ja f8loop
	and al, 11011111b
	mov byte [si], al
	jmp f8loop
	
  f8done:
	_PutStr inputString
	_PutStr newLine
	jmp MainLoop

Function9: ;input a new string, clear the old string first
	_PutStr f9prompt
	mov si, offset inputString
	mov di, offset previous
	sub si, 2 
	sub di, 2 
	mov cl, charCount
  f9loop:
	mov dl, byte [si]
	jcxz f9done
	mov byte [si], '$'
	mov byte [di], '$'
	inc si
	inc di 
	dec cx
	jmp f9loop
	
  f9done:
	_GetStr GetInputString
	_PutCh 10
	jmp MainLoop

Function10: ;bonus: undo last string modification
	cmp canUndo, 1
	jne f10done 
	mov si, offset inputString
	mov di, offset previous 
	sub si, 1
	sub di, 1 
	mov cl, charCount
	
  restoreString:
	mov al, byte [di]
	mov byte [si], al
	inc si
	inc di
	dec cx 
	cmp cx, 0
	jg restoreString
  
  f10print:
	mov canUndo, 0 
	_PutStr f10prompt
	_PutStr inputString
	_PutStr newLine
	jmp MainLoop
  
  f10done:
	mov canUndo, 0
	_PutStr f10prompt1
	jmp MainLoop
Function100:
	_PutStr menu
	_PutStr menu2
	_PutStr menu3
	_PutStr menu4
	_PutStr menu5
	_PutStr menu6
	jmp MainLoop
	
Function0:
	_PutStr newLine
	_PutStr f0prompt
	_Exit 0
	

Main ENDP
END Main