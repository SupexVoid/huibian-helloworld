# 8086 汇编实验

这里整理了四个汇编实验的源码、运行结果和反汇编分析。程序面向 16 位 DOS，使用 DOSBox 运行。

## 实验目录

1. [Hello World](01_hello_world)：输出字符串，练习汇编、链接和 DEBUG 操作。
2. [字母表输出](02_ascii_table)：分别用 LOOP 和条件跳转实现双重循环，每行输出 13 个小写字母。
3. [求和](03_sum)：把累加结果分别放在寄存器、数据段和栈中，并实现输入 n 后求和。
4. [九九乘法表](04_multiplication)：输出倒三角乘法表，练习乘法指令和过程调用。

每个实验目录下，`src/` 是源码，`bin/` 是 DOS 可执行文件，`results/` 是输出和反汇编清单。实验二到四还附有 C 程序，方便对照编译后的指令。

## 使用环境

- 汇编、编译和链接：Open Watcom V2（WASM、WCC、WLINK）。
- 运行：DOSBox Staging 0.83.0。
- 调试、反汇编：FreeDOS DEBUG 2.51、WDIS。

汇编采用 MASM 风格语法。C 程序按 8086 指令集、小内存模型编译，关闭优化，便于对照源码。工具下载、编译参数和检查记录放在[环境与工具](docs/environment.md)中。

## 怎么运行

先在 DOSBox 中挂载仓库目录，再进入相应的 bin 文件夹。例如运行求和程序：

```text
mount c "C:\path\huibian-helloworld"
c:
cd 03_sum\bin
sumreg
sumdata
sumstack
sumn
```

`sumreg`、`sumdata`、`sumstack` 输出 5050；`sumn` 需要输入 1～100 的整数。其他实验的运行方法见各自的 README。这些 EXE 是 DOS 程序，不能直接当作 Windows 控制台程序运行。

需要重新编译或批量检查时，见[构建与检查](docs/README.md)。
