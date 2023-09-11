;	Executable name	:	custom_shell_cmd
;	Version			:	1.0
;	Author			: 	p1tsi
;	Description		:	This program runs '/bin/zsh -c touch /tmp/mynewfile.txt' and exits.
;						Use: 59 - int execve(char *fname, char **argp, char **envp)
;							rdi: *fname
;							rsi: **argp
;							rdx: **envp
;
;	Build:
;		nasm -f macho64 custom_shell_cmd.asm
;		ld -L /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -l System -o custom_shell_cmd custom_shell_cmd.o
;

bits 64

section .data
	
	shellStr	db '/bin/zsh', 0x0
	paramStr	db '-c', 0x0
	cmdStr		db 'touch /tmp/mynewfile.txt', 0x0

section .text
	global _main

	_main: 
		
		; run command
		mov		rax, 0x200003b		; execve syscall number
		mov 	rbx, cmdStr			
		push 	rbx					; push 'cmdStr' into the stack
		mov 	rbx, paramStr
		push 	rbx					; push 'paramStr' into the stack
		mov 	rbx, shellStr		
		push 	rbx					; push 'shellStr' into the stack
		mov		rsi, rsp
		
		mov		rdi, shellStr
		xor		rdx, rdx			; zero rdx register (set **envp to NULL)
		syscall

		; exit
		mov rax, 0x2000001
		mov rdi, 0x0
		syscall
	
