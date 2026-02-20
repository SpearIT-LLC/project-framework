#Requires -Version 7.0

<#
.SYNOPSIS
    Resets and republishes all plugins to the local Claude Code marketplace for testing.

.DESCRIPTION
    Wipes the local marketplace and Claude plugin cache (dev-marketplace), then
    republishes all plugins as directory junctions. Run this before each test cycle
    to ensure a clean, up-to-date state.

    SCOPE: Testing infrastructure ONLY - not release automation.
    For building distributable packages, use Build-Plugin.ps1.

.EXAMPLE
    .\tools\Publish-ToLocalMarketplace.ps1
    Resets marketplace and cache, republishes all plugins.

.NOTES
    File Name      : Publish-ToLocalMarketplace.ps1
    Prerequisite   : Plugins must have .claude-plugin/plugin.json files
    Location       : ../claude-local-marketplace/ (parallel to project repo)

    Testing workflow (repeat until satisfied):
      1. .\tools\Publish-ToLocalMarketplace.ps1
      2. /plugin marketplace update dev-marketplace  (in Claude Code)
      3. Restart Claude Code
      4. Test
#>

[CmdletBinding()]
param()

# Strict mode for better error handling
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

#region Helper Functions

function Write-Status {
    param([string]$Message, [string]$Type = "Info")

    $color = switch ($Type) {
        "Success" { "Green" }
        "Error"   { "Red" }
        "Warning" { "Yellow" }
        default   { "Cyan" }
    }

    Write-Host $Message -ForegroundColor $color
}

function Get-PluginMetadata {
    param([string]$PluginPath)

    $pluginJsonPath = Join-Path $PluginPath ".claude-plugin\plugin.json"

    if (-not (Test-Path $pluginJsonPath)) {
        Write-Status "Warning: No plugin.json found at $pluginJsonPath" -Type Warning
        return $null
    }

    try {
        $pluginJson = Get-Content $pluginJsonPath -Raw | ConvertFrom-Json

        if (-not $pluginJson.name) {
            Write-Status "Warning: Plugin at $PluginPath missing 'name' field" -Type Warning
            return $null
        }

        return $pluginJson
    }
    catch {
        Write-Status "Error reading plugin.json at $pluginJsonPath : $_" -Type Error
        return $null
    }
}

#endregion

#region Main Script

