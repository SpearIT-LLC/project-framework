# Pattern: CMD Batch Wrappers for PowerShell

**Type:** Implementation Pattern
**Language:** CMD (Batch)
**Purpose:** Enable double-click execution of PowerShell scripts with proper error handling

---

## Overview

Windows batch (.cmd) wrappers provide a user-friendly way to execute PowerShell scripts:
- Double-click execution from File Explorer
- Proper error handling and exit codes
- Execution policy handling
- Window behavior control (pause on error)

---

## Pattern Variants

### 1. Basic Wrapper (TEMPLATE-WRAPPER.cmd)

```batch
@echo off
REM Basic PowerShell wrapper - executes script and pauses on error

PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0ScriptName.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Script failed with exit code %ERRORLEVEL%
    pause
)
```

**Use case:** Simple scripts with no parameters

**Features:**
- Executes PowerShell script
- Pauses window on error
- Closes window on success

### 2. Enhanced Wrapper (TEMPLATE-WRAPPER-ENHANCED.cmd) ⭐ Recommended

```batch
@echo off
REM Enhanced PowerShell wrapper with error checking and output capture

setlocal EnableDelayedExpansion

REM Get the directory where this batch file is located
set "SCRIPT_DIR=%~dp0"
set "PS_SCRIPT=%SCRIPT_DIR%ScriptName.ps1"

REM Check if PowerShell script exists
if not exist "%PS_SCRIPT%" (
    echo ERROR: PowerShell script not found: %PS_SCRIPT%
    echo.
    pause
    exit /b 1
)

echo.
echo Executing: %PS_SCRIPT%
echo.

REM Execute PowerShell script
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%" %*

REM Capture exit code
set EXIT_CODE=%ERRORLEVEL%

REM Check result
if !EXIT_CODE! EQU 0 (
    echo.
    echo Script completed successfully.
) else (
    echo.
    echo ========================================
    echo ERROR: Script failed with exit code !EXIT_CODE!
    echo ========================================
    echo.
    pause
)

exit /b !EXIT_CODE!
```

**Use case:** Production scripts (recommended for most scenarios)

**Features:**
- ✓ Validates script exists before execution
- ✓ Captures and propagates exit codes correctly
- ✓ Shows clear success/error messages
- ✓ Passes arguments to PowerShell script (`%*`)
- ✓ Pauses only on error
- ✓ Enables delayed expansion for proper error code handling

### 3. PowerShell 7 Wrapper (TEMPLATE-WRAPPER-PS7.cmd)

```batch
@echo off
REM PowerShell 7 wrapper - prefers pwsh.exe if available

setlocal EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "PS_SCRIPT=%SCRIPT_DIR%ScriptName.ps1"

REM Check if PowerShell script exists
if not exist "%PS_SCRIPT%" (
    echo ERROR: PowerShell script not found: %PS_SCRIPT%
    pause
    exit /b 1
)

REM Check if PowerShell 7 (pwsh.exe) is available
where pwsh.exe >nul 2>&1
if !ERRORLEVEL! EQU 0 (
    echo Using PowerShell 7 ^(pwsh.exe^)
    pwsh.exe -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%" %*
) else (
    echo PowerShell 7 not found, using Windows PowerShell
    PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%" %*
)

set EXIT_CODE=%ERRORLEVEL%

if !EXIT_CODE! NEQ 0 (
    echo.
    echo Script failed with exit code !EXIT_CODE!
    pause
)

exit /b !EXIT_CODE!
```

**Use case:** Scripts requiring PowerShell 7 features (when available)

**Features:**
- ✓ Detects and prefers PowerShell 7 (pwsh.exe)
- ✓ Falls back to Windows PowerShell 5.1
- ✓ Shows which PowerShell version is being used

### 4. Administrator Wrapper (TEMPLATE-WRAPPER-ADMIN.cmd)

