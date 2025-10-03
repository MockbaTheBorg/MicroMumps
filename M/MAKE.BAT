@echo off
if exist MUMPS.CIM del MUMPS.CIM
if exist MUMPSB.CIM del MUMPSB.CIM
if exist SETMUMPS.CIM del SETMUMPS.CIM
if exist SETGLOB.CIM del SETGLOB.CIM
if exist MUMPS.COM del MUMPS.COM
if exist MUMPSB.COM del MUMPSB.COM
if exist SETMUMPS.COM del SETMUMPS.COM
if exist SETGLOB.COM del SETGLOB.COM
if exist MUMPS.LST del MUMPS.LST
if exist MUMPSB.LST del MUMPSB.LST
if exist SETMUMPS.LST del SETMUMPS.LST
if exist SETGLOB.LST del SETGLOB.LST
echo ++++++++++++++++++ Building MUMPS.COM
zmac -Lo MUMPS.CIM MUMPS.Z80
ren MUMPS.CIM MUMPS.COM
echo ++++++++++++++++++ Building MUMPSB.COM
zmac -Lo MUMPSB.CIM MUMPSB.Z80
ren MUMPSB.CIM MUMPSB.COM
echo ++++++++++++++++++ Building SETMUMPS.COM
zmac -Lo SETMUMPS.CIM SETMUMPS.Z80
ren SETMUMPS.CIM SETMUMPS.COM
echo ++++++++++++++++++ Building SETGLOB.COM
zmac -Lo SETGLOB.CIM SETGLOB.Z80
ren SETGLOB.CIM SETGLOB.COM