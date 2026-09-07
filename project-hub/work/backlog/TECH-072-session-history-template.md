# Tech Debt: Create Session History Template

**ID:** TECH-072
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-01-23
**Theme:** Workflow

---

## Summary

No session history template exists in `framework/templates/documentation/`. Users must create session histories from scratch or copy existing examples.

---

## Problem Statement

**What is the current state?**

- Session histories referenced in workflow documentation
- No template provided in `framework/templates/documentation/`
- Users must create format ad-hoc or find examples

**Why is this a problem?**

- Inconsistent session history format across projects
- New users don't know what to include
- Copy-paste from examples may include project-specific content

**What is the desired state?**

- Standard session history template
- Clear guidance on required vs optional sections
- Consistent format across all framework users

---

## Proposed Solution

Create `SESSION-HISTORY-TEMPLATE.md` in `framework/templates/documentation/`:

**Proposed Template Structure:**
```markdown
# Session History: YYYY-MM-DD

**Project:** {{PROJECT_NAME}}
**Date:** YYYY-MM-DD
**Duration:** [Start time] - [End time]

---

## Summary

[1-2 sentence summary of what was accomplished]

---

## Work Items Touched

| ID | Description | Status Change |
|----|-------------|---------------|
| FEAT-NNN | [Brief description] | todo → doing |
| BUG-NNN | [Brief description] | doing → done |

---

## Key Decisions

- [Decision 1 with brief rationale]
- [Decision 2 with brief rationale]

---

## Blockers / Open Questions

- [ ] [Blocker or question needing resolution]

---

## Next Session

- [ ] [First task for next session]
- [ ] [Second task for next session]

---

## Notes

[Any additional context for future reference]
```

**Files Created:**
- `framework/templates/documentation/SESSION-HISTORY-TEMPLATE.md`

---

## Acceptance Criteria

- [ ] Template created in framework/templates/documentation/
- [ ] Template includes all recommended sections
- [ ] NEW-PROJECT-CHECKLIST.md references template location

---

## Notes

Discovered during FEAT-025 validation testing. Session histories were created ad-hoc during testing in project-hello-world.

---

## Superseded by FEAT-222 (2026-09-07)

**Do not implement as written.** This card targets
`framework/templates/documentation/` — an old-framework path — and its premise ("no
standard exists") was overtaken: the 2026-09-07 review found **three** authored
session-history formats that disagree (this card's proposal being the third).

The format is now settled in the new ADR-009 build by **FEAT-222**, which closes this
card. The proposed structure above survives as *input* to that decision — in particular
its **Blockers / Open Questions** and **Next Session** sections, which the running
command lacks and which FEAT-222 must decide as core or optional.

---

## Related

- **FEAT-222** — session history in the new build. **Supersedes this card.**
- FEAT-025: Manual Setup Validation (source of finding)
- TECH-071: Session handoff checklist
