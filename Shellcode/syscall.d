syscall::socket:entry
/execname == "bind_shell"/
{
    printf("%s(%d, %d, %d)", probefunc, arg0, arg1, arg2);
}

syscall::bind:entry
/execname == "bind_shell"/
{
    printf("%s(%d, %d, %d)", probefunc, arg0, arg1, arg2);
}

syscall::listen:entry
/execname == "bind_shell"/
{
    printf("%s(%d, %d)", probefunc, arg0, arg1);
}

syscall::accept*:entry
/execname == "bind_shell"/
{
    printf("%s(%d, %d, %d)", probefunc, arg0, arg1, arg2);
}

syscall::*dup2*:entry
/execname == "bind_shell"/
{
    printf("%s(%d, %d)", probefunc, arg0, arg1);
}

syscall::execve:entry
/execname == "bind_shell"/
{
    printf("%s(%d, %d, %d)", probefunc, arg0, arg1, arg2);
}


syscall::connect:entry
/execname == "bind_shell"/
{
    printf("%s(%d, %d, %d)", probefunc, arg0, arg1, arg2);
}