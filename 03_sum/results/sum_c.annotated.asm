; 根据实际wdis -a输出增加中文注释，指令与常量保持原样。
; .386p/.387为工具模板指示；实际C编译选项-0，机器码为8086。
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
; 函数sum_to：AX传入n，返回值AX；开始保存寄存器、建立栈帧。
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
; n存入BP-8；total在BP-2初始化0，i在BP-4初始化1。
L$1:
	mov		word ptr -8[bp],ax
	mov		word ptr -2[bp],0
	mov		word ptr -4[bp],1
	jmp		near ptr L$2
; 循环条件：比较i与n，无符号JBE在i<=n时进入循环。
L$2:
	mov		ax,word ptr -4[bp]
	cmp		ax,word ptr -8[bp]
	jbe		L$3
	jmp		near ptr L$5
; 循环体total += i，累加结果在栈变量BP-2中。
L$3:
	mov		ax,word ptr -4[bp]
	add		word ptr -2[bp],ax
; i自增，再跳回循环条件。
L$4:
	inc		word ptr -4[bp]
	jmp		L$2
; 读取total并通过临时槽BP-6准备返回值AX。
L$5:
	mov		ax,word ptr -2[bp]
	mov		word ptr -6[bp],ax
	mov		ax,word ptr -6[bp]
; 恢复栈帧与寄存器，RET返回调用者。
L$6:
	mov		sp,bp
	pop		bp
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		bx
	ret
; C运行库调用的main函数；先检查栈空间再建立局部栈帧。
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
; AX=64h即100，调用sum_to；结果和格式串逆序压栈交给printf。
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
; AX保留返回值0，恢复现场返回C启动代码。
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
; 常量字节25h,75h,0Ah,0对应格式串%u、换行和零终止。
L$10:
    DB	25H, 75H, 0aH, 0

CONST		ENDS
CONST2		SEGMENT	WORD PUBLIC USE16 'DATA'
CONST2		ENDS
_DATA		SEGMENT	WORD PUBLIC USE16 'DATA'
_DATA		ENDS
		END
