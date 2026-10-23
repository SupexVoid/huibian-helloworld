; 8086 / DOS, MASM syntax. Two nested LOOP instructions share CX.
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
    mov cx, 2                   ; two rows
row_loop:
    push cx                     ; save the OUTER LOOP counter
    mov cx, 13                  ; thirteen letters in this row
column_loop:
    mov dl, bl
    call put_char
    inc bl                      ; consecutive lowercase ASCII codes

    cmp cx, 1                   ; no space after the last letter
    je no_space
    mov dl, ' '
    call put_char
no_space:
    loop column_loop            ; inner LOOP: CX = CX - 1

    call put_newline
    pop cx                      ; restore the OUTER LOOP counter
    loop row_loop

    mov ax, 4C00h
    int 21h
main endp

; Input: DL = character. Preserve AX, BX, CX and DX, including LOOP's CX.
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
