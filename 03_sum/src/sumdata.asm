; 作业3：每次累加直接写入数据段中的word变量total。
.8086
.model small
.stack 100h
.data
    total dw 0
    newline db 13,10,'$'
.code
start:
    mov ax,@data
    mov ds,ax
    mov cx,100
sum_loop:
    add total,cx
    loop sum_loop
    mov ax,total
    call print_uint
    lea dx,newline
    mov ah,09h
    int 21h
    mov ax,4c00h
    int 21h
include sumio.inc
end start
