# 实验二：字母表输出

输出 26 个小写字母，每行 13 个，字母之间一个空格，行末不加空格：

```text
a b c d e f g h i j k l m
n o p q r s t u v w x y z
```

## 两种循环写法

[ascloop.asm](src/ascloop.asm) 使用两层 LOOP。外层执行 2 次，内层执行 13 次。由于 LOOP 使用 CX 计数，进入内层前先 PUSH CX 保存外层计数，内层结束后 POP CX 恢复，再执行外层 LOOP。

[ascjump.asm](src/ascjump.asm) 使用条件跳转。BH 保存剩余行数，CX 保存本行剩余字母数，分别通过 DEC / JNZ 控制循环，不使用 LOOP。

两种程序都用 BL 保存当前字母，从 'a' 开始，每输出一个字母就加一。若不是本行最后一个字母，再输出一个空格。换行使用 DOS 的 CR/LF，即 13、10。

输出过程会保存和恢复 AX、BX、CX、DX，避免影响主程序的字符和循环计数。

## C 程序与反汇编

[ascii.c](src/ascii.c) 用两层 for 循环实现相同输出。关闭优化后，循环变量位于栈中，循环主要由 CMP 和条件跳转实现，不一定生成 LOOP 指令。

- [反汇编分析](disassembly-notes.md)：局部变量、循环和 printf 调用。
- [机器码清单](results/ascii_c.disasm.txt)、[汇编导出](results/ascii_c.generated.asm)、[中文注释](results/ascii_c.annotated.asm)。

## 运行

在 DOSBox 中进入本实验的 bin 目录，分别运行：

```text
ascloop
ascjump
ascii_c
```

三种实现的输出一致，记录分别见 [ascloop.txt](results/ascloop.txt)、[ascjump.txt](results/ascjump.txt)、[ascii_c.txt](results/ascii_c.txt)。

## 单独编译

配置好 Open Watcom 后，从本实验目录执行，先建立 .build、bin、results 目录：

```text
wasm -q -0 -fo=.build\ascloop.obj src\ascloop.asm
wlink system dos option quiet name bin\ascloop.exe file .build\ascloop.obj
wasm -q -0 -fo=.build\ascjump.obj src\ascjump.asm
wlink system dos option quiet name bin\ascjump.exe file .build\ascjump.obj
wcc -q -0 -ms -od -d2 -bt=dos -fo=.build\ascii_c.obj src\ascii.c
wlink system dos option quiet name bin\ascii_c.exe file .build\ascii_c.obj
wdis -l=results\ascii_c.disasm.txt .build\ascii_c.obj
```

工具配置和批量构建方法见[构建与检查](../docs/README.md)。
