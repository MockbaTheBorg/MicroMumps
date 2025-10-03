; ===========================================================================
; UC Davis MicroMumps for CP/M - version 4.06
; Rebuilt by Marcelo F. Dantas in February of 2014
; marcelo.f.dantas@gmail.com
; ===========================================================================
;
		org	0100h
; ---------------------------------------------------------------------------
BOOT		equ	0000h
BDOS		equ	0005h
; ---------------------------------------------------------------------------
		ld	hl, 0
		add	hl, sp
		ld	(SaveSP), hl	; Saves the current stack addr
		ld	hl, Stack
		ld	sp, hl		; New stack goes below the disk buffer
		ld	c, 9		; Output string
		ld	de, Greet
		call	BDOS
rGlobDR:
		ld	c, 9		; Output string
		ld	de, EnterDrive	; Enter the drive for the globals.dat file
		call	BDOS
		call	ReadDR		; Reads drive letter, returns in a
		jp	c, rGlobDR
		cp	0FFh		; Is it invalid?
		jp	z, rGlobDR
		ld	e, a
		ld	c, 14		; Select disk
		call	BDOS
		ld	c, 15		; Open file
		ld	de, GlobalsFCB
		call	BDOS
		inc	a
		jp	z, rFileSize	; Not found
		ld	c, 9
		ld	de, AlreadyExists
		call	BDOS
		jp	rGlobDR
rFileSize:
		ld	c, 9
		ld	de, EnterSize1	; Enter the file size in blocks
		call	BDOS
		ld	hl, (DefaultSize)
		call	HLToInt
		ld	c, 9
		ld	de, EnterSize2	; Enter the file size in blocks
		call	BDOS
		call	ReadNum
		jp	c, rFileSize	; 
		cp	0FFh		; Is it empty?
		jp	nz, rFileSize1
		ld	hl, (DefaultSize)
rFileSize1:
		dec	hl
		ld	a, h
		or	l
		jp	z, rFileSize	; File size cannot be 1
		ld	(NumBlocks), hl
rAllocate:
		ld	c, 9
		ld	de, Allocate	; Enter the file size in blocks
		call	BDOS
		call	ReadYesNo
		jp	c, rAllocate
		ld	(fAllocate), a	; Save the allocate flag for later
; ---------------------------------------------------------------------------
rBitMap:
		ld	hl, (NumBlocks)
		ex	de, hl
		ld	hl, Bitmap
		xor	a
		ld	b, a
		jp	rBitMap2	; Directory block is always occupied
rBitMap1:
		ld	a, b
		or	10000000b
		ld	b, a
		dec	de
		ld	a, d
		or	e
		jp	z, rBitMap9
rBitMap2:
		ld	a, b
		or	01000000b
		ld	b, a
		dec	de
		ld	a, d
		or	e
		jp	z, rBitMap9
rBitMap3:
		ld	a, b
		or	00100000b
		ld	b, a
		dec	de
		ld	a, d
		or	e
		jp	z, rBitMap9
rBitMap4:
		ld	a, b
		or	00010000b
		ld	b, a
		dec	de
		ld	a, d
		or	e
		jp	z, rBitMap9
rBitMap5:
		ld	a, b
		or	00001000b
		ld	b, a
		dec	de
		ld	a, d
		or	e
		jp	z, rBitMap9
rBitMap6:
		ld	a, b
		or	00000100b
		ld	b, a
		dec	de
		ld	a, d
		or	e
		jp	z, rBitMap9
rBitMap7:
		ld	a, b
		or	00000010b
		ld	b, a
		dec	de
		ld	a, d
		or	e
		jp	z, rBitMap9
rBitMap8:
		ld	a, b
		or	00000001b
		ld	b, a
		dec	de
		ld	a, d
		or	e
		jp	z, rBitMap9
		ld	(hl), b
		xor	a
		ld	b, a
		inc	hl
		jp	rBitMap1
rBitMap9:
		ld	(hl), b
rWriteFile:
		ld	c, 9
		ld	de, Creating	; Start creating GLOBALS.DAT file
		call	BDOS
		ld	c, 16h		; Make file
		ld	de, GlobalsFCB
		call	BDOS
		jp	nz, rMakeError
;
		ld	de, Block0	; Set DMA Addr to CP/M  Block 0
		call	WriteBlock
		ld	de, Block1	; Set DMA Addr to CP/M  Block 1
		call	WriteBlock
		ld	de, Block2	; Set DMA Addr to CP/M  Block 2
		call	WriteBlock
		ld	de, Block3	; Set DMA Addr to CP/M  Block 3
		call	WriteBlock
		ld	de, Block4	; Set DMA Addr to CP/M  Block 4
		call	WriteBlock
		ld	de, Block5	; Set DMA Addr to CP/M  Block 5
		call	WriteBlock
rAllocateAll:
		ld	a, (fAllocate)
		cp	4Eh ; 'N'
		jp	z, rCreated
		ld	de, (NumBlocks)
rAllocateAll1:	push	de
;
		ld	de, EmptyBlock	; Write an empty Global block
		call	WriteBlock
		ld	de, EmptyBlock
		call	WriteBlock
		ld	de, EmptyBlock
		call	WriteBlock
		ld	de, EmptyBlock
		call	WriteBlock
		ld	de, EmptyBlock
		call	WriteBlock
		ld	de, EmptyBlock
		call	WriteBlock
;
		pop	de
		dec	de
		ld	a, d
		or	e
		jp	nz, rAllocateAll1
rCreated:
		ld	c, 10h		; Close file
		ld	de, GlobalsFCB
		call	BDOS
		cp	0FFh
		jp	z, rCloseError
		ld	c, 9
		ld	de, Done	; File has been created
		call	BDOS
		jp	rFinished
; ---------------------------------------------------------------------------
rMakeError:
		ld	de, MakeError
		jp	rPrintError
rWriteError:
		ld	de, WriteError
		jp	rPrintError
rCloseError:
		ld	de, CloseError
rPrintError:
		ld	c, 9
		call	BDOS
rFinished:
		ld	c, 9
		ld	de, NewLine
		call	BDOS
		ld	hl, (SaveSP)
		ld	sp, hl		; Restore the previously saved stack addr
		jp	BOOT
;
; =============== S U B	R O U T	I N E =======================================
; Writes a CP/M Block to disk
WriteBlock:
		ld	c, 1Ah		; Set DMA Address to DE
		call	BDOS
		ld	c, 15h		; and writes the block
		ld	de, GlobalsFCB
		call	BDOS
		or	a
		jp	nz, rWriteError
		ret
; End of function WriteBlock
;
; =============== S U B	R O U T	I N E =======================================
; Reads	drive letter, returns in a
ReadDR:
		ld	a, 1
		ld	(iBuffer), a	; Sets the max read characters to 1
		ld	c, 0Ah		; Buffered input
		ld	de, iBUFFER
		call	BDOS
		ld	hl, BUFFER
		ld	a, (hl)
		or	a
		jp	z, ReadDRErr2	; Nothing was typed
		cp	1
		jp	nz, ReadDRErr1	; More than 1 char was typed
		inc	hl
		ld	a, (hl)
		and	0DFh ; 'ß'	; Converts char to uppercase
		cp	41h ; 'A'	; Is it smaller than A?
		ret	c
		cp	51h ; 'Q'	; Is it Q or bigger?
		jp	nc, ReadDRErr1	; Invalid drive letter was typed
		sub	41h ; 'A'	; Converts A->0, B->1, etc.
		ret
; ---------------------------------------------------------------------------
ReadDRErr1:
		scf
		ret
; ---------------------------------------------------------------------------
ReadDRErr2:
		ld	a, 0FFh
		ret
; End of function ReadDR
;
; =============== S U B	R O U T	I N E =======================================
; Reads	an integer between 1 and MaxBlocks, returns in HL
ReadNum:
		ld	a, 5
		ld	(iBuffer), a	; Sets the max read characters to 5
		ld	c, 0Ah		; Buffered input
		ld	de, iBUFFER
		call	BDOS
		ld	de, BUFFER
		ld	a, (de)
		or	a
		jp	z, ReadNumErr2	; Nothing was typed
		cp	6
		jp	nc, ReadNumErr1	; 6 or more chars were typed
		ld	c, a
		inc	de		; point to the first character
		ld	hl, 0
ReadNum1:
		ld	a, (de)
		push	de
		cp	30h ; '0'
		jp	c, ReadNumErr1
		cp	3Ah ; ':'
		jp	nc, ReadNumErr1
		and	0Fh
		push	hl
		add	hl, hl
		jp	c, ReadNumErr1
		add	hl, hl
		jp	c, ReadNumErr1
		pop	de
		add	hl, de
		jp	c, ReadNumErr1
		add	hl, hl
		jp	c, ReadNumErr1
		ld	e, a
		ld	d, 0
		add	hl, de
		pop	de
		inc	de
		dec	c
		jp	nz, ReadNum1
		ld	a, h
		or	l
		jp	z, ReadNumErr1
		ld	de, (MaxBlocks)
		ld	a, e
		sub	l
		ld	a, d
		sbc	a, h
		jp	c, ReadNumErr1
		ret
