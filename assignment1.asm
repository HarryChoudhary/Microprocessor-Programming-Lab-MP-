;NAME-Harish choudhary
;roll no-SECOA121
;Assignment 1-:counting number of positive or negative 
;		elements from 64 bit array
;________________________________________________________________

%macro print 2
	       	mov rax,1               ;id of syscall
       		mov rdi,1               ;file descriptor
       		mov rsi,%1              
       		mov rdx,%2              
       		syscall                 ;system call
 %endmacro 
 %macro exit 0
 	mov rax,60
 	mov rbx,0
 	syscall
 %endmacro                             
;____________________________
section .data
        nline db 10
        n_len equ $-nline
        
	m db '                              ASSIGNMENT No.-1',10,'Counting number of positive and negative integers in array',10         
	m_len equ $-m  
	
	pmsg db ' Number of positive numbers = '
	pmsg_len equ $-pmsg    
	
	nmsg db 'Number of negative numbers = '
	nmsg_len equ $-nmsg 
	
	arr64 dq -11H,20H,30H,-40H,41H,1H,1H,1H,1H,1H,1H,1H,1H,1H
	n equ 14          
;____________________________
section .bss
	pans resq 5
	nans resq 5
	chans resq 4
;____________________________
section .text                           
	global _start                   
	_start:                         
                print nline,n_len
                print m,m_len
                mov rsi,arr64
                mov rcx,n
                xor rbx,rbx
                xor rdx,rdx
                
       	next_num:
       	 	 mov rax,[rsi]
       	 	 rol rax,1
       	 	 jc negative
       	 	 
       	positive:
       	         inc rbx
       	         jmp next
       	         
       	negative:
       	         inc rdx
       	         
       	next:
       	     add rsi,8
       	     dec rcx
       	     jnz next_num
       	     mov [pans],rbx
       	     mov [nans],rdx
       	     print nline,n_len
       	     print pmsg,pmsg_len
       	     mov rax,[pans]
       	     call display
       	     print nline,n_len
       	     print nmsg,nmsg_len
       	     mov rax,[nans]
       	     call display
       	     print nline,n_len
 exit
       display:
                    mov rbx,16
                    mov rcx,4
                    mov rsi,chans+3
       cnt:
           mov rdx,0
           div rbx     			;rdx(remainder)=rax(qoutient)/rbx(value)
           cmp dl,09h
           jbe add30
           add dl,07h
       add30:
              add dl,30h
              mov [rsi],dl
              dec rsi
              dec rcx				;decrement count
              jnz cnt				;till count isnot equal to 0
              print chans,4
              ret	     

;____________________________________________________________________________________________________________
;____________________________________________________________________________________________________________
;_____________________________________________________________________________________________________________


;		OUTPUT:



;		ASSIGNMENT No.-1
;Counting number of positive and negative integers in array

; Number of positive numbers = 000C
;Number of negative numbers = 0002

;____________________________________________________________________________________________________________




	
       	     
