# 实验四：倒三角九九乘法表

输出标题 `The 9mul9 table:`，再输出 9 行乘法式。第一行从 `9*1=9` 到 `9*9=81`，第二行从 `8*1=8` 到 `8*8=64`，最后一行是 `1*1=1`，共 45 项。相邻算式之间用两个空格分隔，行末不加空格。

## 循环与乘法

[mult.asm](src/mult.asm) 用 BX 保存行因子，从 9 递减到 1；用 CX 保存列因子，每行从 1 增加到 BX。

每次调用 PrintTerm 输出一个算式。因子都在 1～9 内，可以加上 '0' 转为单个字符；乘积可能有两位，需要调用十进制输出过程。

乘法使用 `MUL CL`：AL 是行因子，CL 是列因子，结果写入 AX。最大乘积为 81，可以完整保存在 AX 中。

## 过程调用

| 过程 | 输入 | 用途 |
|---|---|---|
| PrintTerm | BX=行因子，CX=列因子 | 输出“行*列=积”，保存并恢复 AX、BX、CX、DX |
| PrintUnsigned | AX=无符号整数 | 除以 10 取余、压栈，再逆序输出数字；保存并恢复 AX、BX、CX、DX |
| PutChar | DL=字符 | 调用 INT 21h / AH=02h，保存并恢复 AX、DX |
| NewLine | 无 | 输出回车和换行，保存并恢复 DX，AX 由 PutChar 保护 |

保存 BX、CX 是为了让输出过程不影响外层和内层的循环计数。PUSH 与 POP 的顺序相反，过程返回后恢复现场；这里不依赖过程调用前的标志位。

这些过程都在同一代码段，使用 NEAR CALL。CALL 将返回地址 IP 压栈，RET 再弹出 IP 返回。除了寄存器的保存和恢复，十进制输出中压入的每个余数也有对应的弹出操作。

源文件声明 `.STACK 100h`，即 256 字节。这里 WLINK 生成的 EXE 初始 SP 为 `1000h`，链接后的栈为 4 KiB；源文件的声明与最终链接布局要分开看。

## C 程序与结果

[mult.c](src/mult.c) 用两层 for 循环实现相同输出。它使用 16 位无符号乘法，结果为 DX:AX；本题乘积不超过 81，只保存 AX 就够了。

- [汇编输出](results/mult.txt)、[C 程序输出](results/mult_c.txt)。
- [C 反汇编分析](disassembly-notes.md)。
- [机器码清单](results/mult_c.disasm.txt)、[汇编导出](results/mult_c.generated.asm)、[中文注释](results/mult_c.annotated.asm)。

## 编译与运行

配置好 Open Watcom 后，从本实验目录执行，先建立 .build、bin 和 results 目录：

```text
wasm -q -0 -fo=.build\mult.obj src\mult.asm
wlink system dos option quiet name bin\mult.exe file .build\mult.obj
wcc -q -0 -ms -od -d2 -bt=dos -fo=.build\mult_c.obj src\mult.c
wlink system dos option quiet name bin\mult_c.exe file .build\mult_c.obj
wdis -l=results\mult_c.disasm.txt .build\mult_c.obj
```

在 DOSBox 中进入 bin 目录，运行 mult 或 mult_c。批量构建和结果检查见[构建与检查](../docs/README.md)。