```batch
@echo off
REM PowerShell wrapper requiring Administrator privileges

REM Check for admin privileges
net session >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ========================================
    echo ERROR: Administrator privileges required
    echo ========================================
    echo.
    echo This script must be run as Administrator.
    echo Right-click and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

set "SCRIPT_DIR=%~dp0"
set "PS_SCRIPT=%SCRIPT_DIR%ScriptName.ps1"

if not exist "%PS_SCRIPT%" (
    echo ERROR: PowerShell script not found: %PS_SCRIPT%
    pause
    exit /b 1
)

echo Running with Administrator privileges...
echo.

PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%" %*

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Script failed with exit code %ERRORLEVEL%
    pause
)

exit /b %ERRORLEVEL%
```

**Use case:** Scripts requiring Administrator privileges

**Features:**
- ✓ Checks for admin privileges before execution
- ✓ Clear error message if not admin
- ✓ Exits gracefully if privilege check fails

---

## Key Concepts

### 1. Execution Policy Bypass

```batch
PowerShell.exe -ExecutionPolicy Bypass
```

**Why:**
- Windows default execution policy often blocks unsigned scripts
- `-ExecutionPolicy Bypass` allows script to run without policy restrictions
- Safe for trusted scripts in controlled environments

**Alternative:**
```batch
PowerShell.exe -ExecutionPolicy RemoteSigned
```
Use if you want some policy enforcement (local scripts can run, downloaded scripts must be signed)

### 2. NoProfile Flag

```batch
PowerShell.exe -NoProfile
```

**Why:**
- Skips loading user profile scripts
- Faster startup
- Consistent behavior across machines
- Prevents profile script interference

### 3. Exit Code Handling

```batch
setlocal EnableDelayedExpansion

PowerShell.exe -File script.ps1
set EXIT_CODE=%ERRORLEVEL%

if !EXIT_CODE! NEQ 0 (
    echo Failed
)

exit /b !EXIT_CODE!
```

**Key points:**
- `EnableDelayedExpansion` needed for proper exit code capture in if blocks
- Use `!EXIT_CODE!` (delayed) not `%EXIT_CODE%` (immediate) inside if blocks
- `exit /b` returns exit code to caller (important for automation)

### 4. Script Path Resolution

```batch
set "SCRIPT_DIR=%~dp0"
set "PS_SCRIPT=%SCRIPT_DIR%ScriptName.ps1"
```

**Why:**
- `%~dp0` = directory where batch file is located (with trailing backslash)
- Ensures correct path even when batch file invoked from different directory
- Supports spaces in paths (quotes required)

### 5. Argument Forwarding

```batch
PowerShell.exe -File "%PS_SCRIPT%" %*
```

**Why:**
- `%*` passes all command-line arguments to PowerShell script
- Enables: `wrapper.cmd -Verbose -ManifestPath "custom.json"`
- PowerShell script receives arguments as if called directly

---

## Usage Examples

### Example 1: Simple Script Wrapper

```batch
@echo off
REM New-JobsFromManifest.cmd
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0New-JobsFromManifest.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo Script failed with exit code %ERRORLEVEL%
    pause
)
```

**Double-click to run:** Generates jobs from manifest

### Example 2: Wrapper with Parameters

```batch
@echo off
REM Get-JobReport.cmd
setlocal EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "PS_SCRIPT=%SCRIPT_DIR%Get-JobReport.ps1"

PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%" %*

if %ERRORLEVEL% NEQ 0 (
    pause
)
```

**Usage:**
```
Get-JobReport.cmd -Format Html -OutputPath "report.html"
```

### Example 3: Cleanup with Confirmation

```batch
@echo off
REM Clear-JobQueue.cmd
setlocal EnableDelayedExpansion

echo ========================================
echo WARNING: This will delete all jobs
echo ========================================
echo.
set /p CONFIRM="Type YES to continue: "

if /i not "!CONFIRM!"=="YES" (
    echo Cancelled.
    pause
    exit /b 0
)

PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Clear-JobQueue.ps1" -Confirm:$false

if %ERRORLEVEL% NEQ 0 (
    echo Cleanup failed
    pause
)
```

**Safety:** Requires explicit confirmation before running destructive command

---

## Best Practices

