<#
.SYNOPSIS
    Lists backlog items with metadata from a project framework backlog folder.

.DESCRIPTION
    Scans a project-hub/work/backlog/ folder for .md files, parses work item metadata,
    and outputs a formatted table or JSON. Handles inconsistent metadata formats
    from older items by inferring values from filenames and content patterns.

.PARAMETER Path
    Path to the backlog folder. If not specified, searches common locations:
    - framework/project-hub/work/backlog
    - project-hub/work/backlog
    - ../project-hub/work/backlog

.PARAMETER Format
    Output format: 'json'. Mutually exclusive with -Full, -SortBy, and -Ascending.
    Default output (without -Format) is table format.

.PARAMETER SortBy
    Sort field: 'Created' (default), 'ID', or 'Priority'
    - Created: Oldest to newest by default
    - ID: Lowest number to highest (numeric sort, ignores type prefix)
    - Priority: Groups by priority (High, Medium, Low), then by Created within each group

.PARAMETER Ascending
    Reverses the default sort direction:
    - Created: Shows newest first instead of oldest
    - ID: Shows highest numbers first instead of lowest
    - Priority: Groups Low to High instead of High to Low

.PARAMETER Full
    Show full summaries with word-wrapping instead of truncated single-line.
    Mutually exclusive with -Format json.

.EXAMPLE
    .\Get-BacklogItems.ps1
    Lists all backlog items in compact single-line format (default).

.EXAMPLE
    .\Get-BacklogItems.ps1 -Full
    Lists all backlog items with word-wrapped summaries.

.EXAMPLE
    .\Get-BacklogItems.ps1 -Format json
    Outputs backlog items as JSON for programmatic consumption.

.EXAMPLE
    .\Get-BacklogItems.ps1 -Path "C:\Projects\myproject\project-hub\work\backlog"
    Lists backlog items from a specific folder.

.EXAMPLE
    .\Get-BacklogItems.ps1 -SortBy ID
    Lists items sorted by ID number (4, 5, 6... regardless of FEAT/TECH/DECISION prefix).

.EXAMPLE
    .\Get-BacklogItems.ps1 -SortBy Priority
    Groups items by priority (High, Medium, Low), sorted by Created within each group.

.OUTPUTS
    System.String (table format) or System.Object[] (JSON format)

.NOTES
    Version: 1.1.0
    Author: SpearIT Project Framework
    Requires: PowerShell 5.1+
    Dependencies: FrameworkWorkflow.psm1
#>

[CmdletBinding(DefaultParameterSetName = 'Table')]
param(
    [Parameter(Position = 0)]
    [ValidateScript({
        if ($_ -and -not (Test-Path $_)) {
            throw "Path '$_' does not exist."
        }
        $true
    })]
    [string]$Path,

    [Parameter(ParameterSetName = 'Json')]
    [ValidateSet("json")]
    [string]$Format,

    [Parameter(ParameterSetName = 'Table')]
    [Parameter(ParameterSetName = 'Full')]
    [ValidateSet("Created", "ID", "Priority")]
    [string]$SortBy = "Created",

    [Parameter(ParameterSetName = 'Table')]
    [Parameter(ParameterSetName = 'Full')]
    [switch]$Ascending,

    [Parameter(ParameterSetName = 'Full')]
    [switch]$Full
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

# Ensure UTF-8 output for Unicode characters (arrows, etc.)
# Wrapped in try/catch for non-interactive contexts (CI, scheduled tasks)
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch { }

#region Helper Functions

function Get-WorkItemMetadata {
    <#
    .SYNOPSIS
        Extracts metadata from a work item markdown file.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$FilePath
    )

    try {
        $content = Get-Content -Path $FilePath -Raw -Encoding UTF8 -ErrorAction Stop
    }
    catch {
        Write-Warning "Failed to read file: $FilePath - $_"
        return $null
    }

    if ([string]::IsNullOrWhiteSpace($content)) {
        return $null
    }

    $filename = Split-Path -Path $FilePath -Leaf

    # Skip supporting documents (they reference a parent work item)
    if ($content -match '\*\*Supporting Document for:\*\*' -or
        $content -match '\*\*Parent:\*\*' -or
        $content -match '\*\*Supporting:\*\*') {
        return $null
    }

    # Extract ID - try metadata field first, then filename
    # Uses ConvertTo-NormalizedWorkItemId from FrameworkWorkflow.psm1 for consistent normalization
    $id = ""
    if ($content -match '\*\*ID:\*\*\s*([A-Za-z]+-\d+(?:\.\d+)?)') {
        $id = ConvertTo-NormalizedWorkItemId -RawId $matches[1] -IncludeSubItem
    }
    elseif ($content -match '\*\*ID:\*\*\s*(\d+)') {
        # Bare number - infer prefix from filename
        $num = $matches[1]
        if ($filename -match '^([A-Za-z]+)-') {
            $id = ConvertTo-NormalizedWorkItemId -RawId "$($matches[1])-$num"
        }
        else {
            $id = $num
        }
    }
    elseif ($filename -match '^([A-Za-z]+-\d+(?:\.\d+)?)') {
        $id = ConvertTo-NormalizedWorkItemId -RawId $matches[1] -IncludeSubItem
    }

    # Extract Priority from metadata and normalize to High/Medium/Low
    $priority = ""
    if ($content -match '\*\*Priority:\*\*\s*([^\r\n]+)') {
        $rawPriority = $matches[1].Trim()
        # Normalize priority values
        switch -Regex ($rawPriority) {
            '^(High|P1)'   { $priority = "High"; break }
            '^(Medium|P2)' { $priority = "Medium"; break }
            '^(Low|P3)'    { $priority = "Low"; break }
            default        { $priority = "Medium" }  # Default ambiguous values to Medium
        }
    }

    # Extract Version Impact
    $impact = ""
    if ($content -match '\*\*Version Impact:\*\*\s*([A-Z]+)') {
        $impact = $matches[1]
    }

    # Extract Created date (try multiple field names)
    $created = ""
    if ($content -match '\*\*Created:\*\*\s*(\d{4}-\d{2}-\d{2})') {
        $created = $matches[1]
    }
    elseif ($content -match '\*\*Date:\*\*\s*(\d{4}-\d{2}-\d{2})') {
        $created = $matches[1]
    }

    # Extract Summary - first paragraph after ## Summary or ## Context heading
    $summary = ""
    if ($content -match '(?ms)##\s*Summary\s*\r?\n\r?\n(.+?)(?=\r?\n\r?\n|$)') {
        $summary = $matches[1].Trim()
    }
    elseif ($content -match '(?ms)##\s*Context\s*\r?\n\r?\n\*\*Problem:\*\*\s*(.+?)(?=\r?\n\r?\n|$)') {
        # For Decision documents, extract Problem statement from Context section
        $summary = $matches[1].Trim()
    }
    elseif ($content -match '(?ms)##\s*Context\s*\r?\n\r?\n(.+?)(?=\r?\n\r?\n|$)') {
        # Fallback to first paragraph of Context section
        $summary = $matches[1].Trim()
    }

    return [PSCustomObject]@{
        ID       = $id
        Priority = $priority
        Impact   = $impact
        Created  = $created
        Summary  = $summary
        File     = $filename
    }
}

function Format-TableOutput {
    <#
    .SYNOPSIS
        Formats items as a table for console output.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [PSCustomObject[]]$Items,

        [Parameter()]
        [switch]$Full
    )

    # Column widths
    $colId = 14
    $colPriority = 10
    $colImpact = 8
    $colCreated = 12
    $colSummary = 44  # Remaining width for summary
    $totalWidth = $colId + $colPriority + $colImpact + $colCreated + $colSummary

    $output = @()
    $output += ""
    $output += "Backlog: $($Items.Count) items"
    $output += "=" * $totalWidth
    $output += "{0,-$colId} {1,-$colPriority} {2,-$colImpact} {3,-$colCreated} {4}" -f "ID", "Priority", "Impact", "Created", "Summary"
    $output += "-" * $totalWidth

    foreach ($item in $Items) {
        $id       = if ($item.ID)       { $item.ID }       else { "-" }
        $priority = if ($item.Priority) { $item.Priority } else { "-" }
        $impact   = if ($item.Impact)   { $item.Impact }   else { "-" }
        $created  = if ($item.Created)  { $item.Created }  else { "-" }
        $summary  = if ($item.Summary)  { $item.Summary }  else { "-" }

        if ($Full) {
            # Word-wrap summary for full view
            $summaryLines = Split-TextIntoLines -Text $summary -MaxWidth $colSummary
            $prefixWidth = $colId + $colPriority + $colImpact + $colCreated + 3  # +3 for spaces

            # First line includes all columns
            $output += "{0,-$colId} {1,-$colPriority} {2,-$colImpact} {3,-$colCreated} {4}" -f $id, $priority, $impact, $created, $summaryLines[0]

            # Subsequent lines are indented
            for ($i = 1; $i -lt $summaryLines.Count; $i++) {
                $output += ("{0,$prefixWidth} {1}" -f "", $summaryLines[$i])
            }
        }
        else {
            # Truncate summary for single-line compact view (default)
            if ($summary.Length -gt $colSummary) {
                $summary = $summary.Substring(0, $colSummary - 3) + "..."
            }
            $output += "{0,-$colId} {1,-$colPriority} {2,-$colImpact} {3,-$colCreated} {4}" -f $id, $priority, $impact, $created, $summary
        }
    }

    $output += ""
    return $output
}

