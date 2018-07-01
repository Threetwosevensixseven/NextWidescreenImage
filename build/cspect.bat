:: Set current directory
::@echo off
C:
CD %~dp0

..\tools\pskill.exe -t cspect.exe

"C:\Program Files (x86)\CSpect1_11\CSpect.exe" -s14 -zxnext -mmc=..\sd\ ..\bin\Daybreak.sna

REM"C:\Program Files (x86)\CSpect1_10_6\CSpect.exe" -s14 -zxnext -mmc="C:\Users\robin\Documents\Visual Studio 2015\Projects\Spectron2084\sd" ..\bin\Spectron2084.sna

:: pause