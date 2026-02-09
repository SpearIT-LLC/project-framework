<#
.SYNOPSIS
    Builds distributable ZIP archives for Claude Code plugins.

.DESCRIPTION
    Packages plugin directories from plugins/ into distributable ZIP files.
    Version is read from each plugin's .claude-plugin/plugin.json file.

    Creates output structure:
    - distrib/plugin-light/spearit-framework-light-v1.0.0.zip
    - distrib/plugin-full/spearit-framework-v2.0.0.zip (future)

    Validates plugin structure matches Anthropic standards:
    - .claude-plugin/plugin.json (required)
    - commands/ directory (required)
    - skills/ directory (optional)
    - README.md (required)

.PARAMETER Plugin
    Specific plugin to build (e.g., "spearit-framework-light").
    If not specified, builds all plugins in plugins/ directory.

.PARAMETER OutputPath
    Path for the output directory. Defaults to ./distrib/

.PARAMETER KeepTemp
    If specified, keeps the temp folder after creating the archive

.EXAMPLE
    .\tools\Build-Plugin.ps1
    Builds all plugins in plugins/ directory

.EXAMPLE
    .\tools\Build-Plugin.ps1 -Plugin spearit-framework-light
    Builds only the lightweight edition plugin

.EXAMPLE
    .\tools\Build-Plugin.ps1 -OutputPath "C:\Releases"
    Builds all plugins to custom output directory
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$Plugin,

    [Parameter()]
    [string]$OutputPath,

    [Parameter()]
    [switch]$KeepTemp
)

$ErrorActionPreference = "Stop"

# Determine paths - script is in tools/, so repo root is parent
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$PluginsDir = Join-Path $RepoRoot "plugins"

# Validate plugins directory exists
if (-not (Test-Path $PluginsDir)) {
    Write-Error "Plugins directory not found: $PluginsDir"
    exit 1
}

# Default output path relative to repo root
if (-not $OutputPath) {
    $OutputPath = Join-Path $RepoRoot "distrib"
}

# Create output directory
$OutputPath = [System.IO.Path]::GetFullPath($OutputPath)
if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    Write-Host "Created output directory: $OutputPath" -ForegroundColor Gray
}

# Function to validate plugin structure
function Test-PluginStructure {
    param(
        [string]$PluginPath,
        [string]$PluginName
    )

    $errors = @()

    # Check required: .claude-plugin/plugin.json
    $pluginJson = Join-Path $PluginPath ".claude-plugin\plugin.json"
    if (-not (Test-Path $pluginJson)) {
        $errors += "Missing required file: .claude-plugin/plugin.json"
    }

    # Check required: commands/ directory
    $commandsDir = Join-Path $PluginPath "commands"
    if (-not (Test-Path $commandsDir)) {
        $errors += "Missing required directory: commands/"
    } elseif ((Get-ChildItem $commandsDir -Filter "*.md" -ErrorAction SilentlyContinue).Count -eq 0) {
        $errors += "commands/ directory exists but contains no .md files"
    }

    # Check required: README.md
    $readmeFile = Join-Path $PluginPath "README.md"
    if (-not (Test-Path $readmeFile)) {
        $errors += "Missing required file: README.md"
    }

    # Check optional: skills/ directory (warn if missing, don't error)
    $skillsDir = Join-Path $PluginPath "skills"
    if (-not (Test-Path $skillsDir)) {
        Write-Host "    Note: No skills/ directory (optional)" -ForegroundColor Yellow
    }

    if ($errors.Count -gt 0) {
        Write-Host "  Plugin structure validation FAILED:" -ForegroundColor Red
        foreach ($error in $errors) {
            Write-Host "    - $error" -ForegroundColor Red
        }
        return $false
    }

    Write-Host "    Structure validation passed" -ForegroundColor Green
    return $true
}

# Function to read plugin metadata
function Get-PluginMetadata {
    param(
        [string]$PluginPath
    )

    $pluginJson = Join-Path $PluginPath ".claude-plugin\plugin.json"

    try {
        $metadata = Get-Content $pluginJson -Raw | ConvertFrom-Json

        if (-not $metadata.name) {
            Write-Error "plugin.json missing 'name' field"
            return $null
        }

        if (-not $metadata.version) {
            Write-Error "plugin.json missing 'version' field"
            return $null
        }

        # Validate version format (semantic versioning)
        if ($metadata.version -notmatch '^\d+\.\d+\.\d+$') {
            Write-Error "Invalid version format: $($metadata.version). Expected: X.Y.Z"
            return $null
        }

        return $metadata
    }
    catch {
        Write-Error "Failed to parse plugin.json: $_"
        return $null
    }
}

