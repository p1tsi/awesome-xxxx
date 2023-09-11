
# Compile to object file
nasm -f macho64 $1.asm || exit

# link and create executable file
ld -L /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -l System -o $1 $1.o

#remove object file
rm $1.o
