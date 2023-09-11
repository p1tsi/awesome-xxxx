;	Executable name	:	write_syscall
;	Version			:	1.0
;	Author			: 	p1tsi
;	Description		:	Simple trial on macOS syscall
;
;	Build:
;		nasm -f macho64 write_syscall.asm
;		ld -L /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -l System -o write_syscall write_syscall.o
;

bits 64

global _main

_main:

	mov	rax, 0x2000004		; 0x2000000 -> BSD syscall (0x1000000 -> mach traps) 
	mov	rdi, 0x1			; 1st arg: fd (0x1 -> stdout)
	mov	rbx, 'Hi'
	push	rbx
	mov	rsi, rsp			; 2nd arg: cbuf (pontier to string 'Hi')
	mov 	rdx, 2			; 3rd arg: nbyte (byte length of buffer)
	syscall
	
	mov	rax, 0x2000001		
	mov	rdi, 0x0			; 1st arg: rval (of exit syscall)
	syscall
