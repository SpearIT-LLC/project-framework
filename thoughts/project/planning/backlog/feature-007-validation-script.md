# Feature: Framework Validation Script

**ID:** FEAT-007
**Type:** Feature (Tooling)
**Version Impact:** MINOR (new tool)
**Target Version:** v2.1.0
**Status:** Backlog
**Created:** 2025-12-19
**Completed:** N/A
**Developer:** Gary Elliott

---

## Summary

Create a validation script that checks if a project correctly follows the framework structure and identifies issues or deviations.

---

## Problem Statement

**What problem does this solve?**

After adopting framework, users may:
- Accidentally delete required folders
- Misplace files in wrong locations
- Forget to set WIP limits
- Let documentation become stale

A validation script provides automated structure checking.

**Who is affected?**

- Users maintaining framework-based projects
- Teams ensuring consistency across projects
- Framework maintainers testing changes

**Current workaround:**

Manual review of folder structure and files.

---

## Requirements

### Functional Requirements

- [ ] Detect framework level (Minimal/Light/Standard)
- [ ] Validate folder structure for detected level
- [ ] Check for required files (README.md, PROJECT-STATUS.md, etc.)
- [ ] Validate WIP limit files exist and contain valid numbers
- [ ] Check for stale documentation (Last Updated > 6 months)
- [ ] Verify git repository exists (if expected)
- [ ] Generate validation report with issues and warnings
- [ ] Return exit code 0 (valid) or 1 (issues found)

### Non-Functional Requirements

- [ ] Cross-platform (PowerShell Core 7+ or Python)
- [ ] Fast execution (< 5 seconds for Standard framework)
- [ ] Clear, actionable error messages
- [ ] Optional verbose mode for detailed output
- [ ] JSON output mode for CI/CD integration

---

## Design

### Validation Checks

**Level Detection:**
- Check for presence of thoughts/framework/ → Standard
- Check for PROJECT-STATUS.md + thoughts/project/ → Light
- Check for README.md only → Minimal

**Folder Structure (Standard):**
```
✓ thoughts/project/planning/ exists
✓ thoughts/project/work/todo/ exists
✓ thoughts/project/work/doing/ exists
✓ thoughts/project/work/done/ exists
✓ thoughts/project/reference/ exists
✓ thoughts/project/research/ exists
✓ thoughts/project/history/ exists
✓ thoughts/framework/process/ exists
✓ thoughts/framework/templates/ exists
✓ thoughts/framework/patterns/ exists
```

**Required Files:**
```
✓ README.md exists
✓ PROJECT-STATUS.md exists (Light/Standard)
✓ CHANGELOG.md exists (Light/Standard)
✓ CLAUDE.md exists (Standard)
✓ INDEX.md exists (Standard)
```

**WIP Limits (Standard):**
```
✓ thoughts/project/work/doing/.limit exists
✓ Content is valid number (typically 1)
✓ thoughts/project/work/todo/.limit exists
✓ Content is valid number (typically 10)
```

**Stale Documentation:**
```
⚠ README.md last updated: 2025-01-15 (5 months ago)
⚠ PROJECT-STATUS.md last updated: 2024-06-01 (6+ months - STALE)
```

### Output Format

**Console Output:**
```
Framework Validation Report
===========================
Framework Level: Standard
Project: SpearIT Project Framework
Validated: 2025-12-19 23:59:59

Structure:
✓ All required folders present (10/10)

Files:
✓ All required files present (5/5)

WIP Limits:
✓ doing/.limit = 1 (valid)
✓ todo/.limit = 10 (valid)

Documentation:
✓ README.md updated 2025-12-19 (current)
✓ PROJECT-STATUS.md updated 2025-12-19 (current)
⚠ CLAUDE.md updated 2025-11-15 (1 month old - consider review)

Issues Found: 0 errors, 1 warning

Status: VALID ✓
```

**JSON Output (for CI/CD):**
```json
{
  "status": "valid",
  "framework_level": "standard",
  "errors": [],
  "warnings": [
    {
      "type": "stale_doc",
      "file": "CLAUDE.md",
      "last_updated": "2025-11-15",
      "age_days": 34,
      "message": "Consider reviewing"
    }
  ],
  "checks": {
    "structure": {"passed": 10, "failed": 0},
    "files": {"passed": 5, "failed": 0},
    "wip_limits": {"passed": 2, "failed": 0},
    "documentation": {"passed": 2, "warnings": 1}
  }
}
```

---

## Implementation Steps

- [ ] Create validate-framework.ps1 (PowerShell Core 7+)
- [ ] Implement framework level detection
- [ ] Implement folder structure validation
- [ ] Implement required file checks
- [ ] Implement WIP limit validation
- [ ] Implement stale documentation detection
- [ ] Add JSON output mode
- [ ] Add verbose mode
- [ ] Test on all framework levels
- [ ] Document script usage in README.md
- [ ] Add to project-framework-template/standard/thoughts/framework/tools/

---

## Success Criteria

- [ ] Script correctly detects all 3 framework levels
- [ ] All validation checks work correctly
- [ ] Error messages are clear and actionable
- [ ] JSON output valid for CI/CD integration
- [ ] Performance acceptable (< 5 seconds)
- [ ] Documentation complete

---

## CHANGELOG Notes

**Added:**
- validate-framework.ps1 - Framework structure validation script
- Automated checking of folder structure, files, and WIP limits
- Stale documentation detection
- JSON output mode for CI/CD integration

---

**Last Updated:** 2025-12-19
**Status:** Backlog (priority for v2.1.0)
