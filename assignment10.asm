;NAME-Harish choudhary
;roll no-SECOA121
;MIL assignment 10 - Write a program to find the roots of the quadratic equation 
; a) Root 1 = [ -b + sqrt(b*b - 4ac) ]/2a
; b) Root 2 = [ -b - sqrt(b*b - 4ac) ]/2a
;_________________________________________________________________________________
section .data
	rmsg db 10,"Complex Roots (No Real Solutions) for a ,b and c values"
	rmsg_len equ $-rmsg

        msg1 db 10,"Real Solutions for the Roots are :"
	msglen1 equ $-msg1

	msg2 db 10,"Root1 : "
	msglen2 equ $-msg2

	msg3 db 10,"Root2 : "
	msglen3 equ $-msg3

        nline db 10,10
	nline_len equ $-nline

        dot db 10,"--------------------------------------------------------------------"
	dot_len equ $-dot



    a dd 1.00     	; a = 1
    b dd 8.00		; b = 8		
    c dd 15.00		; c = 15

  four dd 4.00		; four = 4
  two dd 2.00		; two = 2

  hdec dq 100		; hundred decimal(hdec) = 100
  point db "."


;--------------------------------------------------------------------------------------------------------------------------------		
section .bss
	
	resbuff resT 1    ; Ten words = 20 bytes (20 digits) 
	char_ans resB 2   ; 2 bytes = 2 digits
	disc resD 1   

;--------------------------------------------------------------------------------------------------------------------------------
%macro print 2			;macro for display
	mov rax,1 
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro read 2			;macro for input
	mov rax,0
	mov rdi,0
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro exit 0			;macro for exit
	mov rax,60
	xor rdi,rdi
	syscall
%endmacro
;---------------------------------------------------------------------------------------------------------------------------------
section .text
  global _start
  _start:
  
  finit				; initialise 80387 co-processor : st(0) = 0

  fld dword[b]			; stack of top i.e. st(0) = b

  fmul dword[b] 			; stack: st(0) = b*b
 
  fld dword[a]			; stack: st(0)= a , b*b

  fmul dword[c] 			; stack: st(0)= a*c , b*b

  fmul dword[four]		; stack: st(0)= 4*a*c , b*b
  
  fsub	 			; stack: st(0) = (b*b)-(4*a*c)

  ftst 				; compares ST0 and 0
     
  fstsw ax				;Stores the coprocessor status word into either a word in memory or the AX register

  sahf		            ;Stores the AH register into the FLAGS register.

  jb no_real_solutions 		; if disc < 0, No real solutions (Complex roots) otherwise Real solutions

  fsqrt 				; stack: st(0) = sqrt(b*b - 4*a*c)

  fst dword[disc] 		; store disc = st(0) i.e. sqrt(b*b - 4*a*c)

  fsub dword[b] 			; stack: st(0) = st(0)-b  i.e. (disc-b)

  fdiv dword[a] 			; stack: st(0) = (disc-b)/*a or (-b+disc)/a

  fdiv dword[two]      		 ; stack: st(0) = (disc-b)/2*a or (-b+disc)/2a

  print msg1,msglen1
  print msg2,msglen2  
  call disp_proc 

  fldz				; stack: st(0) = 0
  fsub dword[disc]		; stack: st(0) = -disc  i.e. disc = sqrt(b*b - 4*a*c)
  fsub dword[b] 			; stack: st(0) = -disc - b
  fdiv dword[a]			; stack: st(0) = (-b - disc)/a
  fdiv dword[two]      		 ; stack: st(0) = (-b - disc)/(2*a)
  
  print msg3,msglen3
  call disp_proc 
  jmp Exit
;---------------------------------------------------------------------------------------------------
no_real_solutions:
       
	print rmsg,rmsg_len

;-------------------------------------------------------------------------------------------------
Exit : 
        print nline,nline_len
       	mov rax,60
	mov rdi,00
	syscall
  	
;--------------------------------------------------------------------------------------------------
disp_proc:
	FIMUL dword[hdec]         ;multiply top of the stack value by 100 to remove decimal point (eg. 1.35 * 100 = 135) 
	FBSTP tword[resbuff]      ;store top of the stack value in resbuff in the form of Tenwords = 20 bytes = 20 digits
	mov rsi,resbuff+9         ;load last word address into rsi 
	mov rcx,09                ;to display first 18 digits, counter = 9 (for eg. counter 1 = display 2 digits)

  next1:
  	
  	push rcx 		; push counter on to the stack
  	push rsi 		; push rsi on to the stack       	
  	
  	mov al,[rsi]		; take value in al register and display 2 digits
  	call display_8
  	
  	pop rsi                 
  	pop rcx
  	
   	dec rsi                 ; rsi points to one byte back ( 2 digits back)
        dec rcx			; decrement counter
  	jnz next1
        
        
  	print point,1		; display decimal point
        
  	mov al,[resbuff]	; load the first word address into al then display
  	call display_8
ret
;-----------------------------------------------------------------------------------------------------  
display_8:
	mov 	rsi,char_ans+1	
	mov 	rcx,2		; number of digits 

cnt:	mov 	rdx,0		
	mov 	rbx,16	
	div 	rbx
	cmp 	dl, 09h 	; check for remainder in RDX
	jbe  	add30
	add  	dl, 07h 
add30:
	add 	dl,30h		; calculate ASCII code
	mov 	[rsi],dl	; store it in buffer
	dec 	rsi		; point to one byte back

	dec 	rcx		; decrement count
	jnz 	cnt		
	
	print char_ans,2	; display result on screen
ret
;-------------------------------------------------------------------------------------------------------


;Output :



;administrator@211-VW:~/Desktop/1$ nasm -f elf64 q.asm
;administrator@211-VW:~/Desktop/1$ ld -o q q.o
;administrator@211-VW:~/Desktop/1$ ./q

;Real Solutions for the Roots are :
;Root1 : 800000000000000003.00
;Root2 : 800000000000000005.00
















