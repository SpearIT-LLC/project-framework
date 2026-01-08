# Pattern: Configuration Management

**Type:** Implementation Pattern
**Language:** PowerShell, JSON
**Purpose:** Flexible configuration with local overrides and git-friendly defaults

---

## Overview

This pattern provides a two-tier configuration system:
- **Shared config** - Tracked in git, provides defaults for all developers
- **Local config** - Git-ignored, allows per-machine customization

---

## Pattern Structure

### File Structure

```
project-root/
├── config.shared.json      # Tracked in git
├── config.local.json       # Git-ignored (in .gitignore)
└── scripts/
    └── modules/
        └── Config.psm1     # Configuration loader
```

### .gitignore Entry

```
# Local configuration overrides
config.local.json
```

---

## Configuration Files

### config.shared.json (Tracked)

```json
{
  "paths": {
    "jobs_root": "Jobs",
    "manifests": "manifests",
    "logs": "logs",
    "reports": "reports"
  },
  "execution": {
    "default_timeout_minutes": 60,
    "max_concurrent_jobs": 1,
    "retry_attempts": 0
  },
  "logging": {
    "level": "INFO",
    "format": "[{timestamp}] {level} | {message}"
  }
}
```

**Purpose:**
- Provides sensible defaults
- Documents all available settings
- Shared across all developers
- Changes are version-controlled

### config.local.json (Git-ignored)

```json
{
  "paths": {
    "jobs_root": "Jobs",
    "manifests": "manifests",
    "logs": "D:\\CustomLogs",
    "reports": "reports"
  },
  "execution": {
    "default_timeout_minutes": 120,
    "max_concurrent_jobs": 1,
    "retry_attempts": 0
  },
  "logging": {
    "level": "DEBUG",
    "format": "[{timestamp}] {level} | {message}"
  }
}
```

**Purpose:**
- Overrides specific settings for local machine
- Not tracked in git (personal preferences)
- Must be complete (not merged, selection-based)

---

## Config.psm1 Module

### Selection-Based Loading

```powershell
# Config.psm1

$script:cachedConfig = $null
$script:cacheTimestamp = $null
$script:cacheDurationMinutes = 5

function Get-ProjectConfig {
    <#
    .SYNOPSIS
        Loads project configuration with local override support

    .DESCRIPTION
        Loads configuration using selection-based priority:
        1. If config.local.json exists -> use it exclusively
        2. Otherwise -> use config.shared.json

        Results are cached for 5 minutes to avoid repeated disk I/O.

    .PARAMETER ConfigType
        Force loading specific config type: 'local' or 'shared'

    .PARAMETER Force
        Bypass cache and force reload from disk

    .EXAMPLE
        $config = Get-ProjectConfig
        $jobsRoot = $config.paths.jobs_root

    .EXAMPLE
        $config = Get-ProjectConfig -Force
        Reload config, bypassing cache
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [ValidateSet('local', 'shared')]
        [string]$ConfigType,

        [Parameter(Mandatory=$false)]
        [switch]$Force
    )

    # Check cache (unless Force specified)
    if (-not $Force -and $script:cachedConfig) {
        $age = (Get-Date) - $script:cacheTimestamp
        if ($age.TotalMinutes -lt $script:cacheDurationMinutes) {
            Write-Verbose "Using cached config (age: $($age.TotalMinutes.ToString('F2')) minutes)"
            return $script:cachedConfig
        }
    }

    # Determine config root (assume script is in scripts/modules/)
    $configRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

    # Determine which config to load
    if ($ConfigType) {
        # Explicitly requested type
        $configPath = Join-Path $configRoot "config.$ConfigType.json"
        Write-Verbose "Loading explicit config type: $ConfigType"
    }
    else {
        # Selection-based: local if exists, otherwise shared
        $localPath = Join-Path $configRoot "config.local.json"
        $sharedPath = Join-Path $configRoot "config.shared.json"

        if (Test-Path $localPath) {
            $configPath = $localPath
            Write-Verbose "Using local config: $localPath"
        }
        elseif (Test-Path $sharedPath) {
            $configPath = $sharedPath
            Write-Verbose "Using shared config: $sharedPath"
        }
        else {
            throw "No configuration file found. Expected $sharedPath or $localPath"
        }
    }

    # Verify file exists
    if (-not (Test-Path $configPath)) {
        throw "Configuration file not found: $configPath"
    }

    # Load and parse JSON
    try {
        $configContent = Get-Content $configPath -Raw -ErrorAction Stop
        $config = $configContent | ConvertFrom-Json -ErrorAction Stop

        # Cache result
        $script:cachedConfig = $config
        $script:cacheTimestamp = Get-Date

        Write-Verbose "Configuration loaded successfully from: $configPath"
        return $config
    }
    catch {
        throw "Failed to load configuration from $configPath : $_"
    }
}

Export-ModuleMember -Function @('Get-ProjectConfig')
```

---

## Usage in Scripts

### Basic Usage

