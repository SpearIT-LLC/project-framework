<#
.SYNOPSIS
    Moves a work item between workflow folders with validation.

.DESCRIPTION
    Production script for /fw-move command. Handles:
    - Finding item by ID across workflow folders
    - Validating transitions against workflow matrix
    - Checking WIP limits for any folder with a .limit file (doing/, todo/, etc.)
    - Using git mv or mv based on tracking status

.PARAMETER ItemId
    Work item ID (e.g., FEAT-018, TECH-064) or partial match

.PARAMETER Target
    Target folder: backlog, todo, doing, done

.PARAMETER Force
    Skip confirmation prompt

.PARAMETER WhatIf
    Show what would happen without executing

.EXAMPLE
    .\Move-WorkItem.ps1 TECH-064 todo
    Moves TECH-064 to the todo folder.

.EXAMPLE
    .\Move-WorkItem.ps1 FEAT-018 done -WhatIf
    Shows what would happen without moving.
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory, Position = 0)]
    [string]$ItemId,

    [Parameter(Mandatory, Position = 1)]
    [ValidateSet("backlog", "todo", "doing", "done")]
    [string]$Target,

    [Parameter()]
    [switch]$Force
)

#Requires -Version 5.1
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Import shared module
$modulePath = Join-Path $PSScriptRoot "FrameworkWorkflow.psm1"
if (Test-Path $modulePath) {
    Import-Module $modulePath -Force
} else {
    Write-Error "Required module not found: $modulePath"
    exit 1
}

#region Configuration

# Valid transitions: From -> To[]
$ValidTransitions = @{
    "backlog" = @("todo")
    "todo"    = @("backlog", "doing")
    "doing"   = @("todo", "done")
    "done"    = @("history")  # No reopening
}

#endregion

#region Helper Functions

function Find-WorkItem {
    param([string]$Id, [string]$WorkPath)

    $folders = @("backlog", "todo", "doing", "done")
    $pattern = "*$Id*"

    foreach ($folder in $folders) {
        $folderPath = Join-Path $WorkPath $folder
        if (Test-Path $folderPath) {
            $files = Get-ChildItem -Path $folderPath -Filter "*.md" -File |
                Where-Object { $_.Name -like $pattern -or $_.Name -match "(?i)$Id" }

            foreach ($file in $files) {
                return @{
                    Path = $file.FullName
                    Name = $file.Name
                    Folder = $folder
                }
            }
        }
    }
    return $null
}

function Test-TransitionValid {
    param([string]$From, [string]$To)

    if (-not $ValidTransitions.ContainsKey($From)) {
        return $false
    }
    return $ValidTransitions[$From] -contains $To
}

# Get-WipCount and Get-WipLimit are now imported from FrameworkWorkflow.psm1

function Test-GitTracked {
    param([string]$FilePath)

    # Run git ls-files and capture exit code directly
    # Note: Don't pipe to Out-Null as it can interfere with $LASTEXITCODE
    $null = git ls-files --error-unmatch $FilePath 2>&1
    return $LASTEXITCODE -eq 0
}

function Move-File {
    param(
        [string]$Source,
        [string]$Destination,
        [switch]$WhatIf
    )

    $isTracked = Test-GitTracked -FilePath $Source

    if ($WhatIf) {
        $method = if ($isTracked) { "git mv" } else { "mv" }
        Write-Output "Would use: $method"
        Write-Output "  From: $Source"
        Write-Output "  To:   $Destination"
        return $true
    }

    if ($isTracked) {
        git mv $Source $Destination
        return $LASTEXITCODE -eq 0
    }
    else {
        Move-Item -Path $Source -Destination $Destination
        return $?
    }
}

#endregion

#region Main

# Find work folder
$workPath = Find-WorkFolder
if (-not $workPath) {
    Write-Error "Could not find thoughts/work folder"
    exit 1
}

# Find the item
$item = Find-WorkItem -Id $ItemId -WorkPath $workPath
if (-not $item) {
    Write-Error "Could not find work item matching '$ItemId'"
    exit 1
}

$fromFolder = $item.Folder
$toFolder = $Target

# Same folder check
if ($fromFolder -eq $toFolder) {
    Write-Warning "Item is already in $toFolder/"
    exit 0
}

# Validate transition
if (-not (Test-TransitionValid -From $fromFolder -To $toFolder)) {
    Write-Output ""
    Write-Output "X Cannot move from $fromFolder to $toFolder"
    Write-Output "  Valid targets from $fromFolder/: $($ValidTransitions[$fromFolder] -join ', ')"

    if ($fromFolder -eq "done") {
        Write-Output "  Note: Items in done/ cannot be reopened. Create a new work item instead."
    }
    elseif ($fromFolder -eq "backlog" -and $toFolder -eq "doing") {
        Write-Output "  Hint: Move to todo first, then to doing"
    }
    exit 1
}

# WIP limit check for any target folder with a .limit file
$targetPath = Join-Path $workPath $toFolder
$wipStatus = Test-WipLimitExceeded -FolderPath $targetPath

if ($wipStatus.HasLimit -and $wipStatus.Exceeded) {
    Write-Output ""
    Write-Output "X Cannot move to $toFolder/ - WIP limit reached"
    Write-Output "  Current: $($wipStatus.Current) of $($wipStatus.Limit)"
    if ($toFolder -eq "doing") {
        Write-Output "  Complete or pause current work first."
    }
    else {
        Write-Output "  Review and prioritize existing items in $toFolder/ first."
    }
    exit 1
}

# Build destination path
$destFolder = Join-Path $workPath $toFolder
$destPath = Join-Path $destFolder $item.Name

# Confirm or execute
Write-Output ""
Write-Output "Moving: $($item.Name)"
Write-Output "  From: $fromFolder/"
Write-Output "  To:   $toFolder/"

if ($WhatIfPreference) {
    Move-File -Source $item.Path -Destination $destPath -WhatIf
}
else {
    $success = Move-File -Source $item.Path -Destination $destPath
    if ($success) {
        Write-Output ""
        Write-Output "[OK] Moved successfully"
    }
    else {
        Write-Error "Move failed"
        exit 1
    }
}

#endregion
