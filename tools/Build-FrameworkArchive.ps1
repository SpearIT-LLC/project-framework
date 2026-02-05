<#
.SYNOPSIS
    Builds a distributable archive of the SpearIT Framework.

.DESCRIPTION
    Creates a zip archive containing:
    - framework/docs/ (from live framework)
    - framework/templates/ (from live framework)
    - framework/tools/ (from live framework)
    - Project scaffolding (from templates/starter/)

    Excludes:
    - project-hub/ (framework's own work items)
    - framework root files (CLAUDE.md, README.md, etc.)

    Pre-build checks:
    - Warns if items exist in done/ (unreleased work)

.PARAMETER OutputPath
    Path for the output directory. Defaults to ./distrib/

.PARAMETER KeepTemp
    If specified, keeps the temp folder after creating the archive

.EXAMPLE
    .\tools\Build-FrameworkArchive.ps1
    # Version is read from framework/PROJECT-STATUS.md

.EXAMPLE
    .\tools\Build-FrameworkArchive.ps1 -OutputPath "C:\Releases"
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$OutputPath,

    [Parameter()]
    [switch]$KeepTemp
)

$ErrorActionPreference = "Stop"

# Determine paths - script is in tools/, so repo root is parent
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$FrameworkDir = Join-Path $RepoRoot "framework"
$StarterDir = Join-Path $RepoRoot "templates\starter"

# Validate source directories exist
if (-not (Test-Path $FrameworkDir)) {
    Write-Error "Framework directory not found: $FrameworkDir"
    exit 1
}

if (-not (Test-Path $StarterDir)) {
    Write-Error "Starter template directory not found: $StarterDir"
    exit 1
}

# Read version from PROJECT-STATUS.md (single source of truth)
$StatusFile = Join-Path $FrameworkDir "PROJECT-STATUS.md"
if (-not (Test-Path $StatusFile)) {
    Write-Error "PROJECT-STATUS.md not found: $StatusFile"
    exit 1
}
$StatusContent = Get-Content $StatusFile -Raw
if ($StatusContent -match '\*\*Current Version:\*\*\s*v?(\d+\.\d+\.\d+)') {
    $Version = $Matches[1]
    Write-Host "Version: v$Version (from PROJECT-STATUS.md)" -ForegroundColor Cyan
} else {
    Write-Error "Could not parse version from PROJECT-STATUS.md"
    exit 1
}

# Check for unreleased items in done/
$DoneDir = Join-Path $RepoRoot "project-hub\work\done"
$DoneItems = Get-ChildItem "$DoneDir\*.md" -ErrorAction SilentlyContinue
if ($DoneItems) {
    Write-Host "`nUnreleased items in done/:" -ForegroundColor Yellow
    foreach ($item in $DoneItems) {
        Write-Host "  - $($item.Name)" -ForegroundColor Yellow
    }
    Write-Host ""
    $continue = Read-Host "Items awaiting release found. Continue build anyway? (y/n)"
    if ($continue -notmatch "^[yY]") {
        Write-Host "Build cancelled. Release items first, then rebuild." -ForegroundColor Red
        exit 0
    }
    Write-Host ""
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

# Create temp directory
$ArchiveName = "spearit_framework_v$Version"
$TempDir = Join-Path $OutputPath "temp\$ArchiveName"
$ZipPath = Join-Path $OutputPath "$ArchiveName.zip"

# Clean up any existing temp or zip
if (Test-Path $TempDir) {
    Remove-Item -Recurse -Force $TempDir
}
if (Test-Path $ZipPath) {
    Remove-Item -Force $ZipPath
}

# Create temp directory structure
Write-Host "Building framework archive v$Version..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $TempDir -Force | Out-Null

# Step 1: Copy starter template (project scaffolding)
Write-Host "  Copying starter template..." -ForegroundColor Gray
Copy-Item -Recurse -Force "$StarterDir\*" $TempDir

# Step 2: Create framework directory in archive
$ArchiveFrameworkDir = Join-Path $TempDir "framework"
New-Item -ItemType Directory -Path $ArchiveFrameworkDir -Force | Out-Null

# Step 3: Copy framework/docs/
Write-Host "  Copying framework/docs/..." -ForegroundColor Gray
$SourceDocs = Join-Path $FrameworkDir "docs"
$DestDocs = Join-Path $ArchiveFrameworkDir "docs"
Copy-Item -Recurse -Force $SourceDocs $DestDocs

# Step 4: Copy framework/templates/
Write-Host "  Copying framework/templates/..." -ForegroundColor Gray
$SourceTemplates = Join-Path $FrameworkDir "templates"
$DestTemplates = Join-Path $ArchiveFrameworkDir "templates"
Copy-Item -Recurse -Force $SourceTemplates $DestTemplates

# Step 5: Copy framework/tools/
Write-Host "  Copying framework/tools/..." -ForegroundColor Gray
$SourceTools = Join-Path $FrameworkDir "tools"
$DestTools = Join-Path $ArchiveFrameworkDir "tools"
Copy-Item -Recurse -Force $SourceTools $DestTools

# Step 6: Create .framework-version file
Write-Host "  Creating .framework-version file..." -ForegroundColor Gray
$VersionFile = Join-Path $ArchiveFrameworkDir ".framework-version"
$Version | Set-Content -Path $VersionFile -NoNewline

# Step 7: Create the zip archive
Write-Host "  Creating zip archive..." -ForegroundColor Gray

# Use Compress-Archive (PowerShell 5+)
$TempContents = Join-Path $TempDir "*"
Compress-Archive -Path $TempContents -DestinationPath $ZipPath -Force

# Step 8: Clean up temp directory
if (-not $KeepTemp) {
    Write-Host "  Cleaning up temp directory..." -ForegroundColor Gray
    Remove-Item -Recurse -Force (Join-Path $OutputPath "temp")
}

# Summary
$ZipSize = (Get-Item $ZipPath).Length / 1KB
Write-Host "`nBuild complete!" -ForegroundColor Green
Write-Host "  Archive: $ZipPath" -ForegroundColor White
Write-Host "  Size: $([math]::Round($ZipSize, 2)) KB" -ForegroundColor White

# List archive contents summary
Write-Host "`nArchive contents:" -ForegroundColor Cyan
Write-Host "  framework/" -ForegroundColor White
Write-Host "    docs/          - Process and collaboration documentation" -ForegroundColor Gray
Write-Host "    templates/     - Work item and documentation templates" -ForegroundColor Gray
Write-Host "    tools/         - PowerShell workflow tools" -ForegroundColor Gray
Write-Host "    project-hub/   - Project workflow structure" -ForegroundColor Gray
Write-Host "  src/, tests/, docs/ - Empty scaffolding" -ForegroundColor White
Write-Host "  *.md, framework.yaml - Project root files (with placeholders)" -ForegroundColor White
Write-Host "  Setup-Project.ps1 - Project creation script" -ForegroundColor White

Write-Host "`nUsage:" -ForegroundColor Yellow
Write-Host "  1. Extract the archive to a convenient location" -ForegroundColor White
Write-Host "  2. Run: .\Setup-Project.ps1 -Destination `"C:\Projects\MyApp`"" -ForegroundColor White
Write-Host "  3. Repeat step 2 for additional projects" -ForegroundColor White
