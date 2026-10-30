# 构建与检查

实验源码和结果仍放在各自目录中。这里说明批量构建、运行和检查的方法；工具版本和下载地址见[环境与工具](environment.md)。

## 重新编译

在 Windows PowerShell 中进入仓库根目录执行，路径换成本机安装位置：

```powershell
python scripts/build.py --watcom C:\WATCOM
```

脚本生成 11 个 DOS EXE 和对应反汇编清单。中间目标文件放在各实验的 `.build/`，EXE 放在 `bin/`。实验一的 `helloe.com` 需要用 DEBUG 生成，步骤见[实验一说明](../01_hello_world/README.md)。

## 批量运行

```powershell
python scripts/run_dos.py --dosbox C:\DOSBox\dosbox.exe
```

脚本在 DOSBox 中运行程序，把输出保存到各实验的 `results/`，随后调用检查脚本。临时文件位于 `.run/`。

2026-10-23 保存的记录包含 119 次程序执行：11 次固定输出、100 次合法输入求和，以及 8 次非法输入后重试。

## 检查保存的结果

```powershell
python scripts/verify.py
```

这一步只读取已有输出文件，不会重新编译或运行 DOS 程序。7 组检查包括字符串输出、字母表、三种存储方式的求和、输入求和和乘法表。

求和结果与 `n(n+1)/2` 比较；乘法表检查标题、行数、每行项数、因子和乘积。检查的具体范围见 [verify.py](../scripts/verify.py)。

仓库中保留的日志：

- [编译日志](../BUILD_LOG.txt)
- [DOSBox 日志](../DOSBOX_LOG.txt)
- [输出检查记录](../TEST_REPORT.txt)

脚本和日志是实验的辅助材料，各题原理与运行结果见[实验目录](../README.md)。
