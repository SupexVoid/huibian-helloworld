; 作业3：SS:[BP-2]是栈中的局部word，累加结果一直保存在该位置。
.8086
.model small
.stack 100h
.data
    newline db 13,10,'$'
.code
start:
    mov ax,@data
    mov ds,ax
    push bp
    mov bp,sp
    sub sp,2
    mov word ptr [bp-2],0
    mov cx,100
sum_loop:
    add word ptr [bp-2],cx
    loop sum_loop
    mov ax,[bp-2]
    call print_uint
    mov sp,bp
    pop bp
    lea dx,newline
    mov ah,09h
    int 21h
    mov ax,4c00h
    int 21h
include sumio.inc
end start
