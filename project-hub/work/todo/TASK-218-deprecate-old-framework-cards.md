# Task: Deprecate the Old-Framework Backlog — Disposition, Archive, and Reversal Record

**ID:** TASK-218
**Type:** Task
**Priority:** Medium
**Version Impact:** None (board hygiene; no framework behaviour changes)
**Created:** 2026-09-02
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
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

### A. Archive — old-framework mechanics, no live subject (56 cards)

Reason codes: **PLUGIN-TIER** = exists only because 3 tiers were hand-synced; ADR-009's
one-copy model dissolves it. **OLD-DOCS** = targets `framework/docs/` or
`framework/CLAUDE.md`. **OLD-SETUP** = targets `Setup-Framework.ps1` / archive
distribution, which commands now replace. **OLD-LIFECYCLE** = about a `project-hub/`
lifecycle the new layout drops.

| Card | Code | One-line reason |
|---|---|---|
| TECH-169 | PLUGIN-TIER | Reconcile 3 `/fw-move` copies — one copy now exists |
| FEAT-179 | PLUGIN-TIER | Plugin create-gate parity — no second edition to reach parity with |
| TECH-160 | PLUGIN-TIER | Align `Build-Plugin.ps1` zip model — no plugin build script in new model |
| FEAT-124 | PLUGIN-TIER | `/spearit-framework-light:about` — that edition is retired |
| FEAT-125 | PLUGIN-TIER | Configurable paths for plugin commands — commands build the structure now |
| FEAT-138 | PLUGIN-TIER | Full-plugin dev-guidance commands — re-earnable later as skills, not as plugin-tier work |
| FEAT-148 | PLUGIN-TIER | `/spearit-framework:preflight` — same; ties to the retired edition |
| CHORE-133 | PLUGIN-TIER | Marketplace submission follow-up for the light plugin (submitted 2026-02-13) |
| BUG-174 | PLUGIN-TIER | `.gitkeep` inflates WIP count in the **old** `fw-move.sh`; new engine has no such count |
| TECH-182 | OLD-DOCS | Retire `framework/CLAUDE.md` + quick-reference — files are maintenance-only |
| TECH-183 | OLD-DOCS | Repoint `framework.yaml` phantom pointers — old-tree references |
| TECH-158 | OLD-DOCS | Stale links in `framework/INDEX.md` (33 links to an obsolete layout) |
| TECH-187 | OLD-DOCS | Restatement audit of `framework/docs/` (12,109 lines) |
| TECH-100 | OLD-DOCS | Split `workflow-guide.md` into three |
| TECH-067 | OLD-DOCS | Consolidate AI sections into `workflow-guide.md` |
| TECH-058 | OLD-DOCS | DRY cleanup across old collaboration docs |
| TECH-101 | OLD-DOCS | Project-definition SsoT pattern in old `framework.yaml`/README |
| TECH-102 | OLD-DOCS | `/fw-*` slash-command performance — old command set |
| FEAT-102 | OLD-DOCS | Create `framework/docs/collaboration/project-guide.md` |
| FEAT-103 | OLD-DOCS | Create `framework/docs/collaboration/developer-guide.md` |
| feature-004 | OLD-DOCS | Visual diagrams for old framework docs |
| feature-009 | OLD-DOCS | Stale-doc checker over old docs tree |
| feature-010 | OLD-DOCS | Enterprise framework documentation |
| feature-012 | OLD-DOCS | CONTRIBUTING.md for old distribution |
| feature-013 | OLD-DOCS | Migration guide from other frameworks |
| feature-014 | OLD-DOCS | FAQ for old distribution |
| BUGFIX-045 | OLD-SETUP | Bash/Write/Edit permissions for old setup flow |
| FEAT-051 | OLD-SETUP | Update test harness over old release archives |
| FEAT-107 | OLD-SETUP | System requirements doc for old distribution |
| FEAT-111 | OLD-SETUP | Data-driven `Setup-Framework.ps1` questions |
| FEAT-112 | OLD-SETUP | `Setup-Framework.ps1` edge cases |
| feature-007 | OLD-SETUP | Validation script for old structure |
| feature-008 | OLD-SETUP | Minimal→Light→Standard upgrade automation (tiers retired) |
| DOCS-134 | OLD-SETUP | Split release processes per product (old 3-product model) |
| FEAT-028 | OLD-SETUP | `framework/tools/release.sh` automation |
| feature-019 | OLD-SETUP | Release checklist template for old process |
| FEAT-021 | OLD-LIFECYCLE | Hierarchical numbering — new build uses one flat shared sequence |
| FEAT-024 | OLD-LIFECYCLE | Renumber checkpoint-policy steps 7.5/8.5 — that policy is retired |
| FEAT-030 | OLD-LIFECYCLE | Add `work/hold/` — new build ships `onhold/` |
| TECH-027 | OLD-LIFECYCLE | Cross-reference convention (**already marked Cancelled**) |
| TECH-033 | OLD-LIFECYCLE | `Status:` field redundancy — new records drop the field; location is status |
| TECH-041 | OLD-LIFECYCLE | Supporting-files naming — new build ships artifact bundles `<ID>/` |
| TECH-044 | OLD-LIFECYCLE | "Create in backlog/" policy for old `workflow-guide.md` |
| TECH-048 | OLD-LIFECYCLE | Remove small-team references from old docs |
| TECH-049 | OLD-LIFECYCLE | Human-AI handoff policy for old docs |
| TECH-070 | OLD-LIFECYCLE | Issue-response process in old `workflow-guide.md` |
| TECH-070.1 | OLD-LIFECYCLE | Validation sub-task of TECH-070 |
| TECH-071 | OLD-LIFECYCLE | Session-handoff checklist for old docs |
| TECH-072 | OLD-LIFECYCLE | Session-history template in `framework/templates/` |
| TECH-073 | OLD-LIFECYCLE | External-reference template in old tree |
| TECH-078 | OLD-LIFECYCLE | Release archival to `project-hub/history/releases/` |
| TECH-080 | OLD-LIFECYCLE | Add release step to old session-history command |
| TECH-161 | OLD-LIFECYCLE | Midnight rollover in the **old** `/fw-session-history` |
| TECH-176 | OLD-LIFECYCLE | Rename `FEATURE-TEMPLATE.md`/`TECHDEBT-TEMPLATE.md` in old tree |
| FEAT-034 | OLD-SETUP | Projects showcase for old distribution |
| FEAT-149 | OLD-LIFECYCLE | Virtual-staff transparency in meeting records (no meeting-record feature in new build) |

