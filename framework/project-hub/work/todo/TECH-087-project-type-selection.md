# Tech Debt: Add Project Type Selection to Setup-Project.ps1

**ID:** TECH-087
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-01-27

---

## Summary

Enhance Setup-Project.ps1 to prompt for project type during setup, reading valid options from framework-schema.yaml to ensure consistency and maintainability.

---

## Problem Statement

**What is the current state?**

Setup-Project.ps1 prompts for project name and description but not project type. The `framework.yaml` in the starter template has a hardcoded placeholder that users must manually update after setup.

**Why is this a problem?**

- Users don't know which project types are valid
- Manual editing of framework.yaml is error-prone
- No validation of project type values
- Schema is the source of truth but isn't used during setup

**What is the desired state?**

- Setup script reads valid project types from `framework/docs/ref/framework-schema.yaml`
- Presents numbered options with descriptions during setup
- Validates selection
- Automatically populates `framework.yaml` with selected type

---

## Proposed Solution

### 1. Add Project Type Placeholder

Add `{{PROJECT_TYPE}}` placeholder to `templates/starter/framework.yaml`:

```yaml
project:
  name: "{{PROJECT_NAME}}"
  description: "{{PROJECT_DESCRIPTION}}"
  type: {{PROJECT_TYPE}}
  deliverable: code  # or documentation, or hybrid
```

### 2. Parse Schema for Valid Types

Add function to `Setup-Project.ps1` to parse `framework/docs/ref/framework-schema.yaml`:

```powershell
function Get-ProjectTypes {
    param([string]$SchemaPath)

    $content = Get-Content -Path $SchemaPath -Raw

    # Extract project.type enum values and descriptions
    # Pattern: values: followed by key: description pairs
    # Returns: hashtable of @{ key = description }
}
```

### 3. Prompt User for Project Type

Add interactive prompt after project description:

```powershell
# Display project types
Write-Host "`nSelect project type:" -ForegroundColor Yellow
$types = Get-ProjectTypes -SchemaPath "$TemplateDir\framework\docs\ref\framework-schema.yaml"
$i = 1
$typeKeys = @()
foreach ($key in $types.Keys | Sort-Object) {
    Write-Host "  $i. $key - $($types[$key])" -ForegroundColor White
    $typeKeys += $key
    $i++
}

# Get selection
$selection = Read-Host "`nProject type [1-$($types.Count)]"
$projectType = $typeKeys[$selection - 1]
```

### 4. Replace Placeholder

Add project type to replacement hashtable:

```powershell
$placeholders = @{
    "{{PROJECT_NAME}}" = $ProjectName
    "{{PROJECT_DESCRIPTION}}" = $ProjectDescription
    "{{PROJECT_TYPE}}" = $projectType
    "{{DATE}}" = $CurrentDate
}
```

### Implementation Notes

- Schema parsing should be simple regex (YAML libraries not needed for this enum)
- Validate selection is in valid range [1-N]
- Include project type in confirmation summary
- Error handling for missing/malformed schema file

---

## Acceptance Criteria

- [ ] `{{PROJECT_TYPE}}` placeholder added to templates/starter/framework.yaml
- [ ] Setup-Project.ps1 reads framework-schema.yaml
- [ ] Script displays numbered list of valid project types with descriptions
- [ ] Script validates user selection
- [ ] Selected project type replaces placeholder in framework.yaml
- [ ] Project type shown in confirmation summary
- [ ] Error handling for invalid schema file

---

## Files Affected

- `templates/starter/framework.yaml` - Add {{PROJECT_TYPE}} placeholder
- `templates/starter/Setup-Project.ps1` - Add parsing, prompting, and replacement logic

---

## Benefits

- Schema is single source of truth for valid project types
- Setup script always current with schema changes
- User gets clear descriptions of each project type
- Fewer manual edits after setup
- Validation ensures only valid values

---

## Related

- TECH-081: Setup Process Suggestions (related UX improvements)
- framework-schema.yaml defines valid project.type enum values

---

**Created:** 2026-01-27
