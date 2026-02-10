#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Install a plugin to the Claude Code cache for testing in VSCode.

.DESCRIPTION
    Copies a plugin from the development directory to Claude Code's plugin cache.
    Handles cache clearing, installation, and provides clear feedback.

    This is necessary because Claude Code copies plugins to cache rather than
    symlinking them (for security reasons). During development, you must manually
    update the cache after making changes.

.PARAMETER Plugin
    Plugin name to install (e.g., "spearit-framework-light")
    If not specified, auto-detects from plugins/ directory.

.PARAMETER Force
    Clear cache and reinstall even if plugin already exists.

.PARAMETER NoBuild
    Skip running Build-Plugin.ps1 before installation.
    Use this if you're testing changes that don't need a full rebuild.

.EXAMPLE
    .\tools\Install-PluginToCache.ps1
    # Auto-detects plugin, builds, and installs

.EXAMPLE
    .\tools\Install-PluginToCache.ps1 -Plugin spearit-framework-light -Force
    # Forces reinstall of specific plugin

.EXAMPLE
    .\tools\Install-PluginToCache.ps1 -NoBuild
    # Installs without rebuilding (faster for quick tests)

.NOTES
    Author: Gary Elliott / SpearIT Solutions
    Created: 2026-02-10

    Cache Location: %USERPROFILE%\.claude\plugins\cache\

    After installation:
    - Restart VSCode for changes to take effect
    - Use /plugin list to verify installation
    - Use /spearit-framework-light:help to test commands
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Plugin,

    [switch]$Force,

    [switch]$NoBuild
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Colors for output
function Write-Success { Write-Host "✓ $args" -ForegroundColor Green }
function Write-Info { Write-Host "ℹ $args" -ForegroundColor Cyan }
function Write-Warning { Write-Host "⚠ $args" -ForegroundColor Yellow }
function Write-Error { Write-Host "✗ $args" -ForegroundColor Red }

# Determine repository root
$RepoRoot = Split-Path -Parent $PSScriptRoot
$PluginsDir = Join-Path $RepoRoot "plugins"

# Cache location
$CacheDir = Join-Path $env:USERPROFILE ".claude\plugins\cache"

Write-Info "Claude Code Plugin Cache Installer"
Write-Host ""

# Step 1: Auto-detect or validate plugin
if (-not $Plugin) {
    Write-Info "Auto-detecting plugin..."
    $AvailablePlugins = Get-ChildItem -Path $PluginsDir -Directory | Where-Object {
        Test-Path (Join-Path $_.FullName ".claude-plugin")
    }

    if ($AvailablePlugins.Count -eq 0) {
        Write-Error "No plugins found in plugins/ directory"
        exit 1
    }

    if ($AvailablePlugins.Count -eq 1) {
        $Plugin = $AvailablePlugins[0].Name
        Write-Success "Detected plugin: $Plugin"
    } else {
        Write-Error "Multiple plugins found. Please specify which one:"
        $AvailablePlugins | ForEach-Object { Write-Host "  - $($_.Name)" }
        exit 1
    }
}

$PluginPath = Join-Path $PluginsDir $Plugin

# Validate plugin exists
if (-not (Test-Path $PluginPath)) {
    Write-Error "Plugin not found: $PluginPath"
    exit 1
}

if (-not (Test-Path (Join-Path $PluginPath ".claude-plugin"))) {
    Write-Error "Invalid plugin (missing .claude-plugin/ directory): $PluginPath"
    exit 1
}

Write-Info "Plugin source: $PluginPath"
Write-Host ""

# Step 2: Build plugin (unless skipped)
if (-not $NoBuild) {
    Write-Info "Building plugin..."
    $BuildScript = Join-Path $PSScriptRoot "Build-Plugin.ps1"

    if (-not (Test-Path $BuildScript)) {
        Write-Warning "Build script not found at: $BuildScript"
        Write-Warning "Skipping build step..."
    } else {
        try {
            & $BuildScript -Plugin $Plugin
            Write-Success "Plugin built successfully"
            Write-Host ""
        } catch {
            Write-Error "Build failed: $_"
            exit 1
        }
    }
} else {
    Write-Info "Skipping build (NoBuild flag set)"
    Write-Host ""
}

