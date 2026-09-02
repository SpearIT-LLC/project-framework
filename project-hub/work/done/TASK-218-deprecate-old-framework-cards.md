# Task: Deprecate the Old-Framework Backlog — Disposition, Archive, and Reversal Record

**ID:** TASK-218
**Type:** Task
**Priority:** Medium
**Version Impact:** None (board hygiene; no framework behaviour changes)
**Created:** 2026-09-02
**Workspace:** framework
**Completed:** 2026-09-02
**Theme:** Framework Consistency

---

## Summary

Archive the open work items that target the **old** framework (`framework/`, `templates/`,
`plugins/`, `tools/`) into `project-hub/work/archive/deprecated/`, and record **why each
one went** so a card can be pulled back deliberately rather than rediscovered by accident.

This card exists because the archive itself is not self-explaining. A folder of 50 files
with no rationale is indistinguishable from an accident six months from now. The
disposition table below **is** the deliverable; the `git mv` is the mechanical part.

> **Scope note.** This card archives cards. It changes no framework source, no script, and
> no command. Version Impact is None.

---

## Problem Statement

**What needs to be done?**

The 2026-09-02 roadmap (`project-hub/planning/ROADMAP-DELIVERABLES.md`, D8) grouped 78
open cards as old-framework work with nothing planned. They sit in `backlog/` and `todo/`
alongside live cards, where they inflate the board, dilute `/fw-status`, and make the real
queue hard to see.

**Why now?** The old framework is maintenance-only at v5.6.0 (TECH-172's 2026-08-24
re-scope note: *"its doc, template, and plugin straggler edits below are dead work"*), and
ADR-009's build is where all work lands. The board should say that.

**What must NOT happen:** a silent bulk move. Reading all 66+ candidates in full (2026-09-02)
changed the disposition of **24 of them** — see Findings. A bulk move would have buried
every one of those.

---

## Findings From the Full Read (2026-09-02)

The roadmap's original D8 recommendation was *"bulk-move rather than dispositioning 75
cards individually."* **That recommendation is retracted.** Reading the full bodies
surfaced four classes the summary-level grouping got wrong:

### F1 — The new build has no kanban gates yet

`workspaces/framework/scripts/fw-move.sh:14` states plainly: **"No kanban gates apply."**
The engine is operations-only; the kanban namespace is an empty policy slot awaiting the
ADR-009 D5 board crossover (`fw-move.sh:15-17`).

Consequence: cards describing **gate behaviour** are not "already implemented in the new
engine" — they are *unbuilt*, and they are the design input for the crossover work.
TECH-166, TECH-168, TECH-055, TECH-114 (and TECH-177, already in `todo/`) all fall here.
Archiving them would discard the thinking immediately before the work that needs it.

### F2 — SPIKE-178 is answered, by production code

Its question: *can a plugin invoke a script inside its own cached directory?* The new build
answers **yes** in five commands and a hook — `${CLAUDE_PLUGIN_ROOT}/scripts/*.sh`
(`commands/fw-move.md:36`, `fw-contacts.md:29`, `fw-new-workspace.md:26`,
`fw-new-kb-domain.md:21`, `fw-new-ops-record.md:20`, `hooks/hooks.json:9`).

It closes as **answered**, with the finding recorded — not archived unread.

### F3 — Some cards are decisions, not tasks

DECISION-162 carries four live options and `**Chosen Option:** _TBD_`. ADR-009 chose
Option C by construction (one copy — the framework *is* the plugin). It closes as
**superseded-by-design with the rationale recorded**, which is what keeps the decision
trail legible. Archiving an undecided decision silently loses the fact that it was ever
open.

### F4 — Product ideas are not deprecated, they are unbuilt

FEAT-047 (team ID collision), FEAT-092 (sprints), FEAT-093 (planning-period archival),
FEAT-104 (velocity), FEAT-089/090 (patterns), FEAT-052 (task-based templates) describe
capabilities absent from **both** frameworks. They have no old-framework dependency beyond
naming `project-hub/` paths. Filing them as deprecated would quietly delete roadmap
surface. They stay on the board.

---

## Scope

**In scope:**
- Move the **Archive** cards below to `project-hub/work/archive/deprecated/` using `git mv`.
- Add a one-line `**Deprecated:** 2026-09-02 — <reason>` stamp to each archived card, so the
  reason travels with the file and not only with this record.
- Write `project-hub/work/archive/deprecated/README.md` — what the folder is, the reversal
  procedure, and a pointer back to this card.
- Close the **Record-then-archive** cards with their finding written into the card first.
- Leave the **Keep** cards on the board; where the roadmap mis-filed them, note it.

**Out of scope:**
- Creating the re-earned replacement cards (FEAT-180 / FEAT-115 / FEAT-157 style rewrites
  against `workspaces/framework/`). Those are separate cards, written when the work is
  actually wanted — not as a batch here.
- Deleting anything. Nothing is deleted, ever (the never-delete principle TECH-077 argues
  for, which is itself on this list).
- Touching `framework/`, `templates/`, `plugins/`, or `tools/` source.

---

## ID Safety — Verified, Not Assumed

Archiving must not let an ID be reissued. Verified 2026-09-02 by reading **both** engines:

| Engine | Behaviour | Verdict |
|---|---|---|
| Old (live for this board) — `framework/tools/FrameworkWorkflow.psm1:276-281` | Scans `work`, `releases`, `poc`, `history/spikes` with `-Recurse`, matching any `[A-Za-z]+-NNN` basename generically (ADR-006 disk-discovery: "recognized" = "present on disk") | ✅ `work/archive/deprecated/` is under `work/` → counted |
| New — `workspaces/framework/scripts/fw-next-id.sh:33-35` | Recursive `find` over the namespace root. Header: *"status is only the first path segment under the root; deeper folders … are grouping, never status, and still count."* | ✅ parses as status `archive`, grouping `deprecated` → counted |

**Precedent:** `work/archive/` already holds 8 cards (TECH-135, DECISION-029, CHORE-131,
CHORE-132, DOCS-133 + supporting files). The pattern is in use and working today.

**⚠️ Constraint — the one way to get this wrong:** deprecated must live **under `work/`**.
A sibling root such as `project-hub/deprecated/` falls outside the old scanner's four scan
folders, is invisible to it, and reopens the ID-reissue risk. The recursion under `work/`
is what makes this safe; there is no archive-specific special case in either engine.

---

## Disposition

### A. Archive — old-framework mechanics, no live subject (23 cards)

**Reason codes.** Named for the *artifact* each card targets, since this repo now has
four command-bearing sets — `.claude/` (the live board's own commands),
`plugins/spearit-framework` (full, v1.0.1), `plugins/spearit-framework-light`
(v1.0.5), and `workspaces/framework` (the dev build, 0.4.6, which IS the new
framework). A generic "plugin" code would not say which.

| Code | Means | Target artifact |
|---|---|---|
| `OLD-PLUGIN` | Work on the two retired marketplace editions | `plugins/spearit-framework{,-light}` |
| `TIER-SYNC` | Exists **only** because the sets were hand-synced; ADR-009's one-copy model dissolves the problem itself | spans `.claude/` + both plugins + `tools/Build-Plugin.ps1` |
| `OLD-ENGINE` | The old board's own command/script set | `.claude/commands/`, `.claude/scripts/` |
| `OLD-DOCS` | Old documentation tree | `framework/docs/`, `framework/CLAUDE.md` |
| `OLD-SETUP` | Old setup + archive distribution, which commands now replace | `Setup-Framework.ps1`, `tools/Build-*.ps1` |
| `OLD-LIFECYCLE` | A `project-hub/` work-item lifecycle the new layout drops | `project-hub/`, old templates |

`TIER-SYNC` is the code worth reading twice on a reversal: those cards are not
merely stale, they are **answered by construction** — the new framework is a single
authored copy, which is the outcome they were asking for.

| Card | Code | One-line reason |
|---|---|---|
| TECH-182 | OLD-DOCS | Retire `framework/CLAUDE.md` + quick-reference — files are maintenance-only |
| TECH-183 | OLD-DOCS | Repoint `framework.yaml` phantom pointers — old-tree references |
| TECH-158 | OLD-DOCS | Stale links in `framework/INDEX.md` (33 links to an obsolete layout) |
| TECH-187 | OLD-DOCS | Restatement audit of `framework/docs/` (12,109 lines) |
| TECH-100 | OLD-DOCS | Split `workflow-guide.md` into three |
| TECH-067 | OLD-DOCS | Consolidate AI sections into `workflow-guide.md` |
| TECH-058 | OLD-DOCS | DRY cleanup across old collaboration docs |
| TECH-101 | OLD-DOCS | Project-definition SsoT pattern in old `framework.yaml`/README |
| FEAT-102 | OLD-DOCS | Create `framework/docs/collaboration/project-guide.md` |
| FEAT-103 | OLD-DOCS | Create `framework/docs/collaboration/developer-guide.md` |
| feature-004 | OLD-DOCS | Visual diagrams for old framework docs |
| feature-009 | OLD-DOCS | Stale-doc checker over old docs tree |
| feature-010 | OLD-DOCS | Enterprise framework documentation |
| feature-012 | OLD-DOCS | CONTRIBUTING.md for old distribution |
| feature-013 | OLD-DOCS | Migration guide from other frameworks |
| feature-014 | OLD-DOCS | FAQ for old distribution |
| BUGFIX-045 | OLD-SETUP | Bash/Write/Edit permissions for old setup flow |
| FEAT-107 | OLD-SETUP | System requirements doc for old distribution |
| DOCS-134 | OLD-SETUP | Split release processes per product (old 3-product model) |
| feature-019 | OLD-SETUP | Release checklist template for old process |
| FEAT-024 | OLD-LIFECYCLE | Renumber checkpoint-policy steps 7.5/8.5 — that policy is retired |
| TECH-048 | OLD-LIFECYCLE | Remove small-team references from old docs |
| FEAT-034 | OLD-SETUP | Projects showcase for old distribution |

### B. Record the finding, then archive (1 card)

These carry a conclusion worth keeping. **Write the finding into the card, then move it** —
archiving unread loses the answer.

| Card | Finding to record before archiving |
|---|---|
| TECH-172 | **PARTIALLY DONE.** Its own re-scope note says the surviving half is dispositioning DECISION-035/036/110/162/171 — which *this card completes*. Record that, then archive. |

### C. Keep on the board (58 cards) — C1 gates, C2 product ideas, C3 re-earn, C4 command/plugin/script, C5 hooks, C6 board conventions

**C1 — Kanban gate design, needed at the D5 crossover (F1).** The new engine has no kanban
gates; these are its design input, not dead work:
TECH-166 (readiness false-positives), TECH-168 (Completed-date backstop), TECH-055
(transition validation), TECH-114 (WIP enforcement hook), TECH-098 (auto-branching).
*(TECH-177 is already in `todo/` and stays — same class.)*

**C2 — Product ideas, unbuilt in both frameworks (F4).** No old-framework dependency
beyond path naming:
FEAT-047 (team ID collision), FEAT-092 (sprints), FEAT-093 (planning-period archival),
FEAT-104 (velocity tracking), FEAT-089 (project-type patterns), FEAT-090 (coding
patterns), FEAT-052 (task-based templates), TECH-083 (model-selection guidance).

**C3 — Re-earn candidates flagged in the roadmap.** Keep in place until their replacement
card is written, so nothing is lost in the gap:
FEAT-180 (documentation as a done-gate rule — cheapest to adopt), FEAT-115 (`/fw-tour`),
FEAT-157 (provenance stamp, useful at graduation).

**C4 — Command, plugin, script, and hook cards — HOLD until the artifact crosses over
(Gary, 2026-09-02).** The migration is roughly a third done: the new build ships **5**
commands (`fw-move`, `fw-contacts`, `fw-new-workspace`, `fw-new-ops-record`,
`fw-new-kb-domain`) against the old set's **11**. Ten have not crossed over —
`/fw-status`, `/fw-wip`, `/fw-backlog`, `/fw-next-id`, `/fw-help`, `/fw-release`,
`/fw-roadmap`, `/fw-swarm`, `/fw-topic-index`, `/fw-session-history`.

**The rule: if a card is about a command, a plugin, a script, or a hook — including an
update to an underlying script — it holds.** Paths in these cards are stale; the design
thinking is not, and it is the requirements input for rebuilding that artifact.

| Card | Artifact it informs |
|---|---|
| TECH-102 | **The strongest case.** Not really a perf card — it is a *design record for commands that do not exist yet*: four architectural options **with the rejection rationale** (Claude-reads-directly rejected at 2–4× tokens; lighter runtime; JSON cache; MCP server), plus a per-command requirements table naming what each must do (`/fw-status` counts files, `/fw-next-id` scans 50+, `/fw-topic-index` parses YAML). Six of its eight commands are unbuilt. |
| TECH-161 | Complete midnight-rollover spec for `/fw-session-history` — bidirectional "Continued from"/"Continued on" cross-references. The card itself anticipates this: *"If DECISION-162 later consolidates these copies to a single source, this fix lands in that source instead."* |
| TECH-072 | The session-history **template format** the new command will need |
| TECH-080 | Release step in session history — same command |
| TECH-169 | `/fw-move` reconciliation; carries the verified finding that cache isolation forces inline embedding |
| DECISION-162 | Command-tier sync — four options with analysis; the drift inventory is its evidence |
| SPIKE-178 | `${CLAUDE_PLUGIN_ROOT}` invocation — **answered yes**, and the new build depends on that answer |
| FEAT-179 | Create-gate derivation pattern (SoT + templates + engine into a channel at build) |
| BUG-174 | Dotfile-inflated WIP count — the new engine has no WIP count *yet*; it will |
| FEAT-124 | `/about` command — plugin identity/version surface |
| FEAT-125 | Configurable paths — "how does a command find conventions in a non-framework repo?" is live for a distributed plugin |
| FEAT-138 | `/review`, `/refactor`, `/poc` guidance commands |
| FEAT-148 | `/preflight` — the standalone pre-implementation review |
| TECH-160 | `Build-Plugin.ps1` execution model (forward-slash zip entries) |
| FEAT-028 | Release automation script |
| feature-007 | Framework validation script |
| feature-008 | Upgrade automation script |
| FEAT-111 | Data-driven setup questions — setup script design |
| FEAT-112 | Setup script edge cases (no git, alternative VCS) |
| FEAT-051 | Update test harness — regression testing the update mechanism |
| DECISION-110 | README-FIRST — updates `Build-FrameworkArchive.ps1` |
| CHORE-133 | Marketplace submission process — the distribution channel the new plugin will use |
| TECH-176 | Template rename — touches the build's template copy step |

**C5 — Hook cards — HOLD (Gary, 2026-09-02).** Hooks are the mechanism half of the
Single-Source Rule; the new build already ships `hooks/hooks.json` +
`refresh-contacts.sh` and `tools/pre-commit`, so this design is actively in use.

| Card | Subject |
|---|---|
| TECH-096 | Enforcing policy for **manual** (non-Claude) operations — native git hooks vs Claude hooks, with the trade-off analysis. The new build's `tools/install-git-hooks.sh` is one answer to it; the card holds the options |
| TECH-114 | WIP-enforcement hook (already C1) |
| TECH-168 | `Completed`-date pre-commit hook (already C1) |

*Checked and excluded — NOT a C5 member:* `FEAT-107` mentions hooks only as a listed
prerequisite inside a system-requirements doc; it is not hook work. It **stays in
Section A** (archive). Named here so a later reader does not re-litigate it.

> **Findings still to be recorded on four held cards.** SPIKE-178, DECISION-162,
> TECH-096 and DECISION-110 were in Sections B/D (record-then-archive) before the
> command/plugin/script/hook rule pulled them back onto the board. They **stay**, but
> their findings should still be written into the cards so the answer is not
> re-derived later:
> - **SPIKE-178** — ANSWERED YES. `${CLAUDE_PLUGIN_ROOT}/scripts/*.sh` is used in all
>   five new-build commands and `hooks/hooks.json`. Record and close the *question*;
>   keep the card as the invocation-pattern record.
> - **DECISION-162** — ADR-009 selects Option C by construction (one authored copy).
>   Record that as the decision with rationale; the card stays as the tier-sync
>   analysis for whenever a second channel reappears.
> - **TECH-096** — partially answered by the new build's `tools/pre-commit` +
>   `install-git-hooks.sh`; the card holds the remaining options.
> - **DECISION-110** — no live subject, but it edits `Build-FrameworkArchive.ps1`, so
>   it holds under the script rule.


**C6 — Board conventions the new build has not defined yet — HOLD (final scan,
2026-09-02).** Gary: *"Are there any cards in the deprecated list that might apply to
the new framework?"* Yes — 13. The trap in this group is that each one *reads* like an
old-framework docs task ("Document X policy"), so the type-and-title heuristic filed
them as dead. What they actually contain is the **definition of a board convention the
new build will need the moment the kanban namespace goes live (ADR-009 D5)** — and the
new build has defined none of them.

**Verified against `workspaces/framework/` this scan:**
- `templates/records/` holds **only** `contact.md`, `ops-record.md`, `ts-case.md` —
  there is **no work-item template of any kind**. Every convention a board item needs
  (fields, naming, numbering, cross-references) is currently undefined.
- `fw-move.sh:6` already names **"child items"** as a thing the engine treats as
  grouping — but nothing anywhere defines what a child item *is*. TECH-082 is that
  definition.
- Grep for a never-delete/archival policy in the new build's `CLAUDE.md`, `README.md`
  and scripts: **no match.** TASK-218 is *itself* honouring a policy the new build has
  not written down.

| Card | What the new build needs it for |
|---|---|
| TECH-082 | Defines parent/child work items — a concept `fw-move.sh:6` **already references** but nothing defines |
| TECH-041 | Supporting-files naming for files sharing a parent ID — the new build's artifact-bundle (`<ID>/`) convention is the same problem, only partly specified |
| TECH-027 | Cross-reference convention for items that move between folders — unchanged problem in the new layout |
| FEAT-021 | Work-item numbering + naming standards, incl. hierarchical sub-ids and ID exhaustion. `fw-next-id.sh` implements a sequence but no card defines the *naming* rules around it |
| TECH-033 | Status-field-vs-folder redundancy. The new build **chose** location-is-status; this card is the analysis behind that choice and the record of what `Status:` is for (if anything) |
| TECH-077 | Never-delete / archive-only policy — **unwritten in the new build**, though TASK-218 is following it right now |
| FEAT-030 | A hold/paused state for board items. Operations has `onhold/`; the **kanban** namespace has no equivalent defined |
| TECH-070 | Issue-response process (triage → assess → decide → resolve) — process design, not old-framework mechanics |
| TECH-070.1 | Its validation sub-task; travels with TECH-070 |
| TECH-071 | Session handoff checklist — the new build has session history but no start/end checklist |
| TECH-073 | External-reference template — the new build has no equivalent template |
| TECH-049 | Human-AI concurrent-work handoff, esp. around git operations — unchanged by ADR-009 |
| TECH-044 | Work-item **creation** policy (create in backlog, promote when committed). The new build's create gates cover workspaces/ops/contacts; the board's creation policy is undefined |
| TECH-078 | Release archival — done items → `history/releases/vX.Y.Z/`. The new build has **no release tooling at all** (`tools/` holds only git-hook installers) and its own CHANGELOG already archives to that path |
| FEAT-149 | Meeting-record transparency standard for AI participants. The new build **scaffolds `meetings/` folders** in both the floor and operations templates but ships **no meeting-record template** — this is the content standard for one |
| DECISION-171 | The `fw-` namespace rule for artifacts in user-shared folders — **the new build follows this convention** (every command and script is `fw-*`), so it is the live rationale, not a dead decision |

**Why these differ from Section A's survivors.** The cards still in A propose edits to
*specific old files* (`framework/docs/…`, `framework/INDEX.md`, `Setup-Framework.ps1`) —
the file is the deliverable, and the file is dead. C6's cards define *conventions*; the
old paths in them are incidental, and the convention is what carries over.

**Also keep:** FEAT-139 (`claude-project.yaml`) — superseded in *mechanism* by the plugin
model, but its underlying question (how does a command find project conventions in a repo
that isn't framework-shaped?) is live for the new build. Re-scope rather than archive.

### D. Already-resolved decisions — archive with their resolution noted (2 cards)

| Card | Note |
|---|---|
| DECISION-035 | Root status reference — no live subject (old `PROJECT-STATUS.md`) |
| DECISION-036 | **Already Resolved** in-card by DECISION-050 (embedded framework model) |

### E. Re-scope for the new build — decided 2026-09-02 (Gary)

Both sat in `todo/` while the roadmap classed them deprecated. **Neither is archived.**
Both are re-scoped against `workspaces/framework/` and stay on the board.

| Card | Pri | Decision |
|---|---|---|
| **BUG-181** | High | **Re-scope for new build.** The *old* starter template is dead, but the question survives it: does the collaboration contract actually reach a generated workspace? The new build authors its own `CLAUDE.md` and generates workspace scaffolds — so the same failure mode (a project created by the framework ships without the contract) is reachable and untested. |
| **FEAT-175** | Med | **Re-scope.** The new build has create gates for workspaces, ops records, and contacts — but **no `fw-new` for board items**. The kanban namespace is an empty policy slot (ADR-009 D5), and its create gate is exactly this card's subject. It becomes the crossover's create gate. |

**Re-scope means, for each:** rewrite Summary/Problem/Scope against
`workspaces/framework/` paths, drop the old-tree acceptance criteria, and keep the
original ID and the reasoning that earned it. This is card surgery, not a new card —
the history stays attached.

**Sequencing.** FEAT-175's re-scope should wait for, or land with, the D5 board
crossover — writing a board create gate before the board namespace is active would be
speculative. BUG-181's can be done as soon as someone generates a workspace and checks
what its `CLAUDE.md` contains. Neither is in scope for TASK-218, which only archives;
the re-scoping is separate work on cards that never leave the board.

---

## Reconciliation (recomputed 2026-09-02, after the final gotcha scan)

Board = `backlog/` + `todo/` + `doing/` = **109** cards (including this one).

| | Count |
|---|---|
| A — archive | 23 |
| B — record finding, then archive | 1 |
| D — resolved decisions, archive | 2 |
| **Moving (A+B+D)** | **26** |
| C — keep on board (C1–C6 + FEAT-139) | 58 |
| E — re-scoped, stay on board | 2 |
| Live roadmap D1–D7 cards | 22 |
| TASK-218 (this card) | 1 |
| **Staying** | **83** |
| **Total** | **109** ✅ |

Verified mechanically each pass: every move-set id resolves to a file; no id appears in
two sections; 109 − 26 = 83.

**How the move set shrank, and why each cut was right**

| Pass | Moving | What changed |
|---|---|---|
| Roadmap D8 (summary-level) | ~75 | Grouped by type + title; recommended a bulk move |
| After reading all cards in full | 66 | F1–F4: kanban gates unbuilt, SPIKE-178 answered, DECISION-162 undecided, product ideas ≠ deprecated |
| After *"keep any plugin/command/script card"* | 42 | C4 (24 cards) — the migration is a third done; 10 of 11 commands unbuilt |
| After *"keep hook cards"* | 42 | C5 — TECH-096 held (TECH-114/168 already held) |
| After *"anything that might apply to the new framework?"* | **26** | C6 (16 cards) — board conventions the new build has not defined |

**The pattern across every pass:** the summary-level heuristic (type + title + the paths a
card names) systematically over-archived. A card titled *"Document X policy"* whose Files
Affected line names `framework/docs/…` looks dead, but the *policy* is the deliverable and
the file is incidental. The three surviving classes — commands not yet ported (C4), hooks
(C5), and undefined board conventions (C6) — all failed that heuristic identically.

**What the 26 survivors have in common:** each names a **specific dead file** as its
deliverable — `framework/docs/collaboration/workflow-guide.md`, `framework/INDEX.md`,
`framework/CLAUDE.md`, `Setup-Framework.ps1`, or a doc that only ever described the old
distribution. The file *is* the deliverable, and the file is not coming back.

**Post-move expectation:** `backlog/`+`todo/` = 82 (+1 in `doing/`),
`archive/deprecated/` = 26, `Get-NextWorkItemId.ps1` returns **219** before and after.

---

## Reversal Procedure

To bring a card back:

```bash
git mv project-hub/work/archive/deprecated/<CARD>.md project-hub/work/backlog/
```

Then remove the `**Deprecated:**` stamp and re-scope the card against
`workspaces/framework/` before working it — the archived text describes old-framework
paths and will mislead if taken at face value. Its ID is still unique and was never
reissued (see ID Safety above).

**If you are reversing several, read Findings F1–F4 first** — they explain what the
original grouping got wrong and are the most likely reason a card deserves to come back.

---

## Acceptance Criteria

- [x] `project-hub/work/archive/deprecated/README.md` exists — purpose, reversal procedure,
      pointer to this card
- [x] All Section A cards moved via `git mv` (not `Move-Item`/`cp`), each carrying a
      `**Deprecated:** 2026-09-02 — <reason>` stamp
- [x] Section B (TECH-172) finding written into the card before the move
- [x] All Section D cards moved with their resolution noted
- [x] Section C cards verified still on the board — 16 spot-checked across C1–C6, none wrongly archived
- [x] Section E resolved by Gary (2026-09-02): BUG-181 and FEAT-175 both **re-scoped, not archived** — they stay on the board
- [x] `ROADMAP-DELIVERABLES.md` D8 updated — the "bulk-move" recommendation replaced by a
      pointer to this card's disposition table
- [x] Next-ID unchanged: **219 before, 219 after** — ID safety confirmed in practice
- [x] Board count reconciles: 109 before = 83 after + 26 archived ✅

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

- [x] **PRE-IMPLEMENTATION REVIEW COMPLETED** (2026-09-02). Three rulings from Gary:
      (1) Section E — BUG-181 + FEAT-175 re-scoped, not archived. (2) `PLUGIN-TIER`
      too generic with four command-bearing sets; split into `OLD-PLUGIN` /
      `TIER-SYNC` / `OLD-ENGINE`. (3) **Keep every command, plugin, script, and hook
      card** while the migration is mid-flight — move set 66 → 42
- [x] Baseline recorded: next-ID **219**; backlog 97 / todo 11 / doing 1
- [x] Created `archive/deprecated/` + README.md (68 lines)
- [x] Section B: finding written into TECH-172 (the one remaining B card)
- [x] Section A + B + D: 26 cards stamped and `git mv`d — git tracked all 26 as renames
- [x] Verified: next-ID 219→219, Section C untouched, counts reconcile
- [x] Updated ROADMAP-DELIVERABLES.md D8
- [x] `/fw-move 218 done`

---

## Documentation

| Surface | What it must say |
|---|---|
| `archive/deprecated/README.md` | What lives here, why, and the reversal procedure |
| `ROADMAP-DELIVERABLES.md` D8 | Points at this card instead of recommending a bulk move |
| Each archived card | Carries its own `**Deprecated:**` reason line |

---

## Related

- `project-hub/planning/ROADMAP-DELIVERABLES.md` — D8 is this card's input; its bulk-move
  recommendation is **retracted here** (see Findings)
- `project-hub/history/sessions/2026-09-02-SESSION-HISTORY.md` — Decisions #1, #3, #5
- **TECH-172** — the re-scope note establishing the old framework as maintenance-only;
  its surviving half (disposition the open `DECISION-*` items) is completed by this card
- **ADR-009** — the workspace model and fresh-build-in-place decision
- **ADR-006** — disk-discovery ID model, which is why archived cards still count
