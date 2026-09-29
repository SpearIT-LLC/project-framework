# Task: The Process and Template Conventions (ex-TASK-223 Groups 3–4)

**ID:** TASK-257
**Type:** Task
**Priority:** Low
**Version Impact:** MINOR
**Created:** 2026-09-29
**Workspace:** framework
**Completed:**
**Theme:** Framework Consistency

---

## Summary

Six conventions for process and templates. They are not board conventions. Split out of
**TASK-223** on 2026-09-29. Gary set the kanban finish line to TASK-223's Groups 2 and 5
only, with Groups 3–4 "not board work and to be split into their own card"
(`project-hub/history/sessions/2026-09-29-SESSION-HISTORY.md`).

Same contract as TASK-223: for each convention, **decide it against the new build, give it
a mechanism, and close the source card.** A convention that is decided but only written in
prose is not finished (ADR-008 Root 2).

**Not on the kanban finish line.** Take a group when something needs it.

---

### Group 3: Process and collaboration

| Source | Convention to settle |
|---|---|
| TECH-070 | Issue-response process (triage → assess → decide → resolve) |
| TECH-070.1 | Its validation sub-task. Travels with TECH-070 |
| TECH-071 | Session handoff checklist. The new build has session history but no start/end checklist |
| TECH-049 | Human-AI concurrent-work handoff, especially around git operations |

### Group 4: Templates the new build lacks

| Source | Convention to settle |
|---|---|
| TECH-073 | External-reference template |
| FEAT-149 | Meeting-record standard, incl. AI-participant transparency. `meetings/` folders are scaffolded with nothing to put in them |

---

## Approach

The two groups are independent. For each convention:

1. **Decide it against the new build**, not the old one. The source card's analysis is
   input; its paths and file targets are not.
2. **Give it a mechanism**: a template, a template field, a script check, a hook, or an
   explicit statement that it is one of the rules that cannot be mechanized.
3. **Close the source card.** Record the outcome in it and move it to `done/`, or archive
   it with a closing note if it turned out to be superseded.

---

## Acceptance Criteria

- [ ] Each of the six has a recorded outcome: **defined** (with its mechanism),
      **decided-by-construction** (with the rationale written down), or **dropped** (with
      the reason)
- [ ] The two Group 4 templates exist in the new build, or are dropped with the reason
- [ ] Every source card is closed, moved to `done/`, or archived with a closing note.
      None is left open describing a convention that is now defined
- [ ] Plugin CHANGELOG updated

---

## Related

- **TASK-223**: the parent. Keeps Groups 2 and 5 (board lifecycle, the `fw-` rule), which
  are on the kanban finish line.
- **TASK-218** (done): its Section C6 holds the original per-card analysis.
- **ADR-008**: Root 2 is why every convention here needs a mechanism, not just a decision.
