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

$donePath = Join-Path $projectDir "framework/project-hub/work/done"

# Skip if done/ doesn't exist
if (-not (Test-Path $donePath)) {
    exit 0
}

$errors = @()

Get-ChildItem -Path $donePath -Filter "*.md" -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -notlike ".*" } |
    ForEach-Object {
        $content = Get-Content $_.FullName -Raw
        $name = $_.Name

        # Check Status field
        if ($content -notmatch '\*\*Status:\*\*\s*Done') {
            $errors += "${name}: Missing 'Status: Done'"
        }

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