function Split-TextIntoLines {
    <#
    .SYNOPSIS
        Splits text into lines that fit within a maximum width, breaking at word boundaries.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Text,

        [Parameter(Mandatory)]
        [int]$MaxWidth
    )

    if ([string]::IsNullOrWhiteSpace($Text) -or $Text.Length -le $MaxWidth) {
        return @($Text)
    }

    $lines = @()
    $words = $Text -split '\s+'
    $currentLine = ""

    foreach ($word in $words) {
        if ($currentLine.Length -eq 0) {
            $currentLine = $word
        }
        elseif (($currentLine.Length + 1 + $word.Length) -le $MaxWidth) {
            $currentLine += " " + $word
        }
        else {
            $lines += $currentLine
            $currentLine = $word
        }
    }

    if ($currentLine.Length -gt 0) {
        $lines += $currentLine
    }

    return $lines
}

#endregion

#region Main Script

try {
    # Resolve backlog folder path
    if (-not $Path) {
        $workFolder = Find-WorkFolder
        if ($workFolder) {
            $Path = Join-Path $workFolder "backlog"
            if (-not (Test-Path $Path)) {
                $Path = $null
            }
        }
        if (-not $Path) {
            Write-Error "Backlog folder not found. Use -Path to specify location."
            exit 1
        }
    }

    Write-Verbose "Scanning backlog folder: $Path"

    # Get all markdown files
    $files = Get-ChildItem -Path $Path -Filter "*.md" -File -ErrorAction Stop

    if ($files.Count -eq 0) {
        Write-Warning "No markdown files found in $Path"
        $items = @()
    }
    else {
        Write-Verbose "Found $($files.Count) markdown files"

        # Parse metadata from each file
        $items = foreach ($file in $files) {
            $metadata = Get-WorkItemMetadata -FilePath $file.FullName
            if ($metadata) {
                $metadata
            }
        }

        # Ensure items is always an array, filtering nulls
        $items = @($items | Where-Object { $_ })

        Write-Verbose "Parsed $($items.Count) work items (excluding supporting documents)"

        # Sort items based on SortBy parameter
        # Default sort directions: Created=oldest first, ID=lowest first, Type=A-Z then by Created
        if ($items.Count -gt 0) {
            switch ($SortBy) {
                "Created" {
                    # Sort by date, oldest to newest by default
                    $items = $items | Sort-Object -Property {
                        if ([string]::IsNullOrEmpty($_.Created)) { "0000-00-00" } else { $_.Created }
                    } -Descending:$Ascending  # Inverted: -Ascending flag means newest first
                }
                "ID" {
                    # Sort by numeric portion of ID (e.g., FEAT-004 -> 4), lowest to highest by default
                    $items = $items | Sort-Object -Property {
                        if ($_.ID -match '-(\d+)') { [int]$matches[1] } else { [int]::MaxValue }
                    } -Descending:$Ascending  # Inverted: -Ascending flag means highest first
                }
                "Priority" {
                    # Group by priority (High=1, Medium=2, Low=3, empty=4), then by Created within each group
                    $items = $items | Sort-Object -Property @(
                        @{ Expression = {
                            switch ($_.Priority) {
                                "High"   { 1 }
                                "Medium" { 2 }
                                "Low"    { 3 }
                                default  { 4 }
                            }
                        }; Descending = $Ascending }
                        @{ Expression = { if ([string]::IsNullOrEmpty($_.Created)) { "0000-00-00" } else { $_.Created } }; Descending = $false }
                    )
                }
            }
        }
    }

    # Output results based on parameter set
    switch ($PSCmdlet.ParameterSetName) {
        'Json' {
            $items | ConvertTo-Json -Depth 3
        }
        'Full' {
            Format-TableOutput -Items $items -Full | ForEach-Object { Write-Output $_ }
        }
        'Table' {
            Format-TableOutput -Items $items | ForEach-Object { Write-Output $_ }
        }
    }
}
catch {
    Write-Error "Failed to list backlog items: $_"
    exit 1
}

#endregion
