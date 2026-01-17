# Session History: 2026-01-17

**Date:** 2026-01-17
**Participants:** Gary Elliott, Claude
**Session Focus:** FEAT-059 Roles System Testing (Session 3)
**Related Work:** FEAT-059, TECH-055, ADR-004, FEAT-062

---

## Summary

Continued testing of the context-aware AI roles system (FEAT-059). Validated several role behaviors, discovered gaps, and emerged with a new feature requirement (POC folder workflow). Created prototype move script during testing.

---

## Test Results

### FEAT-059 Role System Tests

| Test | Result | Notes |
|------|--------|-------|
| Bootstrap block - policy enforcement | ✅ Pass | AI correctly blocked invalid transition (backlog → doing) |
| Bootstrap block - session start prompt | ⚠️ Partial | Didn't fire automatically; needs explicit trigger |
| `requires_context` - subject_matter_expert | ✅ Pass | Prompted "What domain should I focus on?" |
| `requires_context` - compliance | ✅ Pass | Prompted "What regulatory framework applies?" |
| Variant trigger - developer.prototype | ✅ Pass | "Quick prototype" triggered variant adoption |
| Default role from framework.yaml | ✅ Pass | senior-architect respected |
| Extension-agnostic file queries | ❌ Gap found | Used `*.md` instead of `*` for WIP counting |

### Key Findings

1. **`requires_context` works well** - Both `subject_matter_expert` and `compliance` roles correctly prompted for domain clarification before activation.

2. **Variant triggers work** - "Let's do a quick prototype" triggered `developer.prototype` adoption with correct mindset.

3. **Extension-agnostic queries needed** - Discovered that `*.md` glob patterns miss `.yaml` and other file types. Work items can have multiple file types. Fixed in TECH-055.

4. **POC workflow gap identified** - Prototype variant created code outside tracking. Led to ADR-004 and FEAT-062.

---

## Work Completed

### Documentation Created
- **ADR-004:** POC Folder for Experiments - Documents decision to use `thoughts/poc/` for experiments
- **FEAT-062:** POC Folder and Spike Workflow - Work item to implement the feature (moved to todo)

### Code Created
- **Move-WorkItem.ps1:** Prototype script for moving work items through workflow
  - Validates transitions against matrix
  - Uses `git mv` for all `{TYPE-ID}-*` files (extension-agnostic)
  - Checks WIP limits
  - Location: `framework/scripts/Move-WorkItem.ps1`

### Updates Made
- **TECH-055:** Added extension-agnostic file pattern requirements, fixed WIP counting logic in design
- **ADR-004:** New decision record for poc/ folder

---

## Decisions Made

### ADR-004: POC Folder Location
- **Decision:** `thoughts/poc/` (sibling to work/ and research/)
- **Rationale:**
  - POCs don't follow kanban flow
  - Clear separation: research/ = documentation, poc/ = code experiments
  - No WIP limits for experimentation
  - Spikes archive to history/spikes/

### Extension-Agnostic Patterns
- **Decision:** All work item queries must use `{TYPE-ID}-*` not `{TYPE-ID}-*.md`
- **Rationale:** Work items can include .md, .yaml, .json, .ps1, .png, etc.

---

## Insights

### Research vs POC Distinction
Clarified the purpose of each folder:
- `research/` = Understanding & analysis (documentation, ADRs, landscape reviews)
- `poc/` = Proving & experimenting (code snippets, test harnesses, spike artifacts)

They often work together: research identifies approach → POC proves it works → formal implementation follows.

### Developer.prototype Workflow
Proposed workflow for prototype variant:
1. User says "let's prototype X"
2. AI adopts developer.prototype
3. AI asks: "Should I create a spike to track this experiment?"
4. Work happens in `thoughts/poc/SPIKE-XXX/`
5. Findings recorded, spike archived

---

## Items for Future Sessions

- [ ] Complete FEAT-059 testing (experience tier differences, mid-session context switch)
- [ ] Implement FEAT-062 (create poc/ folder, update workflow-guide.md, update roles.yaml)
- [ ] Test Move-WorkItem.ps1 script with real transitions
- [ ] Consider TECH-055 implementation (full validation script)

---

## Files Changed This Session

### Created
- `framework/thoughts/research/adr/004-poc-folder-for-experiments.md`
- `framework/thoughts/work/todo/FEAT-062-poc-folder-and-spike-workflow.md`
- `framework/scripts/Move-WorkItem.ps1`
- `framework/thoughts/history/2026-01-17-SESSION-HISTORY.md`

### Modified
- `framework/thoughts/work/backlog/TECH-055-work-item-move-validation-script.md`

---

**Session Duration:** ~2 hours
**Next Session:** Continue FEAT-059 testing or implement FEAT-062
