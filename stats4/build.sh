#!/bin/bash

PROGNAME="stats"

# build all assembly sources

for asmsrc in `ls *.asm`; do
    asmsrc=`echo $asmsrc | cut -d "." -f1`
    yasm -f elf64 $asmsrc.asm -l $asmsrc.lst
    if [ $? -gt 0 ]; then
        echo "ERROR: assemble $asmsrc.asm failed. Quit."
        exit 1
    fi
done

# build C sources

for csrc in `ls *.c`; do
    gcc -Wall -c $csrc
    if [ $? -gt 0 ]; then
        echo "ERROR: building $csrc failed. Quit."
        exit 1
    fi
done

# link object files
ls *.o >/dev/null 2>&1
if [ $? -gt 0 ]; then
    echo "ERROR: no object files present. Cannot build executable."
    exit 1
fi

gcc -o $PROGNAME *.o