# Function to build a single plugin
function Build-SinglePlugin {
    param(
        [string]$PluginPath,
        [string]$PluginName
    )

    Write-Host "`nBuilding plugin: $PluginName" -ForegroundColor Cyan
    Write-Host "  Source: $PluginPath" -ForegroundColor Gray

    # Validate plugin structure
    Write-Host "  Validating structure..." -ForegroundColor Gray
    if (-not (Test-PluginStructure -PluginPath $PluginPath -PluginName $PluginName)) {
        Write-Host "  Build FAILED for $PluginName" -ForegroundColor Red
        return $false
    }

    # Read plugin metadata
    Write-Host "  Reading metadata..." -ForegroundColor Gray
    $metadata = Get-PluginMetadata -PluginPath $PluginPath
    if (-not $metadata) {
        Write-Host "  Build FAILED for $PluginName" -ForegroundColor Red
        return $false
    }

    $pluginNameFromJson = $metadata.name
    $version = $metadata.version

    Write-Host "    Name: $pluginNameFromJson" -ForegroundColor White
    Write-Host "    Version: v$version" -ForegroundColor White

    # Determine output subdirectory based on plugin name
    $outputSubdir = switch ($pluginNameFromJson) {
        "spearit-framework-light" { "plugin-light" }
        "spearit-framework"       { "plugin-full" }
        default                   { "plugin-$pluginNameFromJson" }
    }

    $pluginOutputPath = Join-Path $OutputPath $outputSubdir
    if (-not (Test-Path $pluginOutputPath)) {
        New-Item -ItemType Directory -Path $pluginOutputPath -Force | Out-Null
    }

    # Create temp directory
    $zipFileName = "$pluginNameFromJson-v$version.zip"
    $tempDir = Join-Path $pluginOutputPath "temp\$pluginNameFromJson"
    $zipPath = Join-Path $pluginOutputPath $zipFileName

    # Clean up any existing temp or zip
    if (Test-Path $tempDir) {
        Remove-Item -Recurse -Force $tempDir
    }
    if (Test-Path $zipPath) {
        Remove-Item -Force $zipPath
        Write-Host "    Removed existing: $zipFileName" -ForegroundColor Gray
    }

    # Create temp directory structure
    Write-Host "  Preparing archive..." -ForegroundColor Gray
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

    # Copy plugin contents to temp (this becomes the root of the ZIP)
    Copy-Item -Path (Join-Path $PluginPath "*") -Destination $tempDir -Recurse -Force

    # Create the zip archive
    Write-Host "  Creating ZIP archive..." -ForegroundColor Gray
    $tempContents = Join-Path $tempDir "*"
    Compress-Archive -Path $tempContents -DestinationPath $zipPath -Force

    # Clean up temp directory
    if (-not $KeepTemp) {
        Write-Host "  Cleaning up temp directory..." -ForegroundColor Gray
        Remove-Item -Recurse -Force (Join-Path $pluginOutputPath "temp")
    }

    # Summary
    $zipSize = (Get-Item $zipPath).Length / 1KB
    Write-Host "  Build complete!" -ForegroundColor Green
    Write-Host "    Archive: $zipPath" -ForegroundColor White
    Write-Host "    Size: $([math]::Round($zipSize, 2)) KB" -ForegroundColor White

    # List contents summary
    $commandCount = (Get-ChildItem (Join-Path $PluginPath "commands") -Filter "*.md").Count
    $skillsDir = Join-Path $PluginPath "skills"
    $skillCount = if (Test-Path $skillsDir) {
        (Get-ChildItem $skillsDir -Filter "*.md").Count
    } else {
        0
    }

    Write-Host "    Contents:" -ForegroundColor Gray
    Write-Host "      - $commandCount commands" -ForegroundColor Gray
    Write-Host "      - $skillCount skills" -ForegroundColor Gray
    Write-Host "      - README.md" -ForegroundColor Gray
    Write-Host "      - plugin.json" -ForegroundColor Gray

    return $true
}

# Main execution
Write-Host "SpearIT Framework Plugin Builder" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

if ($Plugin) {
    # Build specific plugin
    $pluginPath = Join-Path $PluginsDir $Plugin

    if (-not (Test-Path $pluginPath)) {
        Write-Error "Plugin not found: $Plugin`nPath: $pluginPath"
        exit 1
    }

    $success = Build-SinglePlugin -PluginPath $pluginPath -PluginName $Plugin

    if (-not $success) {
        exit 1
    }
}
else {
    # Build all plugins
    $pluginDirs = Get-ChildItem $PluginsDir -Directory

    if ($pluginDirs.Count -eq 0) {
        Write-Host "`nNo plugins found in: $PluginsDir" -ForegroundColor Yellow
        exit 0
    }

    Write-Host "`nFound $($pluginDirs.Count) plugin(s)" -ForegroundColor White

    $successCount = 0
    $failCount = 0

    foreach ($dir in $pluginDirs) {
        $success = Build-SinglePlugin -PluginPath $dir.FullName -PluginName $dir.Name

        if ($success) {
            $successCount++
        } else {
            $failCount++
        }
    }

    # Overall summary
    Write-Host "`n=================================" -ForegroundColor Cyan
    Write-Host "Build Summary" -ForegroundColor Cyan
    Write-Host "=================================" -ForegroundColor Cyan
    Write-Host "  Successful: $successCount" -ForegroundColor Green
    if ($failCount -gt 0) {
        Write-Host "  Failed: $failCount" -ForegroundColor Red
        exit 1
    }
}

Write-Host "`nAll builds completed successfully!" -ForegroundColor Green
