# Tech Debt: Document Issue Response Process (formerly Rollback Policy)

**ID:** TECH-070
**Type:** Tech Debt
**Priority:** High
**Version Impact:** PATCH
**Created:** 2026-01-23

---

## Summary

The framework has template placeholders for rollback plans but no actual documented process for when and how to handle issues discovered during development, testing, or after release.

**Scope Expansion:** During implementation, we expanded from a narrow "Rollback Policy" to a comprehensive "Issue Response Process" that covers all issue discovery scenarios with a unified triage → assess → decide → resolve workflow.

---

## Problem Statement

**What is the current state?**

- `**Rollback Plan:**` placeholder exists in FEATURE-TEMPLATE.md and BUG-TEMPLATE.md
- Troubleshooting guide has `git revert` snippets
- No documented process for:
  - When to rollback vs. fix forward
  - Version numbering for rollbacks
  - CHANGELOG format for reverted changes
  - Work item type for rollbacks
  - Tag handling (delete old tag? keep it?)
  - How to handle already-archived work items
  - Impact assessment before deciding on resolution path
  - Function-level conflict analysis

**Why is this a problem?**

- Teams must make ad-hoc decisions under pressure during issue scenarios
- Inconsistent version numbering after rollbacks
- CHANGELOG entries may be unclear
- Git history may be unclear
- No structured assessment before choosing resolution path

**What is the desired state?**

- Clear issue response process with step-by-step workflow
- Structured impact assessment before resolution
- Consistent versioning after any resolution
- Clear CHANGELOG entries for all resolution types

---

## Delivered Solution

Added comprehensive "Issue Response Process" section to `version-control-workflow.md`:

**Four-Phase Process:**
1. **Phase 1: Severity Triage** - Immediate questions and severity classification
2. **Phase 2: Impact Assessment** - Root cause location, code scope, release impact analysis, conflict analysis
3. **Phase 3: Decision Matrix** - Structured decision based on assessment findings
4. **Phase 4: Resolution Paths** - Four paths: Fix in place, Fix forward, Rollback, Hotfix

**Key Features:**
- Universal process for issues discovered at any point (development, testing, post-release)
- Function-level and line-range conflict analysis
- Rollback branch strategy (never revert directly on main)
- Rollback limitations documented (practical window is most recent release)
- Assessment report template
- Decision tree for choosing resolution path
- Version numbering and CHANGELOG formats for each path
- Complete test scenario with exercises for practice

**Files Affected:**
- `framework/docs/process/version-control-workflow.md` - Added Issue Response Process section
- `templates/standard/framework/docs/process/version-control-workflow.md` - Synced changes

---

## Acceptance Criteria

- [x] Rollback policy documented in version-control-workflow.md
- [x] When to rollback vs fix forward guidance provided
- [x] Version numbering rules for rollbacks defined
- [x] CHANGELOG format for reverted changes shown
- [x] Example rollback scenario documented
- [x] Template synced to templates/standard/

**Additional delivered (scope expansion):**
- [x] Unified issue response process covering all discovery points
- [x] Severity triage phase with classification
- [x] Impact assessment with function-level analysis capability
- [x] Assessment report template
- [x] Decision matrix for choosing resolution path
- [x] Rollback limitations and practical window documented
- [x] Rollback branch strategy (never revert on main)
- [x] Test scenario with exercises for practice

---

## CHANGELOG Notes

### Added
- Issue Response Process section in version-control-workflow.md
  - Four-phase process: Triage → Assess → Decide → Resolve
  - Severity classification (Critical/High/Medium/Low)
  - Impact assessment with function-level conflict analysis
  - Assessment report template
  - Decision matrix for resolution path selection
  - Four resolution paths: Fix in place, Fix forward, Rollback, Hotfix
  - Rollback branch strategy and limitations
  - Version numbering and CHANGELOG formats for each path
  - Complete test scenario with exercises

---

## Status

**Paused:** Documentation complete. Awaiting validation testing (TECH-070.1).

---

## Notes

Discovered during FEAT-025 validation testing. FEAT-012 in project-hello-world tested rollback workflow and found no documented policy.

During implementation, expanded scope based on discussion:
- Rollback assessment should include function-level analysis
- Rollbacks should use a dedicated branch, not revert directly on main
- Process applies to any issue discovery, not just post-release
- Same triage/assess/decide flow works regardless of when issue is found

---

## Related

- **TECH-070.1:** Validate Issue Response Process (sub-task, pending)
- FEAT-025: Manual Setup Validation (source of finding)
- TECH-068: Hotfix/emergency workflow
- TECH-069: Work item cancellation process
