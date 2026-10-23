# 实际使用的工具链

验证日期：2026-10-23（Asia/Shanghai）。第三方工具未放入仓库。

| 工具 | 下载来源 | SHA-256 |
|---|---|---|
| Open Watcom V2 snapshot | [官方发行](https://github.com/open-watcom/open-watcom-v2/releases/download/Current-build/ow-snapshot.tar.xz) | `ce59cfad6f9d4f530e9b6cf4975d01cb3acda64811123a22a174ce691b51aa39` |
| DOSBox Staging 0.83.0 | [官方发行](https://github.com/dosbox-staging/dosbox-staging/releases/download/v0.83.0/dosbox-staging-windows-x64-v0.83.0.zip) | `725b915e325a6d410ce30a10989fd492fdad07f6611fff40ff77f160478810f4` |

Open Watcom 编译器版本：2.0 beta Oct 23 2026，Windows x64 主机工具，目标为 DOS 8086；WASM/WCC 使用 `-0`，C 使用 `-ms -od -d2 -bt=dos`。Current-build 是滚动发行，重下载时应核对散列，之后版本可能改变反汇编细节。

DEBUG：FreeDOS DEBUG 2.51；[FreeDOS 软件目录](https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/repositories/latest/base/)。实际从 [FreeDOS 镜像](https://ftp.icm.edu.pl/packages/freedos/repositories/latest/base/debug.zip) 下载，包 SHA-1 为 `B056BE942DDD47DDC2D12A939FCBCC27EDE2F34E`；程序和许可证保留在本机工具目录，不随作业分发。

DOSBox 的结果重定向和 DEBUG 会话由实际模拟器执行，运行脚本使用临时挂载目录，文件名符合 DOS 8.3 规则。
