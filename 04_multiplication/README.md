# ʵ���ģ������Ǿžų˷���

������� `The 9mul9 table:`������� 9 �г˷�ʽ����һ�д� `9*1=9` �� `9*9=81`���ڶ��д� `8*1=8` �� `8*8=64`�����һ���� `1*1=1`���� 45 �������ʽ֮���������ո�ָ�����ĩ���ӿո�

## ѭ����˷�

[mult.asm](src/mult.asm) �� BX ���������ӣ��� 9 �ݼ��� 1���� CX ���������ӣ�ÿ�д� 1 ���ӵ� BX��

ÿ�ε��� PrintTerm ���һ����ʽ�����Ӷ��� 1��9 �ڣ����Լ��� '0' תΪ�����ַ����˻���������λ����Ҫ����ʮ����������̡�

�˷�ʹ�� `MUL CL`��AL �������ӣ�CL �������ӣ����д�� AX�����˻�Ϊ 81���������������� AX �С�

## ���̵���

| ���� | ���� | ��; |
|---|---|---|
| PrintTerm | BX=�����ӣ�CX=������ | �������*��=���������沢�ָ� AX��BX��CX��DX |
| PrintUnsigned | AX=�޷������� | ���� 10 ȡ�ࡢѹջ��������������֣����沢�ָ� AX��BX��CX��DX |
| PutChar | DL=�ַ� | ���� INT 21h / AH=02h�����沢�ָ� AX��DX |
| NewLine | �� | ����س��ͻ��У����沢�ָ� DX��AX �� PutChar ���� |

���� BX��CX ��Ϊ����������̲�Ӱ�������ڲ��ѭ��������PUSH �� POP ��˳���෴�����̷��غ�ָ��ֳ������ﲻ�������̵���ǰ�ı�־λ��

��Щ���̶���ͬһ����Σ�ʹ�� NEAR CALL��CALL �����ص�ַ IP ѹջ��RET �ٵ��� IP ���ء����˼Ĵ����ı���ͻָ���ʮ���������ѹ���ÿ������Ҳ�ж�Ӧ�ĵ���������

Դ�ļ����� `.STACK 100h`���� 256 �ֽڡ����� WLINK ���ɵ� EXE ��ʼ SP Ϊ `1000h`�����Ӻ��ջΪ 4 KiB��Դ�ļ����������������Ӳ���Ҫ�ֿ�����

## C ��������

[mult.c](src/mult.c) ������ for ѭ��ʵ����ͬ�������ʹ�� 16 λ�޷��ų˷������Ϊ DX:AX������˻������� 81��ֻ���� AX �͹��ˡ�

- [������](results/mult.txt)��[C �������](results/mult_c.txt)��
- [C ��������](disassembly-notes.md)��
- [�������嵥](results/mult_c.disasm.txt)��[��ർ��](results/mult_c.generated.asm)��[����ע��](results/mult_c.annotated.asm)��

## ����������

���ú� Open Watcom �󣬴ӱ�ʵ��Ŀ¼ִ�У��Ƚ��� .build��bin �� results Ŀ¼��

```text
wasm -q -0 -fo=.build\mult.obj src\mult.asm
wlink system dos option quiet name bin\mult.exe file .build\mult.obj
wcc -q -0 -ms -od -d2 -bt=dos -fo=.build\mult_c.obj src\mult.c
wlink system dos option quiet name bin\mult_c.exe file .build\mult_c.obj
wdis -l=results\mult_c.disasm.txt .build\mult_c.obj
```

�� DOSBox �н��� bin Ŀ¼������ mult �� mult_c�����������ͽ������[��������](../docs/README.md)��
