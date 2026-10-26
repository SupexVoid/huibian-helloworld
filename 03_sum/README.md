# 实验三：求和与十进制输入输出

计算 `1+2+…+100` 并打印十进制结果 `5050`，分别考察寄存器、数据段和栈内存三种结果存储方式；通过 DOS 缓冲输入读取 `1～100` 的整数 `n`，计算并输出 `1+…+n`。

| 实验内容 | 源码 | DOS 程序 | 运行结果 |
|---|---|---|---|
| 结果保存在寄存器中 | [sumreg.asm](src/sumreg.asm) | [sumreg.exe](bin/sumreg.exe) | [5050](results/sumreg.txt) |
| 结果保存在数据段中 | [sumdata.asm](src/sumdata.asm) | [sumdata.exe](bin/sumdata.exe) | [5050](results/sumdata.txt) |
| 结果保存在栈中 | [sumstack.asm](src/sumstack.asm) | [sumstack.exe](bin/sumstack.exe) | [5050](results/sumstack.txt) |
| 输入 n 并输出结果 | [sumn.asm](src/sumn.asm) | [sumn.exe](bin/sumn.exe) | [n=1](results/input_001.txt)、[n=10](results/input_010.txt)、[n=100](results/input_100.txt) |
| C 实现及反汇编注释 | [sum.c](src/sum.c) | [sum_c.exe](bin/sum_c.exe) | [5050](results/sum_c.txt) |

所有汇编为 8086 指令、MASM 小内存模型；输出过程在 [sumio.inc](src/sumio.inc)，由各程序在汇编时包含，各 EXE 可以独立运行。

## 三种存储位置

寄存器版执行 `ADD AX,CX`，AX 始终保存累加结果；数据段版执行 `ADD total,CX`，DS 指向数据段，`total` 是一个 `DW`；栈版通过 `PUSH BP / MOV BP,SP / SUB SP,2` 分配局部变量，执行 `ADD WORD PTR [BP-2],CX`。BP 寻址默认使用 SS，因此最后一种确实在栈内保存结果。

固定版本让 CX 从 100 递减到 1，使用 LOOP 累加。结果 `5050 = 13BAh`，超过 8 位无符号数的最大值 255，但小于 16 位有符号数的最大值 32767，也小于无符号数的最大值 65535，因此结果变量和累加寄存器均使用 16 位。不要用单字节变量保存 5050，也不能直接给二进制数加 `'0'` 就输出多位十进制数。

## 十进制转换

`print_uint` 接收 AX，先保存 AX/BX/CX/DX。每次把 DX 清零，再除以 10，将余数压栈，直到商为 0；之后逐个弹出余数，加 `'0'`，调用 `INT 21h/AH=02h` 输出。压栈逆序的处理使最高位先输出。程序也能正确打印 0。每个压栈均有对应出栈，过程结束时原寄存器恢复，标志位可以改变。

例如 5050 的除法依次得到余数 0、5、0、5，逆序打印即 `5050`。

## 输入版本

`INT 21h/AH=0Ah` 用于缓冲键盘输入，DS:DX 指向 `inputbuf`：第 0 字节是容量，第 1 字节是实际字符数，第 2 字节开始是用户输入，末尾有回车。程序只接受 1～3 位数字，并检查数值在 1～100 内；最多解析 999，解析的中间值不会发生 16 位溢出。允许 `001` 这种最多 3 位的前导零写法；空白、符号、小数、字母、过长输入和越界值均提示重新输入。

循环执行 `value = value*10 + digit` 取得 n，再累加 1 到 n。输入 `10` 的实际结果：

```text
Enter n (1-100): 10
Sum = 55
```

完整原始记录见链接；DOS 0Ah 的输入回显和显式换行在重定向记录中可能产生空行，校验器从 `Sum =` 后读取结果。

## 编译与运行

统一构建方法见 [实验总说明](../README.md)。单独构建一个程序时，在本目录 `src` 下运行（先建立 `bin`、`.build`、`results`）：

```bat
wasm -q -0 -fo=..\.build\sumreg.obj sumreg.asm
wlink system dos option quiet name ..\bin\sumreg.exe file ..\.build\sumreg.obj
wcc -q -0 -ms -od -d2 -bt=dos -fo=..\.build\sum_c.obj sum.c
wlink system dos option quiet name ..\bin\sum_c.exe file ..\.build\sum_c.obj
wdis -l=..\results\sum_c.disasm.txt ..\.build\sum_c.obj
```

将相应 EXE 所在目录挂载到 DOSBox，再执行 `sumreg`、`sumdata`、`sumstack` 或 `sumn`。这些是 DOS 16 位 EXE，需要 DOS 环境运行。

## C 反汇编与验证

[真实机器码清单](results/sum_c.disasm.txt)、[真实反汇编汇编文本](results/sum_c.generated.asm)、[中文逐段注释](results/sum_c.annotated.asm)、[变量与指令对照说明](disassembly-notes.md)。

实际运行了全部 100 个合法输入，结果均与 `n(n+1)/2` 核对；另运行了 8 类非法输入并在提示后输入 10，均得到 55。记录位于 `results/input_001.txt` 到 `input_100.txt` 和 `invalid_*.txt`。例如 [空输入](results/invalid_empty.txt)、[101 越界](results/invalid_large.txt)、[过长数字](results/invalid_long.txt)。这些输出由统一运行脚本从 DOSBox 获取。
