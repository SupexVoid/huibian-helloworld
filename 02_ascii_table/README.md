# 作业二：按 ASCII 码输出 a～z

将 26 个小写英文字母依次输出，每行 13 个，字母之间只有一个空格，行末没有多余空格。两行均以 DOS 的 CR/LF（十六进制 `0D 0A`）结束。

```text
a b c d e f g h i j k l m
n o p q r s t u v w x y z
```

| 要求 | 对应文件 | 实现要点 |
| --- | --- | --- |
| 用 LOOP 指令实现双重循环 | `src/ascloop.asm` | 外层循环 2 次，内层循环 13 次；内层开始前 `PUSH CX`，结束后 `POP CX`，保留外层计数 |
| 用条件转移指令实现双重循环 | `src/ascjump.asm` | 内层 `DEC CX / JNZ`，外层 `DEC BH / JNZ` |
| 用 C 实现同样功能 | `src/ascii.c` | C89 的双层 `for` 循环，`printf` 输出字符、间隔和换行 |
| 分析编译后的汇编 | `results/ascii_c.disasm.txt`、`results/ascii_c.annotated.asm`、`disassembly-notes.md` | 原始反汇编来自实际编译的 C 目标文件，中文注释解释变量、循环、调用和栈 |

## 程序原理

小写字母的 ASCII 码从 `'a' = 61h = 97` 连续排列到 `'z' = 7Ah = 122`。汇编程序以 `BL` 保存当前字符，每输出一个字母后执行 `INC BL`。第一行输出 `61h～6Dh`（a～m），第二行输出 `6Eh～7Ah`（n～z）。空格为 `20h`，回车为 `0Dh`，换行为 `0Ah`。

`LOOP` 隐含使用 `CX`：先将 `CX` 减一，不为零则跳转。因此内、外循环不能同时把自己的计数留在同一个 `CX` 中。`ascloop.asm` 先把外层的 `CX` 压栈，再装入内层计数 13；内层结束时 `CX` 为 0，弹栈恢复外层计数后才执行外层 `LOOP`。两次压栈分别对应两次弹栈，堆栈保持平衡。

`ascjump.asm` 使用独立计数：`BH` 保存剩余行数，`CX` 保存本行剩余字母数，`BL` 保存当前字母。条件循环用 `DEC` 设置零标志，再由 `JNZ` 判断是否继续；该文件不使用 `LOOP`。

两种汇编程序都在输出字母之后判断当前是否为本行最后一个字母，只有不是最后一个时才输出空格。`put_char` 使用 DOS `INT 21h / AH=02h`，输入为 `DL`；`put_newline` 使用 `INT 21h / AH=09h` 输出 `13,10,'$'`。两个过程均保存并恢复 `AX/BX/CX/DX`，避免输出调用破坏主程序的字符和循环计数。`main` 通过 `INT 21h / AX=4C00h` 返回 DOS，退出码为 0。

## 编译与运行

所有汇编源文件限定 `.8086`，使用 MASM 风格的 `.model small`、`.stack`、`.data` 和 `.code`。以下命令从本目录执行；先创建 `bin` 与 `results`，并将相应工具加入 `PATH`。

在 DOS 的 MASM 5.x / LINK 环境中：

```bat
masm src\ascloop.asm,bin\ascloop.obj,nul,nul;
link bin\ascloop.obj,bin\ascloop.exe,nul;
masm src\ascjump.asm,bin\ascjump.obj,nul,nul;
link bin\ascjump.obj,bin\ascjump.exe,nul;
```

使用 Open Watcom v2 的 Windows 主机工具构建 16 位 DOS 程序：

```bat
wasm -q -0 -fo=bin\ascloop.obj src\ascloop.asm
wlink system dos option quiet name bin\ascloop.exe file bin\ascloop.obj
wasm -q -0 -fo=bin\ascjump.obj src\ascjump.asm
wlink system dos option quiet name bin\ascjump.exe file bin\ascjump.obj
wcc -q -0 -ms -od -d2 -fo=bin\ascii_c.obj src\ascii.c
wlink system dos option quiet name bin\ascii_c.exe file bin\ascii_c.obj
wdis -l=results\ascii_c.disasm.txt bin\ascii_c.obj
wdis -a -l=results\ascii_c.generated.asm bin\ascii_c.obj
```

`-0` 指定 8086 指令集；`-ms` 使用 small 内存模型；`-od` 关闭优化以便对照 C 源码；`-d2` 保留调试信息。C 编译和链接还需要安装目录中的 DOS 头文件及库，按根目录的工具链说明设置 `WATCOM`、`PATH` 和 `INCLUDE`。C 程序的 `\n` 经 DOS C 运行库的文本输出转换成 CR/LF。

在真实 DOS 或 DOSBox 中运行，可将原始输出保存到文件：

```bat
bin\ascloop.exe > results\ascloop.txt
bin\ascjump.exe > results\ascjump.txt
bin\ascii_c.exe > results\ascii_c.txt
```

Windows 不能直接执行这些 16 位 DOS EXE。完整的自动构建、DOSBox 运行和输出校验方法见仓库根目录说明及 `scripts`。
