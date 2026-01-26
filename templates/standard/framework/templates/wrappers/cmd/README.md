# CMD Wrappers for PowerShell Scripts

**Purpose:** Reusable CMD batch wrappers that allow PowerShell scripts to be executed via double-click in Windows Explorer.

**Author:** Gary Elliott (gary.elliott@spearit.solutions)
**Organization:** SpearIT, LLC
**Last Updated:** 2025-11-25

---

## Overview

These wrapper templates solve a common Windows usability problem: PowerShell scripts (`.ps1` files) cannot be double-clicked to run directly due to execution policy restrictions. These CMD wrappers provide a user-friendly launcher experience.

### How It Works

1. User double-clicks `MyScript.cmd`
2. Wrapper automatically finds and launches `MyScript.ps1` with proper execution policy
3. Script output is displayed in console window
4. Window pauses on completion (success or failure) for user review
5. Exit code is preserved and returned

---

## Available Wrapper Templates

### WRAPPER.cmd (Basic)

**Use for:** Most general-purpose scripts that don't require special privileges or PowerShell version.

**Features:**
- Simple, minimal wrapper
- Uses Windows PowerShell (powershell.exe)
- Bypasses execution policy
- Reports success/failure
- Pauses on completion

**Usage:**
```cmd
copy framework\templates\wrappers\cmd\WRAPPER.cmd scripts\New-JobsFromManifest.cmd
```

---

### WRAPPER-ENHANCED.cmd (Recommended)

**Use for:** Production scripts where you want better error handling and user feedback.

**Features:**
- Everything from basic wrapper, plus:
- Checks if PowerShell script exists before running
- Clear error message if script not found
- Displays script name being executed
- Better formatted output with spacing

**Usage:**
```cmd
copy framework\templates\wrappers\cmd\WRAPPER-ENHANCED.cmd scripts\Start-JobScheduler.cmd
```

**Recommended for:**
- Main project scripts (New-JobsFromManifest, Start-JobScheduler, etc.)
- Installer scripts
- User-facing utilities

---

### WRAPPER-PS7.cmd (PowerShell 7 Preferred)

**Use for:** Scripts that benefit from PowerShell 7 features but should still work on Windows PowerShell.

**Features:**
- Everything from enhanced wrapper, plus:
- Detects if PowerShell 7 (pwsh) is installed
- Prefers PowerShell 7 if available
- Falls back to Windows PowerShell (powershell.exe) if not
- Displays which PowerShell version is being used

**Usage:**
```cmd
copy framework\templates\wrappers\cmd\WRAPPER-PS7.cmd scripts\Export-HpcJobXml.cmd
```

**When to use:**
- Scripts using PS 7 features (e.g., parallel processing, ternary operators)
- Development environments with mixed PowerShell versions
- Scripts where PS 7 provides 20%+ performance improvement (per coding standards)

---

### WRAPPER-ADMIN.cmd (Administrator Required)

**Use for:** Scripts that require administrator privileges (system-level changes, service management, etc.).

**Features:**
- Everything from enhanced wrapper, plus:
- Checks for administrator privileges before running
- Clear error message if not running as admin
- Reminds user to "Run as administrator"
- Prevents partial execution of privileged operations

**Usage:**
```cmd
copy framework\templates\wrappers\cmd\WRAPPER-ADMIN.cmd installers\microsoft\Install-HpcPack.cmd
```

**When to use:**
- Installing software or Windows features
- Modifying system settings
- Managing Windows services
- Registry modifications
- Network configuration changes

---

## Usage Pattern

### Basic Pattern

1. **Copy** the appropriate template to your target location
2. **Rename** to match your PowerShell script name (without .ps1 extension)
3. The wrapper automatically finds the corresponding `.ps1` file

**Example:**

```cmd
# For a script named Start-JobScheduler.ps1
cd HPCJobQueuePrototype
copy wrappers\cmd\TEMPLATE-WRAPPER-ENHANCED.cmd scripts\Start-JobScheduler.cmd

# Now users can double-click Start-JobScheduler.cmd
```

### Directory Structure

```
HPCJobQueuePrototype/
├── project-hub/
│   └── framework/
│       └── templates/
│           └── wrappers/
│               └── cmd/
│                   ├── WRAPPER.cmd           # Basic wrapper
│                   ├── WRAPPER-ENHANCED.cmd  # Recommended
│                   ├── WRAPPER-PS7.cmd       # PowerShell 7 preferred
│                   ├── WRAPPER-ADMIN.cmd     # Administrator required
│                   └── README.md             # This file
│
├── scripts/
│   ├── New-JobsFromManifest.ps1             # PowerShell script
│   ├── New-JobsFromManifest.cmd             # Wrapper (copy of template)
│   ├── Start-JobScheduler.ps1
│   └── Start-JobScheduler.cmd
│
└── installers/
    └── microsoft/
        ├── Install-HpcPack.ps1
        └── Install-HpcPack.cmd              # Wrapper (copy of template)
```

---

## Technical Details

### How the Wrapper Works

The wrapper uses CMD batch scripting to:

1. **Determine script location:**
   ```cmd
   set THISFOLDER=%~dp0         # Directory where wrapper is located
   set THISBASENAME=%~n0        # Wrapper filename without extension
   ```

