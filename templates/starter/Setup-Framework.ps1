<#
.SYNOPSIS
    Sets up a new project from this SpearIT Framework template.

.DESCRIPTION
    Creates a new project by:
    - Copying template contents to the destination path
    - Prompting for project name and description
    - Replacing {{PLACEHOLDER}} tokens in all files
    - Optionally initializing a git repository

    Run this script from within the extracted framework template folder.

.PARAMETER Destination
    Path for the new project. Will be created if it doesn't exist.
    (Optional - will prompt if not provided)

.PARAMETER ProjectName
    Name of the project (optional - will prompt if not provided)

.PARAMETER ProjectDescription
    Description of the project (optional - will prompt if not provided)

.PARAMETER AuthorName
    Author name (optional - will use git config user.name or prompt if not provided)

.PARAMETER AuthorEmail
    Author email (optional - will use git config user.email or prompt if not provided)

.PARAMETER NoGit
    Skip git repository initialization

.PARAMETER Force
    Overwrite existing files in destination

.EXAMPLE
    .\Setup-Framework.ps1

.EXAMPLE
    .\Setup-Framework.ps1 -Destination "C:\Projects\my-app"

.EXAMPLE
    .\Setup-Framework.ps1 -Destination ".\my-app" -ProjectName "My Application" -ProjectDescription "A sample application" -AuthorName "John Smith" -AuthorEmail "john@example.com"
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$Destination,

    [Parameter()]
    [string]$ProjectName,

    [Parameter()]
    [string]$ProjectDescription,

    [Parameter()]
    [string]$AuthorName,

    [Parameter()]
    [string]$AuthorEmail,

    [Parameter()]
    [switch]$NoGit,

    [Parameter()]
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Get the template directory (where this script lives)
$TemplateDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Get absolute path for template directory
$TemplateDir = [System.IO.Path]::GetFullPath($TemplateDir)

function Get-ProjectTypes {
    <#
    .SYNOPSIS
        Parses project types from framework-schema.yaml
    .DESCRIPTION
        Reads the project.type enum values and their descriptions from the schema file.
        Uses regex parsing to avoid YAML library dependency.
    .PARAMETER SchemaPath
        Path to the framework-schema.yaml file
    .OUTPUTS
        Ordered hashtable of @{ typeName = description }
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$SchemaPath
    )

    if (-not (Test-Path $SchemaPath)) {
        Write-Error "Schema file not found: $SchemaPath"
        return $null
    }

    $content = Get-Content -Path $SchemaPath -Raw

    # Find the project.type section and extract values block
    # Match from 'project.type:' to the next top-level field
    if ($content -notmatch '(?s)project\.type:.*?values:(.*?)(?=\n  project\.)') {
        Write-Error "Could not find project.type values in schema"
        return $null
    }

    $valuesBlock = $Matches[1]
    $types = [ordered]@{}

    # Extract each type and its description
    # Pattern: type name, colon, newline, spaces, description: "value"
    $typeMatches = [regex]::Matches($valuesBlock, '(\w+):\s*\r?\n\s+description:\s*"([^"]+)"')

    foreach ($match in $typeMatches) {
        $typeName = $match.Groups[1].Value
        $description = $match.Groups[2].Value
        $types[$typeName] = $description
    }

    if ($types.Count -eq 0) {
        Write-Error "No project types found in schema"
        return $null
    }

    return $types
}

Write-Host "`nSpearIT Framework Project Setup" -ForegroundColor Cyan
Write-Host "================================`n" -ForegroundColor Cyan

# Prompt for destination if not provided
if ([string]::IsNullOrWhiteSpace($Destination)) {
    $Destination = Read-Host "Destination path for new project"
    if ([string]::IsNullOrWhiteSpace($Destination)) {
        Write-Error "Destination path is required"
        exit 1
    }
}

# Get absolute path for destination
$Destination = [System.IO.Path]::GetFullPath($Destination)

# Prevent copying to self
if ($TemplateDir -eq $Destination) {
    Write-Error "Destination cannot be the same as the template directory."
    exit 1
}

# Check destination
if (Test-Path $Destination) {
    $existingFiles = Get-ChildItem $Destination -Force
    if ($existingFiles.Count -gt 0 -and -not $Force) {
        Write-Error "Destination directory is not empty: $Destination`nUse -Force to overwrite existing files."
        exit 1
    }
}

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

# Get author name (git config → prompt → empty)
if ([string]::IsNullOrWhiteSpace($AuthorName)) {
    $gitAuthorName = & git config user.name 2>$null
    if (-not [string]::IsNullOrWhiteSpace($gitAuthorName)) {
        $AuthorName = $gitAuthorName
        $gitConfigPath = if ($env:USERPROFILE) { "$env:USERPROFILE\.gitconfig" } else { "~/.gitconfig" }
        Write-Host "Author name found in git config ($gitConfigPath): $AuthorName" -ForegroundColor Gray
    } else {
        $AuthorName = Read-Host "Author name (optional, press Enter to skip)"
    }
}

# Get author email (git config → prompt → empty)
if ([string]::IsNullOrWhiteSpace($AuthorEmail)) {
    $gitAuthorEmail = & git config user.email 2>$null
    if (-not [string]::IsNullOrWhiteSpace($gitAuthorEmail)) {
        $AuthorEmail = $gitAuthorEmail
        $gitConfigPath = if ($env:USERPROFILE) { "$env:USERPROFILE\.gitconfig" } else { "~/.gitconfig" }
        Write-Host "Author email found in git config ($gitConfigPath): $AuthorEmail" -ForegroundColor Gray
    } else {
        $AuthorEmail = Read-Host "Author email (optional, press Enter to skip)"
    }
}

# Get project types from schema and prompt for selection
$schemaPath = Join-Path $TemplateDir "framework\docs\ref\framework-schema.yaml"
$projectTypes = Get-ProjectTypes -SchemaPath $schemaPath

if ($null -eq $projectTypes) {
    Write-Host "Warning: Could not read project types from schema. Using default 'application'." -ForegroundColor Yellow
    $ProjectType = "application"
} else {
    Write-Host "`nSelect project type:" -ForegroundColor Yellow
    $typeKeys = @($projectTypes.Keys)
    for ($i = 0; $i -lt $typeKeys.Count; $i++) {
        $key = $typeKeys[$i]
        Write-Host "  $($i + 1). $key - $($projectTypes[$key])" -ForegroundColor White
    }

    $validSelection = $false
    while (-not $validSelection) {
        $selection = Read-Host "`nProject type [1-$($typeKeys.Count)]"

        # Handle empty input - default to application
        if ([string]::IsNullOrWhiteSpace($selection)) {
            $defaultIndex = [Array]::IndexOf($typeKeys, "application")
            if ($defaultIndex -ge 0) {
                $selection = $defaultIndex + 1
            } else {
                $selection = 1
            }
        }

        if ($selection -match '^\d+$') {
            $selectionInt = [int]$selection
            if ($selectionInt -ge 1 -and $selectionInt -le $typeKeys.Count) {
                $ProjectType = $typeKeys[$selectionInt - 1]
                $validSelection = $true
            }
        }

        if (-not $validSelection) {
            Write-Host "Invalid selection. Please enter a number between 1 and $($typeKeys.Count)." -ForegroundColor Red
        }
    }
}

# Get current date
$CurrentDate = Get-Date -Format "yyyy-MM-dd"

Write-Host "`nConfiguration:" -ForegroundColor Yellow
Write-Host "  Project Name: $ProjectName" -ForegroundColor White
Write-Host "  Description:  $ProjectDescription" -ForegroundColor White
Write-Host "  Project Type: $ProjectType" -ForegroundColor White
Write-Host "  Author Name:  $(if ($AuthorName) { $AuthorName } else { '(not set)' })" -ForegroundColor White
Write-Host "  Author Email: $(if ($AuthorEmail) { $AuthorEmail } else { '(not set)' })" -ForegroundColor White
Write-Host "  Destination:  $Destination" -ForegroundColor White
Write-Host "  Date:         $CurrentDate" -ForegroundColor White

Write-Host "`nNote: Author info can be updated later in framework.yaml and README.md" -ForegroundColor Gray

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

# Step 2: Copy template contents (excluding this script)
Write-Host "  Copying template files..." -ForegroundColor Gray
$scriptName = Split-Path -Leaf $MyInvocation.MyCommand.Path

Get-ChildItem -Path $TemplateDir -Force | Where-Object {
    $_.Name -ne $scriptName
} | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $Destination -Recurse -Force
}

# Step 3: Replace placeholders in all text files
Write-Host "  Replacing placeholders..." -ForegroundColor Gray

$placeholders = @{
    "{{PROJECT_NAME}}" = $ProjectName
    "{{PROJECT_DESCRIPTION}}" = $ProjectDescription
    "{{PROJECT_TYPE}}" = $ProjectType
    "{{AUTHOR_NAME}}" = if ($AuthorName) { $AuthorName } else { "" }
    "{{AUTHOR_EMAIL}}" = if ($AuthorEmail) { $AuthorEmail } else { "" }
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
        & git --version 2>&1 | Out-Null
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
Write-Host "    README.md                  - Project overview" -ForegroundColor Gray
Write-Host "    CLAUDE.md                  - AI assistant instructions" -ForegroundColor Gray
Write-Host "    PROJECT-STATUS.md          - Version and status tracking" -ForegroundColor Gray
Write-Host "    CHANGELOG.md               - Version history" -ForegroundColor Gray
Write-Host "    INDEX.md                   - Documentation navigation" -ForegroundColor Gray
Write-Host "    framework.yaml             - Project configuration (SSOT for metadata)" -ForegroundColor Gray
Write-Host "    src/                       - Source code" -ForegroundColor Gray
Write-Host "    tests/                     - Test files" -ForegroundColor Gray
Write-Host "    docs/                      - Project documentation" -ForegroundColor Gray
Write-Host "    framework/                 - Framework documentation and tools" -ForegroundColor Gray
Write-Host "      docs/                    - Collaboration guides, patterns, process" -ForegroundColor Gray
Write-Host "      templates/               - Work item and documentation templates" -ForegroundColor Gray
Write-Host "      tools/                   - PowerShell workflow tools" -ForegroundColor Gray
Write-Host "    project-hub/               - Project workflow and history" -ForegroundColor Gray
Write-Host "      work/                    - Active work items (backlog, todo, doing, done)" -ForegroundColor Gray
Write-Host "      history/                 - Completed work and releases" -ForegroundColor Gray

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  1. cd `"$Destination`"" -ForegroundColor White
Write-Host "  2. Review: NEW-PROJECT-CHECKLIST.md (After Setup section)" -ForegroundColor White
Write-Host "`nKey topics in the checklist:" -ForegroundColor Cyan
Write-Host "  - Creating your first work item (AI or manual)" -ForegroundColor Gray
Write-Host "  - GitHub/remote setup (optional)" -ForegroundColor Gray
Write-Host "  - Adding a LICENSE file (optional)" -ForegroundColor Gray
Write-Host "`nFor quick workflow reference: QUICK-START.md" -ForegroundColor Cyan

Write-Host "`nKey commands:" -ForegroundColor Cyan
Write-Host "  /fw-help    - Show available framework commands" -ForegroundColor Gray
Write-Host "  /fw-status  - Check project status" -ForegroundColor Gray
Write-Host "  /fw-backlog - Review backlog items" -ForegroundColor Gray
