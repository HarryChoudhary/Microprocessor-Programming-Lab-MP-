;NAME-Harish choudhary
;roll no-SECOA121
;MIL assignment 11 Write 8087ALP to obtain: 
;      i) Mean = (Summation of all elements)/Total no. of elements
;    ii) Variance  = (Summation of ((Xi-mean)*(Xi-mean)))/Total no. of elements
;    iii) Standard Deviation  = Sqrt(Variance)
;for a given set of data elements defined in data segment. Also display result.	
;---------------------------------------------------------------------------------------
section .data
	nline		db	10,10
	nline_len:	equ	$-nline
     
	msg 		db 	10,"MIL assignment 11 : 8087 program for Mean, S.D., & Variance"
			db	10,"---------------------------------------------",10
	msg_len:	equ 	$-msg
    	
	mmsg 	db 	10,"CALCULATED MEAN 		: "
    	mmsg_len 	equ 	$-mmsg
    
    	sdmsg 	db 	10,"CALCULATED STANDARD DEVIATION	: "
    	sdmsg_len 	equ 	$-sdmsg
    
    	vmsg 	db 	10,"CALCULATED VARIANCE 		: "
    	vmsg_len 	equ 	$-vmsg
     
   
    	array 	dd 	111.11, 222.22, 333.33, 444.44, 555.55
    	count		dw 	05

    	dpoint	db 	'.'
    	hdec 	dq 	100
;--------------------------------------------------------------- 
section .bss
	char_ans 	resB 2
    	resbuff 	resT 1       ; TenWords = 20 bytes (20 digits)

	mean 		resD 1
	variance 	resD 1
;--------------------------------------------------------------- 
;macros as per 64-bit convensions

%macro  print   2
	mov 	rax,1	; Function 1 for write
  	mov 	rdi,1	; To stdout
   	mov 	rsi,%1	; String address
   	mov 	rdx,%2	; String size
   	syscall		; invoke operating system to WRITE
%endmacro

%macro  read   2
	mov 	rax,0	; Function 0 - Read
  	mov 	rdi,0	; from stdin
   	mov 	rsi,%1	; buffer address
   	mov 	rdx,%2	; buffer size
   	syscall		; invoke operating system to READ
%endmacro

%macro	exit	0
	print	nline, nline_len

	mov 	rax, 60	        ; system call 60 is exit
	xor 	rdi, rdi 	; we want return code 0
	syscall 		; invoke operating system to exit
%endmacro
;--------------------------------------------------------------- 

section .text
   global _start
_start:

	print	msg, msg_len

	finit			; initialize coprocessor
	fldz			; loads zero on top of stack st(0)=0

	mov 	rbx,array	; load first address of array into rbx
	mov 	rsi,00		; index of array initalized to 0
	xor 	rcx,rcx	
	mov 	cx,[count]	; load count in cx reg

back:	fadd 	dword[RBX+RSI*4]   ; st(0)+[array+(index*4)]=st(0)
				   ; each element in array is of type Double word = 4 bytes

	inc 	rsi		   ; increment array index
        dec     cx
	jnz 	back		   ; repeat addition untill all elements are added

	fidiv	word[count]	   ; st(0)= st(0)/count   i.e. st(0)= (sum of array elements)/count = mean
	fst 	dword[mean]	   ; store the st(0) in mean

	print  mmsg,mmsg_len	   ; Display MEAN result
	call 	display_result




;VARIANCE FUNTION-----




	mov 	rbx,array	    ; load first address of array into rbx
	mov 	rsi,00		    ; index of array initalized to 0
	xor 	rcx,rcx	
	mov 	cx,[count]	    ; load count in cx reg

	fldz			    ; initially loads zero on top of stack st(0)=0

back1:  fldz			    ; First time st(1)=0 , then after first loop again st(0) = 0

	FLD 	DWORD[RBX+RSI*4]     ;st(0)=array[rsi]

	FSUB 	DWORD[mean]          ;st(0)=st(0)-mean    i.e (Xi-Mean)

	FST 	ST1		    ; Store result st(0) into st(1)
 
	FMUL                        ; st(0) = st(0)*st(1)  i.e. (Xi-Mean)^2               
	
	FADD                    ; Summation of (Xi-mean)^2    
					; add squared value to st(1) i.e. st(0)=st(0)+st(1)  then st(1) = st(0)
			       	 ; Here for current instruction initially st(1)=0
	INC 	RSI		; increment RSI index
      	dec     cx		; decrement counter
	jnz 	back1





	FIDIV	word[count]          ;divide result st(0) by count to get variance
                                     ; st(0) = st(0)/count
	FST 	dWORD[variance]
	FSQRT                        ;st(0)=sqrt(st(0))= value of standard deviation

	print  sdmsg,sdmsg_len
	CALL 	display_result

	FLD 	dWORD[variance]
	print vmsg,vmsg_len
	CALL 	display_result

exit
;--------------------------------------------------------------- 
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
;--------------------------------------------------------------- 
display_result:

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
        
        
  	print dpoint,1		; display decimal point
        
  	mov al,[resbuff]	; load the first word address into al then display
  	call display_8
ret
;--------------------------------------------------------------- 


;output-



;MIL assignment 11 : 8087 program for Mean, S.D., & Variance
;---------------------------------------------

;CALCULATED MEAN 		: 000000000000000333.33
;CALCULATED STANDARD DEVIATION	: 000000000000000157.13
;CALCULATED VARIANCE 		: 000000000000024690.86


