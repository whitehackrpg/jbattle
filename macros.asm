;;; write some string out
%macro 	wrout	2
	mov    	rax, SYS_WRITE
	mov    	rdi, STDOUT
	mov    	rsi, %1
	mov    	dl, %2			; Only have byte sized lengths
	syscall	
%endmacro

;;; randomize a number between 1 and %2, store in %1
%macro	rng	2
	rdtsc
	xor	rdx, rdx
	mov	rcx, %2
	div	rcx
	inc	rdx
	mov	%1, rdx
%endmacro

%macro	quit	0
	mov    	rax, SYS_EXIT		
	mov    	rdi, 0
	syscall
%endmacro

;;; decrease something, but only to a limit
%macro	decm	2
	cmp	%1, %2
	je	%%nomore
	dec	%1
%%nomore:	
%endmacro
