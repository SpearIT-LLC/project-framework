# FEAT-052: Framework YAML Validation Script

**ID:** FEAT-052
**Type:** Feature
**Priority:** Medium
**Status:** Done
**Created:** 2026-01-14
**Related:** FEAT-037 (project config file)

---

## Summary

Create a script to validate `framework.yaml` files against `framework-schema.yaml`.

---

## Problem Statement

Currently, validation of `framework.yaml` is manual - an AI assistant reads both files and checks compliance. This is:

1. **Not automated** - requires manual intervention
2. **Not consistent** - different AI sessions may validate differently
3. **Not CI-friendly** - can't be integrated into build pipelines

---

## Proposed Solution

Create a validation script that:

1. Reads `framework.yaml` from project root
2. Reads schema from `framework/tools/framework-schema.yaml`
3. Validates all required fields are present
4. Validates enum fields contain valid values
5. Reports errors with clear messages

### Output Examples

**Valid:**
```
✓ framework.yaml is valid
```

**Invalid - missing field:**
```
✗ framework.yaml validation failed:
  - Missing required field: project.type
```

**Invalid - bad enum value:**
```
✗ framework.yaml validation failed:
  - Invalid value for project.type: "banana"
    Valid values: framework, application, library, tool
```

---

## Implementation

**Language:** PowerShell (native on Windows, cross-platform via PowerShell Core)

**Location:** `framework/tools/validate-framework.ps1`

**Approach:** Parse YAML manually (simple key-value extraction) to avoid external dependencies.

---

## Acceptance Criteria

- [x] Script validates required fields are present
- [x] Script validates enum values are valid
- [x] Script provides clear error messages
- [x] Script returns appropriate exit codes (0 = valid, 1 = invalid)
- [x] Script can be run from project root
- [x] Documentation for usage (inline help via Get-Help)

---

## Future Enhancements

- CI/CD integration examples
- Pre-commit hook integration
- Watch mode for development

---

**Last Updated:** 2026-01-15
