<#
.SYNOPSIS
    Displays the framework topic index from framework.yaml sources section.

.DESCRIPTION
    Reads the sources section from framework.yaml and displays a human-friendly
    table of topics and their authoritative source files. This provides easy
    lookup for "where is X documented?" questions.

    The source of truth is framework.yaml - this script just formats it for humans.

.PARAMETER Path
    Path to framework.yaml. If not specified, searches common locations:
    - framework.yaml
    - ../framework.yaml

.PARAMETER Filter
    Filter to show only topics matching this pattern (case-insensitive, matches anywhere).
    Example: -Filter "workflow" shows all topics containing "workflow".

.PARAMETER Format
    Output format: 'table' (default) or 'json'.

.PARAMETER ListTopics
    Just list topic names without source paths.

.EXAMPLE
    .\Get-FrameworkIndex.ps1
    Displays full topic index as a formatted table.

.EXAMPLE
    .\Get-FrameworkIndex.ps1 -Filter "security"
    Shows all topics containing "security".

.EXAMPLE
    .\Get-FrameworkIndex.ps1 -Filter "workflow"
    Shows all topics containing "workflow".

.EXAMPLE
    .\Get-FrameworkIndex.ps1 -Format json
    Outputs topic index as JSON for tooling.

.EXAMPLE
    .\Get-FrameworkIndex.ps1 -ListTopics
    Lists just the topic names.

.OUTPUTS
    Formatted table or JSON depending on -Format parameter.

.NOTES
    Version: 1.0.0
    Author: SpearIT Project Framework
    Requires: PowerShell 5.1+, powershell-yaml module

    Source of Truth: framework.yaml (sources section)
    Related: /fw-index command
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

    [Parameter()]
    [string]$Filter,

    [Parameter(ParameterSetName = 'Table')]
    [Parameter(ParameterSetName = 'Json')]
    [ValidateSet("table", "json")]
    [string]$Format = "table",

    [Parameter(ParameterSetName = 'ListTopics')]
    [switch]$ListTopics
)

#Requires -Version 5.1
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

#region Helper Functions

function Find-FrameworkYaml {
    <#
    .SYNOPSIS
        Searches for framework.yaml in common locations.
    #>
    [CmdletBinding()]
    param()

    $candidates = @(
        "framework.yaml",
        "../framework.yaml",
        "../../framework.yaml"
    )

    foreach ($candidate in $candidates) {
        if (Test-Path -Path $candidate -PathType Leaf) {
            return (Resolve-Path -Path $candidate).Path
        }
    }

    return $null
}

function Import-YamlFile {
    <#
    .SYNOPSIS
        Imports a YAML file, handling module installation if needed.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$FilePath
    )

    # Check if powershell-yaml is available
    if (-not (Get-Module -ListAvailable -Name powershell-yaml)) {
        Write-Warning "powershell-yaml module not found. Attempting to install..."
        try {
            Install-Module -Name powershell-yaml -Scope CurrentUser -Force -AllowClobber
        }
        catch {
            Write-Error "Failed to install powershell-yaml module. Please install manually: Install-Module powershell-yaml"
            return $null
        }
    }

    Import-Module powershell-yaml -ErrorAction Stop

    $content = Get-Content -Path $FilePath -Raw -Encoding UTF8
    return ConvertFrom-Yaml -Yaml $content
}

function Get-FlattenedSources {
    <#
    .SYNOPSIS
        Flattens nested sources into a simple topic -> path hashtable.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Sources,

        [Parameter()]
        [string]$Prefix = ""
    )

    $result = @{}

    foreach ($key in $Sources.Keys) {
        $value = $Sources[$key]
        $fullKey = if ($Prefix) { "$Prefix-$key" } else { $key }

        if ($value -is [hashtable]) {
            # Nested structure - recurse
            $nested = Get-FlattenedSources -Sources $value -Prefix $fullKey
            foreach ($nestedKey in $nested.Keys) {
                $result[$nestedKey] = $nested[$nestedKey]
            }
        }
        else {
            # Simple value
            $result[$fullKey] = $value
        }
    }

    return $result
}

