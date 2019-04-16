;ASSIGNMENT NO: 12
;ROLL NO.: SECOA121
;NAME: HARISH CHOUDHARY
;CLASS: SE
;DIV: A
;--------------------------------------------------------------------------
;Write a TSR program in 8086 ALP to implement Real Time Clock (RTC). 
;--------------------------------------------------------------------------
CODE SEGMENT
	;DECLARE ALL SEGMENT IN CS
	ASSUME	CS:CODE,DS:CODE,ES:CODE,SS:CODE  

	ORG	100H             ;PSP ADDRRESS IN MEMORY
BEGIN:
	JMP	INIT
	
	OFF1	DW 	?
	SEG1	DW 	?

	HR 	DB 	?
	MIN 	DB 	?
	SEC 	DB 	?
;---------------------------------------------
TEST1:
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	PUSH	DI
	PUSH	ES
	PUSH	SS

	MOV	AH,02 			;TAKING CURRENT TIME
	INT	1AH

	MOV	HR,CH
	MOV	MIN,CL
	MOV	SEC,DH

	MOV 	AX,0B800H 		;VIDEO RAM ADDREESS
	MOV	ES,AX
        MOV     BX,1992                 ;[ POSITION ON SCREEN TO DISPLAY 
					;  CURRENT TIME ATTRIBUTE]

	MOV	AL,HR
	CALL	DISP8
	CALL	COLON

	MOV 	AL,MIN
	CALL	DISP8
	CALL	COLON

	MOV 	AL,SEC
	CALL	DISP8

	POP	SS
	POP	ES
	POP	DI
	POP	SI
	POP	DX
	POP	CX
	POP	BX
	POP	AX

	JMP 	DWORD PTR CS:OFF1
;---------------------------------------------
DISP8 	PROC
	MOV 	CH,02H
	MOV 	CL,04H
BACK:
	ROL 	AL,CL
	MOV 	DL,AL
	AND 	DL,0FH
	ADD 	DL,30H
	MOV 	BYTE PTR ES:[BX],DL
	
	INC 	BX
	MOV 	BYTE PTR ES:[BX],11
	INC 	BX
	
	DEC 	CH
	JNZ 	BACK
	
	RET
DISP8 	ENDP
;---------------------------------------------
COLON 	PROC
     	MOV BYTE PTR ES:[BX],':'
     	INC BX
     	MOV BYTE PTR ES:[BX],13
     	INC BX
     	RET
COLON 	ENDP
;---------------------------------------------

INIT:
	PUSH 	CS
	POP 	DS

	MOV 	AX,0002			;CLEAR WHOLE SCREEN
	INT 	10H

	CLI

	MOV 	AH,35H  		;RETURN ADDRESS OF 08 INTRUPT FROM IVT  
	MOV 	AL,08H
	INT 	21H

	MOV 	WORD PTR OFF1,BX
	MOV 	WORD PTR SEG1,ES

	MOV 	AH,25H
	MOV 	AL,08H
	LEA 	DX,TEST1
	INT 	21H

	STI

	MOV 	AH,31H 			;MEMORY REQIRE FOR PROGRAM
	MOV 	AL,00			;(16 BYTE PER PARAGRAPH)
	LEA 	DX,INIT
	INT 	21H
;---------------------------------------------
	MOV 	AH,4CH
        MOV     AL,00H
	INT 	21H
CODE ENDS
	END BEGIN

