#!/bin/sh
echo ++++++++++++++++++ Building MUMPS.COM
z80asm -o MUMPS.COM MUMPS.Z80
echo ++++++++++++++++++ Building MUMPSB.COM
z80asm -o MUMPSB.COM MUMPSB.Z80
echo ++++++++++++++++++ Building SETMUMPS.COM
z80asm -o SETMUMPS.COM SETMUMPS.Z80
echo ++++++++++++++++++ Building SETGLOB.COM
z80asm -o SETGLOB.COM SETGLOB.Z80
