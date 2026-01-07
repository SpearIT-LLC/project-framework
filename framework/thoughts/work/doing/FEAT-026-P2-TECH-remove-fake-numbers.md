# FEAT-026 Sub-Item: Remove Fabricated Numbers

**ID:** FEAT-026-P2-TECH-remove-fake-numbers
**Parent:** FEAT-026-structure-migration
**Type:** Technical Debt
**Priority:** P2 (Should fix before merge)
**Status:** Todo
**Created:** 2026-01-06

---

## Summary

Remove made-up setup times and other fabricated data from documentation.

---

## Problem

**From followup line 23:**
"Are those Setup Times realistic or just made up? I'd rather have nothing than a made up number. Perhaps a better attribute would be to describe how much of the framework you'll use with each."

Documentation contains fabricated numbers that could mislead users:
- Setup time estimates
- File counts
- Time estimates
- Other unverified claims

---

## Examples

**README.md line 218 - Examples section:**
```
### Scenario 1: Quick Automation Script
**Framework Level:** Minimal
**Setup Time:** 10 minutes    <-- Made up?

### Scenario 2: CLI Utility Tool
**Setup Time:** 45 minutes     <-- Made up?

### Scenario 3: Web Application
**Setup Time:** 3 hours        <-- Made up?
```

---

## Strategy

**Replace fake numbers with:**
1. **Qualitative descriptions** - "minimal setup", "moderate setup"
2. **Framework usage descriptions** - "uses 10% of framework", "full framework"
3. **Complexity indicators** - "simple", "moderate", "complex"
4. **Nothing** - if we don't have real data, don't claim it

**Example replacement:**
- Before: "Setup Time: 3 hours"
- After: "Framework Usage: Full Standard framework with all templates"

---

## Scope

**Search for:**
- "Setup Time:"
- "hours" (in context of estimates)
- "minutes" (in context of estimates)
- "\d+ files" (specific file counts that might be guesses)
- "weeks" / "months" (timeline estimates)

**Files to check:**
- README.md
- QUICK-START.md
- Example scenarios
- Template selection guides

---

## Implementation

1. **Find** all time estimates and number claims
2. **Verify** which are real vs fabricated
3. **Replace** fabricated data with qualitative descriptions
4. **Remove** completely if no good alternative

---

## Completion Criteria

- [ ] All time estimates found and reviewed
- [ ] Fabricated numbers removed or replaced
- [ ] Documentation uses qualitative descriptions
- [ ] No misleading claims remain
- [ ] Changes committed

---

**Last Updated:** 2026-01-06