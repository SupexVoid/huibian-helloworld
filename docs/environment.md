# 环境与工具

以下版本对应 2026-10-23 的构建和运行记录。第三方工具需要单独安装。

| 工具 | 下载来源 | SHA-256 |
|---|---|---|
| Open Watcom V2 snapshot | [官方发行](https://github.com/open-watcom/open-watcom-v2/releases/download/Current-build/ow-snapshot.tar.xz) | `ce59cfad6f9d4f530e9b6cf4975d01cb3acda64811123a22a174ce691b51aa39` |
| DOSBox Staging 0.83.0 | [官方发行](https://github.com/dosbox-staging/dosbox-staging/releases/download/v0.83.0/dosbox-staging-windows-x64-v0.83.0.zip) | `725b915e325a6d410ce30a10989fd492fdad07f6611fff40ff77f160478810f4` |

Open Watcom 编译器版本：2.0 beta Oct 23 2026，Windows x64 主机工具，目标为 DOS 8086；WASM/WCC 使用 `-0`，C 使用 `-ms -od -d2 -bt=dos`。Current-build 是滚动发行，重下载时应核对散列，之后版本可能改变反汇编细节。

DEBUG：FreeDOS DEBUG 2.51；[FreeDOS 软件目录](https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/repositories/latest/base/)。实际从 [FreeDOS 镜像](https://ftp.icm.edu.pl/packages/freedos/repositories/latest/base/debug.zip) 下载，包 SHA-1 为 `B056BE942DDD47DDC2D12A939FCBCC27EDE2F34E`；程序和许可证保留在本机工具目录，不随作业分发。

运行脚本使用临时挂载目录，文件名符合 DOS 8.3 规则。结果由 DOSBox 重定向到文件，DEBUG 会话也保存在各实验的 `results/` 中。

## Open Watcom 配置

将安装目录设为 `WATCOM`，把 `binnt64`（没有该目录时用 `binnt`）和 `binnt` 加入 PATH，将 `INCLUDE` 指向安装目录下的 `h`。C 编译、链接还会使用工具链提供的 DOS 头文件及运行库。

使用仓库中的 `build.py` 时，只需传入安装路径，脚本会为编译进程设置这些环境变量。命令见[构建与检查](README.md)。

## 反汇编文件

- `*.disasm.txt`：包含段内地址和机器码的清单。
- `*.generated.asm`：WDIS 导出的指令和常量。
- `*.annotated.asm`：在导出内容上增加中文注释，便于阅读，不参与程序构建。

C 程序关闭优化并保留调试信息。为方便阅读，脚本导出时省略含本机路径的 DWARF 调试段，保留运行代码和常量。WDIS 开头的 `.386p/.387` 是工具生成的汇编器指示；本实验的编译目标由 `-0` 指定为 8086，不能只凭这个文件头判断运行指令集。
