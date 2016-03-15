# BMP_Square_Rot

This program performs a clockwise 90-degree rotation of square .BMP images in the 24bpp format.

Dependencies:

You need the NASM assembler (available for download at http://www.nasm.us/pub/nasm/releasebuilds/2.12/) 
and a C compiler.
The program has been tested with GCC on Ubuntu 14.04 and TDM-GCC Windows 10.

# Biuld instructions


gcc -m32 -c bm_rot.c

nasm -f elf rotmbp_24.asm

gcc -m32 rotmbp_24.o bm_rot.o -o bmp_rotate
# Very important notice!
When compiling on Linux, you MUST modify the rotbmp_24.asm file by removing the underscores ("_") placed right before the function 
name (lines 1 and 9)!

Usage

Pass the image name as a command line argument.




