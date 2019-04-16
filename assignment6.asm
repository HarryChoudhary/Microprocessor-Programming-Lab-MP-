;NAME-Harish choudhary
;roll no-SECOA121
;ASSIGNMENT 6-.	Write X86/64 ALP to switch from real mode to protected mode and display the values of 
;		GDTR, LDTR, IDTR, TR and MSW Registers

;__________________________________________________________________________________________
%macro print 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro
;___________________________
%macro exit 0
	mov rax,60
	mov rbx,0
	syscall
%endmacro
;______________________________

section .data

	   ano db 10,"                    ASSIGNMENT 6-        ",10
	    db 10,"          .....................................",10
	    db 10,          "		Write X86/64 ALP to switch from real mode to protected mode	",10 
	    db 10,			"	and display the values of    ",10
	    db 10,			"	GDTR, LDTR, IDTR, TR and MSW Registers.",10
	    db 10,"          ...........................................",10
	ano_len equ $ -ano

	
	rmsg db 10,"       PROCESSOR IS IN REAL MODE	",10
        rmsg_len equ $ -rmsg
	
	pmsg db 10,"       PROCESSOR IS IN PROTECTED MODE    	",10
        pmsg_len equ $ -pmsg

        gmsg db "		GDTR CONTENTS	",10
     	gmsg_len equ $ -gmsg

     	imsg db 10,"	IDTR CONTENTS	",10
	imsg_len equ $ -imsg

	lmsg db 10,"       LDTR CONTENTS  	",10
        lmsg_len equ $ -lmsg

	tmsg db 10,"       TR CONTENTS    	",10
        tmsg_len equ $ -tmsg

	mmsg db 10,"       MSW CONTENTS  	",10
        mmsg_len equ $ -mmsg

	col db ":"
;___________________________________________________________

section .bss
	 GDTR resw 3					
	IDTR	resw 3			
	LDTR resw 1			
	TR resw 1
	MSW resw 1
	char_ans resb 4
;___________________________________________________________

section .text
global _start
_start:

	print ano,ano_len
		
	SMSW [MSW]			;store machine status word
	mov rax,[MSW]
	ror rax,1		;rotate to right to get lsb bit in carry flag by one
	jc p_mode		;JUMP IF CARRY=1 to p_mode
	print rmsg,rmsg_len
	jmp next


p_mode:
	print pmsg,pmsg_len
next:
	SGDT [GDTR]		
	SIDT [IDTR]
	SlDT [LDTR]
	STR [TR]
	SMSW [MSW]

	print gmsg,gmsg_len
	mov ax,[GDTR+4]
	call display
	mov ax,[GDTR+2]
	call display
	print col,1
	mov ax,[GDTR+0]
	call display
	
	print imsg,imsg_len
	mov ax,[IDTR+4]
	call display
	mov ax,[IDTR+2]
	call display
	print col,1
	mov ax,[IDTR+0]
	call display
	
	print lmsg,lmsg_len
	mov ax,[LDTR+0]
	call display
	
	print tmsg,tmsg_len
	mov ax,[TR+0]
	call display

	print mmsg,mmsg_len
	mov ax,[MSW+0]
	call display
	
	
exit
;__________________________________________________________________________	
	
display:				;converting hex to ascii
	mov rbx,16
	mov rcx,4
	mov rsi,char_ans+3
  cnt:
	mov rdx,0
	div rbx
	cmp dl,09h
	jbe add30
	add dl,07h
  add30:
	add dl,30h
	mov [rsi],dl
	dec rsi
	dec rcx
	jnz cnt
  print char_ans,4
ret
;_______________________________________________________________________________




;harish@harish-Inspiron-3551:~/Desktop/secoa121$ nasm -f elf64 assignment6.asm
;harish@harish-Inspiron-3551:~/Desktop/secoa121$ ld -o assignment6 assignment6.o
;harish@harish-Inspiron-3551:~/Desktop/secoa121$ ./assignment6

;output-
;
                    ASSIGNMENT 6-        

 ;         .....................................
;
		Write X86/64 ALP to switch from real mode to protected mode	
;
	and display the values of    

;	GDTR, LDTR, IDTR, TR and MSW Registers.

;          ...........................................

;       PROCESSOR IS IN PROTECTED MODE    	
		GDTR CONTENTS	
;3FD0C000:007F
;	IDTR CONTENTS	
;FF574000:0FFF
;       LDTR CONTENTS  	
;0000
;       TR CONTENTS    	
;0040
;      MSW CONTENTS 
;003B

;____________________________________________________________________-

