<#
.SYNOPSIS
    Sets up a new project from a SpearIT Framework archive.

.DESCRIPTION
    Extracts the framework archive and configures a new project by:
    - Extracting to the destination path
    - Prompting for project name and description
    - Replacing {{PLACEHOLDER}} tokens in all files
    - Optionally initializing a git repository

.PARAMETER ArchivePath
    Path to the framework archive (.zip file)

.PARAMETER Destination
    Path for the new project. Will be created if it doesn't exist.

.PARAMETER ProjectName
    Name of the project (optional - will prompt if not provided)

.PARAMETER ProjectDescription
    Description of the project (optional - will prompt if not provided)

.PARAMETER NoGit
    Skip git repository initialization

.PARAMETER Force
    Overwrite existing files in destination

.EXAMPLE
    .\tools\Setup-Project.ps1 -ArchivePath ".\distrib\spearit_framework_v3.0.0.zip" -Destination "C:\Projects\my-app"

.EXAMPLE
    .\tools\Setup-Project.ps1 -ArchivePath ".\distrib\spearit_framework_v3.0.0.zip" -Destination ".\my-app" -ProjectName "My Application" -ProjectDescription "A sample application"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ArchivePath,

    [Parameter(Mandatory = $true)]
    [string]$Destination,

    [Parameter()]
    [string]$ProjectName,

    [Parameter()]
    [string]$ProjectDescription,

    [Parameter()]
    [switch]$NoGit,

    [Parameter()]
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Validate archive exists
if (-not (Test-Path $ArchivePath)) {
    Write-Error "Archive not found: $ArchivePath"
    exit 1
}

# Get absolute paths
$ArchivePath = [System.IO.Path]::GetFullPath($ArchivePath)
$Destination = [System.IO.Path]::GetFullPath($Destination)

# Check destination
if (Test-Path $Destination) {
    $existingFiles = Get-ChildItem $Destination -Force
    if ($existingFiles.Count -gt 0 -and -not $Force) {
        Write-Error "Destination directory is not empty: $Destination`nUse -Force to overwrite existing files."
        exit 1
    }
}

Write-Host "`nSpearIT Framework Project Setup" -ForegroundColor Cyan
Write-Host "================================`n" -ForegroundColor Cyan

# Prompt for project name if not provided
if ([string]::IsNullOrWhiteSpace($ProjectName)) {
    $ProjectName = Read-Host "Project name"
    if ([string]::IsNullOrWhiteSpace($ProjectName)) {
        Write-Error "Project name is required"
        exit 1
    }
}

# Prompt for project description if not provided
if ([string]::IsNullOrWhiteSpace($ProjectDescription)) {
    $ProjectDescription = Read-Host "Project description"
    if ([string]::IsNullOrWhiteSpace($ProjectDescription)) {
        $ProjectDescription = "A new project"
    }
}

# Get current date
$CurrentDate = Get-Date -Format "yyyy-MM-dd"

Write-Host "`nConfiguration:" -ForegroundColor Yellow
Write-Host "  Project Name: $ProjectName" -ForegroundColor White
Write-Host "  Description:  $ProjectDescription" -ForegroundColor White
Write-Host "  Destination:  $Destination" -ForegroundColor White
Write-Host "  Date:         $CurrentDate" -ForegroundColor White

# Confirm
$confirm = Read-Host "`nProceed with setup? (y/n)"
if ($confirm -notmatch "^[yY]") {
    Write-Host "Setup cancelled." -ForegroundColor Yellow
    exit 0
}

# Step 1: Create destination directory
Write-Host "`nSetting up project..." -ForegroundColor Cyan
if (-not (Test-Path $Destination)) {
    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    Write-Host "  Created directory: $Destination" -ForegroundColor Gray
}

# Step 2: Extract archive
Write-Host "  Extracting archive..." -ForegroundColor Gray
Expand-Archive -Path $ArchivePath -DestinationPath $Destination -Force

# Step 3: Replace placeholders in all text files
Write-Host "  Replacing placeholders..." -ForegroundColor Gray

$placeholders = @{
    "{{PROJECT_NAME}}" = $ProjectName
    "{{PROJECT_DESCRIPTION}}" = $ProjectDescription
    "{{DATE}}" = $CurrentDate
}

# Find all text files to process
$textExtensions = @("*.md", "*.yaml", "*.yml", "*.json", "*.txt", "*.ps1", "*.psm1")
$filesToProcess = @()

foreach ($ext in $textExtensions) {
    $filesToProcess += Get-ChildItem -Path $Destination -Filter $ext -Recurse -File
}

$replacementCount = 0
foreach ($file in $filesToProcess) {
    $content = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
    if ($null -eq $content) { continue }

    $modified = $false
    foreach ($placeholder in $placeholders.Keys) {
        if ($content -match [regex]::Escape($placeholder)) {
            $content = $content -replace [regex]::Escape($placeholder), $placeholders[$placeholder]
            $modified = $true
            $replacementCount++
        }
    }

    if ($modified) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
    }
}

Write-Host "    Replaced $replacementCount placeholder instances" -ForegroundColor Gray

# Step 4: Initialize git repository (optional)
if (-not $NoGit) {
    Write-Host "  Initializing git repository..." -ForegroundColor Gray
    Push-Location $Destination
    try {
        # Temporarily allow Continue to suppress git warnings
        $prevErrorAction = $ErrorActionPreference
        $ErrorActionPreference = "Continue"

        # Check if git is available
        $gitVersion = & git --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            # Initialize repository - suppress warnings
            & git init --quiet 2>&1 | Out-Null
            & git add -A 2>&1 | Out-Null
            & git commit -m "Initial project setup from SpearIT Framework" --quiet 2>&1 | Out-Null
            Write-Host "    Git repository initialized with initial commit" -ForegroundColor Gray
        } else {
            Write-Host "    Git not found - skipping repository initialization" -ForegroundColor Yellow
        }

        $ErrorActionPreference = $prevErrorAction
    } finally {
        Pop-Location
    }
}

# Step 5: Summary
Write-Host "`nSetup complete!" -ForegroundColor Green
Write-Host "`nProject created at: $Destination" -ForegroundColor White

Write-Host "`nProject structure:" -ForegroundColor Cyan
Write-Host "  $Destination/" -ForegroundColor White
Write-Host "    README.md           - Project overview" -ForegroundColor Gray
Write-Host "    CLAUDE.md           - AI assistant instructions" -ForegroundColor Gray
Write-Host "    PROJECT-STATUS.md   - Version and status tracking" -ForegroundColor Gray
Write-Host "    framework.yaml      - Project configuration" -ForegroundColor Gray
Write-Host "    framework/          - Documentation and templates" -ForegroundColor Gray
Write-Host "    project-hub/work/   - Kanban workflow folders" -ForegroundColor Gray
Write-Host "    src/, tests/, docs/ - Code and documentation" -ForegroundColor Gray

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  1. cd `"$Destination`"" -ForegroundColor White
Write-Host "  2. Review and customize CLAUDE.md for your project" -ForegroundColor White
Write-Host "  3. Update PROJECT-STATUS.md with initial status" -ForegroundColor White
Write-Host "  4. Start creating work items in project-hub/work/backlog/" -ForegroundColor White
Write-Host "  5. See QUICK-START.md for workflow reference" -ForegroundColor White

Write-Host "`nKey commands:" -ForegroundColor Cyan
Write-Host "  /fw-help    - Show available framework commands" -ForegroundColor Gray
Write-Host "  /fw-status  - Check project status" -ForegroundColor Gray
Write-Host "  /fw-backlog - Review backlog items" -ForegroundColor Gray
