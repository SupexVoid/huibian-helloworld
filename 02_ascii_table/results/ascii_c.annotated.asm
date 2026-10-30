; ����ע�Ͱ棺���� ascii_c.generated.asm �е����д����볣���Σ�׷������ע�͡�
; �� ascii_c.obj �� wdis -a ����������ע�ͣ�����ʱʡ�� DWARF Ԫ���ݡ�
; ָ���ַ�μ�ͬĿ¼ ascii_c.disasm.txt�����е�ַ����Ŀ���ļ�����ƫ�ơ�
; ���ļ������Ķ������������򹹽���ʹ�� src/ascii.c��

.387 ; wdis ����Ļ����ָʾ�����Դ��ж�����ָ�������Ԫ������ʡ��
.386p ; wdis ԭ������Ļ����ָʾ��ʵ�� C ����ʹ�� -0��8086��
		PUBLIC	main_ ; ������������ C �� main ��������
		EXTRN	__STK:BYTE ; �ⲿջ�ռ�����̣��� C ���п��ṩ
		EXTRN	printf_:BYTE ; �ⲿ��ʽ���������������ʱ�� C ���п����
		EXTRN	_small_code_:BYTE ; small ģ�͵����п����ӱ�ʶ
		EXTRN	_cstart_:BYTE ; C ���п�����ģ������ӱ�ʶ
DGROUP		GROUP	CONST,CONST2,_DATA ; ���������ݹ��� DGROUP��small ģ��ʹ�ý�����ָ��
_TEXT		SEGMENT	BYTE PUBLIC USE16 'CODE' ; 16 λ����Σ�����ָ���Ӧԭʼ�嵥 _TEXT:0000 ��
		ASSUME CS:_TEXT, DS:DGROUP, SS:DGROUP ; ������μٶ���DS/SS ������ʱ��ʼ���� C �����������
main_: ; C main(void) ����ڣ����� DOS EXE ���������
	mov		ax,1aH ; 0000��Ϊջ����ṩ 1Ah��26 �ֽڣ�������ֵ
	call		near ptr __STK ; 0003�����п����������ִ�������ջ�ռ�
	push		bx ; 0006����������� BX
	push		cx ; 0007����������� CX
	push		dx ; 0008����������� DX
	push		si ; 0009����������� SI
	push		di ; 000A����������� DI
	push		bp ; 000B����������� BP
	mov		bp,sp ; 000C������ջ֡�������� BP ���ʾֲ�����
	sub		sp,8 ; 000E��Ϊ 4 �� 16 λջ�۱��� 8 �ֽ�
L$1: ; 0012����ʼ�� letter ������к�
	mov		word ptr -2[bp],61H ; 0012��letter = 'a'��ASCII ��Ϊ 61h
	mov		word ptr -6[bp],0 ; 0017��row = 0
	jmp		near ptr L$2 ; 001C���������ѭ������������������ԭʼ������
L$2: ; 001F����� for ���������
	cmp		word ptr -6[bp],2 ; 001F���Ƚ� row �� 2
	jl		L$3 ; 0023���з��� row < 2 ʱ���뱾��
	jmp		near ptr L$11 ; 0025��row >= 2�������������
L$3: ; 0028��ÿ�ο�ʼ�µ�һ��
	mov		word ptr -4[bp],0 ; 0028��column = 0
L$4: ; 002D���ڲ� for ���������
	cmp		word ptr -4[bp],0dH ; 002D���Ƚ� column �� 13
	jl		L$5 ; 0031��column < 13�����һ����ĸ
	jmp		near ptr L$9 ; 0033��һ�� 13 ����ĸ��ɣ�תȥ�������
L$5: ; 0036��printf("%c", letter) �� ++letter
	mov		ax,word ptr -2[bp] ; 0036����ȡ 16 λ�� letter ����
	push		ax ; ��ǰһ�� MOV ׼���� 16 λ����ѹջ��printf ��ʵ�δ���������ջ
	mov		ax,offset DGROUP:L$14 ; 003A��װ���ʽ�� "%c" �Ľ�ָ��
	push		ax ; ��ǰһ�� MOV ׼���� 16 λ����ѹջ��printf ��ʵ�δ���������ջ
	call		near ptr printf_ ; ���� C ���п� printf�����غ��ɵ�������������
	add		sp,4 ; 0041���������� 16 λʵ�Σ�letter �͸�ʽ����ַ��
	inc		word ptr -2[bp] ; 0044��++letter��ת����һ�� ASCII ��ĸ
	cmp		word ptr -4[bp],0cH ; 0047���Ƚ� column �� 12���ж��Ƿ�Ϊ���һ��
	jge		L$6 ; 004B��column >= 12 ʱ�����ո�
	jmp		near ptr L$7 ; 004D��column < 12��׼�������ĸ��Ŀո�
L$6: ; 0050�����һ�еķ�֧
	jmp		near ptr L$8 ; 0050������ printf(" ")��������ĩ�ո�
L$7: ; 0053�������һ�в�ִ��
	mov		ax,offset DGROUP:L$15 ; 0053��װ���ʽ�� " " �Ľ�ָ��
	push		ax ; ��ǰһ�� MOV ׼���� 16 λ����ѹջ��printf ��ʵ�δ���������ջ
	call		near ptr printf_ ; ���� C ���п� printf�����غ��ɵ�������������
	add		sp,2 ; ���� printf ��һ�� 16 λ��ʽ����ַ����
L$8: ; 005D���ڲ� for ������
	inc		word ptr -4[bp] ; 005D��++column
	jmp		L$4 ; 0060���ص��ڲ�ѭ���������
L$9: ; 0062�����һ�к�� printf("\n")
	mov		ax,offset DGROUP:L$16 ; 0062��װ����� LF �� NUL ���ַ�����ַ
	push		ax ; ��ǰһ�� MOV ׼���� 16 λ����ѹջ��printf ��ʵ�δ���������ջ
	call		near ptr printf_ ; ���� C ���п� printf�����غ��ɵ�������������
	add		sp,2 ; ���� printf ��һ�� 16 λ��ʽ����ַ����
L$10: ; 006C����� for ������
	inc		word ptr -6[bp] ; 006C��++row
	jmp		L$2 ; 006F���ص����ѭ���������
L$11: ; 0071��return 0
	mov		word ptr -8[bp],0 ; 0071��������ֵ�ݴ浽������������ջ��
	mov		ax,word ptr -8[bp] ; 0076��AX = 0��׼������ֵ
L$12: ; 0079��������β
	mov		sp,bp ; 0079���ͷ� 8 �ֽھֲ�ջ�ռ�
	pop		bp ; 007B���ָ������� BP
	pop		di ; 007C���ָ������� DI
	pop		si ; 007D���ָ������� SI
	pop		dx ; 007E���ָ������� DX
	pop		cx ; 007F���ָ������� CX
	pop		bx ; 0080���ָ������� BX
	ret ; 0081�������� C �������룬���ߴ��� DOS �˳�
L$13: ; 0082��main_ ����ĩβ��ǣ��������� 82h = 130 �ֽ�
_TEXT		ENDS
CONST		SEGMENT	WORD PUBLIC USE16 'DATA' ; ֻ���ַ�����������Ϊ C �� NUL ��β�ַ���
L$14: ; CONST:0000����Ӧ "%c"
    DB	25H, 63H, 0 ; �ֽ� 25h('%')��63h('c')��00h
L$15: ; CONST:0003����Ӧһ���ո�
    DB	20H, 0 ; �ֽ� 20h(' ')��00h
L$16: ; CONST:0005����Ӧ "\n"��DOS �ı�������п�ת��Ϊ CR/LF
    DB	0aH, 0 ; �ֽ� 0Ah(LF)��00h

CONST		ENDS
CONST2		SEGMENT	WORD PUBLIC USE16 'DATA'
CONST2		ENDS
_DATA		SEGMENT	WORD PUBLIC USE16 'DATA'
_DATA		ENDS
		END
