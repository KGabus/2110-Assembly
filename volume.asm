.model small

EXTRN GETDEC:NEAR
EXTRN PUTUDEC:NEAR

.586
.stack 100h
.data
	Prompt 		DB "Please Enter (in feet and inches):"
	Prompt1		DB 13,10, "Length > $"
	Prompt2 	DB 13, 10, "Width > $"
	Prompt3 	DB 13, 10, "Height > $"
	Message 	DB 13,10, "Your Volume is $"
	Message2 	DB " cu. in. or $"
	Message3 	DB " cu. ft. and $"
	Message4 	DB " cu. in. $"
	twelve  	DW 12
	toFeet		DW 1728
	dim1		DW ?
	dim2		DW ?
	dim3		DW ? 
	vol			DD ?
	vol2		DD ?
	
.code
Volume		PROC						
		mov	ax, @DATA
		mov ds, ax
		mov dx, OFFSET Prompt		;prints 
		mov	ah, 09h					;the
		int 21h						;prompt
		;mov dx, OFFSET Prompt1
		;int 21h
		
		call GETDEC
		;mov	al, ax
		mul twelve
		mov dim1, ax
		call GETDEC
		CWD
		add dim1, ax
		
		mov dx, OFFSET Prompt2		;ask
		mov ah, 09h					;for
		int 21h						;width
		call GETDEC
		;mov al, ah
		mul twelve
		mov dim2, ax
		call GETDEC
		CWD
		add dim2, ax
		
		mov dx, OFFSET Prompt3		;ask
		mov ah, 09h					;for
		int 21h						;height
		call GETDEC
		;mov al, ax
		mul twelve
		mov dim3, ax
		call GETDEC
		CWD
		add dim3, ax
		                            ;calculate the volume
		mov ax, dim3
		mul dim2
		mov vol, edx
		mov eax, vol 
		;mov al, ax
		mul dim1
		mov vol, edx
		mov dx, OFFSET Message		;print 
		mov ah, 09h					;first
		int 21h						;message
		mov eax, vol
		call PUTUDEC									;should output volume in cubic inches
		mov dx, OFFSET Message2		;print 
		mov ah, 09h					;second
		int 21h						;message
		mov eax, vol
		div toFeet
		mov vol, eax
		call PUTUDEC                                     ;output volume in cubic feet
		mov dx, OFFSET Message3		;print 
		mov ah, 09h					;third
		int 21h						;message
		mov vol, edx
		mov eax, vol
		call PUTUDEC									 ;with remainder in cubic inches
		;mov ax, ah
		mov dx, OFFSET Message4		;print 
		mov ah, 09h					;fourth
		int 21h						;message

Volume		ENDP
END Volume