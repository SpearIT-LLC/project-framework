# Tech Debt: Remove Multi-Level Framework References from Documentation

**ID:** TECH-106
**Type:** Tech Debt
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-02-04
**Theme:** Distribution & Onboarding
**Planning Period:** Sprint D&O 0
**Depends On:** DECISION-105

---

## Summary

Remove all references to the obsolete "Minimal/Light/Standard" framework levels concept from active user-facing documentation, implementing the unified framework positioning approved in DECISION-105.

---

## Problem Statement

**What is the current state?**

117+ files contain references to the abandoned "Minimal/Light/Standard" framework levels concept. Core user-facing documentation (README, QUICK-START, CLAUDE.md, INDEX, workflow-guide) still positions the framework as "multi-level" and instructs users to "choose your framework level."

**Why is this a problem?**

1. **Confusing for new users**: Documentation contradicts the unified framework vision
2. **Blocks FEAT-089**: Project Organization work needs clear positioning
3. **Misleading marketing**: "Multi-level project management framework" is vague and inaccurate
4. **Maintenance burden**: Inconsistent messaging across documentation

**What is the desired state?**

- User-facing documentation uses approved positioning statements (DECISION-105)
- No references to "choose your framework level" or Minimal/Light/Standard
- Clear, honest positioning: "file-based workflow and AI collaboration partner for solo developers and small teams"
- Historical files remain unchanged (archived context)

---

## Proposed Solution

Update user-facing documentation with approved positioning statements from DECISION-105:

**Version 1 (Concise)** - README opening, elevator pitch:
> The **SpearIT Project Framework** is a file-based workflow and AI collaboration partner for solo developers and small teams building software or documentation projects.

**Version 2 (Verbose)** - Detailed descriptions:
> The **SpearIT Project Framework** is a file-based workflow and AI collaboration partner for solo developers and small teams. Using markdown files and scripting tools, it provides Kanban work tracking, strategic roadmaps, AI-guided planning, and documentation standards—without requiring external services or databases.

**Files Affected (Priority Order):**

**Tier 1: Critical User-Facing (Must Fix)**
- `README.md` (root) - Use Version 1 in "What Is This?", update Key Features
- `framework/README.md` - Use Version 1, remove level references
- `QUICK-START.md` - Remove "choose your level" section, simplify
- `framework/CLAUDE.md` - Remove level-based instructions
- `templates/starter/framework/CLAUDE.md` - Sync with framework/CLAUDE.md
- `framework/INDEX.md` - Update references to framework levels

**Tier 2: Core Documentation**
- `framework/docs/ref/GLOSSARY.md` - Remove any remaining multi-level references
- `framework/docs/collaboration/workflow-guide.md` - Update framework description
- `framework/docs/collaboration/architecture-guide.md` - Remove level references
- `framework/docs/PROJECT-STRUCTURE.md` - Clarify this is THE structure (not "Standard level")
- `framework/docs/REPOSITORY-STRUCTURE.md` - Update positioning

**Tier 3: Secondary Documentation**
- `framework/CHANGELOG.md` - Add entry documenting this change
- `framework.yaml` - Update any positioning text
- `templates/starter/framework.yaml` - Sync with framework.yaml

**Historical Files (Do NOT change):**
- `framework/project-hub/history/**` - Leave as-is (archived context)
- Session histories, release notes, retrospectives - Historical record, don't modify

---

## Acceptance Criteria

- [x] All Tier 1 files updated with approved positioning (Version 1 or 2 as appropriate)
- [x] All Tier 2 core documentation updated
- [x] CHANGELOG.md entry added
- [x] No references to "Minimal/Light/Standard" in active user docs (excluding history/)
- [x] No instructions to "choose your framework level"
- [x] Positioning is consistent across all user-facing files
- [x] Templates synced (starter/ matches framework/)
- [x] GLOSSARY.md fully reflects unified framework model

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
<!-- User can say "continue to completion" to approve remaining steps at once. -->

- [x] **PRE-IMPLEMENTATION REVIEW COMPLETED**
  - AI presents: Files to update, positioning statements to use, scope boundaries
  - User explicitly approves before proceeding

### Tier 1: Critical User-Facing Files
- [x] Update README.md (root) with Version 1 positioning
- [x] Update framework/README.md with Version 1 positioning
- [x] Simplify QUICK-START.md (remove "choose level" section)
- [x] Update framework/CLAUDE.md (remove level-based instructions)
- [x] Update templates/starter/framework/CLAUDE.md (sync)
- [x] Update framework/INDEX.md (remove level references)

### Tier 2: Core Documentation
- [x] Update GLOSSARY.md (remove multi-level references)
- [x] Update workflow-guide.md (framework description)
- [x] Update architecture-guide.md (remove level references)
- [x] Update PROJECT-STRUCTURE.md (clarify naming)
- [x] Update REPOSITORY-STRUCTURE.md (positioning)

### Tier 3: Meta Files
- [x] Update CHANGELOG.md (document change)
- [x] Update framework.yaml (positioning text if any)
- [x] Sync templates/starter/framework.yaml

### Cleanup
- [x] Rename PROJECT-STRUCTURE-STANDARD.md → PROJECT-STRUCTURE.md
  - Updated 11 active file references (excluding history/)
  - Used `git mv` to preserve history

### Validation
- [x] Grep search confirms no "Minimal/Light/Standard" in active docs (excluding history/)
- [x] Grep search confirms no "choose your framework level" in active docs
- [x] README positioning is clear and specific
- [x] Templates are synced

---

## Effort Estimate

**Estimated Time:** 2-3 hours
- Tier 1 updates: 1 hour (6 files, straightforward replacements)
- Tier 2 updates: 45 min (5 files, contextual updates)
- Tier 3 + validation: 30 min

---

## Risk Assessment

**Low Risk:**
- Text-only changes (no code changes)
- Historical files preserved (no information loss)
- Can be completed incrementally (tier by tier)
- Easy to review (git diff shows all changes)

**Validation Strategy:**
- Use grep to confirm cleanup is complete
- Review git diff for unintended changes
- Spot-check that historical files were NOT modified

---

## Related

- **DECISION-105**: Retire Multi-Level Framework Concept (prerequisite)
- **FEAT-089**: Project Organization (unblocked by this work)
- **FEAT-095**: AI-Guided Roadmap Creation (discovered this issue)

---

## Notes

**Scope Boundaries:**

**DO update:**
- Active user-facing documentation (README, QUICK-START, guides)
- Templates that users copy (starter/)
- Current process documentation

**DO NOT update:**
- Historical files (project-hub/history/**/)
- Session histories
- Release notes (they document what WAS true at that time)
- Retrospectives (historical context)
- Archived work items in done/ folders

**Rationale:** Historical documents are records of what was thought/done at that time. Changing them would rewrite history and lose valuable context about the framework's evolution.

---

**Last Updated:** 2026-02-04
