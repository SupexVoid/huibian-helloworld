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
	mov		ax,1aH
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
	mov		word ptr -2[bp],61H
	mov		word ptr -6[bp],0
	jmp		near ptr L$2
L$2:
	cmp		word ptr -6[bp],2
	jl		L$3
	jmp		near ptr L$11
L$3:
	mov		word ptr -4[bp],0
L$4:
	cmp		word ptr -4[bp],0dH
	jl		L$5
	jmp		near ptr L$9
L$5:
	mov		ax,word ptr -2[bp]
	push		ax
	mov		ax,offset DGROUP:L$14
	push		ax
	call		near ptr printf_
	add		sp,4
	inc		word ptr -2[bp]
	cmp		word ptr -4[bp],0cH
	jge		L$6
	jmp		near ptr L$7
L$6:
	jmp		near ptr L$8
L$7:
	mov		ax,offset DGROUP:L$15
	push		ax
	call		near ptr printf_
	add		sp,2
L$8:
	inc		word ptr -4[bp]
	jmp		L$4
L$9:
	mov		ax,offset DGROUP:L$16
	push		ax
	call		near ptr printf_
	add		sp,2
L$10:
	inc		word ptr -6[bp]
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
    DB	25H, 63H, 0
L$15:
    DB	20H, 0
L$16:
    DB	0aH, 0

CONST		ENDS
CONST2		SEGMENT	WORD PUBLIC USE16 'DATA'
CONST2		ENDS
_DATA		SEGMENT	WORD PUBLIC USE16 'DATA'
_DATA		ENDS
		END
