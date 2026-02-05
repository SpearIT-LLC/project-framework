# Validate-WorkItems.ps1
# Pre-commit hook to verify work item state consistency
# Requires: PowerShell 5.1+
# ASCII-only, no Unicode characters

param()

$ErrorActionPreference = 'Stop'

# Read hook input from stdin
try {
    $jsonInput = $input | Out-String
    $hookData = $jsonInput | ConvertFrom-Json
    $command = $hookData.tool_input.command
} catch {
    # If we can't parse input, allow the command
    exit 0
}

# Only check git commit commands
if ($command -notmatch 'git commit') {
    exit 0
}

# Allow bypass with --no-verify flag
if ($command -match '--no-verify') {
    exit 0
}

$projectDir = $env:CLAUDE_PROJECT_DIR
if (-not $projectDir) {
    # No project directory set, skip validation
    exit 0
}

$donePath = "framework/project-hub/work/done"

# Get staged files from git
Push-Location $projectDir
try {
    $stagedFiles = git diff --cached --name-only 2>$null
    if ($LASTEXITCODE -ne 0) {
        # Git command failed, allow commit
        exit 0
    }
} finally {
    Pop-Location
}

# Filter for .md files directly in done/ folder (not in artifact subfolders)
$stagedInDone = $stagedFiles | Where-Object {
    $_ -like "$donePath/*.md" -and              # In done/ folder
    $_ -notlike "*/.*.md" -and                  # Not hidden files
    $_ -notlike "$donePath/*/*.md"              # Not in artifact subfolders
}

# If no staged files in done/, allow commit
if (-not $stagedInDone -or $stagedInDone.Count -eq 0) {
    exit 0
}

$errors = @()

# Validate each staged file in done/
foreach ($relativePath in $stagedInDone) {
    $fullPath = Join-Path $projectDir $relativePath

    # Skip if file doesn't exist (deleted file)
    if (-not (Test-Path $fullPath)) {
        continue
    }

    $content = Get-Content $fullPath -Raw
    $name = Split-Path -Leaf $relativePath

        # Check Completed date
        if ($content -notmatch '\*\*Completed:\*\*') {
            $errors += "${name}: Missing 'Completed' date"
        }

        # Check for unchecked acceptance criteria
        # Only check boxes AFTER the "## Acceptance Criteria" heading
        if ($content -match '## Acceptance Criteria') {
            $sections = $content -split '## Acceptance Criteria', 2
            if ($sections.Count -gt 1) {
                $criteriaSection = $sections[1]
                # Check if there are unchecked boxes in the criteria section
                if ($criteriaSection -match '- \[ \]') {
                    $errors += "${name}: Has unchecked acceptance criteria"
                }
            }
        }
}

if ($errors.Count -gt 0) {
    [Console]::Error.WriteLine("")
    [Console]::Error.WriteLine("Work item validation failed:")
    $errors | ForEach-Object {
        [Console]::Error.WriteLine("  $_")
    }
    [Console]::Error.WriteLine("")
    [Console]::Error.WriteLine("To override this check, use: git commit --no-verify")
    [Console]::Error.WriteLine("")
    exit 2  # Block commit
}

# All validation passed
exit 0
