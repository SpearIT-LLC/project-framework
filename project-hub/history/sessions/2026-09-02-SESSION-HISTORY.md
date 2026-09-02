# Session History: 2026-09-02

**Date:** 2026-09-02
**Participants:** Gary Elliott, Claude Code
**Session Focus:** Build a deliverable-based roadmap from all open cards — group by user-visible capability, rank toward the ADR-009 build's 1.0, and separate the old framework's dead work from what still earns its place

---

## Summary

No implementation this session. All 108 open cards (96 `backlog/`, 11 `todo/`, 1
`blocked/`) were read and regrouped from *type* into *deliverable* — one thing a user
gets — then ranked against a single goal: graduating `workspaces/framework/` from 0.4.6
to a 1.0 that replaces the old framework. Nine deliverables came out of it, of which
D8 is ~75 cards of old-framework work with nothing planned. The deprecation call was
verified against TECH-172's re-scope note and ADR-009 rather than assumed. The session
closed by verifying, in both ID engines, that archiving those cards cannot cause an ID
collision.

---

## Work Completed

### ROADMAP-DELIVERABLES.md — new deliverable-based roadmap

- Read every open card's header (id, type, priority, workspace, theme, summary) across
  `backlog/`, `todo/`, and `blocked/`.
- Grouped into **nine deliverables** and ranked D1–D9. Mixed-type grouping throughout —
  each deliverable holds whatever FEAT/BUG/TECH/TASK/SPIKE/DECISION cards serve the same
  user-visible capability, regardless of folder.
- Written to `project-hub/planning/ROADMAP-DELIVERABLES.md` as a **companion** to the
  existing `ROADMAP.md`, not a replacement — see Decisions #2.

**The ranking, and the reasoning for each position:**

| | Deliverable | Cards | Why there |
|---|---|---|---|
| D1 | The Spine: board, operations, kb at root | 5 (all `todo/`) | Relocates two top-level trees; every path-bearing command/script/doc is downstream. Most expensive churn to defer. |
| D2 | Knowledgebase that stays trustworthy | 3 | Retrofit cost rises with every day of accumulated content. Both cards High. |
| D3 | Command UX good enough to hand over | 3 | The 1.0 quality bar — the gap between "the script runs" and "someone who is not Gary can use it." |
| D4 | Reporting/roadmaps/history per workspace | 4 | What a contractor shows a client, but gated on D1's `Workspace:` field (TASK-214). |
| D5 | Troubleshooting proven on real work | 3 | TASK-205 is High but demand-driven. See Decisions #4. |
| D6 | Time: deadlines, reminders, calendar | 2 | Coherent pair, nothing depends on it. Post-1.0. |
| D7 | The ADR-008 guards | 4 | ⚠️ Principles bind; cards audit the old tree. Rewrite before 1.0. |
| D8 | Deprecated: old framework/templates/plugins/tools | ~75 | No work planned. See Decisions #1. |
| D9 | Blocked, external | 1 | BUG-144, Anthropic platform fix. Not schedulable. |

---

## Decisions Made

### 1. The old framework is deprecated — confirmed from sources, not assumed

Gary's instruction allowed for uncertainty ("confirm it's really deprecated, ask if
unsure"). Two independent sources settle it, so no ask was needed:

- **TECH-172's re-scope note (2026-08-24), verbatim:** *"the old framework is
  maintenance-only (v5.6.0); its doc, template, and plugin straggler edits below are
  dead work."*
- **ADR-009 (Accepted 2026-08-18)** makes the framework *be* the plugin, with commands
  building the structure — the old archive-ships-the-structure model is superseded by
  design, not by neglect.

Version state corroborates: `framework/PROJECT-STATUS.md` reads v5.6.0 (2026-08-24) and
has not moved; `workspaces/framework/.claude-plugin/plugin.json` reads 0.4.6 and is
where all recent work lands.

**A distinction that emerged while sorting D8** — and that is worth keeping, because it
changes how the cards should be closed rather than merely *that* they close. Some D8
cards are not stale so much as **dissolved by construction**: DECISION-162 (command-tier
sync), TECH-169 (reconcile `/fw-move` copies), FEAT-179 (plugin create-gate parity),
TECH-160 (align plugin build model), SPIKE-178 (can a plugin invoke its own script).
Every one exists *only* because three tiers were hand-synced. ADR-009's one-copy model
is the fix those cards were asking for. They should close as **superseded-by-design**,
which is a different closure note than "old framework, not doing it."

