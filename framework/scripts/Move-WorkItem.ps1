<#
.SYNOPSIS
    Move a work item between workflow folders with validation.

.DESCRIPTION
    Validates transition, finds all {TYPE-ID}-* files, moves them with git mv.
    Prototype - proves the concept, not production-ready.

.PARAMETER From
    Source folder: backlog, todo, doing, done

.PARAMETER To
    Target folder: backlog, todo, doing, done, history

.PARAMETER WorkItemId
    Work item ID (e.g., FEAT-042, TECH-055)

.PARAMETER WorkPath
    Path to work folder (default: thoughts/work)

.EXAMPLE
    ./Move-WorkItem.ps1 -From backlog -To todo -WorkItemId FEAT-042
#>

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("backlog", "todo", "doing", "done")]
    [string]$From,

    [Parameter(Mandatory=$true)]
    [ValidateSet("backlog", "todo", "doing", "done", "history")]
    [string]$To,

    [Parameter(Mandatory=$true)]
    [string]$WorkItemId,

    [string]$WorkPath = "framework/thoughts/work"
)

# Allowed transitions matrix
$allowedTransitions = @{
    "backlog" = @("todo")
    "todo"    = @("doing", "backlog")
    "doing"   = @("done", "todo")
    "done"    = @("history")
}

# 1. Validate transition
if ($allowedTransitions[$From] -notcontains $To) {
    Write-Host "X Invalid transition: $From -> $To" -ForegroundColor Red
    Write-Host "  Allowed from $From`: $($allowedTransitions[$From] -join ', ')" -ForegroundColor Yellow
    exit 1
}

# 2. Find all files for this work item (extension-agnostic)
$sourcePath = "$WorkPath/$From"
$files = Get-ChildItem "$sourcePath/$WorkItemId-*" -ErrorAction SilentlyContinue

if ($files.Count -eq 0) {
    Write-Host "X Work item $WorkItemId not found in $From/" -ForegroundColor Red
    exit 1
}

# 3. Check WIP limit (if moving to doing)
if ($To -eq "doing") {
    $limitFile = "$WorkPath/$To/.limit"
    if (Test-Path $limitFile) {
        $limit = [int](Get-Content $limitFile)
        $existing = Get-ChildItem "$WorkPath/$To/*" -Exclude ".gitkeep",".limit" -ErrorAction SilentlyContinue |
            ForEach-Object { $_.Name -replace '-.*$', '' } |
            Select-Object -Unique
        $count = ($existing | Measure-Object).Count

        if ($count -ge $limit) {
            Write-Host "X WIP limit reached in $To/ ($count/$limit)" -ForegroundColor Red
            Write-Host "  Complete current work before starting $WorkItemId" -ForegroundColor Yellow
            exit 1
        }
    }
}

# 4. Determine target path
if ($To -eq "history") {
    # History requires a version folder - prompt or use default
    $targetPath = "$WorkPath/../history/releases"
    Write-Host "! History archival requires version folder (e.g., v3.3.0)" -ForegroundColor Yellow
    Write-Host "  Use: git mv $sourcePath/$WorkItemId-* $targetPath/vX.Y.Z/" -ForegroundColor Yellow
    exit 1
} else {
    $targetPath = "$WorkPath/$To"
}

# 5. Move files with git mv
Write-Host "Moving $WorkItemId from $From to $To..." -ForegroundColor Cyan
Write-Host "Files:" -ForegroundColor Gray

foreach ($file in $files) {
    Write-Host "  - $($file.Name)" -ForegroundColor Gray
    git mv $file.FullName "$targetPath/"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "X git mv failed for $($file.Name)" -ForegroundColor Red
        exit 1
    }
}

Write-Host "OK Moved $($files.Count) file(s): $From -> $To" -ForegroundColor Green
exit 0
