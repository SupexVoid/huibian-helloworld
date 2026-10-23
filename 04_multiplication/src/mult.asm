; 8086 / DOS，MASM 小模式；Open Watcom WASM 可汇编。
; BX = 当前行因子（9..1），CX = 当前列因子（1..BX）。
.MODEL small
.STACK 100h

.DATA
    heading DB 'The 9mul9 table:', 13, 10, '$'

.CODE
main PROC
    mov ax, @data
    mov ds, ax

    mov dx, OFFSET heading
    mov ah, 09h
    int 21h

    mov bx, 9
row_loop:
    mov cx, 1
column_loop:
    ; 参数直接放在调用者的 BX、CX 中；过程返回后两者不变。
    call PrintTerm
    cmp cx, bx
    jae row_end

    ; 相邻算式之间恰好两个空格；行末无空格。
    mov dl, ' '
    call PutChar
    call PutChar
    inc cx
    jmp column_loop

row_end:
    call NewLine
    dec bx
    jnz row_loop

    mov ax, 4C00h
    int 21h
main ENDP

; 输入 BX = 行、CX = 列（均为 1..9），输出“行*列=积”。
; 显式保存并恢复本过程使用的 AX、BX、CX、DX。
PrintTerm PROC NEAR
    push ax
    push bx
    push cx
    push dx

    mov dx, bx
    add dl, '0'
    call PutChar
    mov dl, '*'
    call PutChar
    mov dx, cx
    add dl, '0'
    call PutChar
    mov dl, '='
    call PutChar

    mov ax, bx
    ; 8 位无符号乘法：AX = AL * CL，覆盖原 AH、AL。
    ; 行因子在 AL，列因子在 CL；最大乘积 81，无截断。
    mul cl
    call PrintUnsigned

    pop dx
    pop cx
    pop bx
    pop ax
    ret
PrintTerm ENDP

; 输入 AX = 无符号 16 位整数，输出十进制数，不添加空格或换行。
; 保存 AX、BX、CX、DX；除法得到的余数逐个压栈再逆序输出。
PrintUnsigned PROC NEAR
    push ax
    push bx
    push cx
    push dx

    mov bx, 10
    xor cx, cx
decimal_loop:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz decimal_loop

digit_loop:
    pop dx
    add dl, '0'
    call PutChar
    loop digit_loop

    pop dx
    pop cx
    pop bx
    pop ax
    ret
PrintUnsigned ENDP

; 输入 DL = 字符。DOS 21h/02h 可能改写 AL，所以保存 AX、DX。
PutChar PROC NEAR
    push ax
    push dx
    mov ah, 02h
    int 21h
    pop dx
    pop ax
    ret
PutChar ENDP

; 无输入；输出 DOS 文本换行 CR（13）与 LF（10）。
NewLine PROC NEAR
    push dx
    mov dl, 13
    call PutChar
    mov dl, 10
    call PutChar
    pop dx
    ret
NewLine ENDP

END main
