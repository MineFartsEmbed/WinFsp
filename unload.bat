@echo off
setlocal

sc.exe query WinFsp >nul 2>&1
if %ERRORLEVEL% NEQ 0 exit /b 0

sc.exe query WinFsp | find "STOPPED" >nul 2>&1
if %ERRORLEVEL% EQU 0 exit /b 0

:: Stop if it isn't already stopping
sc.exe query WinFsp | find "STOP_PENDING" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    sc.exe stop WinFsp >nul
)

:: Wait up to 10 seconds for the driver to finish stopping
set /a RETRIES=0
:WAIT_STOP

    sc.exe query WinFsp | find "STOPPED" >nul 2>&1
    if %ERRORLEVEL% EQU 0 exit /b 0

    set /a RETRIES+=1
    if %RETRIES% GEQ 10 (
        echo [ERROR] WinFsp driver failed to stop within 10 seconds.
        echo Close any File Explorer windows or programs using the mounted drive and try again.
        exit /b 1
    )

    timeout /t 1 /nobreak >nul
    goto :WAIT_STOP

endlocal