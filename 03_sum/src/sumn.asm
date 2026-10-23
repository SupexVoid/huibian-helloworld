; 输入1..100的十进制整数n，计算1+2+...+n。
; DOS INT 21h/AH=0Ah缓冲输入；首字节容量、次字节长度、后面为字符。
.8086
.model small
.stack 100h
.data
    prompt db 'Enter n (1-100): $'
    invalid db 'Invalid input. Please enter 1-100.',13,10,'$'
    answer db 'Sum = $'
    newline db 13,10,'$'
    inputbuf db 127,0,128 dup(0)
.code
start:
    mov ax,@data
    mov ds,ax
read_again:
    lea dx,prompt
    mov ah,09h
    int 21h
    mov byte ptr inputbuf[1],0
    lea dx,inputbuf
    mov ah,0ah
    int 21h
    lea dx,newline
    mov ah,09h
    int 21h
    xor cx,cx
    mov cl,inputbuf[1]
    cmp cx,1
    jb bad_input
    cmp cx,3
    ja bad_input
    lea si,inputbuf[2]
    xor ax,ax
    mov bx,10
parse_digit:
    xor dx,dx
    mov dl,[si]
    cmp dl,'0'
    jb bad_input
    cmp dl,'9'
    ja bad_input
    sub dl,'0'
    push dx
    mul bx
    pop dx
    add ax,dx
    inc si
    loop parse_digit
    cmp ax,1
    jb bad_input
    cmp ax,100
    ja bad_input
    mov cx,ax
    xor bx,bx
add_number:
    add bx,cx
    loop add_number
    lea dx,answer
    mov ah,09h
    int 21h
    mov ax,bx
    call print_uint
    lea dx,newline
    mov ah,09h
    int 21h
    mov ax,4c00h
    int 21h
bad_input:
    lea dx,invalid
    mov ah,09h
    int 21h
    jmp read_again
include sumio.inc
end start
