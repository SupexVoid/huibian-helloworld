# �����빤��

���°汾��Ӧ 2026-10-23 �Ĺ��������м�¼��������������Ҫ������װ��

| ���� | ������Դ | SHA-256 |
|---|---|---|
| Open Watcom V2 snapshot | [�ٷ�����](https://github.com/open-watcom/open-watcom-v2/releases/download/Current-build/ow-snapshot.tar.xz) | `ce59cfad6f9d4f530e9b6cf4975d01cb3acda64811123a22a174ce691b51aa39` |
| DOSBox Staging 0.83.0 | [�ٷ�����](https://github.com/dosbox-staging/dosbox-staging/releases/download/v0.83.0/dosbox-staging-windows-x64-v0.83.0.zip) | `725b915e325a6d410ce30a10989fd492fdad07f6611fff40ff77f160478810f4` |

Open Watcom �������汾��2.0 beta Oct 23 2026��Windows x64 �������ߣ�Ŀ��Ϊ DOS 8086��WASM/WCC ʹ�� `-0`��C ʹ�� `-ms -od -d2 -bt=dos`��Current-build �ǹ������У�������ʱӦ�˶�ɢ�У�֮��汾���ܸı䷴���ϸ�ڡ�

DEBUG��FreeDOS DEBUG 2.51��[FreeDOS ����Ŀ¼](https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/repositories/latest/base/)��ʵ�ʴ� [FreeDOS ����](https://ftp.icm.edu.pl/packages/freedos/repositories/latest/base/debug.zip) ���أ��� SHA-1 Ϊ `B056BE942DDD47DDC2D12A939FCBCC27EDE2F34E`�����������֤�����ڱ�������Ŀ¼��������ҵ�ַ���

���нű�ʹ����ʱ����Ŀ¼���ļ������� DOS 8.3 ���򡣽���� DOSBox �ض����ļ���DEBUG �ỰҲ�����ڸ�ʵ��� `results/` �С�

## Open Watcom ����

����װĿ¼��Ϊ `WATCOM`���� `binnt64`��û�и�Ŀ¼ʱ�� `binnt`���� `binnt` ���� PATH���� `INCLUDE` ָ��װĿ¼�µ� `h`��C ���롢���ӻ���ʹ�ù������ṩ�� DOS ͷ�ļ������п⡣

ʹ�òֿ��е� `build.py` ʱ��ֻ�贫�밲װ·�����ű���Ϊ�������������Щ���������������[��������](README.md)��

## ������ļ�

- `*.disasm.txt`���������ڵ�ַ�ͻ�������嵥��
- `*.generated.asm`��WDIS ������ָ��ͳ�����
- `*.annotated.asm`���ڵ�����������������ע�ͣ������Ķ�����������򹹽���

C ����ر��Ż�������������Ϣ��Ϊ�����Ķ����ű�����ʱʡ�Ժ�����·���� DWARF ���ԶΣ��������д���ͳ�����WDIS ��ͷ�� `.386p/.387` �ǹ������ɵĻ����ָʾ����ʵ��ı���Ŀ���� `-0` ָ��Ϊ 8086������ֻƾ����ļ�ͷ�ж�����ָ���
