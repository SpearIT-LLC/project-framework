# Session History: 2026-01-14

**Date:** 2026-01-14
**Participants:** Gary Elliott, Claude (Opus 4.5)
**Focus:** FEAT-037 simplification, MVP schema finalization, test plan definition

---

## Session Overview

Reviewed FEAT-037 (project configuration file) and significantly simplified its scope. Removed multi-project complexity, established MVP schema with just 3 fields, resolved open design questions, and defined comprehensive test plan with explicit expected results.

---

## Key Decisions Made

### 1. Single-Project Only (Multi-Project Removed)

**Context:** Original FEAT-037 included complex multi-project repository support with `repository:` + `projects:` structure.

**User's Insight:** "Our 'framework source repo' is this project. We are providing some examples and templates but are those really projects anymore?"

**Decision:** Remove multi-project complexity entirely.
- Examples and templates are **artifacts** of the framework project, not separate projects
- Neither has active development, releases, or changelogs
- Single-project config is sufficient for all use cases

**Impact:** Document reduced from ~895 lines to ~320 lines (much more focused)

---

### 2. MVP Schema - Minimal Fields Only

**Decision:** Start with absolute minimum, validate it works, then extend.

**MVP Schema (3 fields):**
```yaml
# framework.yaml
project:
  name: "My Project"
  type: application  # framework | application | library | tool
  deliverable: code  # code | documentation | hybrid
```

**Deferred to Post-MVP:**
- `workflow:` section (workPath, wipLimits)
- `policies:` section (flat list of policy references)
- `categories:` section (work item type interpretations)

**Rationale:** Get infrastructure working first, add complexity with confidence later.

---

### 3. Design Question Resolutions

| Question | Decision | Rationale |
|----------|----------|-----------|
| Field naming | Nested (`project.type`) | Better organization as config grows |
| Policy organization | Flat list | Simple first, get it working |
| MVP fields | Project level only | Minimum viable, extend later |
| INDEX.md relationship | Keep separate | Out of scope for FEAT-037 |

---

### 4. CLAUDE.md Instruction Requirement

**Decision:** AI needs explicit instruction to read `framework.yaml`.

**Required instruction (to add to CLAUDE.md):**
```markdown
## Project Configuration

Read `framework.yaml` at the project root for machine-readable project context:
- `project.name` - Project name
- `project.type` - framework | application | library | tool
- `project.deliverable` - code | documentation | hybrid

Use these values to understand project context rather than inferring from structure.
```

**Validation requirement for FEAT-006:**
- Setup script should either auto-update CLAUDE.md OR provide copy/paste instruction
- `-check` flag (or separate script) should verify instruction exists
- Warn if `framework.yaml` exists but CLAUDE.md doesn't reference it

---

### 5. Test Plan Approach

**Decision:** Manual testing for MVP with explicitly defined expected results.

**User's guidance:** "Manual testing should be ok for this work item but a formal test should be defined. The manual test should have explicitly defined test expected results."

**Test cases defined:**
- T1-T5: Core functionality tests (reads name, type, deliverable, uses config over inference, fallback)
- E1-E3: Edge case tests (malformed YAML, missing fields, invalid values)

---

## FEAT-037 Document Changes

### Removed
- Multi-project repository structure (`repository:` + `projects:` list)
- Framework source repository context switching discussion (~90 lines)
- Complex YAML examples showing multi-project configs
- Open questions about multi-project support

### Added
- Simplified MVP schema (3 fields only)
- Design decisions table with dates
- CLAUDE.md instruction requirement section
- Comprehensive test plan with explicit expected results
- Future enhancements section (deferred items)
- Clear relationship to FEAT-006 documentation

### Updated
- Status: Backlog → Todo
- Implementation plan simplified to 3 phases
- Completion criteria split into MVP vs Future
- Examples focused on single-project scenarios

---

## Relationship to FEAT-006 (Setup Script)

**Clarified:**
- FEAT-037 defines WHAT `framework.yaml` looks like
- FEAT-006 implements HOW it gets created/populated

**User's insight on paths:** "An example yaml makes sense but depending on where the user copies the framework, it could have invalid paths. Perhaps the setup script should generate/update the paths."

**Documented in FEAT-037:**
- Setup script asks for project name, type, deliverable
- Generates `framework.yaml` with user values
- Handles path resolution for policy references (future)
- Should validate CLAUDE.md has required instruction

**FEAT-006 needs update:** Currently references v2.1.0 target version and lacks `framework.yaml` generation. Will be updated after FEAT-037 MVP is validated.

---

## Test Plan Summary

### Prerequisites
1. `framework.yaml` created at project root
2. CLAUDE.md contains instruction to read config
3. Fresh Claude session (no prior context)

### Core Test Cases

| ID | Test | Prompt | Expected Result |
|----|------|--------|-----------------|
| T1 | Reads project name | "What is this project called?" | Response includes name from config |
| T2 | Reads project type | "What type of project is this?" | Response identifies type from config |
| T3 | Reads deliverable | "What is the primary deliverable?" | Response identifies deliverable from config |
| T4 | Config over inference | "Is this a code project?" | Clarifies based on config, not structure |
| T5 | Missing config fallback | "What type of project is this?" | Infers from structure, doesn't error |

### Edge Case Tests

| ID | Test | Expected Result |
|----|------|-----------------|
| E1 | Malformed YAML | Reports error, falls back to inference |
| E2 | Missing required field | Uses available fields, notes missing data |
| E3 | Invalid enum value | Notes invalid value, asks or falls back |

---

## Implementation Ready

**FEAT-037 is now finalized with:**
1. ✅ Simplified single-project MVP schema
2. ✅ Design decisions documented with dates
3. ✅ CLAUDE.md instruction requirement specified
4. ✅ Test plan with explicit expected results
5. ✅ Relationship to FEAT-006 documented
6. ✅ Future enhancements captured but deferred

**Next steps (implementation):**
1. Create `framework.yaml` at project root
2. Add instruction to CLAUDE.md
3. Run through test cases in fresh session
4. Document results

---

## Key Insights

### 1. "Are Those Really Projects?"
User's question cut through complexity. Examples and templates are artifacts, not projects. Single-project config is sufficient.

### 2. MVP First, Extend Later
Starting with 3 fields and validating the infrastructure works is more valuable than designing comprehensive schema upfront.

### 3. Explicit Test Expected Results
User emphasized tests need explicit expected results, not vague "it works" criteria. Each test case now has specific prompt and expected response.

### 4. AI Instruction Discovery Problem
Key realization: Without explicit CLAUDE.md instruction, AI won't know to read `framework.yaml`. Setup script validation should catch this.

---

## Files Modified

- `framework/thoughts/work/todo/FEAT-037-project-config-file.md` - Complete rewrite with simplified scope

---

## Metrics

**Document reduction:** ~895 lines → ~320 lines (64% reduction)
**Open questions resolved:** 4 (field naming, policy org, MVP fields, INDEX.md)
**Test cases defined:** 8 (5 core + 3 edge cases)
**Design decisions documented:** 7 (with dates)

---

## Next Steps

**When ready to implement FEAT-037:**
1. Create `framework.yaml` for this framework project
2. Create example for templates
3. Update CLAUDE.md with instruction
4. Run test plan in fresh session
5. Document test results

**After FEAT-037 MVP validated:**
1. Update FEAT-006 to generate config
2. Add workflow section (Phase 2)
3. Add policies section (Phase 3)

---

**Session End Status:**
- FEAT-037: Finalized, ready for implementation
- FEAT-006: Noted for update after FEAT-037 MVP
- Test plan: Defined with explicit expected results
- Next action: Implementation when user ready

---

## Session 2: FEAT-037 Testing and File Location Fix

**Time:** Later on 2026-01-14
**Focus:** Running T1-T3 tests, discovering file location issue, fixing it

### Testing Began

Started running test cases T1-T3 with prompts:
- T1: "What is this project called?"
- T2: "What type of project is this?"
- T3: "What is the deliverable?"

### Key Discovery: File Location Problem

**Issue:** Claude answered correctly but got the information from the wrong source.

**What happened:**
- User had `FEAT-037-project-config-file.md` work item open in IDE
- Claude read the work item (which contained example configs) instead of reading `framework.yaml` directly
- Test T3 was answered correctly, but by "cheating" - reading examples from documentation rather than the actual config file

**Root cause identified:**
- `framework.yaml` was placed at `framework/framework.yaml` (framework subfolder)
- CLAUDE.md instruction was in `framework/CLAUDE.md` (framework subfolder)
- But root `CLAUDE.md` is what Claude Code loads automatically at session start
- The instruction to read `framework.yaml` was never seen unless Claude navigated to `framework/CLAUDE.md`

### Design Decision Clarification

**Original decision:** "Location | Project root (`framework.yaml`)"

**Problem:** "Project root" is ambiguous in this repo because:
- The repo has nested structure (framework is in a subfolder)
- For typical user projects, "project root" = "repo root"
- For this framework source repo, they're different

### Fix Applied

Moved both files to repo root:

1. **Created** `framework.yaml` at repo root
2. **Added** Project Configuration section to root `CLAUDE.md` (lines 9-16)
3. **Deleted** `framework/framework.yaml`
4. **Removed** redundant Project Configuration section from `framework/CLAUDE.md`
5. **Changed** wording from "project root" to "repo root" for clarity

### Files Modified

- `framework.yaml` - Created at repo root (moved from `framework/`)
- `CLAUDE.md` (root) - Added Project Configuration section
- `framework/CLAUDE.md` - Removed redundant Project Configuration section
- `framework/framework.yaml` - Deleted

### Test Status

- T1-T3: Need re-testing in fresh session after fix
- User will retest to validate the fix works

### Key Insight

**For framework source repo vs user projects:**
- User projects: `framework.yaml` and instruction both at project root (simple)
- Framework source repo: Must be at repo root, not in `framework/` subfolder
- The instruction in CLAUDE.md must be in the file that Claude Code auto-loads

---

**Session 2 End Status:**
- File location issue identified and fixed
- Ready for user to retest T1-T3 in fresh session
- Wording clarified: "repo root" instead of "project root"

---

## Session 3: Schema Creation and DRY Improvements

**Time:** Later on 2026-01-14
**Focus:** Eliminating duplication between CLAUDE.md and framework.yaml, creating schema file

### Problem Identified

User identified design issues with current approach:
1. CLAUDE.md listed valid enum values (`framework | application | library | tool`)
2. `framework.yaml` is the single source of truth for config values
3. What happens if yaml contains a value outside the list? (undefined behavior)
4. As parameters are added to framework.yaml, CLAUDE.md would need manual updates (duplication)

### Solution: Schema File

Created `framework/tools/framework-schema.yaml` as the single source of truth for:
- Valid field types
- Required/optional status
- Enum values and their descriptions
- Field descriptions and examples

### Changes Made

1. **Created** `framework/tools/framework-schema.yaml` - Schema definition with valid values
2. **Updated** `CLAUDE.md` - Now references schema file instead of listing values inline
3. **Updated** `FEAT-037` - Changed from "JSON Schema" to "YAML schema" approach

### Schema Structure

```yaml
schema:
  version: "1.0"
  description: "Schema for framework.yaml project configuration"

fields:
  project.name:
    type: string
    required: true
    description: "Human-readable project name"

  project.type:
    type: enum
    required: true
    values:
      framework: { description: "Process/methodology documentation" }
      application: { description: "Standalone software application" }
      library: { description: "Reusable code package" }
      tool: { description: "Utility script or CLI tool" }

  project.deliverable:
    type: enum
    required: true
    values:
      code: { description: "Primary output is source code" }
      documentation: { description: "Primary output is documentation" }
      hybrid: { description: "Both code and documentation" }
```

### First Schema Validation Test

Validated `framework.yaml` against schema:

| Field | Status |
|-------|--------|
| `project.name` | ✓ Valid |
| `project.type` | ✗ Missing (required) |
| `project.deliverable` | ✓ Valid |

**Result:** Schema validation caught missing `type` field. Added `type: framework` to fix.

This passes test case E2 (missing required field) - AI identified the issue and offered to fix.

### New Work Item Created

**FEAT-052: Framework YAML Validation Script** - Automate schema validation for CI/CD integration.

### Files Modified

- `framework/tools/framework-schema.yaml` - Created
- `CLAUDE.md` - Simplified to reference schema
- `framework/thoughts/work/doing/FEAT-037-project-config-file.md` - Updated for YAML schema
- `framework.yaml` - Added missing `type: framework` field
- `framework/thoughts/work/backlog/FEAT-052-framework-yaml-validation-script.md` - Created

### Test Status Update

- E2: Missing required field - PASS (AI identified missing `project.type` and offered to fix)

---

**Session 3 End Status:**
- Schema file created, eliminating duplication
- CLAUDE.md simplified
- framework.yaml now valid against schema
- E2 test passed
- E3 (invalid enum value) remaining

---

## Session 4: Final Testing and MVP Completion

**Time:** Later on 2026-01-14
**Focus:** E3 edge case test, MVP completion, archival

### E3 Test Execution

**Test:** Invalid enum value detection

**Setup:** `framework.yaml` set with `type: banana` (invalid value)

**Prompt:** "What type of project is this?"