### B. Record the finding, then archive (6 cards)

These carry a conclusion worth keeping. **Write the finding into the card, then move it** —
archiving unread loses the answer.

| Card | Finding to record before archiving |
|---|---|
| SPIKE-178 | **ANSWERED: yes.** A plugin can invoke a script in its own cached directory. Demonstrated in production by the ADR-009 build's use of `${CLAUDE_PLUGIN_ROOT}/scripts/*.sh` across 5 commands + `hooks.json`. Close as answered, not abandoned. |
| DECISION-162 | **SUPERSEDED-BY-DESIGN.** Four options were open (`Chosen Option: TBD`). ADR-009 selects Option C by construction — one authored copy, since the framework *is* the plugin. Record that as the decision with rationale. |
| TECH-172 | **PARTIALLY DONE.** Its own re-scope note says the surviving half is dispositioning DECISION-035/036/110/162/171 — which *this card completes*. Record that, then archive. |
| TECH-096 | Enforcing policy for manual (non-Claude) operations. The new build answers this with git hooks (`tools/pre-commit`, `install-git-hooks.sh`) — record the answer, then archive. |
| TECH-077 | Never-delete policy. **Being honoured by this very card** (archive, never delete). Record that the principle is live, then archive the doc-edit task. |
| TECH-082 | Sub-task/parent pattern. New build ships artifact bundles (`<ID>/` moves with its record); the parent/child *item* pattern remains unbuilt — note it as an open idea, then archive the old-docs task. |

