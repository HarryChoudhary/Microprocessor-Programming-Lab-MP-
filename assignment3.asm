;NAME-Harish choudhary
;roll no-SECOA121
;ASSIGNMENT 3 -Write X86/64 ALP to convert 4-digit Hex number into its equivalent BCD number and 5-digit
		;BCD number into its equivalent HEX number. Make your program user friendly to accept the
			;choice from user for:
			;(a) HEX to BCD b) BCD to HEX (c) EXIT.
;______________________________________________________________________________________________________________________
;______________________________________________________________________________________________________________________
%macro print 2
	mov rax,1	;id of syswrite
	mov rdi,1	;file description
	mov rsi,%1	;address buffer
	mov rdx,%2	
	syscall
%endmacro
;__________________________________________
%macro read 2
	mov rax,0	;id of sysread
	mov rdi,0	;file description
	mov rsi,%1	;address buffer
	mov rdx,%2	;length of size
	syscall
%endmacro
;___________________________________________


%macro exit 0
	mov rax,60
	mov rdi,0
	syscall
%endmacro
;_________________________________________
section .data

	nline db 10
	nline_len equ $-nline

	ano db 10,"             ...........ASSIGNMENT 3........             "
	db 10,"             .. HEX TO BCD AND BCD TO HEX..             "
	db 10, " ..........................................................."           
	ano_len equ $-ano

	menu db 10,"    1.HEX TO BCD       "
	   db 10,  "    2. BCD TO HEX      "
	   db 10,  "    3. EXIT              "
 	db   10,   "      Enter yourchoice     "
	menu_len equ $-menu

	hmsg  db 10,"  Enter 4 digit  hex number  "
	hmsg_len equ $-hmsg

	bmsg  db 10,"  Enter 5 digit bcd number  "
	bmsg_len equ $-bmsg

	ebmsg db 10," equivalent bcd number "	
	ebmsg_len equ $-ebmsg

 	ehmsg db 10, " equivalent hex number "
	ehmsg_len equ $-ehmsg

	emsg  db 10, "	INVALID CHOICE"
	emsg_len equ $-emsg
	
	emsg1 db 10,"	INVALID INPUT"
	emsg1_len equ $-emsg1
;______________________________________________________________

section .bss
	buf resb 6
	char_ans resb 6
;______________________________________________________________
section .text
	global _start:
	_start:

menu1:	print ano,ano_len
	print menu,menu_len
	read buf,2		;reading choice with enter =2value(1for choice and 1 for enter)
	mov al,[buf]		; moving buffer choice in acumulator

c1:	cmp al ,'1'		 ; if al =1 call hex to bcd and jump to menu else jump c2
	jne c2			
	call hex_bcd			;calling hex to bcd func
	jmp menu1


c2:
	cmp al ,'2'		 ; if al =2 call bcd to hex and jump to menu else jump c3
	jne c3
	call bcd_hex	
	jmp menu1

c3:
	cmp al ,'3'		 ; if al =3 exit  else jump invalid	
	jne invalid 		 ; jump to line no 96

exit


 invalid:
		print emsg,emsg_len
		jmp menu1

;________________________________________________________________


display:			;converting hex to ascii
	mov rbx,16		
	mov rcx,4
	mov rsi,char_ans+3
cnt:
	mov rdx,0
	div rbx 		;rdx(remainder)=rax(qoutient)/rbx(value)
	cmp dl,09h 
	jbe add30
	add dl,07h
add30:
	add dl,30h
	mov [rsi],dl
	dec rsi 
	dec rcx ;decrement count
	jnz cnt ;till count isnot equal to 0
	print char_ans,4
ret
;____________________________________________________________

accept:				;converting ascii to hex
	read buf,5		;input 4 numbers and one enter=5
	mov rcx,4		;counter =4
	mov rsi,buf		
	xor bx,bx 		;refreshing bx register to 0

next_byte:
	shl bx,4 		; left shift bx register by 4 byte
	mov al,[rsi] 		;rsi pointer pointing to al
	

	cmp al,'0'
	jb error		;jb jump below to error actually means less than 48(above 48 ex 47,46) refer ascii chart  
	cmp al,'9'
	jbe sub30		;jump if below and equal means 9 or less than 9(such as 8,7 etc) refer ascii chart
 	
	cmp al,'A'
	jb error		;jb jump below to error actually means less than 65(above 65 ex 64,63) refer ascii chart  
	cmp al,'F'
	jbe sub37		;jump if below and equal means F or less than F(such as E,D etc) refer ascii chart

	cmp al,'a'
	jb  error		;jb jump below to error actually means less than 97(above 97 ex 96,95) refer ascii chart  
	cmp al,'f'
	jbe sub57		;jump if below and equal means f or less than f(such as e,d etc) refer ascii chart

