@echo off
:: =============================================================================
:: Wrapper to run the corresponding PowerShell script with the same name.
:: This allows double-click execution from Windows Explorer.
:: SpearIT, LLC
:: www.spearit.solutions
:: =============================================================================

setlocal
set THISFOLDER=%~dp0
set THISBASENAME=%~n0
set SCRIPTPATH=%THISFOLDER%\%THISBASENAME%.ps1

:: Check if PowerShell script exists
if not exist "%SCRIPTPATH%" (
    echo ERROR: PowerShell script not found:
    echo %SCRIPTPATH%
    echo.
    pause
    exit /b 1
)

:: Display what we're running
echo.
echo Running: %THISBASENAME%.ps1
echo.

:: Execute the PowerShell script
powershell -ExecutionPolicy Bypass -File "%SCRIPTPATH%"
set EXITCODE=%ERRORLEVEL%

:: Report result
echo.
if %EXITCODE% equ 0 (
    echo Script completed successfully.
) else (
    echo Script failed with exit code %EXITCODE%
)
echo.

pause
exit /b %EXITCODE%