### 2. Companion roadmap, not a rewrite

`project-hub/planning/ROADMAP.md` is theme-based (Project Guidance / Developer Guidance
/ Workflow / …), last updated 2026-02-17 — seven months stale and pre-ADR-009. It was
left untouched and the new file written beside it.

**Rationale:** the existing roadmap's *themes* are still a defensible taxonomy of what
the project is; what it lacks is any awareness of the workspace model or the two-framework
split. Overwriting it would have destroyed a still-valid axis to deliver a different one.
Two files, two axes, both readable. Revisit if maintaining both proves to be a cost —
this is a judgment that can be reversed cheaply, unlike the deletion.

### 3. D8 destination is `project-hub/work/archive/deprecated/` — ID safety verified in both engines

Gary: *"The location is the status, so I favor archive/deprecated/. Will the next-id
script find those cards?"* Asked because a missed card would let an ID be reissued.

**Verified by reading both implementations, not by inference:**

- **Old engine (live for this board)** — `Get-NextWorkItemId` in
  `framework/tools/FrameworkWorkflow.psm1:276-281` scans `work`, `releases`, `poc`,
  `history/spikes` with `-Recurse`, matching any `[A-Za-z]+-NNN` basename generically
  (ADR-006's disk-discovery model: "recognized" = "present on disk", no authored list).
  `work/archive/deprecated/` sits under `work/`, so it is counted.
- **New engine** — `workspaces/framework/scripts/fw-next-id.sh:33-35` does a recursive
  `find` over the namespace root. Its own header comment already states the governing
  rule: *"status is only the first path segment under the root; deeper folders (year
  buckets, release buckets, bundles) are grouping, never status, and still count."*
  `archive/deprecated/` therefore parses as status `archive`, grouping `deprecated` —
  exactly Gary's "location is the status" model, one level deeper.
- **Precedent:** `work/archive/` already holds 8 cards (TECH-135, DECISION-029,
  CHORE-131/132, DOCS-133 and its supporting files). The pattern is in use and working.

**Constraint recorded in the roadmap:** deprecated must live **under `work/`**. A
sibling root such as `project-hub/deprecated/` would fall outside the old scanner's four
scan folders, be invisible to it, and reopen exactly the ID-reissue risk the question was
about. The recursion under `work/` is what makes this safe — there is no archive-specific
special case in either engine.

### 4. D5 does not jump the queue — no live troubleshooting case

The roadmap draft had TASK-205 as "standing readiness that jumps the queue when a real
case arrives," on the reasoning that three real incidents would reshape `fw-troubleshoot`
more than any design work. Gary: *"No, this is all in development stage."* D5 stays at
rank 5; the queue-jump language is removed from the resolved-questions section.

### 5. Card-by-card review is a precondition for archiving, not a courtesy

Gary: *"I'm leaning towards keeping but we should carefully review before implementation
to be sure all the old stuff is out of the card."*

Recorded as a hard rule: D8 is a **proposed** bucket. No card moves until it has been read
for content that outlived the old framework; anything that survives is rewritten as a
fresh card against `workspaces/framework/` **first**, and only then is the original
archived. Three pre-flagged re-earn candidates — **FEAT-180** (documentation as a
done-gate rule, cheap for the new build to adopt), **FEAT-115** (`/fw-tour`), **FEAT-157**
(provenance stamp, useful at graduation) — are candidates, not a finished list.

The same rule was extended to **D7**, which has the identical shape: TECH-185/186/188/189
carry principles that bind the new build (the Single-Source Rule is live in both
`CLAUDE.md` files) inside cards that audit the old tree. Per-card fate recorded in the
roadmap: TECH-189 and TECH-186 are full re-earners, TECH-188 partial (the new build
publishes by junction, not archive, so the mechanism differs), TECH-185 mostly
superseded-by-construction.

---

## Files Created

- `project-hub/planning/ROADMAP-DELIVERABLES.md` — deliverable-based roadmap; 9 ranked
  deliverables over all 108 open cards, with a Resolved Questions section carrying the
  ID-safety verification and the review-before-archive rule.
- `project-hub/history/sessions/2026-09-02-SESSION-HISTORY.md` — this file.

## Files Modified

- *(none — no framework source was touched this session)*

## Files Moved

