# FEAT-052: Framework YAML Validation Script

**ID:** FEAT-052
**Type:** Feature
**Priority:** Medium
**Status:** Backlog
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

## Implementation Options

| Option | Pros | Cons |
|--------|------|------|
| Python script | Widely available, good YAML support | Requires Python installed |
| Node.js script | Good for JS-heavy projects | Requires Node installed |
| Shell + yq | Minimal dependencies | yq not always installed |
| PowerShell | Native on Windows | Not cross-platform |

**Recommendation:** Python - most portable and has built-in YAML support via PyYAML.

---

## Acceptance Criteria

- [ ] Script validates required fields are present
- [ ] Script validates enum values are valid
- [ ] Script provides clear error messages
- [ ] Script returns appropriate exit codes (0 = valid, 1 = invalid)
- [ ] Script can be run from project root
- [ ] Documentation for usage

---

## Future Enhancements

- CI/CD integration examples
- Pre-commit hook integration
- Watch mode for development

---

**Last Updated:** 2026-01-14
