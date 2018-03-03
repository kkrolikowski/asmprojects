# asmprojects
Assembly basic operations
## toolset
* yasm (assembler)
* ld (linker)
* gdb (debugger)
## running
Simple way to build and run assembly code

```
yasm -g dwarf2 -f elf64 prog.asm -l prog.lst
ld -g -o prog prog.o
gdb prog
```