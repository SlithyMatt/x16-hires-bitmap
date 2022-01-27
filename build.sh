#!/bin/sh

gcc -o convert.exe bitmap_4bpp.c

./convert.exe racecar640.data BITMAP.BIN

cl65 -t cx16 -l hires.list -o HIRES.PRG hires.asm
