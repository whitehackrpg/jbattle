	pdead	db	'You are dead.', 10, 13
	pdlen	equ	$ - pdead

	mdead	db	'The monster is dead.', 10, 13
	mdlen	equ	$ - mdead

	welcom	db	'Kill that monster!', 10, 13
	wellen	equ	$ - welcom

	rgdam	db	'RAGE DAMAGE!', 10, 13
	rgdalen	equ	$ - rgdam

	pinit	db	'You win initiative!', 10, 13
	pinlen	equ	$ - pinit

	minit	db	'The monster wins initiative!', 10, 13
	minlen	equ	$ - minit
	
	ragemsg	db	'The monster rages.', 10, 13 ;
	ragelen	equ	$ - ragemsg

	statm	db	'Your stats: '
	stlen	equ	$ - statm

	plhp	db	'Player HP  '
	plhplen	equ	$ - plhp

	monhp	db	'Monster HP '
	monlen	equ	$ - monhp

	hpbar	db	'|||||||||||||||||||||||||||||||||||||||||||'

	speed	db	'Att Speed  '
	defense	db	'Defense    '
	boosts	db	'HP Boosts  '

	statlen	equ	11

	stats	dq	speed, defense, boosts

	justnl	db	10, 13

	matt1	db	'The monster attacks for '
	m1len	equ	$ - matt1

	patt1	db	'You attack for '
	p1len	equ	$ - patt1

	heal1	db	'You heal for '
	h1len	equ	$ - heal1

	att2	db	' HP.', 10, 13
	a2len	equ	$ - att2

	armor	db	'Armor soaks all damage.', 10, 13
	armlen	equ	$ - armor

	noheal	db	'You have no boosts left.', 10, 13
	nhlen	equ	$ - noheal

	killmsg db	'You killed the monster!', 10, 13
	killen	equ	$ - killmsg

	actmess	db	'Attack [a], heal [h], slow [s], bash [b] or quit [q]? '
	actlen	equ	$ - actmess

	bashmsg	db	'You bash the monster.', 10, 13
	bashlen	equ	$ - bashmsg

	slowmsg	db	'You slow the monster.', 10, 13
	slowlen	equ	$ - slowmsg

	clrterm db   27,"[H",27,"[2J"	; <ESC> [H <ESC> [2J
	clrlen  equ  $ - clrterm		

 	dfatt	db	'The monster did something shrewd!', 10, 13
 	datlen	equ	$ - dfatt