```powershell
# Import module
Import-Module "$PSScriptRoot\modules\Config.psm1" -Force

# Load config (uses local if exists, otherwise shared)
$config = Get-ProjectConfig

# Access settings
$jobsRoot = $config.paths.jobs_root
$timeout = $config.execution.default_timeout_minutes
$logLevel = $config.logging.level

Write-Verbose "Jobs root: $jobsRoot"
Write-Verbose "Timeout: $timeout minutes"
```

### Force Reload

```powershell
# Force reload from disk (bypass cache)
$config = Get-ProjectConfig -Force
```

### Explicit Config Type

```powershell
# Always load shared config (ignore local)
$config = Get-ProjectConfig -ConfigType shared

# Always load local config (error if doesn't exist)
$config = Get-ProjectConfig -ConfigType local
```

### Nested Properties

```powershell
$config = Get-ProjectConfig

# Access nested properties
$queuePath = Join-Path $config.paths.jobs_root "queue"
$logsPath = $config.paths.logs
$timeout = $config.execution.default_timeout_minutes
```

---

## Design Decisions

### Selection-Based vs Merge-Based

**Decision:** Use selection-based (load one file completely)

**Rationale:**
- Simpler to understand: "This is THE config"
- No confusion about which setting came from where
- Local config is complete, self-documenting
- Easier to debug: just look at the file being used

**Alternative (Merge-based):**
```powershell
# NOT USED: Merge approach
$shared = Get-Content config.shared.json | ConvertFrom-Json
$local = Get-Content config.local.json | ConvertFrom-Json
$config = Merge-Objects $shared $local
```

**Why NOT merge:**
- Requires custom merge logic for nested objects
- Harder to debug: "Where did this setting come from?"
- Partial local configs can become outdated
- More complex implementation

### Caching

**Decision:** Cache config for 5 minutes

**Rationale:**
- Reduces disk I/O for frequently-run scripts
- Still responsive enough to pick up changes during development
- Explicit `-Force` flag available when needed

**Trade-off:**
- Config changes may take up to 5 minutes to take effect
- Acceptable for configuration (changes infrequently)

---

## Best Practices

### For Developers

**Setting up local config:**
```powershell
# Copy shared config as starting point
Copy-Item config.shared.json config.local.json

# Edit config.local.json with your preferences
notepad config.local.json
```

**What to put in local config:**
- Custom log paths (e.g., different drive)
- Extended timeouts for debugging
- Higher log verbosity (DEBUG instead of INFO)
- Machine-specific paths

**What NOT to put in local config:**
- Secrets or credentials (use separate credential management)
- Settings that affect test results (keep tests consistent)

### For Project Maintainers

**Updating shared config:**
1. Update config.shared.json with new settings
2. Document new settings in comments or README
3. Commit and push to git
4. Notify team to update their config.local.json if needed

**Adding new settings:**
```json
{
  "execution": {
    "default_timeout_minutes": 60,
    "new_setting": "default_value"  // Add with sensible default
  }
}
```

---

## Configuration Validation

### Optional: Validate Config Schema

```powershell
function Test-ConfigSchema {
    [CmdletBinding()]
    param([Parameter(Mandatory=$true)]$Config)

    $required = @('paths', 'execution', 'logging')

    foreach ($section in $required) {
        if (-not $Config.PSObject.Properties.Name.Contains($section)) {
            throw "Missing required config section: $section"
        }
    }

    # Validate paths section
    $requiredPaths = @('jobs_root', 'manifests', 'logs')
    foreach ($path in $requiredPaths) {
        if (-not $Config.paths.PSObject.Properties.Name.Contains($path)) {
            throw "Missing required path: $path"
        }
    }

    return $true
}
```

Usage:
```powershell
$config = Get-ProjectConfig
Test-ConfigSchema -Config $config
```

---

## Migration and Versioning

### Adding New Settings

When adding new settings to config.shared.json:

1. Add setting with sensible default
2. Update documentation
3. Test that scripts work with both old and new config
4. Communicate changes to team

### Removing Settings

When removing deprecated settings:

1. Mark as deprecated in documentation first
2. Keep setting in config.shared.json with deprecated note
3. Remove from code
4. Wait one release cycle
5. Remove from config.shared.json

---

## Related Patterns

- [powershell-modules.md](powershell-modules.md) - Module structure pattern
- [cmd-wrappers.md](cmd-wrappers.md) - CMD wrapper pattern

---

## Real-World Example

From HPC Job Queue project:

```powershell
# New-JobsFromManifest.ps1

Import-Module "$PSScriptRoot\modules\Config.psm1" -Force

$config = Get-ProjectConfig

# Use config paths
$manifestPath = Join-Path $config.paths.manifests "manifest.json"
$jobsRoot = $config.paths.jobs_root
$queuePath = Join-Path $jobsRoot "queue"

# Use config settings
$timeout = $config.execution.default_timeout_minutes

Write-Host "Loading manifest from: $manifestPath"
Write-Host "Jobs will be queued to: $queuePath"
Write-Host "Default timeout: $timeout minutes"
```

---

## References

- Project: CONFIG-README.md
- Pattern: powershell-modules.md

---

**Last Updated:** 2025-11-27
