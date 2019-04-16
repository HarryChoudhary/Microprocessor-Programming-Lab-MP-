;multiplication using successive addition
;------------------------------------------------------



%macro print 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro read 2
	mov rax,0
	mov rdi,0
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro exit 0
	mov rax,60
	mov rdi,00
	syscall
%endmacro

;--------------------------------------------------
section .data
	msg db 10,"assignment no 4"
	msg_len equ $-msg
	
	menu db 10,"1.successive addition"
	     db 10,"2.add and shift"
	     db 10,"3.Exit"
 	menu_len equ $-menu

	smsg db 10,"multiplication using successive addition is "
	smsg_len equ $-smsg

	amsg db 10,"multiplication using shift and add is "
	amsg_len equ $-amsg

	n1msg db 10,"Enter 1st number(XXXX): "
	n1msg_len equ $-n1msg

	n2msg db 10,"Enter 2nd number(XXXX): "
	n2msg_len equ $-n2msg 

	emsg db 10,"invalid input"
	emsg_len equ $-emsg

;--------------------------------------------
section .bss
	buf resb 5
	n1 resw 1
	n2 resw 1
	ansl  resw 1
	ansh resw 1
	ans resd 1
	char_ans resb 8
;----------------------------------------------------------


section .text
	global _start
	_start:
		print msg,msg_len
		
	MENU:
		print menu,menu_len
		read buf,2
		mov al,[buf]

	c1:
		cmp al,'1'
		jne c2
		call succ_addition
		jmp MENU
	
	c2:
		cmp al,'2'
		jne c3
		call shift_and_add
		jmp MENU
		
	c3:
		cmp al,'3'
		jne invalid
		exit

	invalid:
		print emsg,emsg_len
		jmp MENU
;------------------------------------




	succ_addition:

		mov word[ansh],00
		mov word[ansl],00

		print n1msg,n1msg_len
		read buf,5
		call accept_16
		mov [n1],bx

		print n2msg,n2msg_len
		read buf,5
		call accept_16
		mov [n2],bx
		
		mov ax,[n1]
		mov cx,[n2]
		cmp cx,0
		je final

	back:
		add [ansl],ax
		jnc next
		inc word[ansh]
		
	next:
		dec cx
		jnz back

	final:
		print smsg,smsg_len
		mov ax,[ansh]
		call display_16

		mov ax,[ansl]
		call display_16
		ret
;--------------------------------------------





	shift_and_add:
		mov word[ansl],00
		mov word[ansh],00
	
		print n1msg,n1msg_len
		read buf,5
		call accept_16
		mov [n1],bx

		print n2msg,n2msg_len
		read buf,5
		call accept_16
		mov [n2],bx

		xor rax,rax
		xor rbx,rbx

		mov ax,[n1]
		mov bx,[n2]
		mov cx,16
		mov ebp,0

	back1:
		shl rbp,1
		shl ax,1
		jnc next1
		add ebp,ebx

	next1:
		dec cx
		jnz back1

		mov [ans],ebp
		print amsg,amsg_len
		mov eax,[ans]
		call display_32
;--------------------------------------------------


	
	accept_16:
		xor rbx,rbx
		mov rcx,4
		mov rsi,buf

	next_digit:
		shl bx,4
		mov al,[rsi]
		cmp al,'0'
		jb error
		cmp al,'9'
		jbe sub30

		cmp al,'A'
		jb error
		cmp al,'F'
		jbe sub37
		
		cmp al,'a'
		jb error
		cmp al,'f'
		jbe sub57
		
	error:
		print emsg,emsg_len
		exit

		sub57:sub al,20H
		sub37:sub al,07H
		sub30:sub al,30H
		
		add bx,ax
		inc rsi
		dec rcx
		jnz next_digit
		ret
;-----------------------------------------------
	display_16:
		mov rsi,char_ans+3
		mov rcx,4

	cnt:
		mov rdx,0
		mov rbx,16
		div rbx
		cmp dl,09H
		jbe add30
		add dl,07H

	add30:
		add dl,30H
		mov [rsi],dl
		dec rsi
		dec rcx
		jnz cnt
		print char_ans,4
		ret  
;---------------------------------------------
	display_32:
		mov rsi,char_ans+7
		mov rcx,8

	cnt1:
		mov rdx,0
		mov rbx,16
		div rbx
		cmp dl,09H
		jbe addd30
		add dl,07H

	addd30:
		add dl,30H
		mov [rsi],dl
		dec rsi
		dec rcx
		jnz cnt1
		print char_ans,8
		ret  
;--------------------------------------------

