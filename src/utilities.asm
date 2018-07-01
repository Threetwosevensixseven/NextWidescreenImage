; utilities.asm

Resources proc Table:

  ; Bank  FName  Index  Notes
  db  18,    18  ;   0  Daybreak Layer 2 (1/6)
  db  19,    19  ;   1  Daybreak Layer 2 (2/6)
  db  20,    20  ;   2  Daybreak Layer 2 (3/6)
  db  21,    21  ;   3  Daybreak Layer 2 (4/6)
  db  22,    22  ;   4  Daybreak Layer 2 (5/6)
  db  23,    23  ;   5  Daybreak Layer 2 (6/6)
  db  30,    30  ;   6  Palettes
  db  31,    31  ;   7  Sprites Left
  db  32,    32  ;   8  Sprites Right

  struct
    Bank        ds 1
    FName       ds 1
  Size send

  Len           equ $-Table
  Count         equ Len/Size
  ROM           equ 255

  output_bin "..\build\BankList.bin", Table, Len
pend



LoadResources           proc

                        //xor a                           ; SNX extended snapshot leaves file handle 0 open
                        //ld (esxDOS.Handle), a

                        ld ix, FileName
                        call esxDOS.fOpen
                        jp c, Error

                        ld bc, $0002
                        ld de, $2000                    ; bcde = $22000 = 139264 = first bank
                        ld ixl, esxDOS.esx_seek_set
                        ld l, esxDOS.esx_seek_set
                        call esxDOS.fSeek
                        jp c, Error
                        xor a
                        push af
                        ld iy, Resources.Table
NextBank:
                        ld a, (iy+Resources.Bank)
                        nextreg $57, a
                        ld ix, $E000
                        ld bc, $2000
                        call esxDOS.fRead
                        jp c, Error
                        pop af
                        inc a
                        cp Resources.Count
                        jp z, Finish
                        push af
                        inc iy
                        inc iy
                        jp NextBank

Finish:
                        call esxDOS.fClose
                        jp c, Error
                        ret
Error:
                        di
                        MMU5(8, false)
                        ld iy, FileName
                        jp esxDOSerror
FileName:
  db "Daybreak.sna", 0
pend



SetupDataFileSystem     proc
                        call esxDOS.GetSetDrive
                        jp c, LoadResources.Error
                        ld (esxDOS.DefaultDrive), a
                        ret
pend



esxDOSerror             proc
                        di
                        ld (ErrorNo), a
                        ld sp, $BDFF
                        nextreg $50,255                 ; MMU page bottom 48K back
                        nextreg $51,255                 ; (apart from this bank)
                        nextreg $52, 10
                        nextreg $53, 11
                        nextreg $54,  4
                        call ResetSprites               ; Hide all sprites
                        PortOut($123B, $00)             ; Hide layer 2 and disable write paging

                        NextPaletteRGB8($82, %111 000 00, PaletteULAa)
                        NextPaletteRGB8($0F, %111 111 11, PaletteULAa)
                        NextPaletteRGB8(18, %111 000 00, PaletteULAa)
                        Border(Red)
                        FillLDIR($4000, $1800, $00)
                        FillLDIR($5800, $0300, $57)

                        ld hl, Font.Spectron
                        ld (FZX_FONT), hl
                        ld hl, Text
                        call ErrorPrint

                        push iy
                        push iy
                        pop hl
                        ld b, 25
CaseLoop:
                        ld a, (hl)
                        cp 97
                        jp c, LeaveCase
                        cp 123
                        jp nc, LeaveCase
                        sub a, 32
LeaveCase:              ld (hl), a
                        inc hl
                        djnz CaseLoop
                        pop hl
                        call ErrorPrint

                        ld hl, Text2
                        call ErrorPrint

ErrorNo equ $+1:        ld a, SMC
                        cp esxDOSerrors.Count
                        jp c, NoReset
                        xor a
NoReset:                ld d, a
                        ld e, esxDOSerrors.Size
                        mul
                        ex de, hl
                        add hl, esxDOSerrors.Table
                        call ErrorPrint

                        ld a, $BE
                        ld i, a
                        im 2
                        ei
                        halt
Freeze:                 jp Freeze

