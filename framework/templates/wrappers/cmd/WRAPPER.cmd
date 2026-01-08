@echo off
:: Wrapper to run the corresponding PowerShell script with the same name.
:: This allows double-click execution from Windows Explorer.
:: SpearIT, LLC 
:: www.spearit.solutions

set THISFOLDER=%~dp0
set THISBASENAME=%~n0
set SCRIPTPATH=%THISFOLDER%\%THISBASENAME%.ps1

powershell -ExecutionPolicy Bypass -File "%SCRIPTPATH%"
set EXITCODE=%ERRORLEVEL%
echo.

if %EXITCODE% equ 0 (
    echo Script completed successfully.
) else (
    echo Script failed with exit code %EXITCODE%
)

pause
exit /b %EXITCODE%
