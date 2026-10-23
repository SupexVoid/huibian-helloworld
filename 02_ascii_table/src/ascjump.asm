; 8086 / DOS, MASM syntax. Both loops use conditional jumps.
.8086
.model small
.stack 100h

.data
crlf db 13, 10, '$'

.code
main proc
    mov ax, @data
    mov ds, ax

    mov bl, 'a'
    mov bh, 2                   ; remaining rows
row_again:
    mov cx, 13                  ; remaining letters in this row
column_again:
    mov dl, bl
    call put_char
    inc bl

    cmp cx, 1
    je no_space                 ; suppress the trailing space
    mov dl, ' '
    call put_char
no_space:
    dec cx
    jnz column_again            ; conditional inner loop

    call put_newline
    dec bh
    jnz row_again               ; conditional outer loop

    mov ax, 4C00h
    int 21h
main endp

; Input: DL = character. Preserve AX, BX, CX and DX.
; BX holds the letter and row count; CX holds the column count.
put_char proc near
    push ax
    push bx
    push cx
    push dx
    mov ah, 02h
    int 21h
    pop dx
    pop cx
    pop bx
    pop ax
    ret
put_char endp

; Output a DOS CR/LF pair. Preserve AX, BX, CX and DX.
put_newline proc near
    push ax
    push bx
    push cx
    push dx
    lea dx, crlf
    mov ah, 09h
    int 21h
    pop dx
    pop cx
    pop bx
    pop ax
    ret
put_newline endp

end main