Text:                   db At,   1, 1, "DAYBREAK"                  ; 89 to center
                        db At,  13, 1, "BY ROBIN VERHAGEN-GUEST"
                        //db At,  25, 1
                        //VersionOnly()
                        //db At,  38, 1
                        //BuildDate()
                        db At, 160, 1, "ERROR READING FILE:"
                        db At, 172, 1
                        db 0
Text2:                  db At, 184, 1
                        db 0
pend



ErrorPrint              proc
PrintMenu:              ld a, (hl)                      ; for each character of this string...
                        or a
                        ret z                           ; check string terminator
                        or a
                        jp z, Skip                      ; skip padding character
                        push hl                         ; preserve HL
                        call FZX_START                  ; print character
                        pop hl                          ; recover HL
Skip:                   inc hl
                        jp PrintMenu
                        ret
pend



esxDOSerrors proc Table:

  ;  Error                   Padding  ErrCode
  db "UNKNOWN ERROR"         , ds  9  ;     0
  db "OK"                    , ds 20  ;     1
  db "NONSENSE IN ESXDOS"    , ds  4  ;     2
  db "STATEMENT END ERROR"   , ds  3  ;     3
  db "WRONG FILE TYPE"       , ds  7  ;     4
  db "NO SUCH FILE OR DIR"   , ds  3  ;     5
  db "I/O ERROR"             , ds 13  ;     6
  db "INVALID FILENAME"      , ds  6  ;     7
  db "ACCESS DENIED"         , ds  9  ;     8
  db "DRIVE FULL"            , ds 12  ;     9
  db "INVALID I/O REQUEST"   , ds  3  ;    10
  db "NO SUCH DRIVE"         , ds  9  ;    11
  db "TOO MANY FILES OPEN"   , ds  3  ;    12
  db "BAD FILE NUMBER"       , ds  7  ;    13
  db "NO SUCH DEVICE"        , ds  8  ;    14
  db "FILE POINTER OVERFLOW" , ds  1  ;    15
  db "IS A DIRECTORY"        , ds  8  ;    16
  db "NOT A DIRECTORY"       , ds  7  ;    17
  db "ALREADY EXISTS"        , ds  8  ;    18
  db "INVALID PATH"          , ds 10  ;    19
  db "MISSING SYSTEM"        , ds  8  ;    20
  db "PATH TOO LONG"         , ds  9  ;    21
  db "NO SUCH COMMAND"       , ds  7  ;    22
  db "IN USE"                , ds 16  ;    23
  db "READ ONLY"             , ds 13  ;    24
  db "VERIFY FAILED"         , ds  9  ;    25
  db "SYS FILE LOAD ERROR"   , ds  3  ;    26
  db "DIRECTORY IN USE"      , ds  6  ;    27
  db "MAPRAM IS ACTIVE"      , ds  6  ;    28
  db "DRIVE BUSY"            , ds 12  ;    29
  db "UNKNOWN FILESYSTEM"    , ds  4  ;    30
  db "DEVICE BUSY"           , ds 11  ;    31
  db "PLEASE RUN DAYBREAK ON A ZX SPECTRUM NEXT"   , ds  1  ;    32

  struct
    Error    ds 22
  Size send

  Len           equ $-Table
  Count         equ Len/Size

pend



ClsAttr                 proc
                        ClsAttrFull(DimBlackBlackP)
                        ret
pend



Font proc
  Spectron:             import_bin "..\fonts\Spectron.fzx"
pend



WriteSpritePattern      proc
                        ld bc, Sprite_Index_Port        ; Set the sprite index
                        out (c), a                      ; (0 to 63)
                        ld a, 0                         ; Send 256 pixel bytes (16*16)
                        ld d, 0                         ; Counter
                        ld bc, Sprite_Pattern_Port
PixelLoop:              ld e, (hl)
                        inc hl
                        out (c), e
                        dec d
                        jr nz PixelLoop
                        ret
pend



NextSpriteProc          proc
                        ld bc, Sprite_Index_Port        ; Set the sprite index (port $303B)
                        out (c), a                      ; (0 to 63)
                        ld bc, Sprite_Sprite_Port       ; Send the sprite slot attributes (port $57)
                        out (c), l
                        out (c), h
                        out (c), e
                        out (c), d
                        ret
pend

