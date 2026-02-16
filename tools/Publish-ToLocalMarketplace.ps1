#Requires -Version 7.0

<#
.SYNOPSIS
    Publishes plugins to a local Claude Code marketplace for testing.

.DESCRIPTION
    Creates or updates an ephemeral local marketplace at ../claude-local-marketplace/
    for testing Claude Code plugins during development. This enables testing via the
    official /plugin install workflow instead of manual cache manipulation.

    SCOPE: Testing infrastructure ONLY - not release automation.

.PARAMETER Plugin
    Specific plugin to publish. If not specified, publishes all discovered plugins.
    Valid values: spearit-framework-light, spearit-framework

.PARAMETER Clean
    Delete and recreate the marketplace from scratch.

.PARAMETER Build
    Run Build-Plugin.ps1 for the specified plugin before publishing to marketplace.

.EXAMPLE
    .\tools\Publish-ToLocalMarketplace.ps1 -Plugin spearit-framework -Build
    Builds only the spearit-framework plugin and publishes it to the local marketplace.

.EXAMPLE
    .\tools\Publish-ToLocalMarketplace.ps1
    Publishes all plugins found in plugins/ directory (no build).

.EXAMPLE
    .\tools\Publish-ToLocalMarketplace.ps1 -Clean
    Deletes existing marketplace and creates fresh from current plugin metadata.

.EXAMPLE
    .\tools\Publish-ToLocalMarketplace.ps1 -Build
    Builds all plugins first, then updates marketplace.

