# Feature: Data-Driven Setup Script Questions

**ID:** FEAT-111
**Type:** Feature
**Priority:** Low
**Version Impact:** MINOR
**Created:** 2026-02-05
**Theme:** Distribution & Onboarding

---

## Summary

Refactor Setup-Framework.ps1 to use a data-driven approach for setup questions, enabling easier customization, user defaults, and automation support.

---

## Problem Statement

**What problem does this solve?**

The current Setup-Framework.ps1 has hardcoded question/prompt logic scattered throughout the script. This makes it:
1. Harder to add/modify/reorder questions
2. Difficult for users to provide default answers
3. Not automation-friendly for batch project creation
4. Hard to maintain consistency across questions

**Who is affected?**

- Framework maintainers adding new setup questions
- Power users wanting to customize default answers
- Teams wanting to automate project creation
- Users setting up multiple similar projects

**Current workaround:**

Edit the script directly or answer prompts manually each time.

---

## Requirements

### Functional Requirements

- [ ] Define questions in a PowerShell hashtable/array structure
- [ ] Support reading user defaults from optional config file
- [ ] Each question definition includes:
  - Name (for parameter/variable)
  - Prompt text
  - Default value source (git config, empty, custom)
  - Validation rules (optional)
  - Required/optional flag
- [ ] Loop through questions to collect values
- [ ] Display collected values before proceeding
- [ ] Maintain backward compatibility with existing parameters

### Non-Functional Requirements

- [ ] Question definitions should be at top of script (easy to find/modify)
- [ ] Support for future JSON config file (defer implementation)
- [ ] Clear separation between question definition and collection logic
- [ ] No regression in user experience

---

## Design

### Question Definition Structure

```powershell
# At top of Setup-Framework.ps1
$setupQuestions = @(
    @{
        Name = "ProjectName"
        Prompt = "Enter project name"
        ParamValue = $ProjectName  # From script parameter
        DefaultSource = ""         # Empty default
        Required = $true
        Validator = { param($v) $v -match '^[a-zA-Z0-9-_]+$' }
    },
    @{
        Name = "ProjectDescription"
        Prompt = "Enter project description"
        ParamValue = $ProjectDescription
        DefaultSource = ""
        Required = $true
    },
    @{
        Name = "AuthorName"
        Prompt = "Enter author name"
        ParamValue = $AuthorName
        DefaultSource = "git config user.name"  # Try git first
        Required = $false
    },
    @{
        Name = "AuthorEmail"
        Prompt = "Enter author email"
        ParamValue = $AuthorEmail
        DefaultSource = "git config user.email"
        Required = $false
    }
)
```

### Collection Logic

```powershell
function Get-QuestionValue {
    param($Question)

    # 1. Use parameter value if provided
    if ($Question.ParamValue) { return $Question.ParamValue }

    # 2. Try default source (e.g., git config)
    if ($Question.DefaultSource) {
        $default = Invoke-Expression $Question.DefaultSource 2>$null
        if ($default) { return $default }
    }

    # 3. Prompt user
    $value = Read-Host $Question.Prompt

    # 4. Validate if validator exists
    if ($Question.Validator -and $value) {
        if (-not (& $Question.Validator $value)) {
            Write-Warning "Invalid input"
            return Get-QuestionValue $Question
        }
    }

    return $value
}

# Collect all values
$answers = @{}
foreach ($q in $setupQuestions) {
    $answers[$q.Name] = Get-QuestionValue $q
}

# Show user what will be used
Write-Host "`nSetup will use these values:"
foreach ($q in $setupQuestions) {
    Write-Host "  $($q.Name): $($answers[$q.Name])"
}
```

### Future Enhancement Path

**Sprint D&O 4:** Implement in-script hashtable structure (this work item)

**Future (post-D&O 4):** Optional external config file support
```powershell
# User could create: setup-defaults.json
{
    "ProjectName": "my-default-project",
    "AuthorName": "John Smith",
    "AuthorEmail": "john@example.com"
}

# Script checks for config file, merges with git config defaults
```

---

## Implementation Steps

- [ ] Read current Setup-Framework.ps1
- [ ] Extract current question/prompt logic
- [ ] Define `$setupQuestions` hashtable at top of script
- [ ] Implement `Get-QuestionValue` helper function
- [ ] Update main script flow to use question loop
- [ ] Add "values to be used" display
- [ ] Test with parameters (should skip prompts)
- [ ] Test without parameters (should prompt)
- [ ] Test with git config present/absent
- [ ] Verify backward compatibility
- [ ] Update script comments/documentation

---

## Success Criteria

- [ ] All setup questions defined in single, clear data structure
- [ ] Adding new questions requires only adding to hashtable
- [ ] Script behavior unchanged from user perspective
- [ ] Parameter values still override prompts
- [ ] Git config still used as default when available
- [ ] User sees clear summary of values before setup proceeds
- [ ] Code is more maintainable than before

---

## Dependencies

**Depends On:** FEAT-006 (Interactive Setup Script) - Must be completed first

---

## Related Work Items

**Parent:** FEAT-006 - Interactive Setup Script (Sprint D&O 1)
**Theme:** Distribution & Onboarding (Sprint D&O 4 - Polish)

---

## CHANGELOG Notes

**Added:**
- Data-driven question definition system in Setup-Framework.ps1
- Improved setup script maintainability
- Foundation for future user customization features

**Changed:**
- Setup-Framework.ps1 refactored to use hashtable-driven question flow

---

## Notes

- This is a **refactoring enhancement**, not a feature change
- User experience should remain identical
- Sets foundation for future automation and customization
- JSON config file support deferred to post-D&O 4
- Estimated effort: 2-3 hours (implementation + testing)

---

**Created:** 2026-02-05
**Last Updated:** 2026-02-05
