:: Set current directory
::@echo off
C:
CD %~dp0

ZXVersion.exe
SpectronPackager.exe
copy ..\bin\Daybreak.sna ..\sd\*.*

::pause