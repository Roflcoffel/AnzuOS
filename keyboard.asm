; USE ASCII INSTEAD OF HEX VALUES, ' ' space, '\b' backspace etc.
; MORE VARIABLES
; TRY TO CREATE A JUMP TABLE...

Cursor_X db 1
Cursor_Y db 1

handle_keystroke:
    mov ah, 00h            ; Get Keystroke (Blocking I think) return is in AL
    int 16h                ; Keyboard Interrupt
    cmp al, 0Dh            ; (ASCII) 0D = Return
    je .return
    cmp al, 08h            ; (ASCII) 8h = Backspace
    je .backspace
    cmp ah, 4Bh            ; (BIOS SCANCODE) LEFT  = 4Bh
    je .left
    cmp ah, 4Dh            ; (BIOS SCANCODE) RIGHT = 4Dh
    je .right
    cmp ah, 50h            ; (BIOS SCANCODE) DOWN  = 50h
    je .down
    cmp ah, 48h            ; (BIOS SCANCODE) UP    = 48h
    je .up
    call print_char
    inc byte [Cursor_X]    ; Typing a character moves the cursor
    jmp handle_keystroke

.return:
    inc byte [Cursor_Y]
    mov byte [Cursor_X], 0
    call set_cursor
    mov ah, 0Eh
    mov al, 3Eh            ; (62 = >) Greater than sign
    int 10h
    jmp handle_keystroke

.backspace:
    cmp byte [Cursor_X], 1
    je handle_keystroke
    dec byte [Cursor_X]
    call set_cursor
    mov ah, 0Ah            ; Write char at cursor
    mov al, 20h            ; 20h = SPACE
    mov cx, 1              ; How many times
    int 10h
    jmp handle_keystroke

.left:
    dec byte [Cursor_X]           ; (X-1) MOVE LEFT
    call set_cursor
    jmp handle_keystroke

.right:
    inc byte [Cursor_X]           ; (X+1) MOVE RIGHT
    call set_cursor
    jmp handle_keystroke

.down:
    inc byte [Cursor_Y]           ; (Y+1) MOVE DOWN
    call set_cursor
    jmp handle_keystroke

.up:
    dec byte [Cursor_Y]           ; (Y-1) MOVE UP
    call set_cursor
    jmp handle_keystroke

get_cursor:
    mov ah, 03h            ; Returns Cursor Position
    int 10h                ; DH (Y, 00h, TOP)
    ret                    ; DL (X, 00h, LEFT)

set_cursor:
    mov dh, [Cursor_Y]
    mov dl, [Cursor_X]
    mov bh, 00h
    mov ah, 02h            ; Sets Cursor Position
    int 10h
    ret


; JUMP TABLE
; Use the value from each bios scan code as the offset
; truncate the values to be from 0 to 4
; jump to address + offset