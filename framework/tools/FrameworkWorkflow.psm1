<#
.SYNOPSIS
    Shared PowerShell module for framework workflow operations.

.DESCRIPTION
    Provides common functions for:
    - WIP limit checking with hierarchical counting
    - Work folder discovery
    - Work item ID normalization
    - Next available ID discovery (common namespace across all types)

.NOTES
    Version: 1.1.0
    Used by: Get-WorkflowStatus.ps1, Move-WorkItem.ps1, Get-BacklogItems.ps1
#>

#region Work Folder Discovery

function Find-WorkFolder {
    <#
    .SYNOPSIS
        Searches for project-hub/work folder in common locations.
    #>
    [CmdletBinding()]
    param()

    $candidates = @(
        "project-hub/work",
        "../project-hub/work"
    )

    foreach ($candidate in $candidates) {
        if (Test-Path -Path $candidate -PathType Container) {
            return (Resolve-Path -Path $candidate).Path
        }
    }

    return $null
}

Export-ModuleMember -Function Find-WorkFolder

#endregion

#region ID Normalization

function ConvertTo-NormalizedWorkItemId {
    <#
    .SYNOPSIS
        Normalizes a work item ID to standard format (TYPE-NNN).

    .DESCRIPTION
        Handles various naming conventions:
        - FEAT-018 -> FEAT-018
        - feature-018 -> FEAT-018
        - FEAT-018.1 -> FEAT-018 (base ID only)

    .PARAMETER RawId
        The raw ID string to normalize (from filename or metadata).

    .PARAMETER IncludeSubItem
        If true, preserves sub-item suffix (e.g., FEAT-018.1).
        Default is false (returns base ID only).
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$RawId,

        [Parameter()]
        [switch]$IncludeSubItem
    )

    process {
        # Extract type and number, optionally sub-item
        if ($RawId -match '^([A-Za-z]+)-(\d+)(?:\.(\d+))?') {
            $type = $matches[1].ToUpper()
            $num = $matches[2]
            $subItem = $matches[3]

            # Normalize long-form type names to standard prefixes
            $type = switch ($type) {
                "FEATURE" { "FEAT" }
                "TECHDEBT" { "TECH" }
                "BUGFIX" { "BUG" }
                default { $type }
            }

            if ($IncludeSubItem -and $subItem) {
                return "$type-$num.$subItem"
            }
            return "$type-$num"
        }

        return $null
    }
}

Export-ModuleMember -Function ConvertTo-NormalizedWorkItemId

#endregion

#region ID Discovery

function Find-ThoughtsFolder {
    <#
    .SYNOPSIS
        Searches for project-hub folder in common locations.
    #>
    [CmdletBinding()]
    param()

    $candidates = @(
        "project-hub",
        "../project-hub"
    )

    foreach ($candidate in $candidates) {
        if (Test-Path -Path $candidate -PathType Container) {
            return (Resolve-Path -Path $candidate).Path
        }
    }

    return $null
}

Export-ModuleMember -Function Find-ThoughtsFolder

function Get-NextWorkItemId {
    <#
    .SYNOPSIS
        Finds the next available work item ID by scanning all work item locations.

    .DESCRIPTION
        Scans all directories containing work items (work/, releases/, poc/, history/spikes/)
        to find the maximum ID currently in use, then returns max + 1.

        All work item types share a common ID namespace:
        FEAT, BUG, TECH, DECISION, SPIKE, POLICY

        Per TECH-046 and workflow-guide.md#finding-next-available-id

    .PARAMETER ProjectHubPath
        Path to the project-hub folder. If not provided, searches common locations.

    .PARAMETER ReturnAsInt
        If true, returns the ID as an integer. Default returns zero-padded string (e.g., "068").

    .OUTPUTS
        String (default): Zero-padded ID like "068" or "1001"
        Int (with -ReturnAsInt): Integer like 68 or 1001

    .EXAMPLE
        Get-NextWorkItemId
        # Returns: "068"

    .EXAMPLE
        Get-NextWorkItemId -ReturnAsInt
        # Returns: 68

    .EXAMPLE
        Get-NextWorkItemId -ProjectHubPath "project-hub"
        # Returns: "068"
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$ProjectHubPath,

        [Parameter()]
        [switch]$ReturnAsInt
    )

    # Find project-hub folder if not provided
    if (-not $ProjectHubPath) {
        $ProjectHubPath = Find-ThoughtsFolder
        if (-not $ProjectHubPath) {
            Write-Error "Could not find project-hub folder. Provide -ProjectHubPath parameter."
            return $null
        }
    }

    if (-not (Test-Path $ProjectHubPath)) {
        Write-Error "Thoughts folder not found: $ProjectHubPath"
        return $null
    }

    # Define all scan locations (relative to project-hub folder)
    $scanFolders = @(
        "work",
        "releases",
        "poc",
        "history/spikes"
    )

    # Valid work item type prefixes
    $validPrefixes = @("DECISION", "FEAT", "TECH", "SPIKE", "POLICY", "BUG", "BUGFIX")
    $prefixPattern = ($validPrefixes -join "|")

    $maxId = 0

    foreach ($folder in $scanFolders) {
        $folderPath = Join-Path $ProjectHubPath $folder

        if (-not (Test-Path $folderPath)) {
            Write-Verbose "Skipping non-existent folder: $folderPath"
            continue
        }

        # Get all .md files recursively
        $files = Get-ChildItem -Path $folderPath -Filter "*.md" -Recurse -File -ErrorAction SilentlyContinue

        foreach ($file in $files) {
            # Match pattern: TYPE-NNN where NNN is one or more digits
            if ($file.BaseName -match "^($prefixPattern)-(\d+)") {
                $idNum = [int]$matches[2]
                if ($idNum -gt $maxId) {
                    $maxId = $idNum
                    Write-Verbose "Found ID $idNum in $($file.Name)"
                }
            }
        }
    }

    $nextId = $maxId + 1

    if ($ReturnAsInt) {
        return $nextId
    }

    # Return zero-padded string (3 digits minimum, or more if needed)
    if ($nextId -lt 1000) {
        return $nextId.ToString("D3")
    }
    else {
        return $nextId.ToString()
    }
}

