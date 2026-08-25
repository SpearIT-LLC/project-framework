# Session History: 2026-08-25

**Date:** 2026-08-25
**Participants:** Gary Elliott, Claude Code
**Session Focus:** FEAT-193 — operations scaffold trim (first card of the ops pair)

---

## Summary

FEAT-193 implemented and closed: the operations scaffold is now `open/ onhold/
closed/ meetings/ agreements/ reference/`, with operations opting out of the shared
floor the way kb does. Three design clarifications recorded at the pre-implementation
review (changes, problems, cancelled) — the last one a genuine gap, resolved as a
`Resolution:` closure code rather than a folder.

---

## Work Completed

### FEAT-193: operations scaffold trim (todo → doing → done)

- **Pre-implementation review** presented the two-edit plan under the template
  architecture: the `operations/` overlay becomes the whole tree; the compose step
  skips the floor copy for operations (`[ "$TYPE" = "operations" ] || cp floor`).
  Card annotations: acceptance vocabulary is pre-TASK-197 (read application/kb/sow as
  product/project/kb); the Scope note's `FLOOR` variable describes the old script.
- **Gary's review questions → clarifications recorded on the card:**
  - *Changes:* a change to our own system/process is just another kanban card; a
    change to a customer system is their formal change-management process in their
    tool (e.g. ServiceNow) — the workspace holds at most a pointer.
  - *Problems:* "problem", "can't figure it out", "find and solve" are synonyms for
    **troubleshoot** — root-cause investigation is a troubleshooting case
    (`kb/<domain>/research/`, FEAT-202) linking the INCs it explains; the funded fix
    is a kanban item. A `problems/` folder would be a third, duplicate home.
  - *Cancelled (the gap):* no `cancelled/` folder. Location is the *flow* state;
    outcome is a field — `Resolution:` closure code (resolved | cancelled | duplicate
    | no-fault-found | rejected) + free-text reason, ITIL-style, prompted by
    FEAT-195's `→ closed` move treatment. The kanban's separate `archive/` exists only
    because `done/` feeds a release sweep cancelled items must not enter; ops
    `closed/` has no such fork. Recorded on FEAT-195 as a decision input.
- **Landed:** overlay `intake/*` removed, six-folder overlay added; script opts ops
  out of the floor; ADR-009 change-log entry (its only `intake` mention is OQ5's
  original settled text — superseded, not edited); CHANGELOG `[Unreleased]` entry.
- **Two implementation misses caught by verification:** (1) `git rm` removed the
  tracked `.gitkeep`s but left `intake/` as empty directories, so the first regen
  from the published copy still emitted `intake/` — `rmdir` fixed it; (2) a stray
  `None` under the CHANGELOG's Added heading. Both fixed before closing.
- **Verified from the published marketplace copy:** ops fixture regenerated (old one
  moved to scratchpad — the card's sanctioned one-time manual step; the script gains
  no delete behavior) and emits exactly the six folders + README; product/project/kb
  unchanged in a scratch root; refuse-if-exists intact. All acceptance and doc boxes
  checked; moved to done/.

---

## Current State

- **done/ (1):** FEAT-193
- **doing/:** empty
- **todo/ (5):** BUG-181, FEAT-163, FEAT-175, FEAT-195, TECH-177
- **Next:** `/fw-move 195 doing` — its review must resolve three open questions
  (sequence scope per prefix vs shared, record template home, closed-sweep trigger)
  plus the inputs it now carries: INC artifact bundles, the troubleshooting close
  gate, and the `Resolution:` closure code.

---

**Last Updated:** 2026-08-25
