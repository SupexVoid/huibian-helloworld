; C �˷�������ķ����ע�ͣ���Ӧ mult_c.generated.asm��
; ���������wcc -0 -ms -od -d2������๤�ߣ�Open Watcom wdis��
; .387/.386p �� WDIS Ĭ�������ģ��ͷ��ʵ�ʱ���ʹ�� -0��main_ ָ������� 8086��
; ��������ͳ�����ʡ�Ժ�����·���� DWARF �������ݡ�
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
; C��int main(void)��__STK Ϊ C ���п��ջ�����ڣ����Ǳ�����д���̡�
main_:
	mov		ax,1eH
	call		near ptr __STK
	push		bx
	push		cx
	push		dx
	push		si
	push		di
	push		bp
; ��������߼Ĵ������� BP ջ֡��������� 8 �ֽھֲ������ռ䡣
	mov		bp,sp
	sub		sp,8
; �ֲ�������[BP-6]=row��[BP-4]=column��[BP-2]=product��[BP-8]=����ֵ��ʱ�ۡ�
; C��printf("The 9mul9 table:\n")����� row=9��ÿ����ָ��ռ 2 �ֽڡ�
L$1:
	mov		ax,offset DGROUP:L$14
	push		ax
	call		near ptr printf_
	add		sp,2
	mov		word ptr -6[bp],9
	jmp		near ptr L$2
; C ��� for ��������row != 0��Ϊ��ʱ��ת L$11 ���ء�
L$2:
	cmp		word ptr -6[bp],0
	jne		L$3
	jmp		near ptr L$11
; C��ÿһ�е� column=1��
L$3:
	mov		word ptr -4[bp],1
; C �ڲ� for ������column <= row��JBE Ϊ�޷���С�ڵ��ڡ�
L$4:
	mov		ax,word ptr -4[bp]
	cmp		ax,word ptr -6[bp]
	jbe		L$5
	jmp		near ptr L$9
; C��product=row*column��16 λ MUL �� AX Ϊ�����������Ϊ DX:AX��
; ����˻� <=81����� DX=0������ AX ����������ʾ�����
L$5:
	mov		ax,word ptr -6[bp]
	mul		word ptr -4[bp]
	mov		word ptr -2[bp],ax
; printf �Ĳ���������ѹջ��product��column��row����ʽ����ַ��
; 4 �� 2 �ֽڲ����� 8 �ֽڣ����غ�� ADD SP,8 �ɵ���������������
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
; column==row�����һ��ֱ�������ո������
L$6:
	jmp		near ptr L$8
; column!=row��printf("  ")����������ո�ADD SP,2 ������ʽ��ָ�롣
L$7:
	mov		ax,offset DGROUP:L$16
	push		ax
	call		near ptr printf_
	add		sp,2
; C��++column���ص��ڲ�������
L$8:
	inc		word ptr -4[bp]
	jmp		L$4
; һ����ɣ�printf("\n")��DOS C ���п⸺���ı�ģʽ�� CR/LF ת����
L$9:
	mov		ax,offset DGROUP:L$17
	push		ax
	call		near ptr printf_
	add		sp,2
; C��--row��ADD 0FFFFh �� 16 λ�޷��������еȼ��ڼ� 1��
L$10:
	add		word ptr -6[bp],0ffffH
	jmp		L$2
; C��return 0��������ֵ���� AX��
L$11:
	mov		word ptr -8[bp],0
	mov		ax,word ptr -8[bp]
; ����β�����ͷžֲ����������෴˳��ָ��Ĵ�����RET ���� C �������롣
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
; ��������Ϊ��ʽ�����ݣ��� 00h ��ֹ��0Ah Ϊ C �ַ����еĻ��С�
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
