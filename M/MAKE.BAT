@echo off
if exist MUMPS.COM del MUMPS.COM
if exist MUMPSB.COM del MUMPSB.COM
if exist SETMUMPS.COM del SETMUMPS.COM
if exist SETGLOB.COM del SETGLOB.COM
if exist MUMPS.LST del MUMPS.LST
if exist MUMPSB.LST del MUMPSB.LST
if exist SETMUMPS.LST del SETMUMPS.LST
if exist SETGLOB.LST del SETGLOB.LST
echo ++++++++++++++++++ Building MUMPS.COM
zmac -Ssgo MUMPS.COM MUMPS.ASM
echo ++++++++++++++++++ Building MUMPSB.COM
zmac -Ssgo MUMPSB.COM MUMPSB.ASM
echo ++++++++++++++++++ Building SETMUMPS.COM
zmac -Ssgo SETMUMPS.COM SETMUMPS.ASM
echo ++++++++++++++++++ Building SETGLOB.COM
zmac -Ssgo SETGLOB.COM SETGLOB.ASM
