# Feature: Framework Validation Script

**ID:** FEAT-007
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2025-12-19

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

**Default Mode (Consumer Projects):**

- [ ] Detect framework level (Minimal/Light/Standard)
- [ ] Validate folder structure for detected level
- [ ] Check for required files (README.md, PROJECT-STATUS.md, etc.)
- [ ] Validate WIP limit files exist and contain valid numbers
- [ ] Check for stale documentation (Last Updated > 6 months)
- [ ] Verify git repository exists (if expected)
- [ ] **YAML schema validation:**
  - [ ] Validate framework.yaml against framework-schema.yaml
  - [ ] Report missing required fields, invalid types
- [ ] **Version consistency validation:**
  - [ ] Version in PROJECT-STATUS.md matches latest git tag
  - [ ] CHANGELOG.md has section for current version
  - [ ] No significant [Unreleased] content when version is released
  - [ ] All work/done/ items have been archived to history/releases/vX.Y.Z/
- [ ] Generate validation report with issues and warnings
- [ ] Return exit code 0 (valid) or 1 (issues found)

**Framework Mode (`-Framework` parameter):**

All default checks PLUS:

- [ ] Template sync validation (`templates/starter/` matches `framework/` source)
- [ ] Framework tooling exists (`tools/Build-FrameworkArchive.ps1`, etc.)
- [ ] Schema file up-to-date with framework.yaml fields
- [ ] Build script calls this validation as pre-build gate

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
- Check for presence of framework/project-hub/ → Standard
- Check for PROJECT-STATUS.md + basic structure → Light
- Check for README.md only → Minimal

**Folder Structure (Standard):**
```
✓ framework/project-hub/work/backlog/ exists
✓ framework/project-hub/work/todo/ exists
✓ framework/project-hub/work/doing/ exists
✓ framework/project-hub/work/done/ exists
✓ framework/project-hub/history/ exists
✓ framework/docs/ exists
✓ framework/templates/ exists
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
✓ framework/project-hub/work/doing/.limit exists
✓ Content is valid number (typically 2)
```

**Stale Documentation:**
```
⚠ README.md last updated: 2025-01-15 (5 months ago)
⚠ PROJECT-STATUS.md last updated: 2024-06-01 (6+ months - STALE)
```

**Version Consistency (v2.1.0 enhancement):**
```
✓ PROJECT-STATUS.md version: v2.1.0
✓ Latest git tag: v2.1.0 (matches)
✓ CHANGELOG.md has [2.1.0] section
✓ [Unreleased] section is empty (good - no uncommitted features)
✓ work/done/ folder is empty (all items archived)
```

**Version Consistency Errors:**
```
✗ PROJECT-STATUS.md version: v2.0.0
✗ Latest git tag: v2.1.0 (MISMATCH - update PROJECT-STATUS.md)

✗ CHANGELOG.md missing [2.1.0] section
  → Add version section to CHANGELOG.md

⚠ [Unreleased] has 3 features listed
⚠ Latest version dated yesterday
  → Consider releasing v2.2.0 or move items back to backlog

⚠ work/done/ has 2 items not archived
  → Move to history/releases/v2.1.0/
```

**YAML Schema Validation:**
```
✓ framework.yaml validates against schema
✓ All required fields present (project, policies, roles)
✓ Field types correct
```

**YAML Schema Errors:**
```
✗ framework.yaml missing required field: project.name
✗ Field 'roles.default' expected string, got array

⚠ Unknown field 'customField' - not in schema (warning only)
```

**Framework Mode Additional Checks (`-Framework`):**
```
✓ templates/starter/ exists
✓ Template CLAUDE.md paths match framework structure
✓ tools/Build-FrameworkArchive.ps1 exists
✓ framework-schema.yaml covers all framework.yaml fields
```

### Output Format

**Console Output:**
```
Framework Validation Report
===========================
Framework Level: Standard
Project: SpearIT Project Framework
Validated: 2026-01-26 12:00:00

Structure:
✓ All required folders present (7/7)

Files:
✓ All required files present (5/5)

WIP Limits:
✓ doing/.limit = 2 (valid)

YAML Schema:
✓ framework.yaml validates against schema

Documentation:
✓ README.md updated 2026-01-26 (current)
✓ PROJECT-STATUS.md updated 2026-01-26 (current)
⚠ CLAUDE.md updated 2025-11-15 (2 months old - consider review)

Issues Found: 0 errors, 1 warning

Status: VALID ✓
```

**JSON Output (for CI/CD):**
```json
{
  "status": "valid",
  "framework_level": "standard",
  "mode": "default",
  "errors": [],
  "warnings": [
    {
      "type": "stale_doc",
      "file": "CLAUDE.md",
      "last_updated": "2025-11-15",
      "age_days": 72,
      "message": "Consider reviewing"
    }
  ],
  "checks": {
    "structure": {"passed": 7, "failed": 0},
    "files": {"passed": 5, "failed": 0},
    "wip_limits": {"passed": 1, "failed": 0},
    "yaml_schema": {"passed": 1, "failed": 0},
    "documentation": {"passed": 2, "warnings": 1}
  }
}
```

---

## Implementation Steps

**Core validation (default mode):**

- [ ] Create validate-framework.ps1 (PowerShell Core 7+)
- [ ] Implement framework level detection
- [ ] Implement folder structure validation
- [ ] Implement required file checks
- [ ] Implement WIP limit validation
- [ ] Implement stale documentation detection
- [ ] Implement YAML schema validation (framework.yaml against schema)
- [ ] Add JSON output mode
- [ ] Add verbose mode

**Framework mode (`-Framework`):**

- [ ] Add `-Framework` switch parameter
- [ ] Implement template sync validation
- [ ] Implement framework tooling checks
- [ ] Implement schema completeness check
- [ ] Integrate with Build-FrameworkArchive.ps1 as pre-build gate

**Testing & documentation:**

- [ ] Test on all framework levels
- [ ] Test both default and -Framework modes
- [ ] Document script usage in README.md
- [ ] Add to framework/tools/

---

## Success Criteria

- [ ] Script correctly detects all 3 framework levels
- [ ] All validation checks work correctly (default mode)
- [ ] YAML schema validation catches field mismatches
- [ ] `-Framework` mode validates template sync and tooling
- [ ] Error messages are clear and actionable
- [ ] JSON output valid for CI/CD integration
- [ ] Performance acceptable (< 5 seconds)
- [ ] Build script integration works as pre-build gate
- [ ] Documentation complete

---

## CHANGELOG Notes

**Added:**
- validate-framework.ps1 - Framework structure validation script
- Automated checking of folder structure, files, and WIP limits
- YAML schema validation (framework.yaml against schema)
- Stale documentation detection
- JSON output mode for CI/CD integration
- `-Framework` mode for framework repo pre-release validation

---

**Last Updated:** 2026-01-26
**Status:** Backlog
