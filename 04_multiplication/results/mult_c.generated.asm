.387
.386p
		PUBLIC	main_
		EXTRN	__STK:BYTE
		EXTRN	printf_:BYTE
		EXTRN	_small_code_:BYTE
		EXTRN	_cstart_:BYTE
DGROUP		GROUP	CONST,CONST2,_DATA
_TEXT		SEGMENT	BYTE PUBLIC USE16 'CODE'
		ASSUME CS:_TEXT, DS:DGROUP, SS:DGROUP
main_:
	mov		ax,1eH
	call		near ptr __STK
	push		bx
	push		cx
	push		dx
	push		si
	push		di
	push		bp
	mov		bp,sp
	sub		sp,8
L$1:
	mov		ax,offset DGROUP:L$14
	push		ax
	call		near ptr printf_
	add		sp,2
	mov		word ptr -6[bp],9
	jmp		near ptr L$2
L$2:
	cmp		word ptr -6[bp],0
	jne		L$3
	jmp		near ptr L$11
L$3:
	mov		word ptr -4[bp],1
L$4:
	mov		ax,word ptr -4[bp]
	cmp		ax,word ptr -6[bp]
	jbe		L$5
	jmp		near ptr L$9
L$5:
	mov		ax,word ptr -6[bp]
	mul		word ptr -4[bp]
	mov		word ptr -2[bp],ax
	mov		ax,word ptr -2[bp]
	push		ax
	mov		ax,word ptr -4[bp]
	push		ax
	mov		ax,word ptr -6[bp]
	push		ax
	mov		ax,offset DGROUP:L$15
	push		ax
	call		near ptr printf_
	add		sp,8
	mov		ax,word ptr -4[bp]
	cmp		ax,word ptr -6[bp]
	je		L$6
	jmp		near ptr L$7
L$6:
	jmp		near ptr L$8
L$7:
	mov		ax,offset DGROUP:L$16
	push		ax
	call		near ptr printf_
	add		sp,2
L$8:
	inc		word ptr -4[bp]
	jmp		L$4
L$9:
	mov		ax,offset DGROUP:L$17
	push		ax
	call		near ptr printf_
	add		sp,2
L$10:
	add		word ptr -6[bp],0ffffH
	jmp		L$2
L$11:
	mov		word ptr -8[bp],0
	mov		ax,word ptr -8[bp]
L$12:
	mov		sp,bp
	pop		bp
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		bx
	ret
L$13:
_TEXT		ENDS
CONST		SEGMENT	WORD PUBLIC USE16 'DATA'
L$14:
    DB	54H, 68H, 65H, 20H, 39H, 6dH, 75H, 6cH
    DB	39H, 20H, 74H, 61H, 62H, 6cH, 65H, 3aH
    DB	0aH, 0
L$15:
    DB	25H, 75H, 2aH, 25H, 75H, 3dH, 25H, 75H
    DB	0
L$16:
    DB	20H, 20H, 0
L$17:
    DB	0aH, 0

CONST		ENDS
CONST2		SEGMENT	WORD PUBLIC USE16 'DATA'
CONST2		ENDS
_DATA		SEGMENT	WORD PUBLIC USE16 'DATA'
_DATA		ENDS
		END