### C. Keep on the board — roadmap mis-filed these (18 cards)

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

**Also keep:** FEAT-139 (`claude-project.yaml`) — superseded in *mechanism* by the plugin
model, but its underlying question (how does a command find project conventions in a repo
that isn't framework-shaped?) is live for the new build. Re-scope rather than archive.

### D. Already-resolved decisions — archive with their resolution noted (4 cards)

| Card | Note |
|---|---|
| DECISION-035 | Root status reference — no live subject (old `PROJECT-STATUS.md`) |
| DECISION-036 | **Already Resolved** in-card by DECISION-050 (embedded framework model) |
| DECISION-110 | README-FIRST.txt for old distribution |
| DECISION-171 | **Already Accepted** — `fw-` namespace; the new build follows it |

### E. Open question — needs your call (2 cards, both in `todo/`)

Flagged in the 2026-09-02 session history. Both sit in `todo/` while the roadmap classes
them deprecated — a contradiction that will mislead a future session either way:

- **BUG-181** (Priority: High) — starter `CLAUDE.md` misses the collaboration contract.
  The *old* starter template is dead, but the new build authors its own `CLAUDE.md`, so
  the underlying question (does the contract reach a generated workspace?) may transfer.
  **Recommend:** re-scope to the new build, or archive with that question recorded.
- **FEAT-175** (Priority: Medium) — old `/fw-new` deterministic create gate. The new build
  has create gates (`fw-new-workspace.sh`, `fw-new-ops-record.sh`, `fw-new-contact.sh`)
  but **no `fw-new` for board items** — which the D5 crossover will need.
  **Recommend:** keep, re-scoped as the crossover's create gate.

---

## Reconciliation (verified 2026-09-02)

Board = `backlog/` + `todo/` = **109** cards (including this one).

| | Count |
|---|---|
| A — archive | 56 |
| B — record finding, then archive | 6 |
| D — resolved decisions, archive | 4 |
| **Moving (A+B+D)** | **66** |
| C — keep on board | 18 |
| E — awaiting Gary's call | 2 |
| Live roadmap D1–D7 cards | 22 |
| TASK-218 (this card) | 1 |
| **Staying (C+E+live+self)** | **43** |
| **Total** | **109** ✅ |

Verified mechanically: all 66 move-set ids resolve to a file on the board; no id
appears in two sections; 109 − 66 = 43 and the 43 are exactly C + E + the live
roadmap set + this card.

**Post-move expectation:** `backlog/` + `todo/` = 43, `archive/deprecated/` = 66,
`Get-NextWorkItemId.ps1` returns **219** both before and after.

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

- [ ] `project-hub/work/archive/deprecated/README.md` exists — purpose, reversal procedure,
      pointer to this card
- [ ] All Section A cards moved via `git mv` (not `Move-Item`/`cp`), each carrying a
      `**Deprecated:** 2026-09-02 — <reason>` stamp
- [ ] All Section B cards have their finding written into the card **before** the move
- [ ] All Section D cards moved with their resolution noted
- [ ] Section C cards verified still on the board (none moved by accident)
- [ ] Section E resolved by Gary; both cards dispositioned accordingly
- [ ] `ROADMAP-DELIVERABLES.md` D8 updated — the "bulk-move" recommendation replaced by a
      pointer to this card's disposition table
- [ ] Next-ID unchanged by the move: `Get-NextWorkItemId.ps1` returns the same value
      before and after (recorded in this card)
- [ ] Board count reconciles: cards before = cards after + cards archived

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED** — Gary approves the disposition table,
      resolves Section E, and confirms the reason codes
- [ ] Record `Get-NextWorkItemId.ps1` output **before** any move
- [ ] Create `archive/deprecated/` + README.md
- [ ] Section B: write findings into the 6 cards
- [ ] Section A + B + D: stamp and `git mv` (one commit)
- [ ] Verify next-ID unchanged; verify Section C untouched; reconcile counts
- [ ] Update ROADMAP-DELIVERABLES.md D8
- [ ] `/fw-move 218 done`

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
