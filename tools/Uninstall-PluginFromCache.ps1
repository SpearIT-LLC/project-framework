#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Uninstall a plugin from the Claude Code cache.

.DESCRIPTION
    Removes a plugin from Claude Code's plugin cache, returning to baseline state.
    Useful for testing clean installation or removing development versions.

    This complements Install-PluginToCache.ps1 by providing a way to completely
    remove a plugin and return to a clean state.

.PARAMETER Plugin
    Plugin name to uninstall (e.g., "spearit-framework-light")
    If not specified, shows list of installed plugins.

.PARAMETER All
    Uninstall all plugins from cache.

.PARAMETER Force
    Skip confirmation prompt.

.EXAMPLE
    .\tools\Uninstall-PluginFromCache.ps1
    # Shows list of installed plugins

.EXAMPLE
    .\tools\Uninstall-PluginFromCache.ps1 -Plugin spearit-framework-light
    # Uninstalls specific plugin with confirmation

.EXAMPLE
    .\tools\Uninstall-PluginFromCache.ps1 -Plugin spearit-framework-light -Force
    # Uninstalls without confirmation

.EXAMPLE
    .\tools\Uninstall-PluginFromCache.ps1 -All -Force
    # Clears entire cache (nuclear option)

.NOTES
    Author: Gary Elliott / SpearIT Solutions
    Created: 2026-02-10

    Cache Location: %USERPROFILE%\.claude\plugins\cache\

    After uninstallation:
    - Restart VSCode for changes to take effect
    - Use /plugin list to verify removal
    - Plugin will no longer appear in command suggestions
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Plugin,

    [switch]$All,

    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Colors for output
function Write-Success { Write-Host "✓ $args" -ForegroundColor Green }
function Write-Info { Write-Host "ℹ $args" -ForegroundColor Cyan }
function Write-Warning { Write-Host "⚠ $args" -ForegroundColor Yellow }
function Write-Error { Write-Host "✗ $args" -ForegroundColor Red }

# Cache location
$CacheDir = Join-Path $env:USERPROFILE ".claude\plugins\cache"

Write-Info "Claude Code Plugin Cache Uninstaller"
Write-Host ""

# Check if cache directory exists
if (-not (Test-Path $CacheDir)) {
    Write-Info "Cache directory does not exist: $CacheDir"
    Write-Info "No plugins installed."
    exit 0
}

# Get installed plugins
$InstalledPlugins = Get-ChildItem -Path $CacheDir -Directory -ErrorAction SilentlyContinue

if ($InstalledPlugins.Count -eq 0) {
    Write-Info "No plugins found in cache."
    Write-Info "Cache location: $CacheDir"
    exit 0
}

# If no plugin specified and not -All, show list
if (-not $Plugin -and -not $All) {
    Write-Info "Installed plugins in cache:"
    Write-Host ""
    $InstalledPlugins | ForEach-Object {
        $pluginJsonPath = Join-Path $_.FullName ".claude-plugin\plugin.json"
        if (Test-Path $pluginJsonPath) {
            $pluginJson = Get-Content $pluginJsonPath -Raw | ConvertFrom-Json
            Write-Host "  📦 $($_.Name)"
            Write-Host "     Version: $($pluginJson.version)"
            Write-Host "     Description: $($pluginJson.description)"
        } else {
            Write-Host "  📦 $($_.Name) (invalid - missing plugin.json)"
        }
        Write-Host ""
    }
    Write-Info "To uninstall a plugin:"
    Write-Host "  .\tools\Uninstall-PluginFromCache.ps1 -Plugin <name>"
    Write-Host ""
    Write-Info "To uninstall all plugins:"
    Write-Host "  .\tools\Uninstall-PluginFromCache.ps1 -All"
    exit 0
}

# Handle -All flag
if ($All) {
    Write-Warning "This will remove ALL plugins from cache:"
    $InstalledPlugins | ForEach-Object {
        Write-Host "  - $($_.Name)"
    }
    Write-Host ""

    if (-not $Force) {
        $response = Read-Host "Are you sure? (yes/no)"
        if ($response -ne 'yes') {
            Write-Info "Uninstall cancelled."
            exit 0
        }
    }

    Write-Info "Removing all plugins..."
    foreach ($pluginDir in $InstalledPlugins) {
        try {
            Remove-Item -Path $pluginDir.FullName -Recurse -Force
            Write-Success "Removed: $($pluginDir.Name)"
        } catch {
            Write-Error "Failed to remove $($pluginDir.Name): $_"
        }
    }

    Write-Host ""
    Write-Success "All plugins uninstalled."
    Write-Host ""
    Write-Info "Next steps:"
    Write-Host "  1. Restart VSCode for changes to take effect"
    Write-Host "  2. Verify with: /plugin list"
    exit 0
}

# Single plugin uninstall
$PluginPath = Join-Path $CacheDir $Plugin

if (-not (Test-Path $PluginPath)) {
    Write-Error "Plugin not found in cache: $Plugin"
    Write-Host ""
    Write-Info "Installed plugins:"
    $InstalledPlugins | ForEach-Object {
        Write-Host "  - $($_.Name)"
    }
    exit 1
}

# Show plugin info before uninstall
Write-Info "Plugin to uninstall:"
Write-Host ""

$PluginJsonPath = Join-Path $PluginPath ".claude-plugin\plugin.json"
if (Test-Path $PluginJsonPath) {
    $PluginJson = Get-Content $PluginJsonPath -Raw | ConvertFrom-Json
    Write-Host "  Name:        $($PluginJson.name)"
    Write-Host "  Version:     $($PluginJson.version)"
    Write-Host "  Description: $($PluginJson.description)"
} else {
    Write-Host "  Name: $Plugin (invalid - missing plugin.json)"
}

Write-Host ""
Write-Info "Location: $PluginPath"
Write-Host ""

# Confirm uninstall
if (-not $Force) {
    $response = Read-Host "Uninstall this plugin? (y/N)"
    if ($response -ne 'y') {
        Write-Info "Uninstall cancelled."
        exit 0
    }
}

# Perform uninstall
Write-Info "Uninstalling plugin..."

try {
    Remove-Item -Path $PluginPath -Recurse -Force
    Write-Success "Plugin uninstalled successfully"
} catch {
    Write-Error "Uninstall failed: $_"
    exit 1
}

Write-Host ""

# Verify removal
if (Test-Path $PluginPath) {
    Write-Error "Verification failed - plugin directory still exists"
    exit 1
} else {
    Write-Success "Verified: Plugin removed from cache"
}

Write-Host ""

# Show next steps
Write-Success "Uninstall complete!"
Write-Host ""
Write-Info "Next steps:"
Write-Host "  1. Restart VSCode for changes to take effect"
Write-Host "  2. In VSCode, verify plugin removed:"
Write-Host "     - Open Claude Code"
Write-Host "     - Type: /plugin list"
Write-Host "     - Plugin should not appear"
Write-Host "  3. Commands will no longer be available:"
Write-Host "     - /$($Plugin):* commands will not work"
Write-Host ""
Write-Info "To reinstall:"
Write-Host "  .\tools\Install-PluginToCache.ps1 -Plugin $Plugin -Force"
