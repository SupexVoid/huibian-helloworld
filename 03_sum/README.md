# ʵ���������

�������ִ洢��ʽ���� 1+2+��+100����ʵ������ n ����� 1+2+��+n���̶���͵Ľ���� 5050��

## ���ִ洢��ʽ

| Դ�� | �ۼӽ���������� | ����ָ�� |
|---|---|---|
| [sumreg.asm](src/sumreg.asm) | �Ĵ��� AX | ADD AX,CX |
| [sumdata.asm](src/sumdata.asm) | ���ݶε� word ���� total | ADD total,CX |
| [sumstack.asm](src/sumstack.asm) | ջ�еľֲ����� | ADD WORD PTR [BP-2],CX |

���������� CX �� 100 �ݼ��� 1���� LOOP ����ۼӡ�5050 �����˵��ֽڵı�ʾ��Χ�����ʹ�� 16 λ���ݱ��档

ջ�汾��ִ�� PUSH BP / MOV BP,SP / SUB SP,2���������ֽھֲ��ռ䡣BP ѰַĬ��ʹ�� SS������ [BP-2] ��Ӧջ�ڴ档����ʱͨ�� MOV SP,BP / POP BP �ָ�ջ��

## ʮ�������

���������� [sumio.inc](src/sumio.inc) �е� print_uint ���̣������� AX �е��޷���������

���������� 10��������ѹջ�������ε����������ַ� '0' ����������� 5050 �õ������������� 0��5��0��5����ջ�������ȷ�����˳��ÿ�γ���ǰ���� DX�����̽���ʱ�ָ� AX��BX��CX��DX��

## ���� n �����

[sumn.asm](src/sumn.asm) ʹ�� INT 21h �� AH=0Ah ���ܶ�ȡ���롣���뻺������ǰ�����ֽڷֱ��¼���������볤�ȣ��������ַ���

���� `value = value * 10 + digit` ���ַ�ת����������ֻ���� 1��3 λ���֣���������Ƿ��� 1��100 �ڡ��������� 999���м�ֵ���ᷢ�� 16 λ����������롢�����ֻ�Խ��ʱ��ʾ�������룻`001` ��������λǰ����������Խ��ܡ�

���� 10 ʱ�����

```text
Enter n (1-100): 10
Sum = 55
```

## ��������

- ���̶ֹ���������[�Ĵ���](results/sumreg.txt)��[���ݶ�](results/sumdata.txt)��[ջ](results/sumstack.txt)��
- ����ʾ����[n=1](results/input_001.txt)��[n=10](results/input_010.txt)��[n=100](results/input_100.txt)��
- ��������ʾ����[������](results/invalid_empty.txt)��[Խ��](results/invalid_large.txt)��[��������](results/invalid_long.txt)��
- [C Դ��](src/sum.c)����[��������](disassembly-notes.md)��[�������嵥](results/sum_c.disasm.txt)��[��ർ��](results/sum_c.generated.asm)��[����ע��](results/sum_c.annotated.asm)��

results/ ������ n=1��100 �� 8 ��Ƿ���������м�¼��������齫����� n(n+1)/2 ���գ�������[��������](../docs/README.md)��

## ��������

���ú� Open Watcom ���ڱ�ʵ��� src Ŀ¼ִ�С�������һ������ .build��bin �� results Ŀ¼��

```text
wasm -q -0 -fo=..\.build\sumreg.obj sumreg.asm
wlink system dos option quiet name ..\bin\sumreg.exe file ..\.build\sumreg.obj
wcc -q -0 -ms -od -d2 -bt=dos -fo=..\.build\sum_c.obj sum.c
wlink system dos option quiet name ..\bin\sum_c.exe file ..\.build\sum_c.obj
wdis -l=..\results\sum_c.disasm.txt ..\.build\sum_c.obj
```

��������������ֻ���滻�ļ������������ DOSBox �н��� bin Ŀ¼���С�
