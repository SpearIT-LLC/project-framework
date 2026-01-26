<#
.SYNOPSIS
    Gets workflow status including folder counts, WIP limits, and version information.

.DESCRIPTION
    Scans project-hub/work/ folders to provide a complete picture of project workflow status.
    Applies hierarchical WIP counting where parent + children count as 1 item.
    Used by both /fw-status and /fw-wip-check commands (DRY - single source of truth).

.PARAMETER Path
    Path to the project-hub/work/ folder. If not specified, searches common locations:
    - framework/project-hub/work
    - project-hub/work
    - ../project-hub/work

.PARAMETER Format
    Output format: 'json' (default) or 'table'. Mutually exclusive with -Summary, -WipCount, and -Current.

.PARAMETER Summary
    Output labeled folder counts only (simple text format).

.PARAMETER WipCount
    Output only the hierarchical WIP count as a single integer.

.PARAMETER Current
    Output list of items currently in doing/ folder.

.EXAMPLE
    .\Get-WorkflowStatus.ps1
    Outputs JSON with all workflow status data.

.EXAMPLE
    .\Get-WorkflowStatus.ps1 -Format table
    Outputs formatted table for human consumption.

.EXAMPLE
    .\Get-WorkflowStatus.ps1 -Summary
    Outputs labeled folder counts:
    Backlog: 38
    Todo: 9
    Doing: 1
    Done: 3

.EXAMPLE
    .\Get-WorkflowStatus.ps1 -WipCount
    Outputs single integer for hierarchical WIP count (e.g., "1").

.EXAMPLE
    .\Get-WorkflowStatus.ps1 -Current
    Outputs items currently in doing/ with expanded sub-items:
    FEAT-018: Claude Command Framework
      - FEAT-018.1: /fw-help Command
      - FEAT-018.2: /fw-move Command

.OUTPUTS
    System.String (JSON format) or formatted table output

.NOTES
    Version: 1.2.0
    Author: SpearIT Project Framework
    Requires: PowerShell 5.1+
    Dependencies: FrameworkWorkflow.psm1

    Hierarchical WIP Counting Rule:
    Per workflow-guide.md#hierarchical-numbering, parent and all children
    count as 1 item toward WIP limit (e.g., FEAT-018 + FEAT-018.1 = 1 item).
#>

[CmdletBinding(DefaultParameterSetName = 'Format')]
param(
    [Parameter(Position = 0)]
    [ValidateScript({
        if ($_ -and -not (Test-Path $_)) {
            throw "Path '$_' does not exist."
        }
        $true
    })]
    [string]$Path,

    [Parameter(ParameterSetName = 'Format')]
    [ValidateSet("json", "table")]
    [string]$Format = "json",

    [Parameter(ParameterSetName = 'Summary')]
    [switch]$Summary,

    [Parameter(ParameterSetName = 'WipCount')]
    [switch]$WipCount,

    [Parameter(ParameterSetName = 'Current')]
    [switch]$Current
)

#Requires -Version 5.1
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Import shared workflow module
$modulePath = Join-Path $PSScriptRoot "FrameworkWorkflow.psm1"
if (Test-Path $modulePath) {
    Import-Module $modulePath -Force
} else {
    Write-Error "Required module not found: $modulePath"
    exit 1
}

# Ensure UTF-8 output for Unicode characters
# Wrapped in try/catch for non-interactive contexts (CI, scheduled tasks)
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch { }

#region Helper Functions

function Find-ProjectStatusFile {
    <#
    .SYNOPSIS
        Searches for PROJECT-STATUS.md in common locations.
    #>
    [CmdletBinding()]
    param()

    $candidates = @(
        "framework/PROJECT-STATUS.md",
        "PROJECT-STATUS.md",
        "../PROJECT-STATUS.md"
    )

    foreach ($candidate in $candidates) {
        if (Test-Path -Path $candidate -PathType Leaf) {
            return (Resolve-Path -Path $candidate).Path
        }
    }

    return $null
}

function Find-PocFolder {
    <#
    .SYNOPSIS
        Searches for project-hub/poc folder in common locations.
    #>
    [CmdletBinding()]
    param()

    $candidates = @(
        "framework/project-hub/poc",
        "project-hub/poc",
        "../project-hub/poc"
    )

    foreach ($candidate in $candidates) {
        if (Test-Path -Path $candidate -PathType Container) {
            return (Resolve-Path -Path $candidate).Path
        }
    }

    return $null
}

function Get-PocSpikes {
    <#
    .SYNOPSIS
        Gets active POC spikes from project-hub/poc folder.
    .DESCRIPTION
        POC spikes are folders (not files) containing spike docs and code artifacts.
        Returns count and list of active spikes.
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$PocPath
    )

    $result = @{
        Count = 0
        Spikes = @()
    }

    if (-not $PocPath -or -not (Test-Path $PocPath)) {
        return $result
    }

    # Get spike folders (directories starting with SPIKE-)
    $spikeFolders = @(Get-ChildItem -Path $PocPath -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match '^SPIKE-\d+' })

    if ($spikeFolders.Count -eq 0) {
        return $result
    }

    $spikes = foreach ($folder in $spikeFolders) {
        # Try to get spike doc inside folder
        $spikeDoc = Get-ChildItem -Path $folder.FullName -Filter "*.md" -File -ErrorAction SilentlyContinue | Select-Object -First 1
        $title = $null

        if ($spikeDoc) {
            try {
                $content = Get-Content -Path $spikeDoc.FullName -Raw -Encoding UTF8 -ErrorAction Stop
                # Extract title from first heading
                if ($content -match '^#\s+(?:Spike:\s*)?(.+)$' ) {
                    $title = $matches[1].Trim()
                }
            }
            catch { }
        }

        @{
            ID = $folder.Name -replace '-.*$', '' -replace 'SPIKE-', 'SPIKE-'
            Name = $folder.Name
            Title = $title
        }
    }

    $result.Count = $spikes.Count
    $result.Spikes = @($spikes)
    return $result
}

function Get-ProjectVersion {
    <#
    .SYNOPSIS
        Extracts version and date from PROJECT-STATUS.md.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [AllowNull()]
        [string]$StatusFilePath
    )

    $result = @{
        Version = $null
        Date = $null
        ProjectName = $null
    }

    if (-not $StatusFilePath -or -not (Test-Path $StatusFilePath)) {
        return $result
    }

    try {
        $content = Get-Content -Path $StatusFilePath -Raw -Encoding UTF8 -ErrorAction Stop

        # Extract project name from title
        if ($content -match '^#\s+(.+?)\s*-\s*Project Status') {
            $result.ProjectName = $matches[1].Trim()
        }

        # Extract version - look for "Current Version:" line
        if ($content -match '\*\*Current Version:\*\*\s*(v[\d.]+)\s*\((\d{4}-\d{2}-\d{2})\)') {
            $result.Version = $matches[1]
            $result.Date = $matches[2]
        }
    }
    catch {
        Write-Warning "Failed to read PROJECT-STATUS.md: $_"
    }

    return $result
}

function Get-WorkItemInfo {
    <#
    .SYNOPSIS
        Extracts basic info from a work item markdown file.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$FilePath
    )

    $filename = Split-Path -Path $FilePath -Leaf

    try {
        $content = Get-Content -Path $FilePath -Raw -Encoding UTF8 -ErrorAction Stop
    }
    catch {
        return @{
            ID = $filename -replace '\.md$', ''
            Title = $null
            File = $filename
        }
    }

    # Extract ID (case-insensitive, normalize to uppercase)
    $id = ""
    if ($content -match '\*\*ID:\*\*\s*([A-Za-z]+-\d+(?:\.\d+)?)') {
        $id = $matches[1].ToUpper()
    }
    elseif ($filename -match '^([A-Za-z]+-\d+(?:\.\d+)?)') {
        $id = $matches[1].ToUpper()
    }

    # Extract title from first heading
    # Format: "# Type: Title" or "# FEAT-018.1: Title" or just "# Title"
    $title = $null
    $lines = $content -split "`r?`n"
    foreach ($line in $lines) {
        if ($line -match '^#\s+(.+)$') {
            $rawTitle = $matches[1].Trim()
            # Remove "Type: " prefix (e.g., "Feature: ", "Bugfix: ")
            $rawTitle = $rawTitle -replace '^(?:Feature|Bugfix|Bug Fix|Tech Debt|Spike|Documentation|Decision):\s*', ''
            # Remove ID prefix if present (e.g., "FEAT-018: " or "FEAT-018.1: ")
            $rawTitle = $rawTitle -replace '^[A-Z]+-\d+(?:\.\d+)?[:\s]+', ''
            $title = $rawTitle
            break
        }
    }

    return @{
        ID = $id
        Title = $title
        File = $filename
    }
}

function Get-FolderItems {
    <#
    .SYNOPSIS
        Gets work items from a workflow folder.
    .OUTPUTS
        Array of work item hashtables. Returns empty array (not $null) if no items found.
    #>
    [CmdletBinding()]
    [OutputType([array])]
    param(
        [Parameter(Mandatory)]
        [string]$FolderPath
    )

    if (-not (Test-Path $FolderPath)) {
        # Use comma operator to ensure array is preserved through pipeline
        return , @()
    }

    $files = @(Get-ChildItem -Path $FolderPath -Filter "*.md" -File -ErrorAction SilentlyContinue)

    if ($files.Count -eq 0) {
        return , @()
    }

    $items = foreach ($file in $files) {
        Get-WorkItemInfo -FilePath $file.FullName
    }

    $filtered = @($items | Where-Object { $_.ID })
    if (-not $filtered -or $filtered.Count -eq 0) {
        return , @()
    }
    return , $filtered
}

function Format-TableOutput {
    <#
    .SYNOPSIS
        Formats status as a table for console output.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Status
    )

    $output = @()
    $width = 55

    # Full status output for /fw-status
    $projectName = if ($Status.ProjectName) { $Status.ProjectName } else { "Project" }

    $output += ""
    $output += "Project Status: $projectName"
    $output += "=" * $width
    $output += ""

    # Version info
    if ($Status.Version) {
        $versionLine = "Version: $($Status.Version)"
        if ($Status.VersionDate) {
            $versionLine += " ($($Status.VersionDate))"
        }
        $output += $versionLine
        $output += ""
    }

    # Workflow summary
    $output += "Workflow Summary:"

    $todoInfo = $Status.Todo
    $wipInfo = $Status.Doing

    # Helper function to build folder status line
    function Get-FolderStatusLine {
        param(
            [string]$Label,
            [int]$Count,
            [int]$Limit,
            [bool]$HasLimit
        )

        $itemWord = if ($Count -ne 1) { "items" } else { "item" }
        $line = "  ${Label}:".PadRight(12) + "$Count $itemWord"

        if ($HasLimit) {
            $line += "  (limit: $Limit)"
            # Add indicator
            if ($Count -lt $Limit) {
                $line += " $([char]0x2705)"
            }
            elseif ($Count -eq $Limit) {
                $line += " $([char]0x26A0)"
            }
            else {
                $line += " $([char]0x274C)"
            }
        }

        return $line
    }

    # Done indicator
    $doneIndicator = ""
    if ($Status.Done.Count -gt 0) {
        $doneIndicator = " $([char]0x26A0) Ready for release"
    }

    $output += "  Backlog:  $($Status.Backlog.Count) items"
    $output += Get-FolderStatusLine -Label "Todo" -Count $todoInfo.HierarchicalCount -Limit $todoInfo.Limit -HasLimit $todoInfo.HasLimit
    $output += Get-FolderStatusLine -Label "Doing" -Count $wipInfo.HierarchicalCount -Limit $wipInfo.Limit -HasLimit $wipInfo.HasLimit
    $output += "  Done:     $($Status.Done.Count) item$(if ($Status.Done.Count -ne 1) { 's' })$doneIndicator"
    $output += ""

    # Currently in progress
    if ($wipInfo.Groups.Count -gt 0) {
        $output += "Currently In Progress:"
        foreach ($group in $wipInfo.Groups) {
            $items = $Status.DoingItems | Where-Object { $_.ID -like "$($group.BaseID)*" }
            $parentItem = $items | Where-Object { $_.ID -eq $group.BaseID } | Select-Object -First 1
            $title = if ($parentItem.Title) { $parentItem.Title } else { "(no title)" }

            if ($group.ItemCount -gt 1) {
                $output += "  - $($group.BaseID): $title (+$($group.ItemCount - 1) sub-items)"
            }
            else {
                $output += "  - $($group.BaseID): $title"
            }
        }
        $output += ""
    }

    # Awaiting release
    if ($Status.Done.Count -gt 0) {
        $output += "Awaiting Release:"
        foreach ($item in $Status.DoneItems) {
            $title = if ($item.Title) { $item.Title } else { "(no title)" }
            $output += "  - $($item.ID): $title"
        }
        $output += ""
    }

    # POC Spikes (separate from kanban workflow)
    $output += "POC Spikes (no WIP limit):"
    $spikeWord = if ($Status.PocSpikes.Count -ne 1) { "spikes" } else { "spike" }
    $output += "  Active:   $($Status.PocSpikes.Count) $spikeWord"
    if ($Status.PocSpikes -and $Status.PocSpikes.Count -gt 0) {
        foreach ($spike in $Status.PocSpikes.Spikes) {
            $title = if ($spike.Title) { $spike.Title } else { "(no title)" }
            $output += "    - $($spike.Name): $title"
        }
    }
    $output += ""

    # Warnings
    if ($wipInfo.LimitWarning) {
        $output += "Note: $($wipInfo.LimitWarning)"
        $output += ""
    }

    return $output
}

#endregion

#region Main Script

