@echo off
:: =============================================================================
:: Wrapper to run the corresponding PowerShell script with the same name.
:: This allows double-click execution from Windows Explorer.
:: Prefers PowerShell 7 (pwsh) if available, falls back to Windows PowerShell
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

:: Check for PowerShell 7 (pwsh) and use it if available
where pwsh >nul 2>&1
if %errorLevel% equ 0 (
    echo Using PowerShell 7 (pwsh)
    echo.
    pwsh -ExecutionPolicy Bypass -File "%SCRIPTPATH%"
) else (
    echo Using Windows PowerShell
    echo.
    powershell -ExecutionPolicy Bypass -File "%SCRIPTPATH%"
)
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
