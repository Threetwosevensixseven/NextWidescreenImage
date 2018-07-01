; main.asm

zeusemulate             "Next"
zoLogicOperatorsHighPri = false
zoSupportStringEscapes  = false
zxAllowFloatingLabels   = false
zoParaSysNotEmulate     = false
Zeus_PC                 = Start
Stack                   equ Start
Zeus_P7FFD              = $10
Zeus_IY                 = $5C3A
Zeus_AltHL              = $5C3A
Zeus_IM                 = 1
Zeus_IE                 = false
optionsize 5
Cspect optionbool 15, -15, "Cspect", false
ZEsarUX optionbool 80, -15, "ZEsarUX", false
ZeusDebug optionbool 155, -15, "Zeus", true
UploadNext optionbool 205, -15, "Next", false
NoDivMMC                = ZeusDebug

                        org $6000
Start:
                        di
                        ld iy, $5C3A
                        ld sp, Stack
                        ld a, $BE
                        ld i, a
                        im 2

Loooop:
                        Turbo(MHz14)
                        Border(Black)
                        PortOut($123B, $00)             ; Hide layer 2 and disable write paging
                        nextreg $15, %0 00 001 1 0      ; Disable sprites, over border, set LSU
                        PageBankZX(0, false)            ; Force MMU reset
                        call ClsAttr
                        call SetupDataFileSystem
                        call LoadResources
                        di

                        MMU6(30, false)                 ; SET PRIMARY LAYER 2 9BIT PALETTE
                        ld hl, $C000
                        ld b, 0
                        nextreg $43, %0 001 000 0       ; Set Layer 2 primary palette, incrementing
                        nextreg $40, 0                  ; Start at index 0
L2Loop:                 ld a, (hl)
                        inc hl
                        nextreg $44, a
                        ld a, (hl)
                        inc hl
                        nextreg $44, a
                        djnz L2Loop

                        //nextreg $40, $E3                ; BUG TEST - Redefine layer 2 index $E3
                        //nextreg $44, %111 000 00        ; as 9-bit Red.
                        //nextreg $44, %0000000 0         ; ULA Border 0 now goes to red!

                        MMU6(30, false)                 ; SET PRIMARY SPRITE 9BIT PALETTE
                        ld hl, $C200
                        ld b, 0
                        nextreg $43, %0 010 000 0       ; Set Sprite primary palette, incrementing
                        nextreg $40, 0                  ; Start at index 0
SprLoop:                ld a, (hl)
                        inc hl
                        nextreg $44, a
                        ld a, (hl)
                        inc hl
                        nextreg $44, a
                        djnz SprLoop

                        MMU6(31, false)
                        for n = 0 to 23
                          SetSpritePattern($C000, n, n)
                        next ; n
                        for n = 0 to 11
                          NextSprite(n*2+0, -32, n*16, 0,false, false, false, true, n*2+0)
                          NextSprite(n*2+1, -16, n*16, 0,false, false, false, true, n*2+1)
                        next ; n

                        MMU6(32, false)
                        for n = 0 to 23
                          SetSpritePattern($C000, n+24, n)
                        next ; n
                        for n = 12 to 23
                          NextSprite(n*2+0, 256, (n-12)*16, 0,false, false, false, true, n*2+0)
                          NextSprite(n*2+1, 272, (n-12)*16, 0,false, false, false, true, n*2+1)
                        next ; n

                        nextreg $14, $E3                ; Global L2 transparency colour
                        nextreg $4B, $E3                ; Global sprite transparency index
                        nextreg $4A, $00                ; Transparency fallback colour (black)
                        nextreg $12, 9                  ; Set Layer 2 to bank 18
                        PortOut($123B, $02)             ; Show layer 2 and disable write paging
                        nextreg $15, %0 00 000 1 1      ; Enable sprites, over border, set SLU
Freeze:
                        ei
                        halt
                        jp Freeze

                        include "sprites.asm"           ; Next sprite routines
                        include "utilities.asm"         ; Utility routines
                        include "esxDOS.asm"
FZX_ORG:                include "FZXdriver.asm"
                        include "constants.asm"         ; Global constants
                        include "macros.asm"            ; Zeus macros
                        include "mmu-pages.asm"

org $BE00
                        loop 257
                          db $BF
                        lend
org $BFBF
                        ei
                        reti

                        if zeusver < 73
                          zeuserror "Upgrade to Zeus v3.991 or above, available at http://www.desdes.com/products/oldfiles/zeus.htm."
                        endif

                        output_sna "..\bin\Daybreak.sna", $FF40, Start

                        zeusinvoke "..\build\deploy.bat"

                        if enabled Cspect
                          zeusinvoke "..\build\cspect.bat"
                        endif
                        if enabled ZEsarUX
                          zeusinvoke "..\build\ZEsarUX.bat"
                        endif
                        if enabled UploadNext
                          zeusinvoke "..\build\UploadNext.bat"
                        endif