# Step 3: Prepare cache directory
$CachePath = Join-Path $CacheDir $Plugin

Write-Info "Cache location: $CachePath"

if (Test-Path $CachePath) {
    if ($Force) {
        Write-Info "Removing existing cached plugin..."
        Remove-Item -Path $CachePath -Recurse -Force
        Write-Success "Cache cleared"
    } else {
        Write-Warning "Plugin already exists in cache"
        Write-Warning "Use -Force to reinstall"
        Write-Host ""
        Write-Info "Current cache contents:"
        Get-ChildItem -Path $CachePath -Recurse | Select-Object -First 10 | ForEach-Object {
            Write-Host "  $($_.FullName.Substring($CachePath.Length))"
        }
        Write-Host ""
        $response = Read-Host "Reinstall anyway? (y/N)"
        if ($response -ne 'y') {
            Write-Info "Installation cancelled"
            exit 0
        }
        Remove-Item -Path $CachePath -Recurse -Force
    }
}

# Ensure cache directory exists
if (-not (Test-Path $CacheDir)) {
    Write-Info "Creating cache directory..."
    New-Item -ItemType Directory -Path $CacheDir -Force | Out-Null
    Write-Success "Cache directory created"
}

Write-Host ""

# Step 4: Copy plugin to cache
Write-Info "Installing plugin to cache..."

try {
    Copy-Item -Path $PluginPath -Destination $CachePath -Recurse -Force
    Write-Success "Plugin installed successfully"
} catch {
    Write-Error "Installation failed: $_"
    exit 1
}

Write-Host ""

# Step 5: Verify installation
Write-Info "Verifying installation..."

$RequiredDirs = @(".claude-plugin")
$RequiredFiles = @(".claude-plugin\plugin.json")

$VerificationPassed = $true

foreach ($dir in $RequiredDirs) {
    $path = Join-Path $CachePath $dir
    if (Test-Path $path) {
        Write-Success "Found: $dir"
    } else {
        Write-Error "Missing: $dir"
        $VerificationPassed = $false
    }
}

foreach ($file in $RequiredFiles) {
    $path = Join-Path $CachePath $file
    if (Test-Path $path) {
        Write-Success "Found: $file"
    } else {
        Write-Error "Missing: $file"
        $VerificationPassed = $false
    }
}

if (-not $VerificationPassed) {
    Write-Error "Verification failed - installation may be incomplete"
    exit 1
}

Write-Host ""

# Step 6: Show plugin info
Write-Info "Plugin information:"

$PluginJsonPath = Join-Path $CachePath ".claude-plugin\plugin.json"
if (Test-Path $PluginJsonPath) {
    $PluginJson = Get-Content $PluginJsonPath -Raw | ConvertFrom-Json
    Write-Host "  Name:        $($PluginJson.name)"
    Write-Host "  Version:     $($PluginJson.version)"
    Write-Host "  Description: $($PluginJson.description)"
}

Write-Host ""

# Step 7: Show next steps
Write-Success "Installation complete!"
Write-Host ""
Write-Info "Next steps:"
Write-Host "  1. Restart VSCode for changes to take effect"
Write-Host "  2. In VSCode, verify plugin loaded:"
Write-Host "     - Open Claude Code"
Write-Host "     - Type: /plugin list"
Write-Host "  3. Test commands:"
Write-Host "     - Type: /$($Plugin):help"
Write-Host ""
Write-Info "To reinstall after making changes:"
Write-Host "  .\tools\Install-PluginToCache.ps1 -Force"
Write-Host ""
Write-Info "For faster iterations (skip build):"
Write-Host "  .\tools\Install-PluginToCache.ps1 -NoBuild -Force"
