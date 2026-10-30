# ʵ��һ��Hello World

�����ַ�ʽ��� Hello, World!��һ�Ǳ�д���Դ�ļ������� EXE������ͨ�� DEBUG ��������벢���� COM��

## ������

Դ���� [src/hello.asm](src/hello.asm)�����ɵĳ����� [bin/hello.exe](bin/hello.exe)��

�����ȳ�ʼ�� DS���ٰ��ַ�����ַ���� DX��ͨ�� INT 21h �� AH=09h ��������ַ������ַ����� $ ������$ ��������ʾ��ĩβ�� 13��10 �ֱ��ǻس��ͻ��С�

������� small ģ�ͣ����������λ�ڲ�ͬ�Ρ�EXE ������ʱ DS ָ�� PSP����˲���ʡ�����ݶγ�ʼ����

```asm
mov ax, @data
mov ds, ax
```

## DEBUG ���������

�� DOSBox �н��뱾ʵ��� bin Ŀ¼��׼���� FreeDOS DEBUG ��ִ�У�

```text
DEBUG < ..\DEBUG\HELLO_E.DBG
```

�ű��� e д������룬�� u �鿴ָ��� w ����Ϊ HELLOE.COM������ g=0100 ���С��ļ��� 30 �ֽڣ�����ǰ 14 �ֽ���ָ��� 16 �ֽ����ַ�����

[DEBUG ����˵��](debug/README.md)�г�����������������ָ��Ķ�Ӧ��ϵ��DEBUG �ǵ����� DOS ���ߣ���Ҫ���� DOS ����������·�������� DOSBox �Դ������������ͬ��

## ���н��

���ֳ���������

```text
Hello, World!
```

- [EXE ���](results/hello.txt)��[COM ���](results/helloe.txt)
- [���������� DEBUG ��¼](results/debug_e.txt)
- [EXE ������뵥����¼](results/debug_u.txt)

EXE �� COM ��һ�������ǣ�EXE ����Ҫ��ʼ�� DS ָ�����ݶΣ����� COM �Ĵ�����������ͬһ�Σ�ͨ�� PUSH CS / POP DS ���� DS��

## ��������

�ӱ�ʵ��Ŀ¼ִ�У��Ƚ��� .build �� bin Ŀ¼������ Open Watcom ���߼��� PATH��

```text
wasm -q -0 -fo=.build\hello.obj src\hello.asm
wlink system dos option quiet name bin\hello.exe file .build\hello.obj
```

ȫ��ʵ��Ĺ���������[��������](../docs/README.md)��
