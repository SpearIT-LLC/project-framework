# Distribution & Onboarding Sprint Planning

**Created:** 2026-02-05
**Last Updated:** 2026-02-06
**Purpose:** Track work item allocation across Distribution & Onboarding sprints

---

## Overview

The Distribution & Onboarding theme focuses on packaging, installation, setup automation, and first-time user experience. This plan covers 4 sprints progressing from MVP to polish.

**Total D&O Items:** 17 work items (18 minus DECISION-036 to be archived)
**Completed Sprints:** D&O 0 ✅ (1/1 items complete - 2026-02-05)
**Current Sprint:** D&O 1 (MVP Distribution Package) - 3 items (2 complete - 67%)
**Future Sprints:** D&O 2 (2 items), D&O 3 (1 item), D&O 4 (10 items)

**Sprint D&O 1 streamlined!** DECISION-029 and FEAT-107 moved to D&O 4 (polish). Ready to release v5.1.0.

---

## Sprint D&O 0 (COMPLETE) - Prerequisites for Distribution Work

**Goal:** Foundation decisions and critical structural fixes
**Status:** ✅ COMPLETE
**Items:** 1
**Completed:** 2026-02-05

### Committed Items

- [x] **BUG-109** - Starter Template project-hub Location
  - **Status:** DONE (Completed 2026-02-05)
  - **Theme:** Distribution & Onboarding
  - **Notes:** Fixed starter template structure - project-hub now at repository root

**Sprint Notes:**
- ✅ Template structure fix completed and verified
- ✅ Distribution archive rebuilt with correct structure
- ✅ Setup-Project.ps1 tested successfully
- ✅ DECISION-037 migration now 100% complete
- ✅ Sprint D&O 1 unblocked and ready to start

---

## Sprint D&O 1 (Next) - MVP Distribution Package and Setup Process

**Goal:** Minimal viable distribution package
**Status:** In Progress (2/3 complete - 67%)
**Items:** 3
**Work Order:** FEAT-005 → FEAT-006 → FEAT-011

### Committed Items

- [x] **FEAT-005** - ZIP Distribution Package
  - **Status:** DONE (Completed 2026-02-05)
  - **Theme:** Distribution & Onboarding
  - **Priority:** 1 - Work first
  - **Notes:** Core MVP distribution artifact - requirements met via DECISION-050 implementation

- [x] **FEAT-006** - Interactive Setup Script
  - **Status:** DONE (Completed 2026-02-06)
  - **Theme:** Distribution & Onboarding
  - **Priority:** 2 - Work second
  - **Notes:** Enhanced with author info, git config fallback, project type selection, transparency features; edge cases tracked in FEAT-112

- [x] **FEAT-011** - Trivial Sample Project
  - **Status:** Backlog
  - **Theme:** Distribution & Onboarding
  - **Priority:** 3 - Complete the MVP
  - **Notes:** Final piece of MVP - validates setup process and helps onboarding

**Sprint Notes:**
- MVP = Package to download (FEAT-005) + Script to set it up (FEAT-006) + Sample project to try (FEAT-011)
- License already exists (GPL-3.0) - review deferred to polish sprint
- System requirements documentation deferred to polish sprint
- Ready to release v5.1.0 with FEAT-005 + FEAT-006, then v5.2.0 after FEAT-011

---

## Sprint D&O 2 (Future) - Validation Tooling

**Goal:** Framework validation and testing infrastructure
**Status:** Future
**Items:** 2

### Committed Items

- [ ] **FEAT-007** - Framework Validation Script
  - **Status:** Backlog
  - **Theme:** Distribution & Onboarding
  - **Notes:** Validation sprint focus - ensures framework installation is correct

- [ ] **FEAT-051** - Framework Update Test Harness
  - **Status:** Backlog
  - **Theme:** Distribution & Onboarding
  - **Notes:** Testing infrastructure for validation/upgrade scenarios

**Sprint Notes:**
- Focus on tooling that validates framework installation and configuration
- Test harness supports both validation and upgrade testing
- Ensures users can verify their framework setup is correct

---

## Sprint D&O 3 (Future) - Upgrade Capability

**Goal:** Framework upgrade automation
**Status:** Future
**Items:** 1

### Committed Items

- [ ] **FEAT-008** - Upgrade Automation Script
  - **Status:** Backlog
  - **Theme:** Distribution & Onboarding
  - **Notes:** Upgrade sprint focus - automates framework version upgrades

**Sprint Notes:**
- Focus on enabling users to upgrade framework versions safely
- Critical for long-term framework maintenance and evolution
- Should preserve user customizations and project-specific content
- Leverages test harness from Sprint D&O 2

---

## Sprint D&O 4 (Future) - Polish

**Goal:** Documentation, community features, and refinement
**Status:** Future
**Items:** 10

### Committed Items

- [ ] **DECISION-029** - License Choice for Framework
  - **Status:** Backlog
  - **Theme:** Distribution & Onboarding
  - **Notes:** Review/confirm GPL-3.0 license (moved from Sprint D&O 1 - license already exists)

- [ ] **DECISION-035** - Root Status Reference Strategy
  - **Status:** Backlog
  - **Theme:** Distribution & Onboarding
  - **Notes:** Polish/documentation cleanup

