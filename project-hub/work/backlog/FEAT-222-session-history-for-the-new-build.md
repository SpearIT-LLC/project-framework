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

**Author fresh — which means read all three carefully, then decide.** "Fresh" is about
*authority*, not ignorance: the old formats hold no design authority over the new build,
but they are the best evidence available about what a session history needs — **88
session histories** written between 2025-12-19 and 2026-09-07 sit behind them (verified
2026-09-07). Read them, learn what each got right, and carry
forward what earns its place as a **justified decision** rather than an inherited
default. A carry-in is a `git mv` with the reason written down (ADR-008).

What must *not* happen is porting the old command as-is, or reconciling the three into a
fourth copy. The point of authoring in the new build is to end up with **one** source.

**Specifically worth learning from:**

- The **guide's** Blockers / Next Steps / Lessons Learned — the running command dropped
  all three, and practice has been quietly re-inventing "what's next" inside Current
  State ever since. That is evidence the guide was right about the need, whatever the
  verdict on the section names.
- The **command's** Files Created/Modified/Moved and Current State — these came from
  real use and are what every recent history actually contains.
- **TECH-072's** Work Items Touched status-change table — never implemented, but it is
  the only proposal that captures board movement as data rather than prose.
- **Practice itself** — the 2026-08-18 and 2026-09-03 histories are different shapes for
  different session types (design vs implementation). A format that only fits one of
  them will be worked around, as this session's file already demonstrates.

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

- [ ] `/fw-session-history` exists in the new build, authored (not ported), with one
      authored format
- [ ] Each of the three old formats has a recorded verdict — what it got right, what
      carries forward, what does not and why
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
- Gary, 2026-09-07, on an earlier draft of this card that leaned on the workspace
  boundary to justify not reading the old docs: *"How are we supposed to learn from what
  we did in the past and improve?"* Correct, and the card was wrong. ADR-009 rejected a
  fresh *repo* specifically so the ADRs, retrospectives and session logs stay live
  context — the failure it named was a settled decision being re-proposed because the
  record that rejected it is no longer loaded. The boundary is about **design
  authority** (the old structure does not dictate the new one), never about refusing to
  learn. `workspaces/framework/CLAUDE.md` was reworded the same day to say so.

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