Export-ModuleMember -Function Get-NextWorkItemId

#endregion

#region WIP Limit Functions

function Get-WipLimit {
    <#
    .SYNOPSIS
        Reads WIP limit from a folder's .limit file.

    .PARAMETER FolderPath
        Path to the workflow folder (e.g., doing/, todo/).

    .PARAMETER DefaultLimit
        Default limit if .limit file is missing or invalid. Default is 0 (no limit).

    .OUTPUTS
        Hashtable with Limit, Source, HasLimit, and Warning properties.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$FolderPath,

        [Parameter()]
        [int]$DefaultLimit = 0
    )

    $limitFile = Join-Path $FolderPath ".limit"

    if (-not (Test-Path $limitFile)) {
        return @{
            Limit = $DefaultLimit
            Source = "none"
            HasLimit = $false
            Warning = $null
        }
    }

    try {
        $content = (Get-Content -Path $limitFile -Raw -Encoding UTF8 -ErrorAction Stop).Trim()
        $limit = [int]$content

        if ($limit -lt 1) {
            return @{
                Limit = $DefaultLimit
                Source = "invalid"
                HasLimit = $false
                Warning = "Invalid limit value ($content) in .limit file"
            }
        }

        return @{
            Limit = $limit
            Source = "file"
            HasLimit = $true
            Warning = $null
        }
    }
    catch {
        return @{
            Limit = $DefaultLimit
            Source = "error"
            HasLimit = $false
            Warning = "Failed to parse .limit file: $_"
        }
    }
}

Export-ModuleMember -Function Get-WipLimit

function Get-WipCount {
    <#
    .SYNOPSIS
        Counts work items in a workflow folder with hierarchical grouping.

    .DESCRIPTION
        Per workflow-guide.md#hierarchical-numbering:
        "Parent and all children count as 1 item toward WIP limit"

        Normalizes IDs so FEAT-018, FEAT-018.1, and feature-018 all group together.

    .PARAMETER FolderPath
        Path to the workflow folder (e.g., doing/, todo/).

    .OUTPUTS
        Hashtable with Count (number of WIP groups) and Groups (details).
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$FolderPath
    )

    if (-not (Test-Path $FolderPath)) {
        return @{
            Count = 0
            Groups = @()
        }
    }

    $items = Get-ChildItem -Path $FolderPath -Filter "*.md" -File -ErrorAction SilentlyContinue

    # Group by normalized base ID
    $groups = @{}

    foreach ($item in $items) {
        $baseId = ConvertTo-NormalizedWorkItemId -RawId $item.BaseName

        if ($baseId) {
            if (-not $groups.ContainsKey($baseId)) {
                $groups[$baseId] = @{
                    BaseID = $baseId
                    Items = @()
                }
            }
            $groups[$baseId].Items += $item.Name
        }
    }

    # Build result
    $groupList = foreach ($key in $groups.Keys | Sort-Object) {
        $group = $groups[$key]
        @{
            BaseID = $group.BaseID
            ItemCount = $group.Items.Count
            Items = $group.Items
        }
    }

    return @{
        Count = $groups.Count
        Groups = @($groupList)
    }
}

Export-ModuleMember -Function Get-WipCount

function Test-WipLimitExceeded {
    <#
    .SYNOPSIS
        Checks if adding another item would exceed WIP limit for a folder.

    .DESCRIPTION
        Returns detailed status about WIP limit for any workflow folder.
        If the folder has no .limit file, HasLimit will be false and
        Exceeded will always be false (no limit to exceed).

    .PARAMETER FolderPath
        Path to the workflow folder (e.g., doing/, todo/).

    .OUTPUTS
        Hashtable with Exceeded, Current, Limit, HasLimit, and Message.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$FolderPath
    )

    $wipCount = (Get-WipCount -FolderPath $FolderPath).Count
    $wipLimitInfo = Get-WipLimit -FolderPath $FolderPath

    # If no limit is configured, can't exceed it
    if (-not $wipLimitInfo.HasLimit) {
        return @{
            Exceeded = $false
            Current = $wipCount
            Limit = 0
            HasLimit = $false
            LimitSource = $wipLimitInfo.Source
            LimitWarning = $wipLimitInfo.Warning
            Message = "No WIP limit configured"
        }
    }

    $limit = $wipLimitInfo.Limit
    $exceeded = $wipCount -ge $limit

    $message = if ($wipCount -lt $limit) {
        "$($limit - $wipCount) slot(s) available"
    }
    elseif ($wipCount -eq $limit) {
        "At limit - no slots available"
    }
    else {
        "$($wipCount - $limit) over limit!"
    }

    return @{
        Exceeded = $exceeded
        Current = $wipCount
        Limit = $limit
        HasLimit = $true
        LimitSource = $wipLimitInfo.Source
        LimitWarning = $wipLimitInfo.Warning
        Message = $message
    }
}

Export-ModuleMember -Function Test-WipLimitExceeded

#endregion
