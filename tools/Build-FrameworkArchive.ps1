<#
.SYNOPSIS
    Builds a distributable archive of the SpearIT Framework.

.NOTES
    SINGLE BUILD METHOD (TECH-159): This script is the ONLY sanctioned producer of the
    framework distribution archive, normally invoked via /fw-release. Do NOT hand-build a
    distribution zip (no ad-hoc Compress-Archive). The script builds into a fresh temp dir
    each run and copies .claude/commands/ + framework/docs/** fresh from canonical source,
    so additions, edits, AND removals propagate automatically with no stragglers.
    See: framework/docs/process/distribution-build-checklist.md#single-build-method-required

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
    Path for the output directory. Defaults to ./distrib/framework/

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
    $OutputPath = Join-Path $RepoRoot "distrib\framework"
}

# Create output directory
$OutputPath = [System.IO.Path]::GetFullPath($OutputPath)
if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    Write-Host "Created output directory: $OutputPath" -ForegroundColor Gray
}

# Pre-flight: Drift-guard — templates/starter/ must contain NO duplicate-of-source content.
# Command files and the framework/ ref-doc subtree are copied fresh from canonical
# (Step 1.5 + Step 3). If they reappear in the starter, the build is shipping a stale
# duplicate — fail loudly rather than silently overwrite/ship drift. (TECH-159 / TECH-074)
# IMPORTANT: this runs BEFORE the destructive temp/zip cleanup below, so a failed guard
# aborts without destroying the existing committed artifact.
$DriftPaths = @(
    (Join-Path $StarterDir ".claude\commands"),
    (Join-Path $StarterDir "framework")
)
foreach ($drift in $DriftPaths) {
    if (Test-Path $drift) {
        $stragglers = Get-ChildItem -Path $drift -Recurse -File -ErrorAction SilentlyContinue
        if ($stragglers) {
            $list = ($stragglers.FullName -join "; ")
            Write-Error "Drift-guard: '$drift' must not exist in templates/starter/ - these are copied fresh from canonical at build time. Remove the duplicate(s): $list"
            exit 1
        }
    }
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

# Step 1.5: Copy canonical .claude/commands/*.md fresh from source (never duplicated in starter).
# Scoped to .claude/commands/ + *.md ONLY — deliberately excludes the framework's own
# .claude/hooks/ and settings*.json (dev tooling, not for consuming projects). Uses the same
# Copy-Item mechanism as the rest of the build so the zip records forward-slash paths uniformly
# (a robocopy-created subtree caused Compress-Archive to emit backslash paths — bad for
# cross-platform unzip). The dest dir is created empty first, guaranteeing an exact canonical
# set with no stragglers. (TECH-159)
Write-Host "  Copying canonical .claude/commands/..." -ForegroundColor Gray
$SourceCommands = Join-Path $RepoRoot ".claude\commands"
if (-not (Test-Path $SourceCommands)) {
    Write-Error "Canonical .claude/commands/ not found: $SourceCommands"
    exit 1
}
$DestCommands = Join-Path $TempDir ".claude\commands"
if (Test-Path $DestCommands) {
    Remove-Item -Recurse -Force $DestCommands
}
New-Item -ItemType Directory -Path $DestCommands -Force | Out-Null
Copy-Item -Path (Join-Path $SourceCommands "*.md") -Destination $DestCommands -Force

# Step 1.6: Copy canonical .claude/scripts/*.sh fresh from source (BUG-170). The /fw-move
# execution engine lives at .claude/scripts/fw-move.sh (relocated from framework/scripts/ per
# BUG-170 / DECISION-171 fw- naming), co-located with the fw-move.md command that invokes it.
# Scoped to .claude/scripts/ + *.sh ONLY — same rationale as Step 1.5: excludes dev-only .claude/
# content (hooks, settings). Same Copy-Item mechanism for uniform forward-slash zip paths. Without
# this step the shipped fw-move.md references an engine the archive doesn't carry, and /fw-move
# silently degrades to AI-interpreted moves downstream (the BUG-170 defect).
Write-Host "  Copying canonical .claude/scripts/..." -ForegroundColor Gray
$SourceScripts = Join-Path $RepoRoot ".claude\scripts"
if (-not (Test-Path $SourceScripts)) {
    Write-Error "Canonical .claude/scripts/ not found: $SourceScripts"
    exit 1
}
$DestScripts = Join-Path $TempDir ".claude\scripts"
if (Test-Path $DestScripts) {
    Remove-Item -Recurse -Force $DestScripts
}
New-Item -ItemType Directory -Path $DestScripts -Force | Out-Null
Copy-Item -Path (Join-Path $SourceScripts "*.sh") -Destination $DestScripts -Force

# Step 2: Create framework directory in archive
$ArchiveFrameworkDir = Join-Path $TempDir "framework"
New-Item -ItemType Directory -Path $ArchiveFrameworkDir -Force | Out-Null

# Step 3: Copy framework/docs/
Write-Host "  Copying framework/docs/..." -ForegroundColor Gray
$SourceDocs = Join-Path $FrameworkDir "docs"
$DestDocs = Join-Path $ArchiveFrameworkDir "docs"
New-Item -ItemType Directory -Path $DestDocs -Force | Out-Null
Copy-Item -Path (Join-Path $SourceDocs "*") -Destination $DestDocs -Recurse -Force

# Step 4: Copy framework/templates/
Write-Host "  Copying framework/templates/..." -ForegroundColor Gray
$SourceTemplates = Join-Path $FrameworkDir "templates"
$DestTemplates = Join-Path $ArchiveFrameworkDir "templates"
New-Item -ItemType Directory -Path $DestTemplates -Force | Out-Null
Copy-Item -Path (Join-Path $SourceTemplates "*") -Destination $DestTemplates -Recurse -Force

# Step 5: Copy framework/tools/
Write-Host "  Copying framework/tools/..." -ForegroundColor Gray
$SourceTools = Join-Path $FrameworkDir "tools"
$DestTools = Join-Path $ArchiveFrameworkDir "tools"
New-Item -ItemType Directory -Path $DestTools -Force | Out-Null
Copy-Item -Path (Join-Path $SourceTools "*") -Destination $DestTools -Recurse -Force

# Step 5.5: Copy framework/CLAUDE.md (canonical source — not duplicated in the starter template)
Write-Host "  Copying framework/CLAUDE.md..." -ForegroundColor Gray
$SourceFrameworkClaude = Join-Path $FrameworkDir "CLAUDE.md"
if (-not (Test-Path $SourceFrameworkClaude)) {
    Write-Error "Canonical framework/CLAUDE.md not found: $SourceFrameworkClaude"
    exit 1
}
Copy-Item -Path $SourceFrameworkClaude -Destination (Join-Path $ArchiveFrameworkDir "CLAUDE.md") -Force

# Step 6: Create .framework-version file
Write-Host "  Creating .framework-version file..." -ForegroundColor Gray
$VersionFile = Join-Path $ArchiveFrameworkDir ".framework-version"
$Version | Set-Content -Path $VersionFile -NoNewline

# Step 7: Create the zip archive
Write-Host "  Creating zip archive..." -ForegroundColor Gray

# Use System.IO.Compression directly (NOT Compress-Archive). On some Windows/.NET
# environments Compress-Archive records OS-native backslash separators in entry names,
# which break extraction on macOS/Linux (files land flat with literal '\' in the name).
# Building entries by hand lets us force forward slashes — the cross-platform-correct
# zip convention — regardless of build host. (TECH-159 scope expansion)
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

if (Test-Path $ZipPath) { Remove-Item -Force $ZipPath }

$TempDirFull = [System.IO.Path]::GetFullPath($TempDir)
$prefixLen = $TempDirFull.TrimEnd('\').Length + 1
$zipStream = [System.IO.Compression.ZipFile]::Open($ZipPath, [System.IO.Compression.ZipArchiveMode]::Create)
try {
    $files = Get-ChildItem -Path $TempDir -Recurse -File -Force
    foreach ($f in $files) {
        # Entry name = path relative to temp root, with forward slashes
        $relative = $f.FullName.Substring($prefixLen).Replace('\', '/')
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
            $zipStream, $f.FullName, $relative,
            [System.IO.Compression.CompressionLevel]::Optimal) | Out-Null
    }
}
finally {
    $zipStream.Dispose()
}

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
Write-Host "  Setup-Framework.ps1 - Project creation script" -ForegroundColor White

Write-Host "`nUsage:" -ForegroundColor Yellow
Write-Host "  1. Extract the archive to a convenient location" -ForegroundColor White
Write-Host "  2. Run: .\Setup-Framework.ps1 -Destination `"C:\Projects\MyApp`"" -ForegroundColor White
Write-Host "  3. Repeat step 2 for additional projects" -ForegroundColor White
