; 输入AX=无符号16位整数；十进制打印；保存AX/BX/CX/DX，标志位改变。
; 每次DIV的余数压栈，之后倒序弹出，因而数字顺序正确；0也打印一位。
print_uint proc near
    push ax
    push bx
    push cx
    push dx
    xor cx,cx
    mov bx,10
decimal_divide:
    xor dx,dx
    div bx
    push dx
    inc cx
    cmp ax,0
    jne decimal_divide
decimal_print:
    pop dx
    add dl,'0'
    mov ah,02h
    int 21h
    loop decimal_print
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_uint endp