function Format-TopicName {
    <#
    .SYNOPSIS
        Formats a topic key into a human-readable name.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Key
    )

    # Convert kebab-case to Title Case
    $words = $Key -split '-'
    $formatted = ($words | ForEach-Object {
        if ($_.Length -gt 0) {
            $_.Substring(0,1).ToUpper() + $_.Substring(1).ToLower()
        }
    }) -join ' '

    return $formatted
}

function Format-SourcePath {
    <#
    .SYNOPSIS
        Formats a source path, separating file from anchor.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$SourcePath
    )

    if ($SourcePath -match '^(.+?)#(.+)$') {
        return @{
            File = $matches[1]
            Anchor = $matches[2]
        }
    }
    else {
        return @{
            File = $SourcePath
            Anchor = $null
        }
    }
}

#endregion

#region Main Script

try {
    # Resolve framework.yaml path
    if (-not $Path) {
        $Path = Find-FrameworkYaml
        if (-not $Path) {
            Write-Error "framework.yaml not found. Use -Path to specify location."
            exit 1
        }
    }

    Write-Verbose "Reading framework.yaml from: $Path"

    # Load YAML
    $yaml = Import-YamlFile -FilePath $Path
    if (-not $yaml) {
        Write-Error "Failed to parse framework.yaml"
        exit 1
    }

    # Check for sources section
    if (-not $yaml.sources) {
        Write-Warning "No 'sources' section found in framework.yaml"
        Write-Output "framework.yaml does not contain a sources section."
        exit 0
    }

    # Flatten sources
    $sources = Get-FlattenedSources -Sources $yaml.sources

    # Filter topics if specified (case-insensitive, matches anywhere in key)
    if ($Filter) {
        $filtered = @{}
        # Normalize pattern for case-insensitive matching
        $pattern = "*$Filter*"
        foreach ($key in $sources.Keys) {
            if ($key -like $pattern) {
                $filtered[$key] = $sources[$key]
            }
        }
        $sources = $filtered

        if ($sources.Count -eq 0) {
            Write-Output "No topics found matching '$Filter'"
            Write-Output ""
            Write-Output "Available categories: workflow, work, git, code, testing, security,"
            Write-Output "  architecture, troubleshooting, documentation, dry, structure,"
            Write-Output "  ai, template, new, upgrade, pattern"
            exit 0
        }
    }

    # Output based on parameter set
    switch ($PSCmdlet.ParameterSetName) {
        'ListTopics' {
            $sources.Keys | Sort-Object | ForEach-Object { Write-Output $_ }
        }
        default {
            if ($Format -eq "json") {
                $sources | ConvertTo-Json -Depth 3
            }
            else {
                # Table format
                Write-Output ""
                Write-Output "Framework Topic Index ($($sources.Count) topics)"
                Write-Output ""

                # Build table data
                $tableData = foreach ($key in ($sources.Keys | Sort-Object)) {
                    $parsed = Format-SourcePath -SourcePath $sources[$key]
                    $shortFile = $parsed.File -replace '^framework/', ''

                    $source = $shortFile
                    if ($parsed.Anchor) {
                        $source = "$shortFile#$($parsed.Anchor)"
                    }

                    [PSCustomObject]@{
                        Topic = $key
                        Source = $source
                    }
                }

                # Output as formatted table with full paths
                $tableData | Format-Table -Property Topic, Source -AutoSize -Wrap | Out-String | Write-Output

                Write-Output "Filter: -Filter <pattern> (e.g., 'workflow', 'ai', 'security')"
                Write-Output ""
            }
        }
    }
}
catch {
    Write-Error "Failed to get framework index: $_"
    exit 1
}

#endregion
