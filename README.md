# 8086 汇编语言四次作业

按题目截图完成的四个独立作业。每个文件夹包含源码、DOS 可执行程序、实际运行结果和中文说明；第 2～4 题还包含 C 对照实现与真实编译结果的反汇编注释。

| 作业 | 文件夹 | 已实现内容 |
|---|---|---|
| 1. Hello World | [01_hello_world](01_hello_world) | 汇编→链接 EXE；DEBUG `u` 观察源码与机器码；DEBUG `e` 写入代码和数据并执行、生成 COM |
| 2. ASCII 表 | [02_ascii_table](02_ascii_table) | 小写 a～z，每行 13 个；LOOP 双循环、条件跳转双循环、C 对照 |
| 3. 求和 | [03_sum](03_sum) | 寄存器／数据段／栈三种存储方式；打印 5050；输入 1～100 求和；C 对照 |
| 4. 九九乘法表 | [04_multiplication](04_multiplication) | 按题图从 9 到 1 的倒三角乘法表；MUL、CALL/RET、寄存器保护与恢复、C 对照 |

## 查看与运行

每题的 `src/` 是带注释的源代码，`bin/` 是已生成的 16 位 DOS 程序，`results/` 是实际输出、机器码和反汇编清单。每题 README 均提供要求与文件的对应表。第 1 题的 `debug/` 另附 DEBUG 实验步骤和可重放脚本，第 2～4 题的 `disassembly-notes.md` 解释实际指令与 C 语句的关系。

直接下载仓库后，可以在 DOSBox 中挂载本地目录，再进入某题的 `bin` 文件夹运行程序。示例（把本机仓库路径替换为实际路径）：

```dos
mount c "C:\path\huibian-helloworld"
c:
cd 03_sum\bin
sumreg
sumdata
sumstack
sumn
```

`sumn` 会提示输入 1～100 的整数。其余题目分别执行 `hello`／`helloe`、`ascloop`／`ascjump`／`ascii_c`、`mult`／`mult_c`。C 固定求和版本执行 `sum_c`。这些程序使用 DOS 中断，需要 DOS 或 DOSBox，不能作为现代 Windows 原生程序直接启动。

## 从源码重建

使用 [Open Watcom V2 官方发行](https://github.com/open-watcom/open-watcom-v2/releases/tag/Current-build) 的 WASM、WCC、WLINK、WDIS，和 [DOSBox Staging 0.83.0](https://github.com/dosbox-staging/dosbox-staging/releases/tag/v0.83.0)。手写汇编采用 8086 指令、MASM 风格的小内存模型；C 编译为 8086、16 位 small model，关闭优化便于学习反汇编。

在 Windows PowerShell 中，从仓库根目录运行（替换工具路径）：

```powershell
python scripts/build.py --watcom C:\WATCOM
python scripts/run_dos.py --dosbox C:\DOSBox\dosbox.exe
```

Python 脚本仅使用标准库。第一步生成 11 个 EXE 和真实反汇编；第 1 题的 COM 已由 DEBUG `e` 实验生成，也可以按该题脚本重建。第二步在隐藏的 DOSBox 中执行程序，重定向结果到每题的 `results/`，随后自动核对输出。中间文件保存在忽略的 `.build/` 和 `.run/` 中。

中文注释版 `*.annotated.asm` 是对 `wdis -a` 实际输出添加的学习注释；`*.disasm.txt` 显示真实机器码和段内地址，`*.generated.asm` 保留工具生成的代码及常量。为方便阅读和避免混入本机路径，导出省略了 DWARF 调试元数据。重新构建会更新原始清单，修改 C 程序后需同步核对中文注释版。

传统 MASM/LINK 的单题构建与 DEBUG 操作示例见各题说明；本仓库实际验证使用上述 Open Watcom 工具链。工具版本与下载校验值见 [TOOLCHAIN.md](TOOLCHAIN.md)。

## 实际验证结果

2026-10-23，在 DOSBox Staging 0.83.0 中完成 **119 次程序运行**，7 组自动检查全部通过：Hello World 两种文件格式、ASCII 三种实现、四个固定求和程序、全部 100 个合法 n、8 类非法输入，以及汇编/C 两种乘法表的全部 45 个算式。

第 1 题另使用 **FreeDOS DEBUG 2.51** 完成两次真实会话，记录 [DEBUG e 写内存并执行](01_hello_world/results/debug_e.txt) 和 [DEBUG u／单步／观察数据段](01_hello_world/results/debug_u.txt)。COM 文件与 DEBUG 实际写出的 30 字节一致。

代表性结果：[ASCII 表](02_ascii_table/results/ascloop.txt)、[5050](03_sum/results/sumreg.txt)、[输入 100](03_sum/results/input_100.txt)、[九九乘法表](04_multiplication/results/mult.txt)。完整构建日志为 [BUILD_LOG.txt](BUILD_LOG.txt)，模拟器日志为 [DOSBOX_LOG.txt](DOSBOX_LOG.txt)，验收报告为 [TEST_REPORT.txt](TEST_REPORT.txt)。

只检查已保存的结果，无需安装编译器和 DOSBox：

```powershell
python scripts/verify.py
```

运行结果均由实际程序生成，保存为文本记录，便于直接在 GitHub 中查看。