2. **Build PowerShell script path:**
   ```cmd
   set SCRIPTPATH=%THISFOLDER%\%THISBASENAME%.ps1
   ```

3. **Execute with bypass policy:**
   ```cmd
   powershell -ExecutionPolicy Bypass -File "%SCRIPTPATH%"
   ```

4. **Capture and return exit code:**
   ```cmd
   set EXITCODE=%ERRORLEVEL%
   exit /b %EXITCODE%
   ```

### Exit Code Handling

- **Exit code 0:** Success (green path)
- **Exit code 1:** Standard error (most common failure)
- **Exit code >1:** Specific error codes (script-defined)

The wrapper preserves the PowerShell script's exit code, allowing batch scripts or CI/CD systems to detect failures.

---

## Best Practices

### When to Use Wrappers

**✅ Good use cases:**
- Scripts intended for non-technical users
- Installer and setup scripts
- Main workflow scripts (job generation, scheduling)
- Utility scripts that need double-click execution

**❌ Don't use wrappers for:**
- Scripts only called by other scripts (use direct PowerShell invocation)
- Automated/scheduled tasks (use Task Scheduler or direct PS invocation)
- CI/CD pipeline scripts (use direct PowerShell commands)

### Naming Conventions

- Wrapper and script must have the **same base name**
- Wrapper: `MyScript.cmd`
- PowerShell: `MyScript.ps1`
- Both files in the **same directory**

### Version Control

**Git tracking:**
- ✅ Track template files in `project-hub/framework/templates/wrappers/cmd/`
- ✅ Track copies in `scripts/` and `installers/` (they're small, useful for users)
- ❌ Don't track temporary or generated wrappers

### Updating Wrappers

If you update a template in `project-hub/framework/templates/wrappers/cmd/`:

1. Review all locations where the template is used
2. Decide if updates should be propagated
3. Manually copy updated template to each location
4. Test each wrapper after update

**Note:** There's no automatic synchronization - this is intentional to avoid breaking working wrappers.

---

## Troubleshooting

### "PowerShell script not found"

**Cause:** Wrapper and PowerShell script have different names or are in different directories.

**Solution:**
```cmd
# Verify names match
dir MyScript.cmd
dir MyScript.ps1

# Ensure both files are in the same directory
```

### "This script requires administrator privileges"

**Cause:** Using TEMPLATE-WRAPPER-ADMIN.cmd without admin rights.

**Solution:**
- Right-click the `.cmd` file
- Select "Run as administrator"

### Wrapper runs but script doesn't execute

**Cause:** Execution policy may be blocking despite `-ExecutionPolicy Bypass`.

**Solution:**
```powershell
# Check current execution policy
Get-ExecutionPolicy -List

# If needed, set a more permissive policy (as admin)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### No output visible

**Cause:** Script may be redirecting output or running silently.

**Solution:**
- Add `Write-Host` statements to your PowerShell script
- Check log files if the script uses logging
- Run the `.ps1` file directly in PowerShell to see all output

---

## Examples

### Example 1: Main Workflow Script

**Scenario:** Make `Start-JobScheduler.ps1` double-clickable for QA team.

```cmd
cd HPCJobQueuePrototype
copy framework\templates\wrappers\cmd\WRAPPER-ENHANCED.cmd scripts\Start-JobScheduler.cmd
```

**Result:** QA team can double-click `Start-JobScheduler.cmd` to launch the job scheduler.

---

### Example 2: Installer Script with Admin Rights

**Scenario:** HPC Pack installation requires administrator privileges.

```cmd
cd HPCJobQueuePrototype
copy framework\templates\wrappers\cmd\WRAPPER-ADMIN.cmd installers\microsoft\Install-HpcPack.cmd
```

**Result:**
- User double-clicks `Install-HpcPack.cmd`
- If not admin: Clear error message, instructions to run as admin
- If admin: Proceeds with installation

---

### Example 3: Development Script with PowerShell 7

**Scenario:** Export script uses PowerShell 7 parallel features but should work on PS 5.1.

```cmd
cd HPCJobQueuePrototype
copy framework\templates\wrappers\cmd\WRAPPER-PS7.cmd scripts\Export-HpcJobXml.cmd
```

**Result:**
- On dev machine with PS 7: Uses `pwsh` for faster execution
- On production machine with PS 5.1: Falls back to `powershell`

---

## Related Documentation

- **[coding-standards.md](../../project-hub/project/reference/coding-standards.md)** - PowerShell coding standards
- **[CLAUDE.md](../../CLAUDE.md)** - Project overview and architecture
- **[README.md](../../README.md)** - Getting started guide

---

## Maintenance Notes

### Template Updates

When modifying templates, consider:

1. **Backward compatibility:** Don't break existing wrappers
2. **Documentation:** Update this README
3. **Testing:** Test with sample PowerShell scripts
4. **User communication:** Notify users if they need to update their wrappers

### Future Enhancements

Potential improvements for future versions:

- **Auto-elevation:** Wrapper that prompts for UAC elevation if needed
- **Logging:** Built-in transcript logging option
- **Arguments:** Pass command-line arguments to PowerShell script
- **VBScript wrapper:** Silent execution without console window
- **Bash wrapper:** For WSL/Linux environments

---

**Version:** 1.0.0
**Last Updated:** 2025-11-25
**Maintained by:** Gary Elliott (gary.elliott@spearit.solutions)