try {
    # Resolve work folder path
    if (-not $Path) {
        $Path = Find-WorkFolder
        if (-not $Path) {
            Write-Error "project-hub/work folder not found. Use -Path to specify location."
            exit 1
        }
    }

    Write-Verbose "Scanning work folder: $Path"

    # Get project version info
    $statusFile = Find-ProjectStatusFile
    $versionInfo = Get-ProjectVersion -StatusFilePath $statusFile

    # Define folder paths
    $backlogPath = Join-Path $Path "backlog"
    $todoPath = Join-Path $Path "todo"
    $doingPath = Join-Path $Path "doing"
    $donePath = Join-Path $Path "done"

    # Get items from each folder
    $backlogItems = Get-FolderItems -FolderPath $backlogPath
    $todoItems = Get-FolderItems -FolderPath $todoPath
    $doingItems = Get-FolderItems -FolderPath $doingPath
    $doneItems = Get-FolderItems -FolderPath $donePath

    # Get WIP limit and hierarchical count (from module)
    $todoLimitInfo = Get-WipLimit -FolderPath $todoPath
    $hierarchicalTodo = Get-WipCount -FolderPath $todoPath
    $wipLimitInfo = Get-WipLimit -FolderPath $doingPath
    $hierarchicalWip = Get-WipCount -FolderPath $doingPath

    # Get POC spikes (separate from kanban workflow)
    $pocPath = Find-PocFolder
    $pocSpikes = Get-PocSpikes -PocPath $pocPath

    # Build status object
    $status = @{
        ProjectName = $versionInfo.ProjectName
        Version = $versionInfo.Version
        VersionDate = $versionInfo.Date
        Backlog = @{
            Count = $backlogItems.Count
        }
        Todo = @{
            Count = $todoItems.Count
            HierarchicalCount = $hierarchicalTodo.Count
            Limit = $todoLimitInfo.Limit
            HasLimit = $todoLimitInfo.HasLimit
            LimitSource = $todoLimitInfo.Source
            LimitWarning = $todoLimitInfo.Warning
            Groups = $hierarchicalTodo.Groups
        }
        Doing = @{
            RawCount = $doingItems.Count
            HierarchicalCount = $hierarchicalWip.Count
            Limit = $wipLimitInfo.Limit
            HasLimit = $wipLimitInfo.HasLimit
            LimitSource = $wipLimitInfo.Source
            LimitWarning = $wipLimitInfo.Warning
            Groups = $hierarchicalWip.Groups
        }
        Done = @{
            Count = $doneItems.Count
        }
        PocSpikes = @{
            Count = $pocSpikes.Count
            Spikes = $pocSpikes.Spikes
        }
        # Include item details for table formatting
        DoingItems = $doingItems
        DoneItems = $doneItems
    }

    # Output results based on parameter set
    switch ($PSCmdlet.ParameterSetName) {
        'Summary' {
            Write-Output "Backlog: $($backlogItems.Count)"
            Write-Output "Todo: $($todoItems.Count)"
            Write-Output "Doing: $($hierarchicalWip.Count)"
            Write-Output "Done: $($doneItems.Count)"
            Write-Output "POC Spikes: $($pocSpikes.Count)"
        }
        'WipCount' {
            Write-Output $hierarchicalWip.Count
        }
        'Current' {
            if ($hierarchicalWip.Groups.Count -eq 0) {
                Write-Output "No work currently in progress."
            }
            else {
                foreach ($group in $hierarchicalWip.Groups) {
                    $items = $doingItems | Where-Object { $_.ID -like "$($group.BaseID)*" }
                    $parentItem = $items | Where-Object { $_.ID -eq $group.BaseID } | Select-Object -First 1
                    $subItems = $items | Where-Object { $_.ID -ne $group.BaseID } | Sort-Object { $_.ID }
                    $title = if ($parentItem.Title) { $parentItem.Title } else { "(no title)" }

                    Write-Output "$($group.BaseID): $title"

                    foreach ($subItem in $subItems) {
                        $subTitle = if ($subItem.Title) { $subItem.Title } else { "(no title)" }
                        Write-Output "  - $($subItem.ID): $subTitle"
                    }
                }
            }
        }
        'Format' {
            if ($Format -eq "table") {
                Format-TableOutput -Status $status | ForEach-Object { Write-Output $_ }
            }
            else {
                $jsonStatus = @{
                    ProjectName = $status.ProjectName
                    Version = $status.Version
                    VersionDate = $status.VersionDate
                    Backlog = $status.Backlog
                    Todo = $status.Todo
                    Doing = $status.Doing
                    Done = $status.Done
                    PocSpikes = $status.PocSpikes
                }
                $jsonStatus | ConvertTo-Json -Depth 5
            }
        }
    }
}
catch {
    Write-Error "Failed to get workflow status: $_"
    exit 1
}

#endregion
