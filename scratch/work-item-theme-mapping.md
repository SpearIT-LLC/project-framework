# Work Item Theme & Planning Period Mapping

**Created:** 2026-02-05
**Purpose:** Plan the addition of Theme and Planning Period fields to all open work items

---

## The Four Themes

Per the ROADMAP (framework/docs/project/ROADMAP.md), the framework has four stable themes:

1. **Distribution & Onboarding** - Packaging, installation, setup automation, first-time user experience
2. **Workflow** - File-based Kanban workflow, templates, documentation, skill commands, work item lifecycle
3. **Project Guidance** - AI-guided strategic/planning level guidance (PM/Scrum Master role)
4. **Developer Guidance** - AI-guided tactical/implementation level guidance (Senior Developer/Tester role)

---

## Current Planning Periods

- **Sprint D&O 0** (Current) - Prerequisites for distribution work
- **Sprint D&O 1** (Next) - MVP distribution package and setup process
- **Sprint D&O 2** (Future) - Validation tooling
- **Sprint D&O 3** (Future) - Upgrade capability
- **Sprint D&O 4** (Future) - Polish
- **Sprint PG 1** (Future) - Project Guidance MVP
- **Sprint WF 1+** (Future, not yet defined) - Workflow enhancements
- **Sprint DG 1+** (Future, not yet defined) - Developer Guidance

---

## Work Items in TODO/DOING (5 items)

| Work Item ID | Description | Current Theme | Proposed Theme | Proposed Planning Period | Notes |
|--------------|-------------|---------------|----------------|--------------------------|-------|
| **FEAT-092** | Optional Sprint Support | "Developer Guidance & Patterns" | **Project Guidance** | Sprint PG 1 | Sprint support is strategic/planning guidance, not tactical dev guidance |
| **FEAT-093** | Planning Period Archival System | "Workflow Enhancements" | **Workflow** | Sprint WF 1 | Workflow lifecycle and organization enhancement |
| **TECH-070** | Issue Response Process | _(none)_ | **Workflow** | Sprint WF 1 | Version control workflow and process documentation |
| **TECH-070.1** | Validate Issue Response Process | _(none)_ | **Workflow** | Sprint WF 1 | Validation for parent TECH-070 |
| **BUG-109** | Starter Template project-hub Location | "DECISION-037 Cleanup" | **Distribution & Onboarding** | Sprint D&O 0 or D&O 1 | Critical bug affecting new project setup; blocks distribution work |

---

## Backlog Items by Theme (57 items)

### Distribution & Onboarding (17 items)

| Work Item ID | Description | Proposed Theme | Proposed Planning Period | Notes |
|--------------|-------------|----------------|--------------------------|-------|
| **DECISION-029** | License Choice for Framework | Distribution & Onboarding | Sprint D&O 1 | Foundation for public distribution |
| **DECISION-035** | Root Status Reference Strategy | Distribution & Onboarding | Sprint D&O 4 | Polish/documentation cleanup |
| **DECISION-036** | Template Access Strategy | Distribution & Onboarding | _(Resolved by DECISION-050)_ | Consider archiving |
| **FEAT-005** | ZIP Distribution Package | Distribution & Onboarding | Sprint D&O 1 | Core MVP distribution artifact |
| **FEAT-006** | Interactive Setup Script | Distribution & Onboarding | Sprint D&O 1 | Core MVP setup experience |
| **FEAT-007** | Framework Validation Script | Distribution & Onboarding | Sprint D&O 2 | Validation sprint focus |
| **FEAT-008** | Upgrade Automation Script | Distribution & Onboarding | Sprint D&O 3 | Upgrade sprint focus |
| **FEAT-010** | Enterprise Framework Documentation | Distribution & Onboarding | Sprint D&O 4 | Advanced use case documentation |
| **FEAT-011** | Trivial Sample Project | Distribution & Onboarding | Sprint D&O 1 or D&O 4 | Helps onboarding, could be MVP or polish |
| **FEAT-012** | CONTRIBUTING.md Guide | Distribution & Onboarding | Sprint D&O 4 | Community/contribution polish |
| **FEAT-013** | Migration Guide from Other Frameworks | Distribution & Onboarding | Sprint D&O 4 | Advanced onboarding documentation |
| **FEAT-014** | FAQ Document | Distribution & Onboarding | Sprint D&O 4 | Documentation polish |
| **FEAT-034** | Projects Showcase Documentation | Distribution & Onboarding | Sprint D&O 4 | Community/adoption polish |
| **FEAT-051** | Framework Update Test Harness | Distribution & Onboarding | Sprint D&O 2 or D&O 3 | Testing infrastructure for validation/upgrade |
| **FEAT-107** | System Requirements Documentation | Distribution & Onboarding | Sprint D&O 1 | Already committed to roadmap |
| **BUG-109** | Starter Template project-hub Location | Distribution & Onboarding | Sprint D&O 0 or D&O 1 | Critical structural fix |
| **BUGFIX-045** | Complete Bash/Write/Edit Permissions | Distribution & Onboarding | Sprint D&O 4 | Setup polish (blocked on VSCode extension) |

### Workflow (30 items)

| Work Item ID | Description | Proposed Theme | Proposed Planning Period | Notes |
|--------------|-------------|----------------|--------------------------|-------|
| **DECISION-097** | Release Sizing Policy | Workflow | Sprint WF 1 | Release process policy |
| **FEAT-019** | Release Checklist Template | Workflow | Sprint WF 1 | Release workflow enhancement |
| **FEAT-021** | Work Item Numbering Standards | Workflow | Sprint WF 1 | Core workflow policy |
| **FEAT-024** | Renumber Workflow Steps Sequential | Workflow | Sprint WF 1 | Documentation cleanup |
| **FEAT-028** | Release Automation Script | Workflow | Sprint WF 1 | Release process automation |
| **FEAT-030** | Add work/hold/ Folder | Workflow | Sprint WF 1 | Workflow structure enhancement |
| **FEAT-047** | Small Team ID Collision Support | Workflow | Sprint WF 2 | Multi-user workflow (future) |
| **FEAT-093** | Planning Period Archival System | Workflow | Sprint WF 1 | Roadmap/history management |
| **FEAT-099** | /fw-release Command | Workflow | Sprint WF 1 | Release automation |
| **FEAT-104** | Velocity Tracking | Workflow | Sprint WF 2 | Advanced planning metrics |
| **TECH-027** | Cross-Reference Convention | Workflow | Sprint WF 1 | Work item policy |
| **TECH-033** | Status Field Redundancy Review | Workflow | Sprint WF 1 | Work item structure review |
| **TECH-041** | Supporting Files Naming Policy | Workflow | Sprint WF 1 | Work item artifacts policy |
| **TECH-044** | Work Item Creation Policy | Workflow | Sprint WF 1 | Work item policy |
| **TECH-048** | Remove Team References | Workflow | Sprint WF 1 | Documentation cleanup (solo focus) |
| **TECH-049** | Human-AI Work Handoff Policy | Workflow | Sprint WF 2 | Collaboration patterns |
| **TECH-055** | Work Item Move Validation Script | Workflow | Sprint WF 1 | Workflow automation |
| **TECH-058** | Documentation DRY Cleanup | Workflow | Sprint WF 1 | Documentation refactoring |
| **TECH-067** | Consolidate AI sections | Workflow | Sprint WF 1 | Documentation organization |
| **TECH-102** | Slash Command Performance | Workflow | Sprint WF 2 | Command optimization |
| **TECH-070** | Issue Response Process | Workflow | Sprint WF 1 | Already in TODO |
| **TECH-070.1** | Validate Issue Response Process | Workflow | Sprint WF 1 | Already in TODO |
| **TECH-071** | Session Handoff Checklist | Workflow | Sprint WF 2 | AI collaboration patterns |
| **TECH-072** | Session History Template | Workflow | Sprint WF 2 | Documentation template |
| **TECH-073** | External Reference Template | Workflow | Sprint WF 1 | Documentation template |
| **TECH-077** | "Never Delete" Policy | Workflow | Sprint WF 1 | Work item lifecycle policy |
| **TECH-078** | Release Archival Process | Workflow | Sprint WF 1 | Release workflow policy |
| **TECH-079** | Empty Release Guard | Workflow | Sprint WF 1 | Release workflow safeguard |
| **TECH-080** | Release Session History | Workflow | Sprint WF 1 | Release documentation |
| **TECH-082** | Sub-Task/Parent Pattern | Workflow | Sprint WF 1 | Work item hierarchy pattern |
| **TECH-096** | Enforce Policies Manual Operations | Workflow | Sprint WF 2 | Workflow enforcement |
| **TECH-097** | Document Artifacts Pattern | Workflow | Sprint WF 1 | Work item artifacts pattern |
| **TECH-098** | Auto-Branching Strategy | Workflow | Sprint WF 2 | Git integration |
| **TECH-100** | Split workflow-guide.md | Workflow | Sprint WF 1 | Documentation organization |
| **TECH-101** | Project Definition SsoT Pattern | Workflow | Sprint WF 1 | Documentation pattern |

### Project Guidance (6 items)

| Work Item ID | Description | Proposed Theme | Proposed Planning Period | Notes |
|--------------|-------------|----------------|--------------------------|-------|
| **FEAT-015** | Executive Summary Reporting | Project Guidance | Sprint PG 1 | Project-level reporting |
| **FEAT-052** | Task-Based Project Templates | Project Guidance | Sprint PG 1 | Project planning approach |
| **FEAT-089** | Project Type Patterns | Project Guidance | Sprint PG 1 | Strategic guidance patterns |
| **FEAT-092** | Optional Sprint Support | Project Guidance | Sprint PG 1 | Already in TODO |
| **FEAT-102** | Create project-guide.md | Project Guidance | Sprint PG 1 | Project guidance documentation |
| **TECH-083** | Model Selection Guidance | Project Guidance | Sprint PG 1 | Setup/planning guidance |

### Developer Guidance (4 items)

| Work Item ID | Description | Proposed Theme | Proposed Planning Period | Notes |
|--------------|-------------|----------------|--------------------------|-------|
| **FEAT-004** | Visual Diagrams | Developer Guidance | Sprint DG 1 | Developer understanding aids |
| **FEAT-009** | Stale Documentation Checker | Developer Guidance | Sprint DG 1 | Documentation tooling |
| **FEAT-090** | Coding Strategy Patterns | Developer Guidance | Sprint DG 1 | Development methodology guidance |
| **FEAT-103** | Create developer-guide.md | Developer Guidance | Sprint DG 1 | Developer guidance documentation |

---

## Summary Statistics

**Total Work Items:** 62
- TODO/DOING: 5 items
- Backlog: 57 items

**By Theme:**
- Distribution & Onboarding: 17 items (27%)
- Workflow: 30 items (48%)
- Project Guidance: 6 items (10%)
- Developer Guidance: 4 items (6%)

**Items Currently Assigned to Planning Periods:**
- Sprint D&O 0: 1 item (BUG-109, pending decision)
- Sprint D&O 1: 1 item committed (FEAT-107) + 4 proposed
- All others: Proposed assignments to future sprints

**Critical Issues:**
- **DECISION-036 Resolution:** Marked as resolved by DECISION-050, should be archived

---

## Recommendations

### BUG-109 Priority Decision Needed

**Question:** Should BUG-109 be Sprint D&O 0 or D&O 1?

**Sprint D&O 0 Arguments:**
- Critical bug affecting project structure
- Blocks creation of correct distribution package
- DECISION-037 prerequisite completion
- Currently in Sprint D&O 0 timeframe

**Sprint D&O 1 Arguments:**
- Sprint D&O 0 is focused on decisions and documentation
- Distribution package work happens in D&O 1
- Bug fix ensures D&O 1 starts with correct structure

**Recommendation:** **Sprint D&O 0** - This is foundational structure that must be correct before building distribution artifacts.

### Theme Corrections Needed

1. **FEAT-092:** Change "Developer Guidance & Patterns" → "Project Guidance"
2. **BUG-109:** Change "DECISION-037 Cleanup" → "Distribution & Onboarding"

### New Planning Period Definition Needed

The workflow-related items (FEAT-093, TECH-070, TECH-070.1) reference "Sprint WF 1" which doesn't exist in the ROADMAP yet. We should either:

1. **Define Sprint WF 1** in the ROADMAP Future Planning Periods section
2. **Leave as TBD** and assign planning periods during Sprint D&O 4 planning
3. **Mark as "Future Considerations"** until workflow theme gets prioritized

**Recommendation:** **Leave as "TBD"** until Distribution & Onboarding sprints complete. The workflow items aren't blocking current work.

---

## Implementation Approach

### Phase 1: Foundation (Immediate)
- [ ] Add Theme field to work item templates (if not already present)
- [ ] Add Planning Period field to work item templates (if not already present)
- [x] Resolve TECH-067 duplicate ID conflict (Renumbered to TECH-102)
- [ ] Archive DECISION-036 (resolved by DECISION-050)
- [ ] Verify framework.yaml includes theme definitions

