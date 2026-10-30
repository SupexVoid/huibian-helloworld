# 实验三：求和

先用三种存储方式计算 1+2+…+100，再实现输入 n 后计算 1+2+…+n。固定求和的结果是 5050。

## 三种存储方式

| 源码 | 累加结果放在哪里 | 核心指令 |
|---|---|---|
| [sumreg.asm](src/sumreg.asm) | 寄存器 AX | ADD AX,CX |
| [sumdata.asm](src/sumdata.asm) | 数据段的 word 变量 total | ADD total,CX |
| [sumstack.asm](src/sumstack.asm) | 栈中的局部变量 | ADD WORD PTR [BP-2],CX |

三个程序都让 CX 从 100 递减到 1，用 LOOP 完成累加。5050 超出了单字节的表示范围，因此使用 16 位数据保存。

栈版本先执行 PUSH BP / MOV BP,SP / SUB SP,2，留出两字节局部空间。BP 寻址默认使用 SS，所以 [BP-2] 对应栈内存。结束时通过 MOV SP,BP / POP BP 恢复栈。

## 十进制输出

几个程序共用 [sumio.inc](src/sumio.inc) 中的 print_uint 过程，输入是 AX 中的无符号整数。

它反复除以 10，把余数压栈，再依次弹出、加上字符 '0' 后输出。例如 5050 得到的余数依次是 0、5、0、5，弹栈后就是正确的输出顺序。每次除法前清零 DX，过程结束时恢复 AX、BX、CX、DX。

## 输入 n 后求和

[sumn.asm](src/sumn.asm) 使用 INT 21h 的 AH=0Ah 功能读取输入。输入缓冲区的前两个字节分别记录容量和输入长度，后面存放字符。

程序按 `value = value * 10 + digit` 将字符转换成整数，只接受 1～3 位数字，并检查结果是否在 1～100 内。最多解析到 999，中间值不会发生 16 位溢出。空输入、非数字或越界时提示重新输入；`001` 这样的三位前导零输入可以接受。

输入 10 时输出：

```text
Enter n (1-100): 10
Sum = 55
```

## 结果与对照

- 三种固定求和输出：[寄存器](results/sumreg.txt)、[数据段](results/sumdata.txt)、[栈](results/sumstack.txt)。
- 输入示例：[n=1](results/input_001.txt)、[n=10](results/input_010.txt)、[n=100](results/input_100.txt)。
- 错误输入示例：[空输入](results/invalid_empty.txt)、[越界](results/invalid_large.txt)、[过长数字](results/invalid_long.txt)。
- [C 源码](src/sum.c)及其[反汇编分析](disassembly-notes.md)、[机器码清单](results/sum_c.disasm.txt)、[汇编导出](results/sum_c.generated.asm)、[中文注释](results/sum_c.annotated.asm)。

results/ 保留了 n=1～100 和 8 类非法输入的运行记录。批量检查将结果与 n(n+1)/2 对照，方法见[构建与检查](../docs/README.md)。

## 单独编译

配置好 Open Watcom 后，在本实验的 src 目录执行。先在上一级建立 .build、bin 和 results 目录：

```text
wasm -q -0 -fo=..\.build\sumreg.obj sumreg.asm
wlink system dos option quiet name ..\bin\sumreg.exe file ..\.build\sumreg.obj
wcc -q -0 -ms -od -d2 -bt=dos -fo=..\.build\sum_c.obj sum.c
wlink system dos option quiet name ..\bin\sum_c.exe file ..\.build\sum_c.obj
wdis -l=..\results\sum_c.disasm.txt ..\.build\sum_c.obj
```

另外三个汇编程序只需替换文件名。编译后在 DOSBox 中进入 bin 目录运行。
