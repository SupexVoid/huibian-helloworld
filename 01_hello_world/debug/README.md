# DEBUG 输入与反汇编说明

以下命令已在 DOSBox Staging 0.83.0 中用 FreeDOS DEBUG 2.51 实际运行。上一级 `results/debug_e.txt`、`results/debug_u.txt` 是重定向得到的原始文本记录；下文将实际反汇编与源代码、机器码对应起来。段地址会随运行环境变化。

## 直接用 e 输入、保存并运行 COM

进入 `01_hello_world\bin` 后运行 `DEBUG`，逐行输入：

```text
n HELLOE.COM
e 0100 0e 1f ba 0e 01 b4 09 cd 21 b8 00 4c cd 21
e 010e 48 65 6c 6c 6f 2c 20 57 6f 72 6c 64 21 0d 0a 24
u 0100 010d
d 010e 011d
r bx
0000
r cx
001e
w
g=0100
q
```

上述命令已保存为 `hello_e.dbg`，可用 `DEBUG < ..\DEBUG\HELLO_E.DBG` 重放。`r bx` 与 `r cx` 后的下一行分别是新寄存器值；它们不是独立 DEBUG 命令。`w` 根据 `BX:CX` 写出 30（十六进制 `1E`）字节，从 COM 默认入口偏移 `0100` 开始保存。`g=0100` 指定本次运行入口，避免依赖此前的 IP 值。

### 机器码与 u 命令的对应关系

`u 0100 010d` 的代码范围为下表。段地址由 DEBUG 的实际装入位置决定，用 `xxxx` 表示；数字均为十六进制。DEBUG 版本不同可能显示不同空格或大小写。

| 地址 | 机器码 | 反汇编指令 | 含义 |
| --- | --- | --- | --- |
| `xxxx:0100` | `0E` | `PUSH CS` | 将代码段值压栈 |
| `xxxx:0101` | `1F` | `POP DS` | 使 DS=CS，代码与数据共用一个段 |
| `xxxx:0102` | `BA 0E 01` | `MOV DX,010E` | DX 指向字符串首字节 |
| `xxxx:0105` | `B4 09` | `MOV AH,09` | 选择 DOS 字符串输出功能 |
| `xxxx:0107` | `CD 21` | `INT 21` | 显示 DS:DX 指向的字符串 |
| `xxxx:0109` | `B8 00 4C` | `MOV AX,4C00` | AH=4C：退出；AL=00：返回成功 |
| `xxxx:010C` | `CD 21` | `INT 21` | 返回 DOS |

`MOV DX,010E` 的立即数按小端序编码为 `0E 01`；`MOV AX,4C00` 的立即数按小端序编码为 `00 4C`。机器码前 14 字节是指令，所以数据起点为 `0100+000E=010E`。

### 数据区

`d 010e 011d` 查看以下 16 个字节：

```text
偏移  010E 010F 0110 0111 0112 0113 0114 0115
字节    48   65   6C   6C   6F   2C   20   57
字符     H    e    l    l    o    ,  空格    W

偏移  0116 0117 0118 0119 011A 011B 011C 011D
字节    6F   72   6C   64   21   0D   0A   24
字符     o    r    l    d    !   CR   LF    $
```

代码和数据在内存中都只是字节。`u` 无法从字节本身判断某段内容是否为字符串；若继续反汇编到 `010E` 之后，它可能把 `48 65 ...` 强行解释成指令。因此这里用 `u` 查看 `0100–010D` 的代码，用 `d` 查看 `010E–011D` 的数据。程序在 `010C` 的退出调用后结束，不会顺序执行字符串。

COM 不带 MZ 头或重定位表。DOS 为其建立 256 字节 PSP，并将文件内容装到偏移 `0100`。本例通过 `PUSH CS / POP DS` 明确设置数据段；SP 由 COM 装入器建立，两次栈操作配对，不改变最终 SP。

## 用 DEBUG -u 思路查看传统 EXE

在 `bin` 目录执行：

```text
DEBUG HELLO.EXE < ..\DEBUG\HELLO_U.DBG
```

脚本先用 `r` 查看入口寄存器，再用 `u cs:ip l 11` 从实际入口反汇编十六进制 `11`（17）字节，以 `d ds:0000 l 10` 查看初始 DS 所指的 PSP 开头。接着执行三次 `t`，依次执行 `MOV AX,@data`、`MOV DS,AX`、`MOV DX,OFFSET message`，用 `d ds:dx l 10` 查看字符串，最后 `g` 继续运行。此处查看的是装入器已经处理过重定位的内存，不是简单从 EXE 文件头开始反汇编。

本次运行中入口为 `0740:0000`，实际反汇编与源代码对应如下：

| 地址 | 机器码 | 实际反汇编 | 源代码 |
| --- | --- | --- | --- |
| `0740:0000` | `B8 41 07` | `MOV AX,0741` | `mov ax,@data` |
| `0740:0003` | `8E D8` | `MOV DS,AX` | `mov ds,ax` |
| `0740:0005` | `BA 02 00` | `MOV DX,0002` | `mov dx,offset message` |
| `0740:0008` | `B4 09` | `MOV AH,09` | `mov ah,09h` |
| `0740:000A` | `CD 21` | `INT 21` | `int 21h` |
| `0740:000C` | `B8 00 4C` | `MOV AX,4C00` | `mov ax,4C00h` |
| `0740:000F` | `CD 21` | `INT 21` | `int 21h` |

`MOV AX,@data` 的立即数需要链接器和 DOS 装入器处理，数值不能预先固定为 COM 示例的 CS。源文件中的字符串位于 `.data`，应以装入后数据段地址查看。

字符串虽为 `.data` 中的首项，链接布局仍可能使其相对于 DS 的偏移不为零；本次实际偏移为 `0002`。因此以执行后的 `DS:DX` 为准，用 `d ds:dx l 10` 显示完整的 16 字节：`48 65 6C 6C 6F 2C 20 57 6F 72 6C 64 21 0D 0A 24`。不应把启动时 PSP 的字节误认成程序字符串，也不应预设 EXE 的字符串必定位于 `DS:0000`。

## 工具来源

FreeDOS DEBUG 2.51 来自 [FreeDOS 软件包镜像](https://ftp.icm.edu.pl/packages/freedos/repositories/latest/base/debug.zip)，软件包目录见 [FreeDOS DEBUG 2.51](https://ftp.icm.edu.pl/packages/freedos/repositories/latest/html/en/base/debug/20250621.0/index.html)。本次下载包为 300,968 字节，SHA1 为 `b056be942ddd47ddc2d12a939fcbcc27ede2f34e`，与目录公开值一致。DEBUG 本身是 DOS 程序，在 DOSBox 内运行；工具文件保存在仓库外的工作目录中。