; ---------------------------------------------------------------------------
ReadNumErr1:
		scf
		ret
; ---------------------------------------------------------------------------
ReadNumErr2:
		ld	a, 0FFh
		ret
; End of function ReadNum
;
; =============== S U B	R O U T	I N E =======================================
; Reads	Yes or No
ReadYesNo:
		ld	a, 1
		ld	(iBuffer), a	; Sets the max read characters to 1
		ld	c, 0Ah		; Buffered input
		ld	de, iBUFFER
		call	BDOS
		ld	hl, BUFFER
		ld	a, (hl)
		or	a
		ret	z
		inc	hl
		ld	a, (hl)
		and	0DFh
		cp	4Eh ; 'N'
		jp	z, ReadYesNo1
		cp	59h ; 'Y'
		jp	nz, ReadYesNo2
ReadYesNo1:
		or	a
		ret
; ---------------------------------------------------------------------------
ReadYesNo2:
		scf
		ret
; End of function YesNo
;
; =============== S U B	R O U T	I N E =======================================
; Converts HL to integer string
HLtoInt:
		ld	de, 10000
		ld	bc, 0
ShowPart1:
		ld	a, l
		sub	e
		ld	l, a
		ld	a, h
		sbc	a, d
		ld	h, a
		jp	c, ShowPart2
		inc	b
		jp	ShowPart1
; ---------------------------------------------------------------------------
ShowPart2:
		add	hl, de
		ld	a, b
		or	c
		jp	z, ShowPart3
		ld	a, b
		or	30h ; '0'
		push	hl
		push	de
		push	bc
		ld	e, a
		ld	c, 2		; Console output
		call	BDOS
		pop	bc
		pop	de
		pop	hl
		inc	c
ShowPart3:
		ld	b, 0
		ld	a, e
		cp	10
		jp	z, ShowPart6
		cp	100
		jp	z, ShowPart4
		cp	232
		jp	z, ShowPart5
		ld	de, 1000
		jp	ShowPart1
; ---------------------------------------------------------------------------
ShowPart4:
		ld	de, 10
		jp	ShowPart1
; ---------------------------------------------------------------------------
ShowPart5:
		ld	de, 100
		jp	ShowPart1
; ---------------------------------------------------------------------------
ShowPart6:
		ld	a, l
		or	30h ; '0'
		ld	e, a
		ld	c, 2		; Console output
		call	BDOS
		ret
; End of function HLtoInt
;
; ---------------------------------------------------------------------------
Greet:		db 'SetGlob v4.06 for Z80 Mumps CP/M',0Dh,0Ah
		db 'rebuilt in Feb/2014 by Marcelo Dantas',0Dh,0Ah
		db 'marcelo.f.dantas@gmail.com',0Dh,0Ah,'$'
EnterDrive:	db 0Dh,0Ah
		db 'Enter drive to create the GLOBALS.DAT on: $'
AlreadyExists:	db 0Dh,0Ah
		db 'File aready exists on that drive.$'
EnterSize1:	db 0Dh,0Ah
		db 'Enter the file size in mumps blocks ($'
EnterSize2: 	db '): $'
Allocate:	db 0Dh,0Ah
		db 'Allocate the entire file now (Y/N)? $'
Creating:	db 0Dh,0Ah
		db 'Creating GLOBALS.DAT ... $'
Done:		db 'Done.$'
MakeError:	db 'Creation error.$'
WriteError:	db 'Write error.$'
CloseError:	db 'Close error.$'
NewLine:	db 0Dh,0Ah,'$'
;
DefaultSize:	dw 200			; Default file size in 768 byte blocks
GlobalsFCB:	db 0
		db 'GLOBALS DAT'
		ds 24
;
BlockSize:	dw 768			; Mumps block size
MaxBlocks:	dw 11000		; Maximum number of blocks allowed (approx 8M file)
;					CP/M disk blocks for creating global block 0
;					each global block is 768 bytes long
Block0:		db -1			; Empty file indicator (-1 = Empty)
		dw -1			; Pointer to the first free block (-1 on a new file)
		dw 1			; Some 16 bit value - always 1
NumBlocks:	dw 0			; Number of free blocks in the file
Bitmap:		ds 121			
Block1:		ds 128
Block2:		ds 128
Block3:		ds 128
Block4:		ds 128
Block5:		ds 128
EmptyBlock:	ds 128
;
SaveSP:		dw 0
fAllocate:	db 0
iBUFFER:	db 1			; Buffer for reading console input
BUFFER:		ds 40
;
		ds 32
Stack:		db '$'