### Phase 2: TODO/DOING Items (Sprint D&O 0)
- [ ] Update FEAT-092: Theme = "Project Guidance", Planning Period = "Sprint PG 1"
- [ ] Update FEAT-093: Theme = "Workflow", Planning Period = "TBD (Sprint WF 1)"
- [ ] Update TECH-070: Theme = "Workflow", Planning Period = "TBD (Sprint WF 1)"
- [ ] Update TECH-070.1: Theme = "Workflow", Planning Period = "TBD (Sprint WF 1)"
- [ ] Update BUG-109: Theme = "Distribution & Onboarding", Planning Period = _[TBD: D&O 0 or D&O 1]_

### Phase 3: Backlog Items (Batch Update)
- [ ] Update 17 Distribution & Onboarding items with Theme + proposed Planning Period
- [ ] Update 30 Workflow items with Theme + proposed Planning Period
- [ ] Update 5 Project Guidance items with Theme + proposed Planning Period
- [ ] Update 4 Developer Guidance items with Theme + proposed Planning Period

### Phase 4: Tooling Updates
- [ ] Update /fw-status to display theme groupings
- [ ] Update /fw-backlog to filter by theme
- [ ] Update /fw-roadmap to show work items by theme
- [ ] Consider adding /fw-theme command for theme-based queries

---

## Critical Decisions Required

### 1. BUG-109 Planning Period Assignment
**Question:** Should BUG-109 be Sprint D&O 0 or D&O 1?

**Recommendation:** **Sprint D&O 0** - Foundational structure must be correct before building distribution artifacts.

### 2. TECH-067 Duplicate ID Resolution ✅ RESOLVED
**Problem:** Two work items shared TECH-067:
- TECH-067: Consolidate AI sections into workflow-guide.md
- TECH-067: Slash Command Performance Optimization (DUPLICATE)

**Resolution:** Renumbered Slash Command Performance Optimization to **TECH-102**.

### 3. Planning Period Definition Strategy
**Question:** Should we define Sprint WF 1, Sprint PG 1, Sprint DG 1 in ROADMAP now, or defer?

**Options:**
1. **Define all now** - Complete planning period structure
2. **Define Sprint WF 1 only** - Most items (30) need it
3. **Defer all** - Focus on D&O sprints, define others when D&O 4 completes

**Recommendation:** **Defer all except Sprint WF 1** - Sprint WF 1 should be defined because it has 30 items and provides clarity for workflow improvements. PG/DG sprints can wait until D&O series completes.

### 4. Planning Period Field Semantics
**Question:** What values are allowed for Planning Period field?

**Options:**
1. **Required sprint name** (e.g., "Sprint D&O 1")
2. **Optional with TBD** (e.g., blank, "TBD", "Sprint WF 1")
3. **Structured with status** (e.g., "Sprint D&O 1 (Planned)", "TBD - Sprint WF 1")

**Recommendation:** **Optional with TBD** - Allow blank for true backlog items, "TBD - Sprint X" for proposed assignments, explicit sprint names for committed work.

---

## Questions for Discussion

1. Should BUG-109 be Sprint D&O 0 or D&O 1?
2. ~~How should we resolve the TECH-067 duplicate ID?~~ ✅ RESOLVED - Renumbered to TECH-102
3. Should we define Sprint WF 1 in the ROADMAP now, or defer all non-D&O sprints?
4. Should we define Sprint PG 1 and Sprint DG 1 now, or wait until after D&O series?
5. Do we need a Planning Period value convention (blank vs "TBD" vs "TBD - Sprint X")?
6. Should theme be required for all work items, or optional?
7. Should we archive DECISION-036 since it's marked as resolved?
8. Should we batch-update all backlog items now, or incrementally as they move to TODO?

---

## Next Steps

### Immediate Actions
1. Review this mapping and answer critical decisions
2. ~~Resolve TECH-067 duplicate ID conflict~~ ✅ DONE (Renumbered to TECH-102)
3. Add Theme and Planning Period fields to work item templates
4. Update TODO/DOING items (5 items) with themes

### Sprint D&O 0 Actions
5. Fix BUG-109 and assign to Sprint D&O 0 or D&O 1
6. Define Sprint WF 1 in ROADMAP (if decision made to do so)
7. Plan batch update approach for 57 backlog items

### Sprint D&O 1+ Actions
8. Implement tooling updates (/fw-status, /fw-backlog theme filtering)
9. Execute batch update of backlog items by theme
10. Validate all work items have appropriate theme assignments

