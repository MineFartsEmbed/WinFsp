@echo off
setlocal

set "BIN=%~dp0bin\winfsp-x64.sys"

:: Check if WinFsp service already exists
sc.exe query WinFsp >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    sc.exe create WinFsp binPath= "%BIN%" type= filesys start= demand >nul
    goto :START_DRIVER
)

:: Ensure service is stopped
call "%~dp0unload.bat" || exit /b 1

:: Point the existing service to winfsp-x64.sys
sc.exe config WinFsp binPath= "%BIN%" type= filesys start= demand >nul

:START_DRIVER
sc.exe start WinFsp

endlocal