### Do's
- ✓ Use `@echo off` at start to reduce noise
- ✓ Use `EnableDelayedExpansion` when capturing exit codes in if blocks
- ✓ Check if PowerShell script exists before executing
- ✓ Use `%~dp0` for script path resolution
- ✓ Propagate exit codes with `exit /b %ERRORLEVEL%`
- ✓ Pause on error to allow user to see error message
- ✓ Use descriptive names matching PowerShell script (e.g., `Get-JobReport.cmd` for `Get-JobReport.ps1`)
- ✓ Pass arguments with `%*` for flexibility

### Don'ts
- ✗ Don't use `pause` on success (window should close automatically)
- ✗ Don't hard-code paths (use `%~dp0` for relative paths)
- ✗ Don't ignore exit codes (always check and propagate)
- ✗ Don't use `%ERRORLEVEL%` inside if blocks without delayed expansion
- ✗ Don't assume execution policy allows scripts (use `-ExecutionPolicy Bypass`)
- ✗ Don't load profiles (use `-NoProfile` for consistent behavior)

---

## Testing Wrappers

### Test Success Case

```batch
@echo off
REM test-success.cmd
PowerShell.exe -NoProfile -Command "Write-Host 'Success'; exit 0"
echo Exit code: %ERRORLEVEL%
pause
```

**Expected:** Exit code 0, window pauses for verification

### Test Failure Case

```batch
@echo off
REM test-failure.cmd
PowerShell.exe -NoProfile -Command "Write-Error 'Failure'; exit 1"
echo Exit code: %ERRORLEVEL%
pause
```

**Expected:** Exit code 1, error message shown, window pauses

### Test Argument Passing

```batch
@echo off
REM test-args.cmd
PowerShell.exe -NoProfile -Command "param($name) Write-Host \"Hello, $name\"" -args %*
pause
```

**Usage:** `test-args.cmd World`
**Expected:** Output "Hello, World"

---

## Common Patterns

### Pattern: Confirmation Prompt

```batch
echo WARNING: This action cannot be undone.
set /p CONFIRM="Continue? (yes/no): "

if /i not "!CONFIRM!"=="yes" (
    echo Cancelled.
    exit /b 0
)
```

### Pattern: Check Prerequisites

```batch
REM Check if manifest exists
if not exist "manifests\manifest.json" (
    echo ERROR: manifest.json not found
    pause
    exit /b 1
)
```

### Pattern: Logging

```batch
set "LOG_FILE=%SCRIPT_DIR%logs\wrapper-%date:~-4,4%%date:~-10,2%%date:~-7,2%.log"

echo [%date% %time%] Starting script execution >> "%LOG_FILE%"
PowerShell.exe -File "%PS_SCRIPT%" >> "%LOG_FILE%" 2>&1
echo [%date% %time%] Completed with exit code %ERRORLEVEL% >> "%LOG_FILE%"
```

---

## Project Structure

Recommended folder structure for wrappers:

```
project-root/
├── wrappers/
│   └── cmd/
│       ├── README.md
│       ├── TEMPLATE-WRAPPER.cmd
│       ├── TEMPLATE-WRAPPER-ENHANCED.cmd
│       ├── TEMPLATE-WRAPPER-PS7.cmd
│       └── TEMPLATE-WRAPPER-ADMIN.cmd
│
└── scripts/
    ├── ScriptName.ps1
    ├── ScriptName.cmd              (copy from template)
    ├── AnotherScript.ps1
    └── AnotherScript.cmd           (copy from template)
```

**Workflow:**
1. Write PowerShell script in `scripts/`
2. Copy appropriate template from `wrappers/cmd/`
3. Rename to match PowerShell script name
4. Update `PS_SCRIPT` variable to point to correct .ps1 file
5. Test double-click execution

---

## Related Patterns

- [powershell-modules.md](powershell-modules.md) - PowerShell module structure
- [config-management.md](config-management.md) - Configuration handling

---

## References

- [Batch File Basics](https://ss64.com/nt/)
- [PowerShell Command Line Parameters](https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_powershell_exe)
- [Delayed Expansion in Batch](https://ss64.com/nt/delayedexpansion.html)

---

**Last Updated:** 2025-11-27
