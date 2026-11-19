@echo off

call "%~dp0unload.bat"

sc.exe create WinFsp ^
    binPath= "%~dp0bin\winfsp-x64.sys" ^
    type= filesys ^
    start= demand

sc.exe start WinFsp
