# ʵ�������ĸ�����

��� 26 ��Сд��ĸ��ÿ�� 13 ������ĸ֮��һ���ո���ĩ���ӿո�

```text
a b c d e f g h i j k l m
n o p q r s t u v w x y z
```

## ����ѭ��д��

[ascloop.asm](src/ascloop.asm) ʹ������ LOOP�����ִ�� 2 �Σ��ڲ�ִ�� 13 �Ρ����� LOOP ʹ�� CX �����������ڲ�ǰ�� PUSH CX �������������ڲ������ POP CX �ָ�����ִ����� LOOP��

[ascjump.asm](src/ascjump.asm) ʹ��������ת��BH ����ʣ��������CX ���汾��ʣ����ĸ�����ֱ�ͨ�� DEC / JNZ ����ѭ������ʹ�� LOOP��

���ֳ����� BL ���浱ǰ��ĸ���� 'a' ��ʼ��ÿ���һ����ĸ�ͼ�һ�������Ǳ������һ����ĸ�������һ���ո񡣻���ʹ�� DOS �� CR/LF���� 13��10��

������̻ᱣ��ͻָ� AX��BX��CX��DX������Ӱ����������ַ���ѭ��������

## C �����뷴���

[ascii.c](src/ascii.c) ������ for ѭ��ʵ����ͬ������ر��Ż���ѭ������λ��ջ�У�ѭ����Ҫ�� CMP ��������תʵ�֣���һ������ LOOP ָ�

- [��������](disassembly-notes.md)���ֲ�������ѭ���� printf ���á�
- [�������嵥](results/ascii_c.disasm.txt)��[��ർ��](results/ascii_c.generated.asm)��[����ע��](results/ascii_c.annotated.asm)��

## ����

�� DOSBox �н��뱾ʵ��� bin Ŀ¼���ֱ����У�

```text
ascloop
ascjump
ascii_c
```

����ʵ�ֵ����һ�£���¼�ֱ�� [ascloop.txt](results/ascloop.txt)��[ascjump.txt](results/ascjump.txt)��[ascii_c.txt](results/ascii_c.txt)��

## ��������

���ú� Open Watcom �󣬴ӱ�ʵ��Ŀ¼ִ�У��Ƚ��� .build��bin��results Ŀ¼��

```text
wasm -q -0 -fo=.build\ascloop.obj src\ascloop.asm
wlink system dos option quiet name bin\ascloop.exe file .build\ascloop.obj
wasm -q -0 -fo=.build\ascjump.obj src\ascjump.asm
wlink system dos option quiet name bin\ascjump.exe file .build\ascjump.obj
wcc -q -0 -ms -od -d2 -bt=dos -fo=.build\ascii_c.obj src\ascii.c
wlink system dos option quiet name bin\ascii_c.exe file .build\ascii_c.obj
wdis -l=results\ascii_c.disasm.txt .build\ascii_c.obj
```

�������ú���������������[��������](../docs/README.md)��
