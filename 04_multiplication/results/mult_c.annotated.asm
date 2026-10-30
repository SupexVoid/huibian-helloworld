; C 乘法表程序的反汇编注释，对应 mult_c.generated.asm。
; 编译参数：wcc -0 -ms -od -d2；反汇编工具：Open Watcom wdis。
; .387/.386p 是 WDIS 默认输出的模板头；实际编译使用 -0，main_ 指令均兼容 8086。
; 导出代码和常量，省略含本机路径的 DWARF 调试数据。
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
; C：int main(void)。__STK 为 C 运行库的栈检查入口，不是本题手写过程。
main_:
	mov		ax,1eH
	call		near ptr __STK
	push		bx
	push		cx
	push		dx
	push		si
	push		di
	push		bp
; 保存调用者寄存器后建立 BP 栈帧，下面分配 8 字节局部变量空间。
	mov		bp,sp
	sub		sp,8
; 局部变量：[BP-6]=row，[BP-4]=column，[BP-2]=product，[BP-8]=返回值临时槽。
; C：printf("The 9mul9 table:\n")，随后 row=9。每个近指针占 2 字节。
L$1:
	mov		ax,offset DGROUP:L$14
	push		ax
	call		near ptr printf_
	add		sp,2
	mov		word ptr -6[bp],9
	jmp		near ptr L$2
; C 外层 for 的条件：row != 0；为零时跳转 L$11 返回。
L$2:
	cmp		word ptr -6[bp],0
	jne		L$3
	jmp		near ptr L$11
; C：每一行的 column=1。
L$3:
	mov		word ptr -4[bp],1
; C 内层 for 条件：column <= row。JBE 为无符号小于等于。
L$4:
	mov		ax,word ptr -4[bp]
	cmp		ax,word ptr -6[bp]
	jbe		L$5
	jmp		near ptr L$9
; C：product=row*column。16 位 MUL 以 AX 为被乘数，结果为 DX:AX。
; 本题乘积 <=81，因此 DX=0，保存 AX 已能完整表示结果。
L$5:
	mov		ax,word ptr -6[bp]
	mul		word ptr -4[bp]
	mov		word ptr -2[bp],ax
; printf 的参数按逆序压栈：product、column、row、格式串地址。
; 4 个 2 字节参数共 8 字节，返回后的 ADD SP,8 由调用者清理参数。
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
; column==row：最后一项直接跳过空格输出。
L$6:
	jmp		near ptr L$8
; column!=row：printf("  ")，输出两个空格，ADD SP,2 清理格式串指针。
L$7:
	mov		ax,offset DGROUP:L$16
	push		ax
	call		near ptr printf_
	add		sp,2
; C：++column，回到内层条件。
L$8:
	inc		word ptr -4[bp]
	jmp		L$4
; 一行完成：printf("\n")；DOS C 运行库负责文本模式的 CR/LF 转换。
L$9:
	mov		ax,offset DGROUP:L$17
	push		ax
	call		near ptr printf_
	add		sp,2
; C：--row；ADD 0FFFFh 在 16 位无符号运算中等价于减 1。
L$10:
	add		word ptr -6[bp],0ffffH
	jmp		L$2
; C：return 0，将返回值放入 AX。
L$11:
	mov		word ptr -8[bp],0
	mov		ax,word ptr -8[bp]
; 函数尾声：释放局部变量，按相反顺序恢复寄存器，RET 返回 C 启动代码。
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
; 下列四组为格式串数据，以 00h 终止；0Ah 为 C 字符串中的换行。
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
