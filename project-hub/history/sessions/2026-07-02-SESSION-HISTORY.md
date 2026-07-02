# Session History: 2026-07-02

**Date:** 2026-07-02
**Participants:** Gary Elliott, Claude Code
**Session Focus:** Decision swarm — project model for a single-customer, multi-SOW engagement (led to a new `engagement` project type)

---

## Summary

Ran a `/fw-swarm decision` to work out how a solo contractor should structure
repos for one customer with many independent SOWs. The conversation evolved
substantially through several user course-corrections: from "reuse the toolbox
type with nested project-hubs" to a clean model of **one repo per customer, one
framework spine, one Kanban board, SOWs as `stream` folders**, under a brand-new
fifth project type: **`engagement`**. Produced ADR-005, three backlog items
(FEAT-163/164/165), and meeting minutes. The schema edit that would add the
`engagement` type was deliberately *not* applied — it is tied to FEAT-165 so it
carries history into the distribution archive.

---

## Work Completed

### ADR-005: Multi-SOW Single-Customer Repo Model (`engagement` type)

- Decided: one private git repo per customer; **one** framework spine and **one**
  Kanban board at the customer root; bounded bodies of work live as `stream`
  folders under `streams/`.
- Rejected: repo-per-SOW (detaches shared context, N+1 repos for a solo dev) and
  git submodules (ceremony tax; prior negative experience).
- Rejected mid-session: reusing the `toolbox` type — replaced by a new `engagement`
  type (see Decisions).

### FEAT-163: Stream-Aware Reporting and History

- Report project status **by stream**; ensure session/git/release history can be
  organized by stream; surface unassigned items to make stream drift visible.
- Gated on deciding the stream field (reuse `Theme` vs. new `Stream`).

### FEAT-164: Scalable Stream Content Folder Structure

- Define the `streams/<slug>/` internal layout and a "start a new stream"
  procedure. Deliberately kept as a *sketch* in the ADR; the spec is this item's
  job (sketch → use → formalize).

### FEAT-165: Introduce `engagement` Project Type

- Add `engagement` to the `project.type` enum in `framework-schema.yaml` (schema
  edit deferred to this item so it carries history).
- **Audit every type-branching point.** Confirmed functional gap:
  `framework-roles.yaml` → `project_type_defaults` maps each type to a default AI
  role; `engagement` needs an entry or it falls through to `fallback_default`.
  Also: setup picker (auto-parses schema — verify), and docs enumerating the four
  types (CLAUDE.md, PROJECT-STRUCTURE.md, GLOSSARY.md, architecture-guide.md,
  NEW-PROJECT-CHECKLIST.md).

---

## Decisions Made

The value of this session was in the *evolution* of the model. Preserving the
journey, because each turn was a user course-correction that improved the design:

1. **One Kanban board, not many (course-correction #1):**
   - The team's first framing of the model implied *N* `project-hub/` boards (one
     per SOW). Gary flagged this breaks the whole point of Kanban for a one-person
     shop — one pair of hands should mean one board.
   - Resolved to a single spine + single board at the customer root, with the SOW
     as a *dimension* of the work, not a separate spine. Connected to the `toolbox`
     "one project, many tools" idea.