.NOTES
    File Name      : Publish-ToLocalMarketplace.ps1
    Prerequisite   : Plugins must have .claude-plugin/plugin.json files
    Location       : ../claude-local-marketplace/ (parallel to project repo)
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("spearit-framework-light", "spearit-framework")]
    [string]$Plugin,

    [Parameter(Mandatory=$false)]
    [switch]$Clean,

    [Parameter(Mandatory=$false)]
    [switch]$Build
)

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

        # Validate required fields
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

    Write-Status "Project root: $projectRoot"
    Write-Status "Plugins directory: $pluginsDir"
    Write-Status "Marketplace location: $marketplaceRoot"
    Write-Status ""

    # Validate plugins directory exists
    if (-not (Test-Path $pluginsDir)) {
        throw "Plugins directory not found: $pluginsDir"
    }

    # Handle -Clean flag
    if ($Clean -and (Test-Path $marketplaceRoot)) {
        Write-Status "Cleaning existing marketplace..." -Type Warning
        Remove-Item $marketplaceRoot -Recurse -Force
        Write-Status "Marketplace deleted." -Type Success
        Write-Status ""
    }

    # Create marketplace directory structure
    if (-not (Test-Path $marketplacePluginDir)) {
        Write-Status "Creating marketplace directory structure..."
        New-Item -Path $marketplacePluginDir -ItemType Directory -Force | Out-Null
        Write-Status "Marketplace directory created." -Type Success
        Write-Status ""
    }

    # Discover plugins
    if ($Plugin) {
        Write-Status "Publishing specific plugin: $Plugin ..."
        $pluginPath = Join-Path $pluginsDir $Plugin
        if (-not (Test-Path $pluginPath)) {
            throw "Plugin not found: $pluginPath"
        }
        if (-not (Test-Path (Join-Path $pluginPath ".claude-plugin\plugin.json"))) {
            throw "Plugin missing .claude-plugin/plugin.json: $pluginPath"
        }
        $pluginFolders = @(Get-Item $pluginPath)
    }
    else {
        Write-Status "Discovering all plugins in $pluginsDir ..."
        $pluginFolders = @(Get-ChildItem -Path $pluginsDir -Directory | Where-Object {
            Test-Path (Join-Path $_.FullName ".claude-plugin\plugin.json")
        })
    }

    if ($pluginFolders.Count -eq 0) {
        Write-Status "No plugins found with .claude-plugin/plugin.json" -Type Warning
        Write-Status ""
        Write-Status "Expected structure:"
        Write-Status "  plugins/"
        Write-Status "    <plugin-name>/"
        Write-Status "      .claude-plugin/"
        Write-Status "        plugin.json"
        exit 1
    }

    Write-Status "Found $($pluginFolders.Count) plugin(s) to publish:" -Type Success
    $pluginFolders | ForEach-Object { Write-Status "  - $($_.Name)" }
    Write-Status ""

    # Build plugins if requested
    if ($Build) {
        Write-Status "Building plugins..." -Type Info
        $buildScript = Join-Path $scriptRoot "Build-Plugin.ps1"

        if (-not (Test-Path $buildScript)) {
            Write-Status "Warning: Build-Plugin.ps1 not found, skipping build" -Type Warning
        }
        else {
            foreach ($folder in $pluginFolders) {
                Write-Status "Building $($folder.Name)..."
                # Use -AllowPrerelease for testing builds (e.g., 1.0.0-dev1)
                # Note: Build-Plugin.ps1 uses ErrorActionPreference=Stop, so failures will throw
                & $buildScript -Plugin $folder.Name -AllowPrerelease
            }
            Write-Status "All plugins built successfully." -Type Success
        }
        Write-Status ""
    }

    # Read existing marketplace entries (always, to preserve other plugins)
    $existingEntries = @()
    if (Test-Path $marketplaceJsonPath) {
        Write-Status "Reading existing marketplace entries..."
        try {
            $existingMarketplace = Get-Content $marketplaceJsonPath -Raw | ConvertFrom-Json
            if ($existingMarketplace.plugins) {
                $existingEntries = @($existingMarketplace.plugins)
                Write-Status "  Found $($existingEntries.Count) existing plugin(s)" -Type Info
            }
        }
        catch {
            Write-Status "  Warning: Could not read existing marketplace.json" -Type Warning
        }
    }

    # Read plugin metadata
    Write-Status "Reading plugin metadata..."
    $pluginEntries = @()

    foreach ($folder in $pluginFolders) {
        $metadata = Get-PluginMetadata -PluginPath $folder.FullName

        if ($null -eq $metadata) {
            continue
        }

        # Create symlink to plugin in marketplace
        # This allows live development - changes in source are immediately reflected
        $pluginLinkPath = Join-Path $marketplaceRoot $folder.Name

        if (Test-Path $pluginLinkPath) {
            Remove-Item $pluginLinkPath -Force -Recurse -ErrorAction SilentlyContinue
        }

        # Create directory junction (symlink) on Windows
        $null = New-Item -ItemType Junction -Path $pluginLinkPath -Target $folder.FullName -Force

        # Create marketplace entry
        # Source is relative path within marketplace (where the symlink points)
        $entry = @{
            name = $metadata.name
            source = "./$($folder.Name)"
            description = if ($metadata.description) { $metadata.description } else { "No description" }
            version = if ($metadata.version) { $metadata.version } else { "0.0.0" }
        }

        $pluginEntries += $entry
        Write-Status "  ✓ $($metadata.name) v$($entry.version)" -Type Success
    }

    if ($pluginEntries.Count -eq 0) {
        throw "No valid plugins found to publish"
    }

    # Merge with existing entries (always preserve plugins not being updated)
    if ($existingEntries.Count -gt 0) {
        Write-Status "Merging with existing marketplace entries..."

        # Get names of plugins we're updating
        $updatingNames = @($pluginEntries | ForEach-Object { $_.name })

        # Keep existing entries that aren't being updated
        $preservedEntries = @($existingEntries | Where-Object {
            $_.name -notin $updatingNames
        })

        # Combine: preserved + updated
        $allEntries = @($preservedEntries) + @($pluginEntries)

        Write-Status "  Preserved: $($preservedEntries.Count) plugin(s)" -Type Info
        Write-Status "  Updated: $($pluginEntries.Count) plugin(s)" -Type Info
        Write-Status "  Total: $($allEntries.Count) plugin(s)" -Type Success

        $pluginEntries = $allEntries
    }

    Write-Status ""

    # Create marketplace.json
    Write-Status "Generating marketplace.json..."

    $marketplace = @{
        name = "dev-marketplace"
        owner = @{
            name = "Development"
        }
        plugins = $pluginEntries
    }

    $marketplaceJson = $marketplace | ConvertTo-Json -Depth 10
    Set-Content -Path $marketplaceJsonPath -Value $marketplaceJson -Encoding UTF8

    Write-Status "Marketplace created successfully!" -Type Success
    Write-Status ""
    Write-Status "Location: $marketplaceJsonPath" -Type Info
    Write-Status ""

    # Show next steps
    Write-Status "=== Next Steps ===" -Type Info
    Write-Status ""
    Write-Status "1. Add marketplace to Claude Code (one-time):"
    Write-Status "   /plugin marketplace add $marketplaceRoot" -Type Info
    Write-Status ""
    Write-Status "2. Install plugin:"
    Write-Status "   /plugin install {plugin-name}@dev-marketplace --scope local" -Type Info
    Write-Status ""
    Write-Status "Available plugins:"
    foreach ($entry in $pluginEntries) {
        Write-Status "   - $($entry.name)" -Type Info
    }
    Write-Status ""
    Write-Status "3. After making changes:"
    Write-Status "   .\tools\Publish-ToLocalMarketplace.ps1    # Update marketplace"
    Write-Status "   /plugin marketplace update dev-marketplace # In Claude Code"
    Write-Status "   Restart Claude Code                        # Pick up changes"
    Write-Status ""
    Write-Status "4. To reset:"
    Write-Status "   .\tools\Publish-ToLocalMarketplace.ps1 -Clean"
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
