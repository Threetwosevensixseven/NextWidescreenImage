; sprites.asm

ResetSprites            proc
                        ld a, 64
                        ld h, 0
Loop:                   ld bc, Sprite_Index_Port        ; Set the sprite index (port $303B)
                        dec a
                        out (c), a                      ; (0 to 63)
                        ld bc, Sprite_Sprite_Port       ; Send the sprite slot attributes (port $57)
                        out (c), h
                        out (c), h
                        out (c), h
                        out (c), h
                        jp nz, Loop
                        ret
pend



NextPaletteRGB8Proc     proc
                        ld bc, Sprite_Register_Port     ; Port to select ZX Next register
                        ld a, PaletteControlRegister    ; (R/W) Register $43 (67) => Palette Control
                        out (c), a
                        ld bc, Sprite_Value_Port        ; Port to access ZX Next register
Palette equ $+1:        ld a, %1 010 xxxx               ; 010 = Sprites first palette
                        out (c), a
                        ld bc, Sprite_Register_Port
                        ld a, PaletteIndexRegister      ; (R/W) Register $40 (64) => Palette Index
                        out (c), a
                        ld bc, Sprite_Value_Port
                        out (c), e
                        ld bc, Sprite_Register_Port
                        ld a, PaletteValueRegister      ; (R/W) Register $41 (65) => Palette Value (8 bit colour)
                        out (c), a
                        ld bc, Sprite_Value_Port
                        out (c), d
                        ret
pend

