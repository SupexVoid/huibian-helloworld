# 实验一：Hello World

用两种方式输出 Hello, World!：一是编写汇编源文件并生成 EXE，二是通过 DEBUG 输入机器码并生成 COM。

## 汇编程序

源码是 [src/hello.asm](src/hello.asm)，生成的程序是 [bin/hello.exe](bin/hello.exe)。

程序先初始化 DS，再把字符串地址放入 DX，通过 INT 21h 的 AH=09h 功能输出字符串。字符串以 $ 结束，$ 本身不显示。末尾的 13、10 分别是回车和换行。

这里采用 small 模型，代码和数据位于不同段。EXE 刚启动时 DS 指向 PSP，因此不能省略数据段初始化：

```asm
mov ax, @data
mov ds, ax
```

## DEBUG 输入机器码

在 DOSBox 中进入本实验的 bin 目录，准备好 FreeDOS DEBUG 后执行：

```text
DEBUG < ..\DEBUG\HELLO_E.DBG
```

脚本用 e 写入机器码，用 u 查看指令，用 w 保存为 HELLOE.COM，再用 g=0100 运行。文件共 30 字节，其中前 14 字节是指令，后 16 字节是字符串。

[DEBUG 操作说明](debug/README.md)列出了输入命令、机器码和指令的对应关系。DEBUG 是单独的 DOS 工具，需要加入 DOS 环境的搜索路径；它与 DOSBox 自带调试器的命令不同。

## 运行结果

两种程序均输出：

```text
Hello, World!
```

- [EXE 输出](results/hello.txt)、[COM 输出](results/helloe.txt)
- [输入机器码的 DEBUG 记录](results/debug_e.txt)
- [EXE 反汇编与单步记录](results/debug_u.txt)

EXE 与 COM 的一个区别是：EXE 中需要初始化 DS 指向数据段；本例 COM 的代码与数据在同一段，通过 PUSH CS / POP DS 设置 DS。

## 单独编译

从本实验目录执行，先建立 .build 和 bin 目录，并将 Open Watcom 工具加入 PATH：

```text
wasm -q -0 -fo=.build\hello.obj src\hello.asm
wlink system dos option quiet name bin\hello.exe file .build\hello.obj
```

全部实验的构建方法见[构建与检查](../docs/README.md)。
