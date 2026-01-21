# Feature: Stale Documentation Checker

**ID:** FEAT-009
**Type:** Feature
**Priority:** Low
**Version Impact:** MINOR
**Created:** 2025-12-19

---

## Summary

Script that scans documentation for "Last Updated" dates older than configurable threshold and reports stale files needing review.

---

## Problem Statement

Documentation becomes outdated over time but there's no automated reminder to review and update.

**Current workaround:** Manual review during retrospectives.

---

## Requirements

- [ ] Scan all .md files for "Last Updated:" field
- [ ] Identify files older than threshold (default: 6 months)
- [ ] Generate report of stale files
- [ ] Prioritize by document importance (README > templates)
- [ ] Optional: Open issues for stale docs
- [ ] Optional: Suggest review schedule

---

## Implementation Notes

Can integrate with validation script (FEAT-007) or standalone tool.

Output format:
```
Stale Documentation Report
==========================
Threshold: 6 months

HIGH PRIORITY (Core docs):
⚠ README.md - Last updated 2024-06-01 (6 months old)

MEDIUM PRIORITY (Templates):
⚠ FEATURE-TEMPLATE.md - Last updated 2024-03-15 (9 months old)

LOW PRIORITY (Historical):
✓ All current
```

---

**Last Updated:** 2025-12-19
**Status:** Backlog - Future (v2.2.0)
