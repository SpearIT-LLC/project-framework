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

**Last Updated:** 2026-01-14
