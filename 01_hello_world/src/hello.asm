; 作业一：传统“编辑 -> 汇编 -> 链接 -> 运行”方式。
; 目标：8086、16 位 DOS、MZ EXE；MASM/Open Watcom WASM 语法。
; DOS 09h 功能以 DS:DX 指向的 '$' 结束字符串为参数。

.8086
.model small
.stack 100h

.data
message db 'Hello, World!', 13, 10, '$'

.code
main proc
    mov ax, @data          ; EXE 启动时 DS 指向 PSP，须先初始化数据段。
    mov ds, ax
    mov dx, offset message
    mov ah, 09h            ; DOS：显示字符串，终止符 '$' 本身不输出。
    int 21h
    mov ax, 4C00h          ; 正常结束程序，返回码为 0。
    int 21h
main endp
end main
