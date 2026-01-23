<#
.SYNOPSIS
    Validates framework.yaml against framework-schema.yaml

.DESCRIPTION
    Checks that framework.yaml contains all required fields and that
    enum fields have valid values as defined in framework-schema.yaml.

.PARAMETER ConfigPath
    Path to framework.yaml. Defaults to framework.yaml in the current directory.

.PARAMETER SchemaPath
    Path to framework-schema.yaml. Defaults to framework/docs/ref/framework-schema.yaml
    relative to the config file location.

.EXAMPLE
    .\validate-framework.ps1
    Validates framework.yaml in the current directory.

.EXAMPLE
    .\validate-framework.ps1 -ConfigPath "C:\Projects\myapp\framework.yaml"
    Validates a specific framework.yaml file.

.OUTPUTS
    Exit code 0 if valid, 1 if invalid.
#>

param(
    [string]$ConfigPath = "framework.yaml",
    [string]$SchemaPath = ""
)

# Resolve paths
$ConfigPath = Resolve-Path $ConfigPath -ErrorAction SilentlyContinue
if (-not $ConfigPath) {
    Write-Host "X framework.yaml not found" -ForegroundColor Red
    exit 1
}

if (-not $SchemaPath) {
    $configDir = Split-Path $ConfigPath -Parent
    $SchemaPath = Join-Path $configDir "framework/docs/ref/framework-schema.yaml"
}

if (-not (Test-Path $SchemaPath)) {
    Write-Host "X Schema not found: $SchemaPath" -ForegroundColor Red
    exit 1
}

# Simple YAML parser for our specific structure
function Parse-SimpleYaml {
    param([string]$Path)

    $content = Get-Content $Path -Raw
    $lines = $content -split "`n"
    $result = @{}
    $currentPath = @()
    $indentStack = @(0)

    foreach ($line in $lines) {
        # Skip comments and empty lines
        if ($line -match '^\s*#' -or $line -match '^\s*$') { continue }

        # Get indentation level
        $indent = 0
        if ($line -match '^(\s*)') {
            $indent = $matches[1].Length
        }

        # Adjust current path based on indentation
        while ($indentStack.Count -gt 1 -and $indent -le $indentStack[-1]) {
            $indentStack = $indentStack[0..($indentStack.Count - 2)]
            if ($currentPath.Count -gt 0) {
                $currentPath = $currentPath[0..($currentPath.Count - 2)]
            }
        }

        # Parse key: value
        if ($line -match '^\s*([^:]+):\s*(.*)$') {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim().Trim('"').Trim("'")

            if ($value -eq '' -or $value -match '^[|>]') {
                # This is a parent key
                $currentPath += $key
                $indentStack += $indent
            } else {
                # This is a leaf value
                $fullKey = ($currentPath + $key) -join '.'
                $result[$fullKey] = $value
            }
        }
    }

    return $result
}

# Parse schema to extract field definitions
function Parse-Schema {
    param([string]$Path)

    $content = Get-Content $Path -Raw
    $fields = @{}

    # Extract field definitions using regex
    $fieldMatches = [regex]::Matches($content, '(?m)^  ([\w.]+):\s*\n((?:    .+\n)*)')

    foreach ($match in $fieldMatches) {
        $fieldName = $match.Groups[1].Value
        $fieldBlock = $match.Groups[2].Value

        $field = @{
            required = $false
            type = "string"
            values = @()
        }

        if ($fieldBlock -match 'required:\s*(true|false)') {
            $field.required = $matches[1] -eq 'true'
        }

        if ($fieldBlock -match 'type:\s*(\w+)') {
            $field.type = $matches[1]
        }

        # Extract enum values
        if ($field.type -eq 'enum') {
            $valueMatches = [regex]::Matches($fieldBlock, '(?m)^      (\w+):')
            $field.values = $valueMatches | ForEach-Object { $_.Groups[1].Value }
        }

        $fields[$fieldName] = $field
    }

    return $fields
}

# Main validation
$errors = @()

# Parse files
$config = Parse-SimpleYaml -Path $ConfigPath
$schema = Parse-Schema -Path $SchemaPath

# Validate each schema field
foreach ($fieldName in $schema.Keys) {
    $field = $schema[$fieldName]

    # Check required fields
    if ($field.required -and -not $config.ContainsKey($fieldName)) {
        $errors += "Missing required field: $fieldName"
        continue
    }

    # Check enum values
    if ($config.ContainsKey($fieldName) -and $field.type -eq 'enum') {
        $value = $config[$fieldName]
        if ($value -notin $field.values) {
            $validValues = $field.values -join ', '
            $errors += "Invalid value for ${fieldName}: `"$value`"`n    Valid values: $validValues"
        }
    }
}

# Output results
if ($errors.Count -eq 0) {
    Write-Host "OK framework.yaml is valid" -ForegroundColor Green
    exit 0
} else {
    Write-Host "X framework.yaml validation failed:" -ForegroundColor Red
    foreach ($err in $errors) {
        Write-Host "  - $err" -ForegroundColor Red
    }
    exit 1
}
