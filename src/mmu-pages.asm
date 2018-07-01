; mmu-pages.asm

MMUTemp16 equ $

; PAGE 18 - BANK18.BIN - Daybreak Layer 2 (1/6)
org 0
dispto zeusmmu(18)
import_bin "..\banks\Bank18.bin"

; PAGE 19 - BANK19.BIN - Daybreak Layer 2 (2/6)
org 0
dispto zeusmmu(19)
import_bin "..\banks\Bank19.bin"

; PAGE 20 - BANK20.BIN - Daybreak Layer 2 (3/6)
org 0
dispto zeusmmu(20)
import_bin "..\banks\Bank20.bin"

; PAGE 21 - BANK21.BIN - Daybreak Layer 2 (4/6)
org 0
dispto zeusmmu(21)
import_bin "..\banks\Bank21.bin"

; PAGE 22 - BANK22.BIN - Daybreak Layer 2 (5/6)
org 0
dispto zeusmmu(22)
import_bin "..\banks\Bank22.bin"

; PAGE 23 - BANK23.BIN - Daybreak Layer 2 (36/6)
org 0
dispto zeusmmu(23)
import_bin "..\banks\Bank23.bin"

org MMUTemp16
disp 0

