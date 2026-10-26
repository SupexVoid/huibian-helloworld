# 实验四：倒三角九九乘法表

`src/mult.asm` 为 8086 DOS 小模式汇编程序，`src/mult.c` 为相同输出的 C89 程序。两者先输出 `The 9mul9 table:` 和 CR/LF，再输出 9 行。第一行从 `9*1=9` 到 `9*9=81`，第二行从 `8*1=8` 到 `8*8=64`，最后一行为 `1*1=1`。同一行相邻算式以两个空格分隔，行末无空格，共 45 个算式。

## 算法与寄存器传参

外层循环令 BX 从 9 递减到 1；每一行内，内层循环令 CX 从 1 递增到 BX。每次调用 `PrintTerm`，把 BX、CX 直接作为参数。过程先打印两个因子及 `*`、`=`，再执行 `MUL CL` 求积，并调用 `PrintUnsigned` 打印积。

`MUL CL` 为 8086 的 8 位无符号乘法，隐含被乘数为 AL，结果写入整个 AX。代码先执行 `MOV AX,BX`，所以 AL 是行因子，CL 是列因子。乘积范围为 1..81，AH 必为 0；MUL 此时将 CF、OF 清零，其他算术标志未定义，后续代码不依赖它们。`MUL` 与有符号乘法 `IMUL` 不同。它会覆盖原 AX，原 AX 已由过程入口的 PUSH 保存。

`PrintUnsigned` 使用 `DIV BX`（BX=10）循环求商和余数。每次先清 DX，令 DX:AX 表示当前非负整数。余数压栈，最终由 `POP DX` 逆序输出数字；即使输入 AX=0，也会输出一个 `0`。这里用 `LOOP` 对十进制位数计数。

## 过程约定及保护表

下表中的“临时改写”指过程执行期间；所有过程返回时都恢复所列保存寄存器。SI、DI、BP、DS、ES 均未用作工作寄存器。FLAGS 不作为输出，不承诺保存。DOS 21h 的字符输出按标准接口使用。

| 过程 | 输入 | 执行期间临时改写 | 显式 PUSH/POP 保护 | 返回值及其余寄存器 |
|---|---|---|---|---|
| `PrintTerm` | BX=行因子，CX=列因子 | AX、DX；被调用过程暂用 BX、CX | AX、BX、CX、DX | 通过屏幕输出；AX/BX/CX/DX 恢复，其余通用及段寄存器未改写 |
| `PrintUnsigned` | AX=无符号整数 | AX=商、BX=10、CX=位数、DX=余数/字符 | AX、BX、CX、DX | 通过屏幕输出；AX/BX/CX/DX 恢复，其余未改写 |
| `PutChar` | DL=字符 | AH=02h；DOS 可改写 AL | AX、DX | 通过 DOS 输出字符；其余按 DOS 接口保持 |
| `NewLine` | 无 | DL=13、10 | DX | 输出 CR/LF；AX 由 `PutChar` 保护，其余未改写 |

例如 `PrintTerm` 在打印结束后把原 BX、CX 弹回，所以调用者的嵌套循环不会被十进制转换过程破坏。保存顺序为 AX→BX→CX→DX，恢复顺序为 DX→CX→BX→AX。

## CALL、RET 与栈平衡

所有过程都是同代码段的 NEAR 过程。8086 执行 `CALL` 时，先令 SP 减 2，再将返回地址 IP 压入 SS:SP；`RET` 弹出该 IP，使 SP 加 2。每个过程中的寄存器 PUSH 都有反序 POP；`PrintUnsigned` 的每个余数 PUSH 也恰好对应一次数字 POP。因此每次调用返回后 SP 恢复为 CALL 之前的值，既不需要也没有 `RET n` 参数清理。

`.STACK 100h` 在目标文件中声明 256 字节栈；本仓库使用的 WLINK 默认把最终 EXE 的栈扩为 4 KiB，生成 EXE 的初始 SP 为 `1000h`。对本题最大两位数的乘积，最深的普通过程调用链是 `main → PrintTerm → PrintUnsigned → PutChar`。在打印两位数的首位时，过程返回地址和保存寄存器共占 26 字节，另有 1 个未输出余数占 2 字节，共 28 字节。执行 `INT 21h` 时还会压入 FLAGS、CS、IP，共 6 字节，即这部分可见栈用量为 34 字节；DOS 内部另有自身实现相关的栈行为，不能把 34 当作整个操作系统的完整栈需求。

## 构建、反汇编与运行

以下命令在配置好 Open Watcom 的 `WATCOM`、`PATH`、`INCLUDE` 后，从本目录执行；`bin`、`.build`、`results` 目录由仓库构建脚本创建。Open Watcom 在 Windows 下的文件参数使用反斜杠路径。

```text
wasm -0 -ms -d2 -fo=.build\mult.obj src\mult.asm
wlink system dos name bin\mult.exe file .build\mult.obj
wcc -0 -ms -od -d2 -fo=.build\mult_c.obj src\mult.c
wlink system dos name bin\mult_c.exe file .build\mult_c.obj
wdis -a -l=results\mult_c.generated.asm .build\mult_c.obj
```

`-0` 指定 8086，`-ms` 指定小内存模式，C 的 `-od` 关闭优化，`-d2` 保留调试信息以便反汇编对应源代码。WLINK 的 DOS 系统配置负责选择 C 运行库及启动代码；C 程序不是裸入口的汇编程序。

在实际 DOSBox 中进入本目录后运行：

```text
bin\mult.exe > results\mult.txt
bin\mult_c.exe > results\mult_c.txt
```

运行输出分别保存在 `results/mult.txt` 和 `results/mult_c.txt`。C 标准库以 DOS 文本方式将 `\n` 转为 CR/LF。汇编程序显式输出 13、10。

仓库级验证命令为 `python scripts/verify.py`（从仓库根目录执行），其中第 4 题核对标题、行数、每行项数、所有因子和乘积。C 反汇编见 `results/mult_c.disasm.txt`（地址和机器码）、`results/mult_c.generated.asm`（原始汇编格式的代码与常量导出）、`results/mult_c.annotated.asm`（原样指令配中文注释）；逐段解释见 `disassembly-notes.md`。仓库脚本不启用 WDIS 的源代码交错显示，并省略含本机绝对路径的 DWARF 调试段，保留实际代码、常量、地址和机器码。
