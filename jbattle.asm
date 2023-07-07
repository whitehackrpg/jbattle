;;; A program to explore turn-based JRPG-style combat

%include "macros.asm"


;;; ------------------------------------
section .data

%include "constants.asm"
%include "messages.asm"

	;; 		HP  IN DF Boost
	player	db	20, 4, 5, 3
	monster	db	30, 4, 2, 10

	damage	dq	10
	rage	db	0	 	; rage state tracker
	ragecha	dq	4		; rage chance

;;; ------------------------------------
section .bss
	
	buffer	resb	1
	choice	resb	2

;;; ------------------------------------
section .text
	global 	_start


;;; 	Set starting HP values and write a welcome message.
_start:	

	wrout	clrterm, clrlen
	wrout	welcom, wellen

;;; 	Get the player choice, settle initiative order and call monster
;;; 	and player rounds. Check input and HP to either loop or quit.
alive:	
	wrout	justnl, 2	
	call 	check_init
	cmp	rax, 0
	jg	monster_starts
	call	player_round		
	call	monster_round
	jmp 	alive
monster_starts:	
	call	monster_round
	call	player_round		
	jmp	alive


;;; 	Write out HP and, based on previous choice, attack or heal.
global	playerround
player_round:	
	;; 	wrout	hpmess, hpmlen
	push 	rbp
	mov 	rbp, rsp
	call	wrstats
	wrout	actmess, actlen
	call	readinput
	cmp	byte choice[0], 'q'	 
	jne	contround
	quit

contround:	
	wrout	clrterm, clrlen
	cmp	byte choice[0], 'a'
	je	attack
	mov	byte [rage], 0
	cmp	byte choice[0], 'h'
	je	heal
	cmp	byte choice[0], 's'
	je	slow
	cmp	byte choice[0], 'b'
	je	bash
	pop	rbp
	ret

slow:	decm	byte monster[1], 0
	wrout	slowmsg, slowlen
	pop	rbp
	ret

bash:	decm	byte monster[2], 0
	wrout	bashmsg, bashlen
	pop	rbp
	ret

heal:	
	cmp	byte player[3], 0
	jg	heal_go
	wrout	noheal, nhlen
	pop	rbp
	ret
heal_go:	
	dec	byte player[3]
	rng	r10, 10
	add	player[0], r10
	wrout	heal1, h1len
	mov	rdi, r10
	call	wrnum
	wrout	att2, a2len
	pop	rbp
	ret

attack:	
	rng	r10, [damage]
	sub	r10b, byte monster[2]
	cmp	r10b, 0
	jg	contattack
	wrout	armor, armlen
	pop	rbp
	ret
contattack:	
	wrout	patt1, p1len
	xor	rdi,rdi
	mov	rdi, r10
	call	wrnum
	wrout	att2, a2len
	cmp	byte [rage], 0 		; If in rage state ...
	je	godamage
	inc	byte [rage] 		; ... accelerate rage
godamage:	
	sub	monster[0], r10
	cmp	byte monster[0], 0
	jle	monsterdeath
	pop 	rbp
	ret

monsterdeath:	
	wrout	mdead,mdlen
	quit

;;; 	Attack the player, write out damage.
global	monsterround
monster_round:
	push 	rbp
	mov 	rbp, rsp
	push	rbx
	wrout	justnl, 2
	cmp	byte [rage], 2
	jge	hpattack
	rng	rbx, 8
	cmp	rbx, 4
	jge	hpattack
	wrout	dfatt, datlen
	decm	byte player[rbx], 0
	jmp	monstercont
hpattack:	
	rng	r10, [damage]
	sub	r10b, byte player[2]
	cmp	r10b, 0
	jg	dodamage
	wrout	armor, armlen
	jmp	finish
dodamage:	
	cmp	byte [rage], 1 			; If high rage ...
	jle	normaldamage
	add	r10b, byte monster[3] 		; ... boost damage 
	wrout	rgdam, rgdalen
	mov	byte [rage], 0			; ... and reset rage
normaldamage:	
	sub	player[0], r10
	wrout	matt1, m1len
	mov	rdi, r10
	call	wrnum
	wrout 	att2, a2len
monstercont:	
	cmp	byte player[0], 0
	jle	playerdeath
	rng	rbx, [ragecha]
	cmp	rbx, 1
	je	finish
	inc	byte [rage]
	wrout	ragemsg, ragelen 
finish:	
	pop	rbx
	pop	rbp
	ret

playerdeath:	
	wrout	pdead,pdlen
	quit

;;; 	See who wins initiative
global	check_init
check_init:	
	rng	rdi, 10
	rng	r10, 10
	add	dil, byte player[1]
	add 	r10b, byte monster[1]
	cmp	rdi, r10
	jge	player_wins
	wrout	minit, minlen
	mov	rax, 1
	ret

player_wins:
	wrout	pinit, pinlen
	mov	rax, 0
	ret

;;; 	Turn a number between 0 and 99 in to or two numeric characters
;;; 	and write them out to the console.
global 	wrnum
wrnum:	
	push 	rbp
	mov 	rbp, rsp
	sub	rsp, 1
	push 	rbx
	mov	rax, rdi
	mov	bl, 10
	div	bl
	add	al, 48
	add 	ah, 48
	mov 	[rbp], word ax
	cmp	al,48
	je	onedigit
	wrout	rbp, 2
	jmp 	wrapup

onedigit:	
	inc 	rbp
	wrout	rbp,1

wrapup:	
	pop 	rbx
	add 	rsp, 1
	pop 	rbp
	ret

;;; 	Write out the stats for the monster and the player
global 	wrstats
wrstats:	
	push 	rbp
	mov 	rbp, rsp
	push 	rbx
	wrout	justnl, 2
	wrout	monhp, monlen
	wrout	hpbar, monster[0]
	wrout	justnl, 2
	wrout	plhp, plhplen
	wrout	hpbar, player[0]
	wrout	justnl, 2
	xor	rbx, rbx

statloop:	
	wrout	stats[rbx * 8], statlen
	cmp	byte player[rbx + 1], 0
	jle	endwrite
	wrout	hpbar, player[rbx + 1]
endwrite:	
	wrout	justnl, 2
	inc	rbx
	cmp	rbx, 2
	jle	statloop
	wrout	justnl, 2
	pop	rbx
	pop	rbp
	ret

global	readinput
readinput:	
	push 	rbp
	mov 	rbp, rsp
	push 	rbx
	mov	rbx, choice
	xor	r10, r10
readmore:	
	mov    	rax, SYS_READ
	mov    	rdi, STDIN
	mov    	rsi, buffer
	mov    	rdx, 1
	syscall	
	mov	al, [buffer]
	cmp	al, 10
	je	endread
	inc	r10
	cmp	r10, 1
	jg	readmore
	mov	[rbx], al
	inc	rbx
	jmp 	readmore
endread:	
	pop	rbx
	pop	rbp
	ret
