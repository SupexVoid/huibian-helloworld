# 8086 汇编语言实验

本实验以 8086 指令系统和 DOS 中断为基础，分别研究字符串输出、双重循环、整数求和、乘法运算与过程调用。通过汇编程序、C 程序及反汇编分析，观察寄存器、数据段、堆栈和控制转移指令的使用。

## 实验内容

| 实验 | 文件夹 | 主要内容 |
|---|---|---|
| 一、Hello World | [01_hello_world](01_hello_world) | 汇编与链接；DEBUG 反汇编；直接输入机器码并运行 |
| 二、ASCII 表 | [02_ascii_table](02_ascii_table) | 每行输出 13 个小写字母；LOOP 双重循环；条件转移指令；C 反汇编分析 |
| 三、求和 | [03_sum](03_sum) | 寄存器、数据段和栈内存三种结果存储方式；十进制转换；输入 1～100 的整数求和 |
| 四、九九乘法表 | [04_multiplication](04_multiplication) | 倒三角乘法表；MUL；CALL/RET；过程调用中的寄存器保护与恢复 |

## 实验环境

- 指令集与目标平台：8086、16 位 DOS，small 内存模型。
- 汇编与 C 编译工具：[Open Watcom V2](https://github.com/open-watcom/open-watcom-v2/releases/tag/Current-build) 的 WASM、WCC、WLINK。
- 反汇编工具：WDIS、FreeDOS DEBUG 2.51。
- 运行环境：[DOSBox Staging 0.83.0](https://github.com/dosbox-staging/dosbox-staging/releases/tag/v0.83.0)。

汇编程序采用 MASM 风格语法；C 程序以 8086 指令集编译，并关闭优化，以便分析变量与指令的对应关系。工具版本和校验值见 [TOOLCHAIN.md](TOOLCHAIN.md)。

## 文件结构

各实验目录中的 `src/` 存放源代码，`bin/` 存放 DOS 可执行程序，`results/` 存放运行记录、机器码和反汇编清单。各目录的 README 说明程序原理与实验步骤。

实验一的 `debug/` 存放 DEBUG 操作脚本与指令分析。实验二至四的 `disassembly-notes.md` 说明 C 语句与汇编指令的对应关系：`*.disasm.txt` 记录机器码和段内地址，`*.generated.asm` 记录 WDIS 导出的指令与常量，`*.annotated.asm` 在相同指令上添加中文注释。反汇编清单省略 DWARF 调试元数据。

## 编译与运行

在 Windows PowerShell 中，从仓库根目录运行以下命令，工具路径应替换为本机安装路径：

```powershell
python scripts/build.py --watcom C:\WATCOM
python scripts/run_dos.py --dosbox C:\DOSBox\dosbox.exe
```

构建脚本生成 11 个 EXE 及反汇编清单；实验一的 COM 通过 DEBUG 的 `e`、`w` 命令生成，操作步骤见该实验说明。运行脚本在 DOSBox 中批量执行程序，将输出保存到各实验的 `results/`，并核对结果与格式。脚本使用 Python 标准库，中间文件存放于 `.build/` 和 `.run/`。

也可在 DOSBox 中挂载实验目录，进入相应的 `bin` 文件夹运行。以下以求和实验为例，挂载路径应替换为本机路径：

```dos
mount c "C:\path\huibian-helloworld"
c:
cd 03_sum\bin
sumreg
sumdata
sumstack
sumn
```

`sumn` 读取 1～100 的整数并输出求和结果。其他实验的程序分别为 `hello`、`helloe`、`ascloop`、`ascjump`、`ascii_c`、`sum_c`、`mult` 和 `mult_c`。程序使用 DOS 中断，在 DOS 或 DOSBox 中运行。各实验说明另列出单独编译和 DEBUG 调试命令。

## 实验结果与分析

2026-10-23 的运行记录包含 119 次程序执行，7 组检查均通过：

- EXE 与 COM 两种字符串输出程序均输出 `Hello, World!`。
- ASCII 表的两种汇编实现与 C 实现结果一致，每行输出 13 个字母。
- 三种存储方式的求和程序及 C 程序均输出 `5050`。输入求和覆盖 n=1～100，并检查 8 类非法输入。
- 汇编与 C 乘法表均按行因子从 9 到 1 输出，共 45 个正确算式。

实验一的 DEBUG 记录分别为 [e 命令写入与运行](01_hello_world/results/debug_e.txt) 和 [u 命令反汇编及单步观察](01_hello_world/results/debug_u.txt)。生成的 COM 长度为 30 字节，与输入的机器码一致。

运行结果：[ASCII 表](02_ascii_table/results/ascloop.txt)、[固定求和](03_sum/results/sumreg.txt)、[输入 100 求和](03_sum/results/input_100.txt)、[九九乘法表](04_multiplication/results/mult.txt)。相关记录见 [编译日志](BUILD_LOG.txt)、[模拟器日志](DOSBOX_LOG.txt) 和 [测试记录](TEST_REPORT.txt)。

对已保存的运行结果进行校验：

```powershell
python scripts/verify.py
```
