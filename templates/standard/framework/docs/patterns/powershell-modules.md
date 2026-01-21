# Pattern: PowerShell Modules

**Type:** Implementation Pattern
**Language:** PowerShell 5.1+
**Purpose:** Reusable module structure for organizing PowerShell functions

---

## Overview

This pattern documents the standard structure for creating PowerShell modules (.psm1) that can be imported and reused across scripts.

---

## Pattern Structure

### Basic Module Template

```powershell
# ModuleName.psm1

<#
.SYNOPSIS
    Brief description of module purpose

.DESCRIPTION
    Detailed description of what this module provides

.NOTES
    File Name   : ModuleName.psm1
    Author      : [Author Name]
    Date        : YYYY-MM-DD
    Version     : 1.0
#>

#Requires -Version 5.1

# Module-level variables (if needed)
$script:ModuleVariable = "value"

# Functions

function Verb-Noun {
    <#
    .SYNOPSIS
        Brief function description

    .DESCRIPTION
        Detailed function description

    .PARAMETER ParameterName
        Parameter description

    .EXAMPLE
        Verb-Noun -ParameterName "value"
        Description of what this example does

    .OUTPUTS
        [Type] Description of return value
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$ParameterName,

        [Parameter(Mandatory=$false)]
        [int]$OptionalParameter = 10
    )

    try {
        # Function implementation
        Write-Verbose "Processing $ParameterName"

        # Return value
        return $result
    }
    catch {
        Write-Error "Failed in Verb-Noun: $_"
        throw
    }
}

# Export public functions
Export-ModuleMember -Function @(
    'Verb-Noun'
)
```

---

## Key Components

### 1. CmdletBinding Attribute

```powershell
[CmdletBinding()]
```

**Benefits:**
- Enables `-Verbose`, `-Debug`, `-ErrorAction` common parameters
- Allows `Write-Verbose` and `Write-Debug` to work properly
- Makes function behave like a cmdlet

**When to use:** All exported module functions

### 2. Parameter Validation

```powershell
[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string]$Path

[Parameter(Mandatory=$false)]
[ValidateSet("Debug", "Info", "Warning", "Error")]
[string]$LogLevel = "Info"

[Parameter(Mandatory=$false)]
[ValidateRange(1, 100)]
[int]$Count = 10
```

**Common validators:**
- `ValidateNotNullOrEmpty()` - Ensures value provided
- `ValidateSet()` - Restricts to specific values
- `ValidateRange()` - Numeric range validation
- `ValidateScript()` - Custom validation logic
- `ValidatePattern()` - Regex pattern matching

### 3. Error Handling

```powershell
try {
    $result = Get-Content $Path -ErrorAction Stop
    return $result
}
catch {
    Write-Error "Failed to read $Path : $_"
    throw  # Re-throw to allow caller to handle
}
```

**Pattern:**
- Use `try-catch` for operations that might fail
- Use `-ErrorAction Stop` to catch non-terminating errors
- Log error with `Write-Error` for context
- Re-throw to allow caller to handle

### 4. Export-ModuleMember

```powershell
Export-ModuleMember -Function @(
    'Public-Function1',
    'Public-Function2'
)
```

**Important:**
- Only export functions that should be public
- Private helper functions should NOT be exported
- Use array syntax for multiple functions
- Can also export variables and aliases if needed

### 5. Module-Level Variables

```powershell
# Use $script: scope for module-wide variables
$script:CachedData = @{}
$script:ModuleInitialized = $false

function Get-CachedData {
    return $script:CachedData
}
```

**Scopes:**
- `$script:` - Shared across all functions in module
- `$local:` - Local to current function (default)
- `$global:` - Global to entire PowerShell session (avoid)

---

## Importing Modules

### In Scripts

```powershell
# Relative path from script location
Import-Module "$PSScriptRoot\modules\ModuleName.psm1" -Force

# The -Force flag reloads the module if already loaded
# Useful during development
```

### Module Auto-Loading

PowerShell can auto-load modules from these locations:
```
$env:PSModulePath
- C:\Program Files\WindowsPowerShell\Modules
- C:\Windows\system32\WindowsPowerShell\v1.0\Modules
- $HOME\Documents\WindowsPowerShell\Modules
```

For auto-loading, structure as:
```
ModuleName/
├── ModuleName.psm1
└── ModuleName.psd1 (manifest, optional)
```

---

## Real-World Example

From the HPC project, the Config.psm1 module:

```powershell
# Config.psm1

$script:cachedConfig = $null
$script:cacheTimestamp = $null
$script:cacheDurationMinutes = 5

function Get-ProjectConfig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [ValidateSet('local', 'shared')]
        [string]$ConfigType,

        [Parameter(Mandatory=$false)]
        [switch]$Force
    )

    # Check cache
    if (-not $Force -and $script:cachedConfig) {
        $age = (Get-Date) - $script:cacheTimestamp
        if ($age.TotalMinutes -lt $script:cacheDurationMinutes) {
            Write-Verbose "Using cached config (age: $($age.TotalMinutes) minutes)"
            return $script:cachedConfig
        }
    }

    # Load config logic...
    $config = Get-Content $configPath | ConvertFrom-Json

    # Cache result
    $script:cachedConfig = $config
    $script:cacheTimestamp = Get-Date

    return $config
}

Export-ModuleMember -Function @('Get-ProjectConfig')
```

---

## Best Practices

### Do's
- ✓ Use `[CmdletBinding()]` on all public functions
- ✓ Provide comprehensive comment-based help
- ✓ Use parameter validation attributes
- ✓ Use `try-catch` for error-prone operations
- ✓ Use `-ErrorAction Stop` to catch errors
- ✓ Explicitly export only public functions
- ✓ Use `$script:` for module-level state
- ✓ Use approved PowerShell verbs (Get, Set, New, Test, etc.)

### Don'ts
- ✗ Don't use global variables (`$global:`)
- ✗ Don't export helper/internal functions
- ✗ Don't use Unicode characters in code
- ✗ Don't swallow errors silently
- ✗ Don't use Write-Host for output (use Write-Output)
- ✗ Don't rely on specific working directory

---

## Testing Modules

```powershell
# Test module import
Import-Module "./ModuleName.psm1" -Force

# Test exported functions
Get-Command -Module ModuleName

# Test function with verbose output
Verb-Noun -ParameterName "test" -Verbose

# Test error handling
try {
    Verb-Noun -ParameterName "invalid"
} catch {
    Write-Host "Caught expected error: $_"
}
```

---

## Related Patterns

- [config-management.md](config-management.md) - Configuration handling pattern
- [cmd-wrappers.md](cmd-wrappers.md) - CMD wrapper pattern for invoking PowerShell

---

## References

- [PowerShell Best Practices](https://docs.microsoft.com/powershell/scripting/developer/cmdlet/cmdlet-development-guidelines)
- [Approved PowerShell Verbs](https://docs.microsoft.com/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands)
- [About Comment Based Help](https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_comment_based_help)

---

**Last Updated:** 2025-11-27