error:
	print emsg,emsg_len
	exit

	sub57: sub al,20h 	; subtracting 57 means 1st- 20h ,2nd- 07h ,3rd-   30h subtracting(line no 155,156,157)
	sub37: sub al,07h 	;subtracting 37h means 1st -07, 2nd -30h subtracting(line no 156,157)
	sub30: sub al,30h   	;subtracting 30h means 1st -30h subtracting(line no 157)
				;after subtracting any oof onne jumping to line 159 for add bx(register) and ax(accumulator)
	add bx ,ax
	inc rsi 		; increment rsi pointer
	dec rcx 		;decrement rcx counter
	jnz next_byte		; jump if not zero to next_byte
ret
;_____________________________________

;__________________________________________
 hex_bcd:
	print hmsg,hmsg_len	;print Enter 4 digit  hex number
	call accept		;converting ascii to hex
	mov ax,bx 		;move value of accept(hex value) from bx to ax
	mov bx,10		; store bx register with 10
	xor bp,bp		;refresh bp to 0

back:
	xor dx,dx 		;refresh dx to 0
	div bx			; divide ax by 10(10 is stored in bx) dx will store =remainder,ax will store =quotient
	push dx			 ; push dx value on stack
	inc bp 			; increment bp 
	cmp ax,0
	jne back 		; jump ifnot equal
	print ebmsg,ebmsg_len	; print  equivalent bcd number


back1: 				; convert back bcd number to ascii for printing

	pop dx 			; pop stack element and store on dx register
	add dx,30h 		; add 30h to dl and store value in dl
	mov [char_ans],dx
	print char_ans ,1
	dec bp
	jnz back1 
ret
;______________________________________________________
bcd_hex:
	print bmsg,bmsg_len	;print  Enter 5 digit bcd number
	read buf,6
	mov rsi,buf
	xor ax,ax		;refresh ax to =0
	mov rbp,5		;initialize base pointer=5
	mov rbx,10		;store 10 in rbx register
next:
	xor cx,cx		;referesh cx to =0
	mul bx			;multiply bx with ax=(ax)*(bx)=0*10h [and store valueibn ax register]
	mov cl,[rsi]		;store rsi value in cl register
	sub cl,30h		; convert ascii to hex by subtracitn 30 (no need to write accept function)(reading only bcd number) 
	add ax,cx		;add ax and cx(but ax=ax*bx) ==[ax=ax*bx+cx] store value in ax register
	inc rsi			;increment rsi pointer	
	dec bp			;decrement base pointer	
	jnz next		;jump if not zero to next
			
	mov [char_ans],ax	;move ax value to char ans because  printing ehmsg were macro contains ax register it may overwrite
	print ehmsg,ehmsg_len	; print	 equivalent hex number
	mov ax,[char_ans]	;afterprinting again move charans value into ax register
	call display		; call display function for converting hex to ascii
ret

;____________________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________________
;_______________________________________________________________________________________________________________________________________


;		OUTPUT:


;  ...........ASSIGNMENT 3........             
 ;            .. HEX TO BCD AND BCD TO HEX..             
; ...........................................................
;    1.HEX TO BCD       
;    2. BCD TO HEX      
;    3. EXIT              
 ;     Enter yourchoice     1

 ; Enter 4 digit  hex number  00ff

; equivalent bcd number 255
 ;            ...........ASSIGNMENT 3........             
 ;            .. HEX TO BCD AND BCD TO HEX..             
; ...........................................................
;    1.HEX TO BCD       
;    2. BCD TO HEX      
;    3. EXIT              
;      Enter yourchoice     2

;  Enter 5 digit bcd number  00255

; equivalent hex number 00FF
 ;            ...........ASSIGNMENT 3........             
;             .. HEX TO BCD AND BCD TO HEX..             
; ...........................................................
;    1.HEX TO BCD       
;    2. BCD TO HEX      
;    3. EXIT              
;      Enter yourchoice     3


;_______________________________________________________________________-















