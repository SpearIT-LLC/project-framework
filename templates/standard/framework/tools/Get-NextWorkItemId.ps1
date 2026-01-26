<#
.SYNOPSIS
    Returns the next available work item ID.

.DESCRIPTION
    Standalone script that outputs the next available work item ID.
    Uses the common ID namespace shared across all work item types.

    Can be called from command line or by AI assistants via /fw-next-id.

.EXAMPLE
    ./Get-NextWorkItemId.ps1
    # Output: 067

.EXAMPLE
    ./Get-NextWorkItemId.ps1 -Verbose
    # Shows which files were scanned

.NOTES
    See TECH-046 and workflow-guide.md#finding-next-available-id for policy details.
#>
[CmdletBinding()]
param()

# Import the module from same directory
$modulePath = Join-Path $PSScriptRoot "FrameworkWorkflow.psm1"
Import-Module $modulePath -Force

# Get next ID (auto-discovers project-hub folder)
$nextId = Get-NextWorkItemId

if ($nextId) {
    Write-Output $nextId
}
else {
    Write-Error "Failed to determine next work item ID"
    exit 1
}
