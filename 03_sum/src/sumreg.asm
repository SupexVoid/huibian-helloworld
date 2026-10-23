; 作业3：累加结果放在16位寄存器AX，100*101/2=5050=13BAh。
.8086
.model small
.stack 100h
.data
    newline db 13,10,'$'
.code
start:
    mov ax,@data
    mov ds,ax
    xor ax,ax
    mov cx,100
sum_loop:
    add ax,cx
    loop sum_loop
    call print_uint
    lea dx,newline
    mov ah,09h
    int 21h
    mov ax,4c00h
    int 21h
include sumio.inc
end start