try {
    Write-Status "=== Publish to Local Marketplace ===" -Type Info
    Write-Status ""

    # Determine paths
    $scriptRoot = $PSScriptRoot
    $projectRoot = Split-Path $scriptRoot -Parent
    $pluginsDir = Join-Path $projectRoot "plugins"
    $marketplaceRoot = Join-Path (Split-Path $projectRoot -Parent) "claude-local-marketplace"
    $marketplacePluginDir = Join-Path $marketplaceRoot ".claude-plugin"
    $marketplaceJsonPath = Join-Path $marketplacePluginDir "marketplace.json"
    $claudeCacheRoot = Join-Path $env:USERPROFILE ".claude\plugins\cache\dev-marketplace"
    $installedPluginsPath = Join-Path $env:USERPROFILE ".claude\plugins\installed_plugins.json"

    Write-Status "Project root: $projectRoot"
    Write-Status "Plugins directory: $pluginsDir"
    Write-Status "Marketplace location: $marketplaceRoot"
    Write-Status ""

    # Validate plugins directory exists
    if (-not (Test-Path $pluginsDir)) {
        throw "Plugins directory not found: $pluginsDir"
    }

    # Step 1: Wipe marketplace and Claude plugin cache
    Write-Status "--- Cleaning ---" -Type Warning

    if (Test-Path $marketplaceRoot) {
        Remove-Item $marketplaceRoot -Recurse -Force
        Write-Status "Marketplace deleted." -Type Success
    }

    if (Test-Path $claudeCacheRoot) {
        Remove-Item $claudeCacheRoot -Recurse -Force
        Write-Status "Claude plugin cache purged." -Type Success
    }

    if (Test-Path $installedPluginsPath) {
        $installedPlugins = Get-Content $installedPluginsPath -Raw | ConvertFrom-Json -AsHashtable
        if ($installedPlugins.ContainsKey('plugins') -and $installedPlugins['plugins'] -is [hashtable]) {
            $keysToRemove = @($installedPlugins['plugins'].Keys | Where-Object { $_ -like "*@dev-marketplace" })
            foreach ($key in $keysToRemove) {
                $installedPlugins['plugins'].Remove($key)
            }
            Set-Content -Path $installedPluginsPath -Value ($installedPlugins | ConvertTo-Json -Depth 10) -Encoding UTF8
            Write-Status "Removed $($keysToRemove.Count) dev-marketplace entry/entries from installed_plugins.json." -Type Success
        } else {
            Write-Status "installed_plugins.json plugins entry is empty or not an object — nothing to remove." -Type Info
        }
    }

    Write-Status ""

    # Step 2: Create marketplace directory structure
    New-Item -Path $marketplacePluginDir -ItemType Directory -Force | Out-Null
    Write-Status "--- Publishing ---" -Type Info

    # Step 3: Discover plugins
    $pluginFolders = @(Get-ChildItem -Path $pluginsDir -Directory | Where-Object {
        Test-Path (Join-Path $_.FullName ".claude-plugin\plugin.json")
    })

    if ($pluginFolders.Count -eq 0) {
        throw "No plugins found with .claude-plugin/plugin.json in $pluginsDir"
    }

    # Step 4: Create junctions and build marketplace entries
    $pluginEntries = @()

    foreach ($folder in $pluginFolders) {
        $metadata = Get-PluginMetadata -PluginPath $folder.FullName

        if ($null -eq $metadata) {
            continue
        }

        # Create directory junction — changes in source are immediately reflected
        # Use Directory.Delete (not Remove-Item -Recurse) to avoid following the
        # junction and deleting the actual plugin source files
        $pluginLinkPath = Join-Path $marketplaceRoot $folder.Name
        if (Test-Path $pluginLinkPath) {
            [System.IO.Directory]::Delete($pluginLinkPath)
        }
        $null = New-Item -ItemType Junction -Path $pluginLinkPath -Target $folder.FullName -Force

        $entry = @{
            name        = $metadata.name
            source      = "./$($folder.Name)"
            description = if ($metadata.description) { $metadata.description } else { "No description" }
            version     = if ($metadata.version) { $metadata.version } else { "0.0.0" }
        }

        $pluginEntries += $entry
        Write-Status "  ✓ $($metadata.name) v$($entry.version)" -Type Success
    }

    if ($pluginEntries.Count -eq 0) {
        throw "No valid plugins found to publish"
    }

    # Step 5: Write marketplace.json
    $marketplace = @{
        name   = "dev-marketplace"
        owner  = @{ name = "Development" }
        plugins = $pluginEntries
    }

    Set-Content -Path $marketplaceJsonPath -Value ($marketplace | ConvertTo-Json -Depth 10) -Encoding UTF8

    Write-Status ""
    Write-Status "Marketplace ready: $marketplaceJsonPath" -Type Success
    Write-Status ""

    # Next steps
    Write-Status "=== Next Steps ===" -Type Info
    Write-Status ""
    Write-Status "  /plugin marketplace update dev-marketplace   (in Claude Code)"
    Write-Status "  Restart Claude Code"
    Write-Status "  Test"
    Write-Status ""
    Write-Status "One-time setup (if not already done):"
    Write-Status "  /plugin marketplace add $marketplaceRoot" -Type Info
    Write-Status "  /plugin install {plugin-name}@dev-marketplace --scope local" -Type Info
    Write-Status ""

}
catch {
    Write-Status ""
    Write-Status "Error: $_" -Type Error
    Write-Status ""
    Write-Status "Stack trace:" -Type Error
    Write-Status $_.ScriptStackTrace -Type Error
    exit 1
}

#endregion