**Result:** PASS
- AI read `framework.yaml` and detected `type: banana`
- AI read schema and identified valid values: `framework`, `application`, `library`, `tool`
- AI reported validation error with table showing invalid field
- AI offered to fix with correct value (`framework`)

### All Tests Complete

| Test | Status |
|------|--------|
| T1: Project name | ✅ PASS |
| T2: Project type | ✅ PASS |
| T3: Deliverable | ✅ PASS |
| T4: Config over inference | ✅ PASS |
| T5: Missing config fallback | ✅ PASS |
| E1: Malformed YAML | ✅ PASS |
| E2: Missing required field | ✅ PASS |
| E3: Invalid enum value | ✅ PASS |

### MVP Completion

All completion criteria met:
- [x] `framework.yaml` schema defined
- [x] Config created for this framework project
- [x] Config created for examples/hello-world
- [x] Example config added to templates
- [x] AI successfully reads and uses config
- [x] CLAUDE.md updated to reference config

### Work Item Archived

- Updated status from "In Progress" to "Completed"
- Moved from `doing/` to `done/`
- `framework.yaml` corrected to `type: framework` (valid value)

### Remaining Future Work

Captured in FEAT-037 "Future" section (separate work items):
- [ ] Workflow section added
- [ ] Policies section added
- [ ] FEAT-006 integration complete

---

**Session 4 End Status:**
- All 8 tests passed
- MVP complete
- FEAT-037 archived to `done/`
- `framework.yaml` validated and corrected

---

## Session 5: Workflow Section Cancellation

**Time:** Later on 2026-01-14
**Focus:** Reviewing future enhancements, cancelling redundant workflow section

### Discussion: Workflow vs Policies

Reviewed the proposed `workflow:` and `policies:` sections from FEAT-037 future enhancements.

**Key observations:**
- `workflow:` would contain `workPath` and `wipLimits`
- `.limit` files already exist and handle WIP limits throughout the framework
- `workPath` is convention-based (`thoughts/work/`) - no config needed
- Workflow could be considered a type of policy, creating conceptual overlap

### Decision: Cancel Workflow Section

**Rationale:** No value added over existing mechanisms:
- `.limit` files handle WIP constraints
- Path conventions are established
- Adding `workflow:` to config would duplicate existing functionality

**Updated FEAT-037:** Marked workflow section as CANCELLED with reason documented.

### Remaining Future Work

- [ ] Policies section added (document references for AI guidance)
- [ ] FEAT-006 integration complete

---

**Session 5 End Status:**
- Workflow section cancelled (redundant)
- Policies section remains as valid future enhancement
- FEAT-037 updated with cancellation reason

---

## Session 6: Workflow Documentation Review and Policy Gap

**Time:** Later on 2026-01-14
**Focus:** Duplicate workflow docs, completion criteria policy gap

### Duplicate Workflow Documentation Discovered

Identified two documents defining the same workflow with ~40% overlap:

| Document | Location | Lines |
|----------|----------|-------|
| `workflow-guide.md` | `collaboration/` | ~1420 |
| `kanban-workflow.md` | `process/` | ~420 |

**Decision:** Consolidate into single file (`workflow-guide.md`)

**Created:** TECH-056 to track consolidation work

### FEAT-037 Premature Move to done/

**Issue:** AI moved FEAT-037 from `doing/` to `done/` when user said "MVP is complete", without verifying all completion criteria.

**Root cause:** Policy gap — no explicit rule requiring:
1. All checkboxes in "Completion Criteria" checked before moving to `done/`
2. Clear distinction between in-scope vs future/out-of-scope items

**Fix:** Moved FEAT-037 back to `doing/` (open items remain: policies section, FEAT-006 integration)

### Policy Gap Documented

Updated DOC-054 (workflow state transition rules) to include:
- New pre-flight check #6: "Completion criteria met (doing→done only)"
- New "Completion Criteria Validation" section with explicit rules
- Reference to this gap discovery
- Cross-reference to TECH-056

Updated TECH-056 to reference DOC-054 (should be done together)

### Work Items Created/Updated

**Created:**
- TECH-056: Consolidate workflow documentation

**Updated:**
- DOC-054: Added completion criteria validation rule, referenced TECH-056
- TECH-056: Referenced DOC-054

---

**Session 6 End Status:**
- Duplicate workflow docs identified, TECH-056 created
- FEAT-037 moved back to `doing/` (premature move)
- Policy gap documented in DOC-054
- Both DOC-054 and TECH-056 cross-referenced

---

**Last Updated:** 2026-01-14
