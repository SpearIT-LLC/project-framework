<#
.SYNOPSIS
    Shared PowerShell module for framework workflow operations.

.DESCRIPTION
    Provides common functions for:
    - WIP limit checking with hierarchical counting
    - Work folder discovery
    - Work item ID normalization

.NOTES
    Version: 1.0.0
    Used by: Get-WorkflowStatus.ps1, Move-WorkItem.ps1, Get-BacklogItems.ps1
#>

#region Work Folder Discovery

function Find-WorkFolder {
    <#
    .SYNOPSIS
        Searches for thoughts/work folder in common locations.
    #>
    [CmdletBinding()]
    param()

    $candidates = @(
        "framework/thoughts/work",
        "thoughts/work",
        "../thoughts/work"
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

#region WIP Limit Functions

function Get-WipLimit {
    <#
    .SYNOPSIS
        Reads WIP limit from doing/.limit file.

    .PARAMETER DoingPath
        Path to the doing/ folder.

    .OUTPUTS
        Hashtable with Limit, Source, and Warning properties.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$DoingPath
    )

    $limitFile = Join-Path $DoingPath ".limit"
    $defaultLimit = 2

    if (-not (Test-Path $limitFile)) {
        return @{
            Limit = $defaultLimit
            Source = "default"
            Warning = ".limit file not found, using default"
        }
    }

    try {
        $content = (Get-Content -Path $limitFile -Raw -Encoding UTF8 -ErrorAction Stop).Trim()
        $limit = [int]$content

        if ($limit -lt 1) {
            return @{
                Limit = $defaultLimit
                Source = "default"
                Warning = "Invalid limit value ($content), using default"
            }
        }

        return @{
            Limit = $limit
            Source = "file"
            Warning = $null
        }
    }
    catch {
        return @{
            Limit = $defaultLimit
            Source = "default"
            Warning = "Failed to parse .limit file, using default"
        }
    }
}

Export-ModuleMember -Function Get-WipLimit

function Get-WipCount {
    <#
    .SYNOPSIS
        Counts work items in doing/ with hierarchical grouping.

    .DESCRIPTION
        Per workflow-guide.md#hierarchical-numbering:
        "Parent and all children count as 1 item toward WIP limit"

        Normalizes IDs so FEAT-018, FEAT-018.1, and feature-018 all group together.

    .PARAMETER DoingPath
        Path to the doing/ folder.

    .OUTPUTS
        Hashtable with Count (number of WIP groups) and Groups (details).
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$DoingPath
    )

    if (-not (Test-Path $DoingPath)) {
        return @{
            Count = 0
            Groups = @()
        }
    }

    $items = Get-ChildItem -Path $DoingPath -Filter "*.md" -File -ErrorAction SilentlyContinue

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
        Checks if adding another item would exceed WIP limit.

    .PARAMETER DoingPath
        Path to the doing/ folder.

    .OUTPUTS
        Hashtable with Exceeded (bool), Current, Limit, and Message.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$DoingPath
    )

    $wipCount = (Get-WipCount -DoingPath $DoingPath).Count
    $wipLimitInfo = Get-WipLimit -DoingPath $DoingPath
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
        LimitSource = $wipLimitInfo.Source
        LimitWarning = $wipLimitInfo.Warning
        Message = $message
    }
}

Export-ModuleMember -Function Test-WipLimitExceeded

#endregion
