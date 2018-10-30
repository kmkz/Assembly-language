[BITS 32]

; nasm Jumper.asm -o Jumper

global_start:

_start:
	; Copy EIP  into ECX
	fldz
	fnstenv [esp-12]
	pop ecx
	add cl, 10
	nop

;Another interesting mechanism being use to obtain the EIP is to make 
;use of a few special FPU instructions. 

;This was implemented by Aaron Adams in Vuln-Dev mailing list in the discussion to create pure ASCII shellcode. 
;The code uses fnstenv/fstenv instructions to save the state of the FPU environment.

	;fldz
	;fnstenv [esp-12]
	;pop ecx
	;add cl, 10
	;nop

;ECX will hold the address of the EIP. However, these instructions will generate non-standard ASCII characters.


	; long jump by using ECX (EIP backuped) incrementation/decrementation (it depends of your needs)
	dec ch ;dec ECX -> ECX= EIP-256
	dec ch ; dec ECX -> ECX= EIP-512
	jmp ecx ; jump ECX that is EIP (current location) - 512 
