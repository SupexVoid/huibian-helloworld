# 实验一：Hello, World!

本目录用两种方式生成并运行 8086 DOS 程序。两者均调用 DOS `int 21h` 的 `AH=09h` 功能，输出 `Hello, World!` 和 DOS 换行（`0D 0A`）。字符串末尾的 `$` 是结束标志，不属于输出内容。

## 文件

| 文件 | 用途 |
| --- | --- |
| `src/hello.asm` | 传统汇编程序源代码，small 内存模型 |
| `bin/hello.exe` | 汇编、链接产生的 DOS MZ EXE |
| `bin/helloe.com` | 用 FreeDOS DEBUG 的 `e`、`w` 命令实际生成的 30 字节 COM |
| `debug/hello_e.dbg` | DEBUG 的 `e` 命令输入、反汇编、保存、运行脚本 |
| `debug/hello_u.dbg` | 装入传统 EXE 后查看寄存器与入口反汇编的脚本 |
| `debug/README.md` | 命令说明、地址计算、机器码与指令的对应关系 |
| `results/hello.txt` | 在 DOSBox 中运行 EXE 后重定向保存的实际输出 |
| `results/helloe.txt` | 在 DOSBox 中运行 COM 后重定向保存的实际输出 |
| `results/debug_e.txt` | 在 DOSBox 中实际执行 DEBUG 输入、反汇编、保存、运行的原始文本记录 |
| `results/debug_u.txt` | 在 DOSBox 中实际装入 EXE、反汇编、单步和运行的原始文本记录 |

## 方法一：编辑、汇编、链接、运行

在仓库根目录按根 README 的环境说明运行构建脚本。其关键步骤等价于：

```text
wasm -q -0 -fo=01_hello_world/.build/hello.obj 01_hello_world/src/hello.asm
wlink system dos option quiet name 01_hello_world/bin/hello.exe file 01_hello_world/.build/hello.obj
```

`wasm` 生成 16 位 OMF 目标文件，`wlink system dos` 将其链接为 DOS MZ EXE。`.build`、`bin` 目录应先创建。运行时应使用 DOS 或 DOSBox，不能将这个 16 位程序当作 Windows 控制台程序直接运行。

在 DOS 中切换到 `01_hello_world\bin` 后：

```text
HELLO.EXE
```

屏幕输出为：

```text
Hello, World!
```

small 模型将代码与数据放在不同段中。DOS 装入 EXE 后，`CS:IP` 指向入口，但 `DS` 初始指向 PSP。因此程序先将 `@data` 经 AX 装入 DS，再以 `DS:DX` 指向字符串。

## 方法二：用 DEBUG 的 e 命令直接输入机器码

这一路径不需要汇编器或链接器。在带有 DEBUG 的 DOS 环境中，切换到本目录的 `bin` 后执行：

```text
DEBUG < ..\DEBUG\HELLO_E.DBG
```

脚本通过 `e` 写入代码与数据，以 `u`、`d` 检查内容，将 `BX:CX=0000:001E` 设为文件长度，通过 `w` 写出 `HELLOE.COM`，最后以 `g=0100` 运行。也可手动逐行输入同一脚本；DEBUG 显示的 `-` 提示符不需要输入。

实验环境为 DOSBox Staging 0.83.0 和 FreeDOS DEBUG 2.51。`results/debug_e.txt` 保存原始文本记录，包含 `u` 的七条指令、`Writing 001E bytes`、程序输出及正常退出信息。DEBUG 实际写出的 COM 与脚本中的机器码逐字节相同。独立运行该 COM 的输出另存于 `results/helloe.txt`。

DEBUG 操作使用独立的 FreeDOS `DEBUG.COM`。重现实验时，应先将该工具加入 DOS 环境的搜索路径；DOSBox 内部调试器与 DOS DEBUG 的命令接口不同。

详细的逐指令说明见 [debug/README.md](debug/README.md)。
