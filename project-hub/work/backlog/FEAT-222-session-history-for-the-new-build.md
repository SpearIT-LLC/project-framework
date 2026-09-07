# Feature: Session History in the New Build — One Authored Format

**ID:** FEAT-222
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-09-07
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Workflow

---

## Summary

The ADR-009 build ships **no session-history command**. Build one — and settle the
format while building it, because the old repo carries **three** authored formats that
disagree. Do not migrate the old command; author one source in the new build and let the
old copies die with the old framework.

---

## Problem Statement

**What is the current state?**

`workspaces/framework/commands/` holds five commands (`fw-contacts`, `fw-move`,
`fw-new-kb-domain`, `fw-new-ops-record`, `fw-new-workspace`). Session history is not
among them, though the new build has been producing session histories all along — onto
the *old* repo's board, using the *old* repo's command.

**Three formats, all authored, all disagreeing** (verified 2026-09-07):

| Source | Sections it specifies |
|---|---|
| `framework/docs/collaboration/workflow-guide.md#session-history` — the `sources:` source of truth | Summary, Work Completed, Decisions Made, **Blockers Encountered**, **Next Steps**, **Lessons Learned**; a **Duration** field; location `project-hub/history/` |
| `.claude/commands/fw-session-history.md` — what actually runs | Summary, Work Completed, Decisions Made, **Files Modified/Created/Moved**, **Current State**. No Blockers, no Next Steps, no Duration |
| `TECH-072` (backlog) — a third proposal | **Work Items Touched** as a status-change table, **Blockers / Open Questions**, **Next Session**, **Notes**; a `{{PROJECT_NAME}}` field |

Practice follows the *command*, not the guide. The guide's stated location
(`project-hub/history/`) is also wrong — actual is `project-hub/history/sessions/`.

**Why is this a problem?**

This is textbook ADR-008 drift: one concept, three authored copies, silently diverged
until someone reads two of them. It has already produced a live cost — on 2026-09-07 the
AI removed a "Next Session" section for being non-template, while the guide *and*
TECH-072 both call for exactly that section. No one can follow all three.

**What is the desired state?**

One authored format in the new build, enforced where enforcement is possible, with the
old copies retired rather than reconciled.

---

## Proposed Solution

**Author fresh; do not port.** Per this workspace's `CLAUDE.md`, the old framework's
docs *"are out of scope here: never read them as guidance for this workspace's design."*
The three formats above are **input evidence about a known problem**, not a design to
copy. Carry-ins are moves, justified in writing at the time (ADR-008).

### The format question to settle

Gary, 2026-09-07: *"I do want to keep the template format at a minimum for consistency.
An added section is ok if we have a good reason."* That is the governing rule and it
should be written into the command itself, not left as an oral convention:

- **A required core** — every session history has these, in this order.
- **Optional sections, permitted with a stated reason.** The 2026-09-07 history is the
  worked example: it carries *The Journey* (a design session with no code — the
  reasoning was the work product) and *Open Questions* (unresolved, so they fit neither
  Decisions Made nor Current State), each justified in a one-line block quote inside the
  file so the reason travels with it.

**Candidate core** (from what practice actually converged on, to be confirmed):
Summary → Work Completed → Decisions Made → Files Created/Modified/Moved → Current State.

**Open questions for the review:**

1. **Are `Blockers` and `Next Steps` core or optional?** The guide and TECH-072 both
   want them; the running command has neither, and practice folds "what's next" into
   Current State. Recommendation: optional — a session with no blockers should not carry
   an empty heading — but this is the specific disagreement that must be decided, not
   inherited.
2. **`Duration` / `Participants`** — the guide asks for Duration, practice records
   Participants. Keep either?
3. **How is "a good reason" enforced?** A required justification line under any
   non-core heading is checkable by script; the *quality* of the reason is not. Say
   which half is mechanized (ADR-008: an invariant in prose is not a guardrail).
4. **Does the append-only principle survive as-is?** Both existing copies state it and
   practice honours it (2026-08-18 has six "(Continuation)" sections). It looks correct
   — confirm and carry it.

### Retirement, not reconciliation

The old guide section and old command are **not** edited to match. They belong to the
old framework, which is in maintenance and retires at graduation. Fixing all three would
create a fourth thing to keep in sync — the exact failure this card exists to end.

**TECH-072 closes with this card** as decided-elsewhere: it asks for a session-history
*template* in `framework/templates/documentation/` — an old-framework path, and its
premise (no standard exists) is superseded by settling the format here.

---

## Files Affected

- `workspaces/framework/commands/fw-session-history.md` — new
- `workspaces/framework/templates/records/` — a session-history template, if the format
  warrants a file rather than living in the command (decide at review; the new build
  keeps record shapes in `templates/records/`)
- `workspaces/framework/scripts/` — only if a check is mechanized (see open question 3)
- `workspaces/framework/CHANGELOG.md`
- `project-hub/work/backlog/TECH-072-session-history-template.md` — closed by this card

---

## Acceptance Criteria

- [ ] `/fw-session-history` exists in the new build and produces a history without
      reading any old-framework doc
- [ ] Exactly one authored format; the command is its home (or points at one template —
      never both)
- [ ] The core/optional rule is stated in the command, including that an optional
      section carries its justification inline
- [ ] Open questions 1–4 each have a recorded outcome
- [ ] Append-only principle carried forward and stated
- [ ] TECH-072 closed with a note pointing here
- [ ] Verified against the **built plugin**, not this source tree
- [ ] CHANGELOG updated

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED** — settle the four open questions first
- [ ] Author the format (core + optional rule)
- [ ] Author `fw-session-history.md` in the new build's command style
- [ ] Mechanize whatever part of the rule is checkable
- [ ] Verify against the built plugin
- [ ] Close TECH-072
- [ ] CHANGELOG

---

## Notes

- Gary, 2026-09-07: *"I see we haven't migrated the session-history command to the new
  framework yet. Let's fix it in the new command."* — the decision to fix forward in the
  new build rather than reconcile the old copies.
- Found while asking why the 2026-09-07 history deviated from the template. The answer
  turned out to be that there is no single template to deviate from.
- The 2026-09-07 session history is the best available worked example of the
  core+justified-optional shape; use it as the reference when authoring, but re-derive
  the format rather than transcribing it.

---

## Related

- **TECH-072** — session history template (old-framework path). **Closed by this card.**
- **TECH-071** — session handoff checklist; adjacent, owned by TASK-219 Group 3
- **TASK-219** — board conventions for the new build; this is the same class of work
  (a convention the new build lacks) but is a command, not a board convention
- **ADR-008** — the single-source rule this card restores
- **ADR-009 D3** — the framework IS the plugin; only plugin content ships
- `project-hub/history/sessions/2026-09-07-SESSION-HISTORY.md` — worked example

---

**Last Updated:** 2026-09-07
