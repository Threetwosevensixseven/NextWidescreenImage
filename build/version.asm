; version.asm
;
; Auto-generated by ZXVersion.exe
; On 30 Jun 2018 at 21:44

BuildNo                 macro()
                        db "0"
mend

BuildNoValue            equ "0"
BuildNoWidth            equ 0 + FW0



BuildDate               macro()
                        db "30 Jun 2018"
mend

BuildDateValue          equ "30 Jun 2018"
BuildDateWidth          equ 0 + FW3 + FW0 + FWSpace + FWJ + FWu + FWn + FWSpace + FW2 + FW0 + FW1 + FW8



BuildTime               macro()
                        db "21:44"
mend

BuildTimeValue          equ "21:44"
BuildTimeWidth          equ 0 + FW2 + FW1 + FWColon + FW4 + FW4



BuildTimeSecs           macro()
                        db "6/30/2018 9:44:33 PM"
mend

BuildTimeSecsValue      equ "6/30/2018 9:44:33 PM"
BuildTimeSecsWidth      equ 0 + FW6 + FW/ + FW3 + FW0 + FW/ + FW2 + FW0 + FW1 + FW8 + FWSpace + FW9 + FWColon + FW4 + FW4 + FWColon + FW3 + FW3 + FWSpace + FWP + FWM