- *(none — the D8 bulk move is proposed, not executed)*

---

## Current State

### In doing/
- *(empty)*

### In todo/
- BUG-181, BUG-215, FEAT-163, FEAT-175, FEAT-209, FEAT-210, TASK-213, TASK-214,
  TASK-216, TASK-217, TECH-177

### In blocked/
- BUG-144 (Anthropic issue #26906 — platform fix required)

### Open threads for next session

- **Nothing implemented.** The roadmap is a planning artifact; no card changed state and
  no work item moved folder.
- **D1 is the recommended start**, and yesterday's history already constrains how:
  TASK-213 and TASK-216 *should land as one migration* — both change root layout and
  break the same relative paths. That note predates this roadmap and still stands.
- **Unresolved from 2026-09-01, still unresolved:** does the root move land before or
  after the D5 board crossover? The roadmap does not settle this; it is the first
  question D1 has to answer.
- **The D8 bulk move is not scheduled.** It needs the per-card review from Decisions #5
  before any `git mv` runs. Worth doing as a deliberate pass, not folded into other work.
- **BUG-181 sits in `todo/` but is classed D8** (deprecated) — the starter `CLAUDE.md`
  it fixes belongs to the old framework, and the new build authors its own. It should
  either be re-earned against `workspaces/framework/` or archived; leaving a High-priority
  card in `todo/` that the roadmap treats as dead work is the kind of quiet contradiction
  that misleads a future session.
- **FEAT-175 likewise sits in `todo/`** and is the old framework's `/fw-new` create gate.
  The new build has create gates already (`fw-new-workspace.sh`, `fw-new-ops-record.sh`,
  `fw-new-contact.sh`). Same disposition question as BUG-181.

---

**Last Updated:** 2026-09-02 (morning)

---

# Afternoon Session — TASK-218: Deprecating the Old-Framework Backlog

**Continuation.** The morning ended with the D8 bulk move *unscheduled*, pending the
per-card review recorded as Decisions #5. Gary opened the afternoon with "Start with
moving the deprecated cards" — and the review that followed changed the answer four
times before a single file moved.

---

## Summary (afternoon)

TASK-218 was created, worked, and completed. It archived **26** cards to
`project-hub/work/archive/deprecated/` — not the ~75 the morning roadmap proposed. Four
successive review passes cut the move set by two-thirds, each triggered by a question
from Gary, and each cut justified by something verified in `workspaces/framework/`
rather than inferred from the cards' titles.

**The morning's D8 recommendation — "bulk-move rather than dispositioning 75 cards
individually" — was retracted.** It was wrong, and the record now says so explicitly.

---

## Work Completed

### TASK-218: Deprecate the old-framework backlog → **done**

Created in `todo/` at Gary's suggestion — *"perhaps this activity should be a card of
it's own so it has a record and reason in case we need to backtrack and pull a
deprecated card back."* That framing is what made the card's **disposition table** the
deliverable and the `git mv` the mechanical afterthought.

- Moved `todo → doing`; pre-implementation review presented and approved.
- 26 cards stamped with a `**Deprecated:** 2026-09-02 — <code> — <reason>` line and
  `git mv`'d in one commit (git recorded all 26 as renames, not delete/add pairs).
- `archive/deprecated/README.md` written — reason codes, reversal procedure, and a
  deliberate section on **what is NOT there and why**, so someone hunting a held card
  learns immediately it is still on the board.
- TECH-172's closing finding written into the card **before** it moved: its surviving
  half (disposition the open `DECISION-*` items) was completed by TASK-218, with each
  item's outcome recorded.
- Roadmap D8 rewritten to point at TASK-218.
- Moved `doing → done`; `Completed: 2026-09-02` stamped automatically.

---

## The Four Passes (why the number kept falling)

| Pass | Moving | Trigger | What the read found |
|---|---|---|---|
| Morning roadmap | ~75 | — | Grouped by type + title; recommended a bulk move |
| Full read of every card | 66 | *"Start with moving the deprecated cards"* | F1–F4 below |
| Keep command/plugin/script cards | 42 | *"Keep any plugin or command card, even if it's an update to the underlying script"* | C4 — 24 cards |
| Keep hook cards | 42 | *"Do we have any open cards for hooks?"* | C5 — TECH-096 |
| Final gotcha scan | **26** | *"Are there any cards in the deprecated list that might apply to the new framework?"* | C6 — 16 cards |

### F1 — the new engine has no kanban gates
`workspaces/framework/scripts/fw-move.sh:14` states *"No kanban gates apply."* The engine
is operations-only; kanban is an empty policy slot until the D5 crossover. So TECH-166,
TECH-168, TECH-055, TECH-114 are the crossover's **design input**, not dead work.

### F2 — SPIKE-178 is answered, by production code
Its question (can a plugin invoke a script in its own cached directory?) is answered
**yes** by the new build's use of `${CLAUDE_PLUGIN_ROOT}/scripts/*.sh` in five commands
and `hooks.json`.

### F3 — DECISION-162 is an undecided decision, not a stale task
Four live options, `Chosen Option: TBD`. ADR-009 selects Option C by construction.

### F4 — product ideas are unbuilt, not deprecated
FEAT-047/052/089/090/092/093/104 describe capabilities absent from **both** frameworks.

---

## Decisions Made (afternoon)

### 6. The archive gets a card, and the card gets the reasoning

Gary's call. A folder of 50 files with no rationale is indistinguishable from an accident
six months on. Consequence: the disposition table, the reason codes, the ID-safety proof,
and the reversal procedure all live in TASK-218 and in the folder README — not in a
commit message that nobody re-reads.

### 7. `PLUGIN-TIER` retired as a reason code — it hid real distinctions

Gary: *"PLUGIN-TIER sounds pretty generic since we have 4 sets of plugins now."* Correct,
and the check that followed found genuine mis-filings. Verified per card which artifact
each actually targets:

- **BUG-174** and **TECH-161** are not plugin work at all — they target `.claude/scripts/`
  and the old `/fw-session-history`. Re-coded `OLD-ENGINE`.
- **TECH-160** targets `Build-Plugin.ps1` — build tooling, not plugin content. `OLD-SETUP`.

Split into `OLD-PLUGIN` / `TIER-SYNC` / `OLD-ENGINE`, with the legend naming all four
command-bearing sets (`.claude/`, the two marketplace editions, `workspaces/framework`)
so the ambiguity cannot recur.

### 8. Keep every command, plugin, script and hook card while the migration is mid-flight

Gary asked the question that changed the outcome most: *"Since we're in the middle of
moving the commands to the new framework, do we risk losing some detail or nuance needed
in the new framework if we move the plugin cards?"*

**Yes, and it was measurable.** The new build ships **5** commands; the old set has
**11**. Ten have not crossed over — `/fw-status`, `/fw-wip`, `/fw-backlog`, `/fw-next-id`,
`/fw-help`, `/fw-release`, `/fw-roadmap`, `/fw-swarm`, `/fw-topic-index`,
`/fw-session-history`.

The sharpest example: **TECH-102 is not a performance card.** It is a design record for
commands that do not exist yet — four architectural options *with the rejection rationale*
(Claude-reads-directly rejected at 2–4x tokens), plus a per-command requirements table.
Six of its eight commands are unbuilt. **TECH-161** likewise carries a complete
midnight-rollover spec for `/fw-session-history`.

### 9. Hooks are held (C5)

TECH-096 (21 mentions — native git hooks vs Claude hooks, with trade-offs) was in the
archive set; now held. TECH-114 and TECH-168 were already held under C1. FEAT-107 checked
and **excluded** — it lists hooks as a prerequisite in a requirements doc; it is not hook
work.

### 10. Board conventions the new build has not defined (C6) — the final scan

The subtlest class, and the one a title-based heuristic gets wrong every time. Each card
reads *"Document X policy"* with a Files Affected line naming `framework/docs/` — so it
looks dead. But the **policy is the deliverable and the file is incidental**. Verified in
`workspaces/framework/`:

- `templates/records/` holds **only** `contact.md`, `ops-record.md`, `ts-case.md`. There
  is **no work-item template of any kind** — every board-item convention is undefined.
- `fw-move.sh:6` already references **"child items"** as grouping the engine handles, but
  nothing anywhere defines what a child item *is*. TECH-082 is that definition.
- **No never-delete policy exists** in the new build's `CLAUDE.md`, `README.md` or
  scripts — TASK-218 was itself honouring an unwritten rule (TECH-077).
- Templates scaffold `meetings/` folders but ship **no meeting-record template**
  (FEAT-149); `tools/` holds only git-hook installers — **no release tooling** (TECH-078).

16 cards held: TECH-027/033/041/044/049/070/070.1/071/073/077/078/082, FEAT-021/030/149,
DECISION-171.

### 11. BUG-181 and FEAT-175 — re-scoped, not archived

Gary's call, resolving the contradiction the morning session flagged. Both keep their
original IDs; the re-scope is card surgery so the reasoning that earned them stays
attached. FEAT-175 becomes the D5 crossover's board create gate — the one create gate the
new build lacks. BUG-181's question ("does the contract reach a generated workspace?")
survives its dead template.

---

## The Method That Emerged

**The summary-level heuristic — type + title + the paths a card names — systematically
over-archived.** Three whole classes failed it identically: commands not yet ported (C4),
hooks (C5), and undefined board conventions (C6). Two better tests came out of the work:

1. **The subject test.** A raw grep for `/fw-move` matched 31 cards, most of which only
   *cite* it. The question is whether the command/script/plugin is the card's **subject** —
   its title and its Files Affected block — not whether it appears in the text.
2. **The dead-file test.** The 26 survivors share one property: each names a **specific
   dead file** as its deliverable. The file is the deliverable and it is not coming back.
   That is a far sharper line than "targets the old framework."

---

## Verification (recorded because the card required it)

| Check | Result |
|---|---|
| Next-ID before / after | **219 / 219** — archived cards still count; no reissue risk |
| Board reconciliation | 109 = 83 remaining + 26 archived |
| Git rename detection | all 26 tracked as `R` (renames), no delete/add pairs |
| Held cards spot-check | 16 checked across C1–C6 — all on the board, none wrongly archived |
| Stamps | all 26 carry a `**Deprecated:**` line |

Three counting errors in the draft card were caught and fixed during verification
(Section A said 52 while listing 56; Section C said 14 while listing 18; FEAT-107 was
named in both C5 and the move set). Noted because a disposition table that does not
reconcile is worse than none.

---

## Files Created (afternoon)

- `project-hub/work/done/TASK-218-deprecate-old-framework-cards.md` — the card; ~450
  lines, of which the disposition table is the deliverable
- `project-hub/work/archive/deprecated/README.md` — reason codes, reversal procedure,
  and what is deliberately *not* archived

## Files Modified (afternoon)

- `project-hub/planning/ROADMAP-DELIVERABLES.md` — D8 rewritten; the bulk-move
  recommendation retracted and replaced with a pointer to TASK-218
- 26 archived cards — each gained a `**Deprecated:**` stamp
- `TECH-172` — closing finding recorded before archiving

## Files Moved (afternoon)

- 26 cards: `backlog/` -> `archive/deprecated/`
- `TASK-218`: `todo/` -> `doing/` -> `done/`

---

## Current State (end of afternoon)

**Board: 71 backlog · 11 todo · 0 doing · 7 done · 1 blocked · 26 deprecated**

### In done/ (awaiting release)
- BUG-207, BUG-208, BUG-212, FEAT-193, FEAT-195, TASK-206, **TASK-218**
- 7 items — under the 10-item release threshold; no release nudge

### In doing/
- *(empty)*

### Open threads for next session

- **D1 is still the recommended start** (TASK-213/214/216 + BUG-215). Unchanged by the
  afternoon's work, which was board hygiene, not roadmap progress.
- **Still unresolved from 2026-09-01:** does the root move land before or after the D5
  board crossover? Two sessions have now deferred this; it is the first question D1 must
  answer.
- **BUG-181 and FEAT-175 need their re-scope actually written.** Decided, not done. They
  sit in `todo/` describing old-framework paths until someone rewrites them — the same
  quiet contradiction the morning flagged, now with a decided direction.
- **Four held cards need their findings recorded** (SPIKE-178, DECISION-162, TECH-096,
  DECISION-110). They were in record-then-archive before the keep rules pulled them back;
  the findings are noted in TASK-218 but not yet written into the cards themselves.
- **C6 is a to-do list in disguise.** Sixteen board conventions the new build has not
  defined — parent/child items, numbering, never-delete, release archival, meeting
  records. Most become real work at the D5 crossover. Worth a roadmap deliverable of its
  own rather than leaving them scattered in `backlog/`.
- **The deprecated folder is not final.** Reversal is expected and cheap; the README says
  so. If a card comes back, re-scope it against `workspaces/framework/` first.

---

**Last Updated:** 2026-09-02 (afternoon)
