; 中文注释版：保留 ascii_c.generated.asm 中的运行代码与常量段，追加中文注释。
; 由 ascii_c.obj 经 wdis -a 导出并添加注释；导出时省略 DWARF 元数据。
; 指令地址参见同目录 ascii_c.disasm.txt；所有地址都是目标文件段内偏移。
; 本文件用于阅读编译结果，程序构建仍使用 src/ascii.c。

.387 ; wdis 输出的汇编器指示；不以此判断运行指令集，调试元数据已省略
.386p ; wdis 原样输出的汇编器指示；实际 C 编译使用 -0（8086）
		PUBLIC	main_ ; 向链接器公开 C 的 main 函数符号
		EXTRN	__STK:BYTE ; 外部栈空间检查过程，由 C 运行库提供
		EXTRN	printf_:BYTE ; 外部格式化输出函数，链接时由 C 运行库解析
		EXTRN	_small_code_:BYTE ; small 模型的运行库链接标识
		EXTRN	_cstart_:BYTE ; C 运行库启动模块的链接标识
DGROUP		GROUP	CONST,CONST2,_DATA ; 常量与数据归入 DGROUP，small 模型使用近数据指针
_TEXT		SEGMENT	BYTE PUBLIC USE16 'CODE' ; 16 位代码段；下列指令对应原始清单 _TEXT:0000 起
		ASSUME CS:_TEXT, DS:DGROUP, SS:DGROUP ; 汇编器段假定；DS/SS 的运行时初始化由 C 启动代码完成
main_: ; C main(void) 的入口，不是 DOS EXE 的启动入口
	mov		ax,1aH ; 0000：为栈检查提供 1Ah（26 字节）的需求值
	call		near ptr __STK ; 0003：运行库检查后续函数执行所需的栈空间
	push		bx ; 0006：保存调用者 BX
	push		cx ; 0007：保存调用者 CX
	push		dx ; 0008：保存调用者 DX
	push		si ; 0009：保存调用者 SI
	push		di ; 000A：保存调用者 DI
	push		bp ; 000B：保存调用者 BP
	mov		bp,sp ; 000C：建立栈帧，后续以 BP 访问局部变量
	sub		sp,8 ; 000E：为 4 个 16 位栈槽保留 8 字节
L$1: ; 0012：初始化 letter 和外层行号
	mov		word ptr -2[bp],61H ; 0012：letter = 'a'，ASCII 码为 61h
	mov		word ptr -6[bp],0 ; 0017：row = 0
	jmp		near ptr L$2 ; 001C：跳至外层循环条件，保留编译器原始控制流
L$2: ; 001F：外层 for 的条件检查
	cmp		word ptr -6[bp],2 ; 001F：比较 row 与 2
	jl		L$3 ; 0023：有符号 row < 2 时进入本行
	jmp		near ptr L$11 ; 0025：row >= 2，结束所有输出
L$3: ; 0028：每次开始新的一行
	mov		word ptr -4[bp],0 ; 0028：column = 0
L$4: ; 002D：内层 for 的条件检查
	cmp		word ptr -4[bp],0dH ; 002D：比较 column 与 13
	jl		L$5 ; 0031：column < 13，输出一个字母
	jmp		near ptr L$9 ; 0033：一行 13 个字母完成，转去输出换行
L$5: ; 0036：printf("%c", letter) 和 ++letter
	mov		ax,word ptr -2[bp] ; 0036：读取 16 位的 letter 参数
	push		ax ; 将前一条 MOV 准备的 16 位参数压栈；printf 的实参从右向左入栈
	mov		ax,offset DGROUP:L$14 ; 003A：装入格式串 "%c" 的近指针
	push		ax ; 将前一条 MOV 准备的 16 位参数压栈；printf 的实参从右向左入栈
	call		near ptr printf_ ; 调用 C 运行库 printf；返回后由调用者清理参数
	add		sp,4 ; 0041：清理两个 16 位实参（letter 和格式串地址）
	inc		word ptr -2[bp] ; 0044：++letter，转向下一个 ASCII 字母
	cmp		word ptr -4[bp],0cH ; 0047：比较 column 与 12，判断是否为最后一列
	jge		L$6 ; 004B：column >= 12 时跳过空格
	jmp		near ptr L$7 ; 004D：column < 12，准备输出字母间的空格
L$6: ; 0050：最后一列的分支
	jmp		near ptr L$8 ; 0050：跳过 printf(" ")，避免行末空格
L$7: ; 0053：非最后一列才执行
	mov		ax,offset DGROUP:L$15 ; 0053：装入格式串 " " 的近指针
	push		ax ; 将前一条 MOV 准备的 16 位参数压栈；printf 的实参从右向左入栈
	call		near ptr printf_ ; 调用 C 运行库 printf；返回后由调用者清理参数
	add		sp,2 ; 清理 printf 的一个 16 位格式串地址参数
L$8: ; 005D：内层 for 的增量
	inc		word ptr -4[bp] ; 005D：++column
	jmp		L$4 ; 0060：回到内层循环条件检查
L$9: ; 0062：完成一行后的 printf("\n")
	mov		ax,offset DGROUP:L$16 ; 0062：装入仅含 LF 和 NUL 的字符串地址
	push		ax ; 将前一条 MOV 准备的 16 位参数压栈；printf 的实参从右向左入栈
	call		near ptr printf_ ; 调用 C 运行库 printf；返回后由调用者清理参数
	add		sp,2 ; 清理 printf 的一个 16 位格式串地址参数
L$10: ; 006C：外层 for 的增量
	inc		word ptr -6[bp] ; 006C：++row
	jmp		L$2 ; 006F：回到外层循环条件检查
L$11: ; 0071：return 0
	mov		word ptr -8[bp],0 ; 0071：将返回值暂存到编译器保留的栈槽
	mov		ax,word ptr -8[bp] ; 0076：AX = 0，准备返回值
L$12: ; 0079：函数收尾
	mov		sp,bp ; 0079：释放 8 字节局部栈空间
	pop		bp ; 007B：恢复调用者 BP
	pop		di ; 007C：恢复调用者 DI
	pop		si ; 007D：恢复调用者 SI
	pop		dx ; 007E：恢复调用者 DX
	pop		cx ; 007F：恢复调用者 CX
	pop		bx ; 0080：恢复调用者 BX
	ret ; 0081：近返回 C 启动代码，后者处理 DOS 退出
L$13: ; 0082：main_ 代码末尾标记；函数长度 82h = 130 字节
_TEXT		ENDS
CONST		SEGMENT	WORD PUBLIC USE16 'DATA' ; 只读字符串常量，均为 C 的 NUL 结尾字符串
L$14: ; CONST:0000，对应 "%c"
    DB	25H, 63H, 0 ; 字节 25h('%')、63h('c')、00h
L$15: ; CONST:0003，对应一个空格
    DB	20H, 0 ; 字节 20h(' ')、00h
L$16: ; CONST:0005，对应 "\n"；DOS 文本输出运行库转换为 CR/LF
    DB	0aH, 0 ; 字节 0Ah(LF)、00h

CONST		ENDS
CONST2		SEGMENT	WORD PUBLIC USE16 'DATA'
CONST2		ENDS
_DATA		SEGMENT	WORD PUBLIC USE16 'DATA'
_DATA		ENDS
		END
