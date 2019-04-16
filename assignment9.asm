;NAME-Harish choudhary
;roll no-SECOA121
; ASSIGNMENT 9-Write x86 ALP to find the factorial of a given integer number on a command line by using
;       recursion. Explicit stack manipulation is expected in the code.
;----------------------------------------------------------------
%macro read 2 
mov rax,0 
mov rdi,0 
mov rsi,%1 
mov rdx,%2 
syscall 
%endmacro 

%macro print 2 
mov rax,1 
mov rdi,1 
mov rsi,%1 
mov rdx,%2 
syscall 
%endmacro 

%macro exit 0 
mov rax,60 
mov rdi,00 
syscall 
%endmacro 

;------------------------------------------------------------------------ 

section .data 

  	 ano db 10,"----------------------------------------------" 
        db 10,"      Assignment No.9:  Write x86 ALP to find the factorial of a given integer number on a  "
			db 10,"	command line by using  recursion. Explicit stack manipulation is expected in the code.     " 

       db 10,"----------------------------------------------" 
    ano_len equ $-ano 
    imsg db 10,"Enter a number : " 
    imsg_len equ $-imsg 
    
    omsg db 10,"Factorial Result : " 
    omsg_len equ $-omsg 
    
     
    
    emsg db 10,"Invalid input..!" 
    emsg_len equ $-emsg 
    
;------------------------------------------------------------------------ 

section .bss 
              
        n1 resq 2 
        buf resb 3 
        ans1 resq 1 
        char_ans resq 1 
              
;------------------------------------------------------------------------ 

section .txt 

     global _start 
     
     _start: 
             mov qword[ans1],01 
             print ano,ano_len 
             print imsg,imsg_len 
             
             call Accept_8 
             mov [n1],bx 
             mov rcx,[n1] 
             mov qword[ans1],01 
             call Factorial 
             
             print omsg,omsg_len 
             mov rax,qword[ans1] 
             call Display_10 
             exit 
             
;------------------------------------------------------------------------ 

Factorial: 
            push rcx 
            cmp rcx,01 
            jne next 
            jmp next_1 
            
 next: 
            dec rcx 
            call Factorial 
            
 next_1: 
            pop rcx 
            mov rax,rcx 
            mul qword[ans1] 			;MULTIPLY ans with ax
            mov qword[ans1],rax 		;move rax value into ansl
      ret 
           
;------------------------------------------------------------------------ 
Accept_8: 

           read buf,3 
           mov rcx,2 
           mov rsi,buf 
           xor bx,bx

next_byte: 
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
           
          ; cmp al,'f' 
           ;jbe error 

error: print imsg,imsg_len 
       jmp exit 

sub57: sub al,20h 
sub37: sub al,07h 
sub30: sub al,30h 



       add bx,ax 
       inc rsi 
       dec rcx 
       jnz next_byte 
ret 
 
;-------------------------------------------------------------------- 
 
 Display_10: 
 
       mov rsi,char_ans+15 
       mov rcx,16 
       mov rbx,10
 
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
        print char_ans,16 
        
        ret 

;--------------------------------------------------------------

;output-
        


