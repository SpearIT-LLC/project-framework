<#
.SYNOPSIS
    Publishes the framework workspace plugin to the local fw-dev-marketplace.

.DESCRIPTION
    Creates/refreshes a directory junction to workspaces/framework and writes the
    marketplace manifest. Deliberately separate from the old dev-marketplace
    (tools/Publish-ToLocalMarketplace.ps1), which discovers only plugins/ and wipes
    its marketplace on every run — the two must not interfere (ADR-009 boundary).

    One-time setup in Claude Code:
      /plugin marketplace add <parent>/fw-dev-marketplace
      /plugin install spearit-framework-dev@fw-dev-marketplace --scope local
    Then per cycle: rerun this script, /plugin marketplace update fw-dev-marketplace,
    restart Claude Code.
#>

[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# This script lives at workspaces/framework/tools/ — repo root is three levels up.
$workspaceRoot   = Split-Path $PSScriptRoot -Parent
$repoRoot        = Split-Path (Split-Path $workspaceRoot -Parent) -Parent
$marketplaceRoot = Join-Path (Split-Path $repoRoot -Parent) "fw-dev-marketplace"
$manifestDir     = Join-Path $marketplaceRoot ".claude-plugin"
$manifestPath    = Join-Path $manifestDir "marketplace.json"

$pluginJson = Get-Content (Join-Path $workspaceRoot ".claude-plugin\plugin.json") -Raw |
    ConvertFrom-Json

New-Item -Path $manifestDir -ItemType Directory -Force | Out-Null

# Junction: marketplace/<name> -> workspaces/framework (source changes reflect live).
# Directory.Delete (not Remove-Item -Recurse) so the junction target is never touched.
$linkPath = Join-Path $marketplaceRoot "framework"
if (Test-Path $linkPath) {
    [System.IO.Directory]::Delete($linkPath)
}
New-Item -ItemType Junction -Path $linkPath -Target $workspaceRoot -Force | Out-Null

$manifest = @{
    name    = "fw-dev-marketplace"
    owner   = @{ name = "Development" }
    plugins = @(
        @{
            name        = $pluginJson.name
            source      = "./framework"
            description = $pluginJson.description
            version     = $pluginJson.version
        }
    )
}

Set-Content -Path $manifestPath -Value ($manifest | ConvertTo-Json -Depth 10) -Encoding UTF8

Write-Host "Published $($pluginJson.name) v$($pluginJson.version) -> $marketplaceRoot"
Write-Host "Next: /plugin marketplace update fw-dev-marketplace, then restart Claude Code."