2. **Container term = `stream`, not `SOW` (course-correction #2):**
   - Gary noted "SOW" bakes in a granularity assumption: his new project is defined
     *by* SOW, but the HPC/Honda precedent has *multiple deliverables under one
     SOW*. The term must stay flexible.
   - Rejected `engagements/` (implies SOW-level), reusing `theme` (`Theme` already
     means *stable category* per ROADMAP-TEMPLATE — overloading it mixes permanent
     and temporary meanings), and `deliverables/` (a stream holds internal
     notes/research too, and the repo isn't the deliverable).
   - Landed on **`streams/`** with an optional `deliverables/` *subfolder* per
     stream for the client handoff boundary. **`Stream`** (which bounded work,
     temporary) kept distinct from **`Theme`** (what kind of work, stable category).

3. **New `engagement` project type, not `toolbox` reuse (course-correction #3):**
   - Gary asked whether a distinct 5th type would be cleaner long-term, given the
     tension already felt. He articulated the decisive distinction: `toolbox` is a
     flat set of **homogeneous peers** (utility scripts); a customer engagement is
     **heterogeneous activities** (org info, source, ops, knowledge base,
     deliverables) that **sprawl wider over a long engagement**. A toolbox doesn't
     grow into a KB + ops runbook + source tree; a customer does.
   - Dan (Senior Dev role) conceded his conservative "reuse for now" position given
     the distinction is structural and a real customer repo is imminent.
   - Named **`engagement`** (over `client` / `workspace`) — Gary's call, noting the
     schema *description* is the runtime clarity surface, so wording was made
     explicit.

4. **Stream field left open (by design):**
   - Whether "which stream" rides on the existing `Theme:` field or a new `Stream:`
     field is deferred to FEAT-163 / the scaffolding session. Team leans distinct
     to avoid overloading `Theme`.

5. **Schema change tied to a work item (course-correction #4):**
   - The `engagement` type was initially edited directly into
     `framework-schema.yaml` during the swarm. Gary directed that the change be
     tied to a work item so a new distribution archive carries its history.
   - The schema edit was **reverted**; `engagement` is implemented via FEAT-165.
     ADR-005, FEAT-165, and the minutes were updated to say the schema edit is
     *proposed/pending*, not applied.

---

## Files Created

- `project-hub/research/adr/005-multi-sow-customer-repo-model.md` — the decision record
- `project-hub/work/backlog/FEAT-163-theme-aware-reporting-and-history.md` — stream reporting/history
- `project-hub/work/backlog/FEAT-164-scalable-multi-sow-content-structure.md` — stream folder structure
- `project-hub/work/backlog/FEAT-165-engagement-project-type.md` — new type + type-branch audit
- `project-hub/meetings/2026-07-02-swarm-decision-multi-sow-customer-repo-model.md` — swarm minutes
- `project-hub/history/sessions/2026-07-02-SESSION-HISTORY.md` — this file

## Files Modified

- None to live framework code. The `framework-schema.yaml` edit made during the
  swarm was intentionally reverted (deferred to FEAT-165) — the file is unchanged
  from its committed state.

## Files Moved

- None.

---

## Current State

### In done/ (awaiting release)
- None from this session (planning/decision work only).

### In doing/
- None.

### In backlog/ (new)
- FEAT-163 — Stream-Aware Reporting and History
- FEAT-164 — Scalable Stream Content Folder Structure
- FEAT-165 — Introduce `engagement` Project Type (**suggested first pick** — it
  unblocks scaffolding the real engagement repo, since the type must exist before
  setup can select it)

### Open questions carried forward
- `Stream` vs. `Theme` field mechanism (FEAT-163 / scaffolding).
- `streams/<slug>/` internal layout spec (FEAT-164).
- `engagement` type wiring + audit (FEAT-165), incl. `project_type_defaults` role.

### Next session
- Scaffold the customer repo (`framework.yaml` → `type: engagement`, `customer/`,
  `streams/sow-01-<slug>/`) and settle the open questions against the real repo.

---

## (Later) FEAT-165 Implemented and Completed

**Continuation:** Queued FEAT-163/164/165 to `todo/` (needed `--force` — see below),
then moved FEAT-165 through `doing/` → `done/` and implemented it.

### FEAT-165 — engagement project type (DONE)

Wired the `engagement` type fully into the framework:
- `framework/docs/ref/framework-schema.yaml` — added `engagement` enum + description.
- `framework/docs/ref/framework-roles.yaml` — `engagement: senior-architect` in
  `project_type_defaults` (session-START default only; freely switched
  conversationally — verified against CLAUDE.md role section).
- `framework/docs/ref/GLOSSARY.md`, `framework/docs/PROJECT-STRUCTURE.md`,
  `templates/NEW-PROJECT-CHECKLIST.md` — added `engagement` to type lists.
- **Pre-existing bug fixed:** `NEW-PROJECT-CHECKLIST.md` still said `tool` (stale
  since the 2026-01-17 `tool`→`toolbox` rename) — corrected to `toolbox`.
- **Verified, no edit needed:** `Setup-Framework.ps1` parses types from the schema
  generically (`Get-ProjectTypes`); the regex captures `engagement` automatically.

### TECH-166 filed — move.sh readiness false-positives

Moving the three planning items to `todo/` required `--force` because
`move.sh` readiness heuristics misfire on legitimate planning content: unchecked
acceptance criteria (belong in `doing/`), the word "decide" in prose flagged as a
marker, and `[Optional]` field hints flagged as placeholders. Filed TECH-166 to fix.

### Investigation — the `Completed` field / date intent

Question raised: the `/fw-move` doc says "Check `Completed` date is set" on `→ done`,
but the work-item templates define no `Completed` field, and folder location is the
status. Initially read as pure command drift — but history revised that:

- **Historically, completed items DID carry a `**Completed:** YYYY-MM-DD` field** —
  e.g. `BUG-108` (v-release), `FEAT-146`, `FEAT-153`, `TECH-154`, `FEAT-005/006`,
  and 2026-01-13/01-19 session logs explicitly note "Added completion date."
- So the `/fw-move` instruction reflects a **real, previously-practiced convention**:
  stamp the close date on the item when it completes. It is a *record* of when it
  closed, not a *gate* (the script never enforced it). Gary's read — "meant to just
  record the date it closed, worded awkwardly" — matches the evidence.
- **The drift is in the TEMPLATES, not (only) the command:** current templates
  dropped the `Completed` field, so the practice silently lapsed. The command doc is
  the last place the convention survives.
- Left unresolved this session — candidate follow-up: either restore `**Completed:**`
  to templates (and have `/fw-move` fill it on `→ done`), or formally retire the
  convention and remove the command instruction. Not yet filed as a work item.

FEAT-165 itself was completed **without** adding a `Completed` field, consistent with
the current templates (no field to fill) — the decision on restoring the convention
is deferred.

### Files Modified (this segment)
- `framework/docs/ref/framework-schema.yaml`
- `framework/docs/ref/framework-roles.yaml`
- `framework/docs/ref/GLOSSARY.md`
- `framework/docs/PROJECT-STRUCTURE.md`
- `templates/NEW-PROJECT-CHECKLIST.md`

### Files Created (this segment)
- `project-hub/work/backlog/TECH-166-move-readiness-false-positives.md`

### Files Moved (this segment)
- `FEAT-163`, `FEAT-164` → `todo/`
- `FEAT-165` → `todo/` → `doing/` → `done/`

### Current State (updated)
- **done/:** FEAT-165 (awaiting release) + 1 pre-existing item = 2 total.
- **todo/:** FEAT-163, FEAT-164.
- **backlog/:** TECH-166 (move false-positives).

---

## (Later) `Completed`-Field Investigation → BUG-167 (Filed + Decided)

**Continuation:** The earlier segment (above) left the `Completed`-field question
"deferred, possibly accidental removal." Gary asked to trace the exact drift
timeline before fixing. Deeper git archaeology **corrected the earlier read** — the
removal was NOT accidental. (Preserving the earlier tentative conclusion per
append-only; this segment supersedes it.)

### The corrected timeline (git archaeology)

Traced when/how the `Completed` field left the templates:

| Date | Commit | Event |
|------|--------|-------|
| 2026-01-20 | TECH-064 (`6f43274`) | **Deliberately** removed `Completed` AND `Status` from templates. Documented rationale: "git history captures this; location indicates completion." The `workflow-guide.md` `→ done` checklist at this commit did **not** require a Completed date — internally consistent. |
| 2026-01-20 | TECH-066 | Migrated 41 existing items, stripping `**Completed:**` from all — convention retired end-to-end. |
| 2026-01-29 | TECH-094 (`1b1ec2d`) | Re-introduced "Completed date is set" into `/fw-move`. |
| 2026-02-04 | TECH-108 (`7071e8d`) | While removing the retired-`Status`-field contradiction, **re-added** `- [ ] Completed date is set` to `workflow-guide.md`'s `→ done` checklist — resurrecting a requirement TECH-064 deliberately killed, without restoring the field to templates. |

**The irony:** TECH-108's stated job was *removing* a retired-field contradiction
(`Status`); it *created* the same contradiction for `Completed`.

**Correction to my earlier characterizations (walked back twice):** first I called
the `/fw-move` instruction "outdated" (wrong — it's a live convention: v5.4.0/v5.5.0
items are 100% stamped). Then "accidental collateral damage" (wrong — TECH-064's
commit message shows deliberate removal). The verified truth: deliberately retired,
then accidentally resurrected in ONE layer (the guide/command) but not the templates.

### BUG-167 filed and decided (Option A)

Filed **BUG-167** (Completed-field contradiction) with the full timeline. Then Gary
and I debated the right resolution. I presented four arguments *against* "record the
date when it moves to done/"; Gary dismantled three:
- "moved to done = just staging" → **wrong**: `move.sh` blocks incomplete items, so
  the move IS the completion event by construction.
- "release date could serve" → **wrong**: different fact.
- "two sources of truth" → **wrong**: only if we declare both authoritative. Declare
  the field definitive, git time incidental → one source of truth.

The one surviving argument was a **precondition, not an objection**: a hand-written
date is *less* reliable than git, so the strategy only works if the date is written
**mechanically** by `move.sh`. Verified the precondition holds — Gary uses only
`/fw-move`, which always invokes `move.sh` (`.claude/commands/fw-move.md:75`).

**Decision: Option A — restore the `Completed` field and mechanize it.**
- **Belt:** `move.sh` stamps `**Completed:** <today>` on `→ done/` (idempotent;
  templates declare the field).
- **Suspenders:** pre-commit hook rejects `done/` items lacking a `Completed:` date
  (catches any bypass — the BUG-167 failure mode). A git hook can't force `/fw-move`
  usage but CAN enforce the invariant at commit time.
- Reconcile guide/command/plugin copies; note `.claude/` vs `plugins/*/commands/`
  divergence.

### Edge cases probed (no new work items — low risk)

- **Move an item already in the destination?** `move.sh:396-401` skips it as a no-op
  (`⚠️ already in <target>/ — skipped`), so a `done → done` re-move never re-stamps.
  Idempotency concern is moot on the normal path.
- **Duplicate-ID collision on `git mv` into done/?** Possible in theory, low-risk in
  practice: `Get-NextWorkItemId` scans `work/ + releases/ + poc/ + history/spikes/`,
  so the counter never re-issues a used number; prefix + descriptive filename make
  dupes visible. Gary assessed this as low-risk — **not** worth its own item.
- Added a **guardrail note** to BUG-167: stamp only on a genuine transition, write
  the date only AFTER a confirmed `git mv` (no partial-write on failure).

### Third readiness false-positive of the session

Moving BUG-167 `backlog → todo` needed `--force` again — same TECH-166 pattern
(unchecked criteria, "decide" in prose, Option A/B in the Options section,
`[Optional]` hint). This is the **3rd occurrence** this session (after
FEAT-163/164/165). Strong signal TECH-166 is real friction, not a nicety. BUG-167
trips ALL FOUR detectors → an ideal test fixture for TECH-166.

### Files Created (this segment)
- `project-hub/work/backlog/BUG-167-completed-field-contradiction.md`

### Files Modified (this segment)
- `project-hub/work/done/FEAT-165-engagement-project-type.md` — added
  `**Completed:** 2026-07-02` to comply with the (current) `→ done` procedure.

### Files Moved (this segment)
- `BUG-167` → `todo/` (staged, not yet committed)

### Current State (updated)
- **done/:** FEAT-165 (awaiting release) + 1 pre-existing = 2.
- **todo/:** FEAT-163, FEAT-164, BUG-167 (3 — all move.sh/workflow-tooling items).
- **backlog/:** TECH-166.

### Open follow-ups
- **BUG-167** (todo/, decided) and **TECH-166** (backlog/) both touch `move.sh` —
  candidates to implement together in one focused pass. BUG-167 is a good TECH-166
  fixture.
- **FEAT-163/164** (todo/) — engagement-model follow-ups.
- **Next session (original thread):** scaffold the `engagement` customer repo and
  settle `Stream`-vs-`Theme` against the real repo.

---

**Last Updated:** 2026-07-02
