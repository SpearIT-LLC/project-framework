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
## FEAT-195: Operations Records + the New Build's Move Engine (Continued)

**Scope reality surfaced at review:** the card said "adapt the existing next-id and
fw-move" — but those are the *old* root engine serving the live board (ADR-009 D5);
the new build had no engine at all (graduation criterion #3). So FEAT-195 became the
first slice of the new build's engine. Gary's direction: *"the same script with
different inputs or an internal toggle to look in kanban/ or operations/"* → **one
namespace-aware engine per function**, only the operations policy populated now; the
kanban slot fills at board crossover by carrying the root `fw-move.sh` logic in.

**Decisions (Gary):** shared sequence per ops workspace (kanban precedent — a bare id
is unambiguous); template ships in the plugin with `.claude/templates/` override;
sweep = on-demand year buckets (`closed/YYYY/`), after asking what sweep is for —
answer: keep flat `closed/` to "this year"; nothing deleted, no status change. Gary's
observation that the year folder matches the kanban's sub-folder concept became the
engine's stated rule: **status is the first path segment under a namespace root;
anything deeper (buckets, bundles, children) is grouping, never status** — the
recursive scan makes ops and kanban one mechanism.

**Landed (plugin):** `templates/records/ops-record.md`; `fw-next-id.sh <namespace>`
(THE home for next-id logic — max over records *and* bundles, recursive);
`fw-new-ops-record.sh <inc|req> <slug>` (the create gate — FEAT-175's lesson applied
to ops from day one); `fw-move.sh` (ops policy `open ↔ onhold → closed`, closed
terminal, `--resolution` required and validated, `Closed:`/`Resolution:` stamped,
`INC-nnn/` bundle travels, `sweep`; kanban prefixes refused with a pointer to the root
`/fw-move` until crossover). Command docs for create and move (the `→ closed` step
carries the FEAT-202 distillation prompt), CHANGELOG entry. Out of scope: surfacing
ops records in a status view (no new-build status command yet — FEAT-163/196).

**Bugs caught by testing (recorded so the next engine slice avoids them):**
1. `fw-next-id.sh` died *silently* on an empty namespace — `set -e` + `pipefail` on a
   `grep` with no match inside `$(...)`; the create script then died silently too, and
   `| head -1` in the test harness masked both. Fix: `|| true` on the scan pipeline.
   Lesson: never pipe a script under test through `head` while debugging.
2. Record locator used `${REC#$OPS_ROOT/}` — breaks when the root contains
   backslashes (`$LOCALAPPDATA` in the scratch harness). Fix: `find -printf '%P'`
   gives root-relative paths; status = first segment, no string surgery.
3. Editing scripts with awk/sed one-liners mangled `\n` and backslash paths
   repeatedly — one attempt deleted the locator line outright and that state was
   briefly committed (amended before push). Settled on: write the replacement line to
   a file in a backslash-free working directory and splice with awk `getline`.
   `python3` heredocs hang in this shell — avoid.
4. The engine's `git add` on `→ closed` staged an *untracked fixture* record — correct
   for real records, unstaged for the fixture. Fixtures stay untracked.

**Verified:** full cycle in a scratch git root (create INC + REQ → shared ids 001/002;
onhold ↔ open; closed refused without/with bad code; closed with `resolved` stamps
both fields; closed-is-terminal; kanban prefix refused; sweep bucketed a 2025 record
with its bundle; next-id counted the bucketed record → 003), then create + close from
the **published marketplace copy** in the operations fixture. All three OQs resolved
and every criterion checked; moved to done/.

### Current State

- **done/ (2):** FEAT-193, FEAT-195 — the operations pair
- **doing/:** empty
- **todo/ (4):** BUG-181, FEAT-163, FEAT-175, TECH-177
- **Next:** FEAT-199 (Due: field — now has 195's record shape to build on) → FEAT-196
  (reporting leg of ops) → FEAT-200; or FEAT-163 (status/WIP slicing, which would also
  surface ops records). New commands register at next restart.

---
## UAT Map (Session Close)

Gary: "Let's map out a UAT test for each of the new commands and scripts." Written as a
re-runnable document, `workspaces/framework/tests/UAT-COMMANDS.md` — 29 tests plus an
environment precondition — and TASK-206 (High) filed to track the run.

**Design choices worth remembering:**
- UAT runs in a **throwaway repo with no `workspaces/framework/`**, plugin installed from
  the dev marketplace — the one condition the script harness could never provide. It
  proves self-containment (UAT-27) and lets UAT-28 assert every directory was made by a
  command.
- It tests the **AI judgment steps**, not just the scripts — purpose prompt, INDEX
  one-liner, "what should this workspace be called?", the close gate (closure code +
  durable knowledge), search-first before any hypothesis, remote-mode evidence drops.
  Those are the parts a harness can't reach and the parts most likely to drift.
- State accumulates in order (ops tests use UAT-03's workspace; the sweep test proves a
  bucketed record still counts toward the next id). Negative cases are first-class.
- UAT-29 documents the session-cached-skill-body constraint as known behavior, not a
  defect.
- Coverage: `/fw-new-workspace` 6, `/fw-new-kb-domain` 3, `/fw-contacts` 4, ops records +
  `/fw-move` + sweep 9, `fw-troubleshoot` 4, cross-cutting 3.

Placement note: `tests/` in the framework workspace ships in the dev plugin by junction
(as `standards/` does); the graduation build decides what actually packages.

Tooling note for the record: a long quoted heredoc through the Bash tool failed to parse
("unexpected EOF while looking for matching `'`") — the Write tool was the fallback.

### Board at close

- **done/ (2):** FEAT-193, FEAT-195 (operations pair)
- **doing/:** empty
- **todo/ (4):** BUG-181, FEAT-163, FEAT-175, TECH-177
- **backlog +1:** TASK-206 (run the UAT) — recommended next, before more engine slices
  land on untested ground; then FEAT-199 or FEAT-163.

---

**Last Updated:** 2026-08-25
