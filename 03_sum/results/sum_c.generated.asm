.387
.386p
		PUBLIC	sum_to_
		PUBLIC	main_
		EXTRN	__STK:BYTE
		EXTRN	printf_:BYTE
		EXTRN	_small_code_:BYTE
		EXTRN	_cstart_:BYTE
DGROUP		GROUP	CONST,CONST2,_DATA
_TEXT		SEGMENT	BYTE PUBLIC USE16 'CODE'
		ASSUME CS:_TEXT, DS:DGROUP, SS:DGROUP
sum_to_:
	push		ax
	mov		ax,16H
	call		near ptr __STK
	pop		ax
	push		bx
	push		cx
	push		dx
	push		si
	push		di
	push		bp
	mov		bp,sp
	sub		sp,8
L$1:
	mov		word ptr -8[bp],ax
	mov		word ptr -2[bp],0
	mov		word ptr -4[bp],1
	jmp		near ptr L$2
L$2:
	mov		ax,word ptr -4[bp]
	cmp		ax,word ptr -8[bp]
	jbe		L$3
	jmp		near ptr L$5
L$3:
	mov		ax,word ptr -4[bp]
	add		word ptr -2[bp],ax
L$4:
	inc		word ptr -4[bp]
	jmp		L$2
L$5:
	mov		ax,word ptr -2[bp]
	mov		word ptr -6[bp],ax
	mov		ax,word ptr -6[bp]
L$6:
	mov		sp,bp
	pop		bp
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		bx
	ret
main_:
	mov		ax,14H
	call		near ptr __STK
	push		bx
	push		cx
	push		dx
	push		si
	push		di
	push		bp
	mov		bp,sp
	sub		sp,2
L$7:
	mov		ax,64H
	call		near ptr sum_to_
	push		ax
	mov		ax,offset DGROUP:L$10
	push		ax
	call		near ptr printf_
	add		sp,4
	mov		word ptr -2[bp],0
	mov		ax,word ptr -2[bp]
L$8:
	mov		sp,bp
	pop		bp
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		bx
	ret
L$9:
_TEXT		ENDS
CONST		SEGMENT	WORD PUBLIC USE16 'DATA'
L$10:
    DB	25H, 75H, 0aH, 0

CONST		ENDS
CONST2		SEGMENT	WORD PUBLIC USE16 'DATA'
CONST2		ENDS
_DATA		SEGMENT	WORD PUBLIC USE16 'DATA'
_DATA		ENDS
		END