- [ ] **FEAT-010** - Enterprise Framework Documentation
  - **Status:** Backlog
  - **Theme:** Distribution & Onboarding
  - **Notes:** Advanced use case documentation

- [ ] **FEAT-012** - CONTRIBUTING.md Guide
  - **Status:** Backlog
  - **Theme:** Distribution & Onboarding
  - **Notes:** Community/contribution polish

- [ ] **FEAT-013** - Migration Guide from Other Frameworks
  - **Status:** Backlog
  - **Theme:** Distribution & Onboarding
  - **Notes:** Advanced onboarding documentation

- [ ] **FEAT-014** - FAQ Document
  - **Status:** Backlog
  - **Theme:** Distribution & Onboarding
  - **Notes:** Documentation polish

- [ ] **FEAT-034** - Projects Showcase Documentation
  - **Status:** Backlog
  - **Theme:** Distribution & Onboarding
  - **Notes:** Community/adoption polish

- [ ] **FEAT-107** - System Requirements Documentation
  - **Status:** Backlog
  - **Theme:** Distribution & Onboarding
  - **Notes:** Documents environment requirements (moved from Sprint D&O 1 - polish/documentation work)

- [ ] **BUGFIX-045** - Complete Bash/Write/Edit Permissions
  - **Status:** Backlog
  - **Theme:** Distribution & Onboarding
  - **Notes:** Setup polish (blocked on VSCode extension)

- [ ] **FEAT-111** - Data-Driven Setup Script Questions
  - **Status:** Backlog
  - **Theme:** Distribution & Onboarding
  - **Notes:** Refactor setup script for maintainability and user customization
  - **Depends On:** FEAT-006

**Sprint Notes:**
- Focus on documentation completeness and community engagement
- Advanced features and use cases
- Final polish before wider release
- BUGFIX-045 may remain blocked depending on VSCode extension availability

### Considerations (Not Yet Committed)

**Setup Script UX Improvements:**
- Folder picker dialog for path selection (currently prompts lack tab completion)
- Would provide GUI alternative for users who prefer visual browsing
- Low priority - parameter-based invocation already supports tab completion
- Consider during sprint planning whether this warrants a work item

---

## Placement Decisions (RESOLVED)

All placement decisions have been resolved:

### ✅ BUG-109 - Starter Template project-hub Location
- **Decision:** Sprint D&O 0
- **Reasoning:** Foundational structure must be correct before building distribution artifacts

### ✅ FEAT-011 - Trivial Sample Project
- **Decision:** Sprint D&O 1
- **Reasoning:** Helps validate MVP distribution and setup process (completes the MVP)

### ✅ FEAT-051 - Framework Update Test Harness
- **Decision:** Sprint D&O 2
- **Reasoning:** Primarily supports validation, will be leveraged in D&O 3 for upgrade testing

### ✅ DECISION-029 - License Choice for Framework
- **Decision:** Moved from Sprint D&O 1 → Sprint D&O 4 (Polish) - 2026-02-06
- **Reasoning:** GPL-3.0 already in place; review/confirmation can wait for polish sprint

### ✅ FEAT-107 - System Requirements Documentation
- **Decision:** Moved from Sprint D&O 1 → Sprint D&O 4 (Polish) - 2026-02-06
- **Reasoning:** Documentation work; fits better with other docs in polish sprint; not blocking MVP

---

## Sprint Dependencies

```
D&O 0 (Prerequisites)
  ↓
D&O 1 (MVP Distribution) ← Must have BUG-109 fixed, DECISION-029 resolved
  ↓
D&O 2 (Validation) ← Requires working distribution package from D&O 1
  ↓
D&O 3 (Upgrade) ← Requires validation tooling from D&O 2
  ↓
D&O 4 (Polish) ← Requires stable upgrade capability from D&O 3
```

---

## Success Criteria by Sprint

### D&O 0
- ✅ Starter template has correct project-hub location
- ✅ Distribution prerequisites resolved

### D&O 1
- ✅ License chosen and documented
- ✅ ZIP distribution package created
- ✅ Interactive setup script functional
- ✅ System requirements documented
- ✅ User can download, extract, setup, and use framework

### D&O 2
- ✅ Validation script can verify framework installation
- ✅ Test harness available for framework testing
- ✅ Users can self-diagnose setup issues

### D&O 3
- ✅ Upgrade script can migrate between framework versions
- ✅ User customizations preserved during upgrades
- ✅ Upgrade process documented

### D&O 4
- ✅ Comprehensive documentation available
- ✅ Community contribution process documented
- ✅ Advanced use cases covered
- ✅ Framework ready for wider release

---

## Archived Items

### DECISION-036 - Template Access Strategy
- **Status:** Resolved by DECISION-050
- **Action Needed:** Should be archived
- **Notes:** No longer relevant to D&O sprints

---

## Notes

- This is a **living document** - update as sprint plans evolve
- Items may move between sprints based on capacity and dependencies
- Each sprint should focus on delivering a coherent, testable increment
- Consider user feedback from each sprint when planning the next

---

**Next Actions:**
1. Resolve BUG-109 placement decision
2. Begin Sprint D&O 0 work
3. Plan Sprint D&O 1 capacity and timeline
