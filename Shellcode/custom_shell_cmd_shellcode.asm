;	Executable name	:	custom_shell_cmd_shellcode
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

global _main

_main: 
    
    ; prepare execve args
    xor     rdx, rdx            ; zero rdx - arg[2] = NULL
    push    rdx
    mov     rbx, '/bin/zsh'
    push    rbx
    mov     rdi, rsp            ; arg[0] = '/bin/zsh'
    mov     rbx, '-c'       
    push    rbx
    mov     rbx, rsp 
    push    rdx
    jmp     j_cmd64

r_cmd64:
    push    rbx
    push    rdi
    mov     rsi, rsp            ; arg[1] = ['/bin/zsh', '-c', 'touch ...']
    
    ; put execve syscall number to rax
    push    59
    pop     rax
    bts     rax, 25

    syscall
    ;jmp     j_exit

j_cmd64:
    call r_cmd64                ; useful in order to put ret address on the stack
    db 'touch /tmp/mynewfile.txt', 0