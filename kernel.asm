BITS 16

start:
    mov ax, 07C0h      ; 4K stack space after bootloader
    add ax, 288        ; (4096 + 512) / 16 bytes per paragraph
    mov ss, ax
    mov sp, 4096

    mov ax, 07C0h      ; set data segment
    mov ds, ax

    mov si, my_text
    call clear
    call print_string
    call prompt
    call handle_keystroke

    jmp $

    my_text db 'Welcome to AnzuOS!', 0

print_char:
    mov ah, 0Eh       ; Prints character stored in AL
    int 10h           ; Display Interrupt
    ret

print_string:         ; Ouput string in SI to screen
    mov ah, 0Eh       

.repeat:
    lodsb             ; Load byte from si to al and increment si
    cmp al, 0h
    je .newline
    int 10h           
    jmp .repeat

.newline:
    mov al, 0Ah       ; (10 = \n) New Line Character
    int 10h
    mov al, 0Dh       ; (13 = \r) Carriage return
    int 10h
    ret

prompt:
    mov al, 3Eh       ; (62 = >) Greater than sign
    int 10h
    mov ah, 01h        ; Change Cursor to Block Shaped
    mov cl, 07h        
    mov ch, 00h
    int 10h
    ret

clear:
    mov ah, 00h        ; Set Video mode
    mov al, 03h        ; 80x25 Video Mode
    int 10h
    mov ax, 0600h     ; Scroll up
    mov bh, 1Fh       ; 1h = blue, background, fh = White, foreground
    mov cx, 0000h     ; CH=00H TOP   , CL=00h LEFT
    mov dx, 1950h     ; DH=19h BOTTOM, DL=50h RIGHT;
    int 10h
    ret

%include "keyboard.asm"

times 510-($-$$) db 0 ; Pad boot sector with 0s
dw 0xAA55             ; PC boot signature

;Color Map
;0 0000 black
;1 0001 blue
;2 0010 green
;3 0011 cyan
;4 0100 red
;5 0101 magenta
;6 0110 brown
;7 0111 light gray
;8 1000 dark gray
;9 1001 light blue
;A 1010 light green
;B 1011 light cyan
;C 1100 light red
;D 1101 light magenta
;E 1110 yellow
;F 1111 white 

;Ledger for Interrups
; int 10h - Display
; int 16h - Keyboard


