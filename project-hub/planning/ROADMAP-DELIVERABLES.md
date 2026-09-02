# SpearIT Framework — Deliverable Roadmap

**Created:** 2026-09-02
**Basis:** all 108 open cards (`backlog/` 96, `todo/` 11, `blocked/` 1) grouped by
deliverable, ranked by what gets the ADR-009 build from **0.4.6 → 1.0**.
**Companion to:** [`ROADMAP.md`](ROADMAP.md) — that one is theme-based and predates
ADR-009 (last updated 2026-02-17). This one is deliverable-based and current.

> **Grouping rule.** A *deliverable* is one thing a user gets — a capability they can
> name. Cards of every type (FEAT/BUG/TECH/TASK/SPIKE/DECISION) that serve the same
> user-visible capability sit together, regardless of which folder they are in.

---

## The Frame

Two frameworks exist in this repo:

| | old | new |
|---|---|---|
| **Lives in** | `framework/`, `templates/`, `plugins/`, `tools/` | `workspaces/framework/` |
| **Version** | v5.6.0 (2026-08-24) | 0.4.6 |
| **Status** | **maintenance-only** — confirmed by TECH-172's 2026-08-24 re-scope note: *"the old framework is maintenance-only (v5.6.0); its doc, template, and plugin straggler edits below are dead work."* | the live build (ADR-009, Accepted 2026-08-18) |
| **Model** | archive ships the structure; 3 hand-synced tiers (framework + 2 plugin editions) | the framework **is** the plugin; commands build the structure (ADR-009 D3) |

Everything below is ranked against one goal: **graduate `workspaces/framework/` to a
1.0 that replaces the old framework on live client work.**

---

## Ranked Deliverables

### D1 — The Spine: Board, Operations, and kb at Root
**Rank 1 · 5 cards · all in `todo/`**

The repo-root structure the whole model rests on. Everything else assumes these paths
are settled, so churn here is the most expensive churn available — it is first for that
reason alone, not because it is the largest.

| Card | Folder | Pri | What |
|---|---|---|---|
| TASK-213 | todo | Med | Operations moves out of `workspaces/` to root, as a peer queue beside the board |
| TASK-214 | todo | Med | `Workspace:` field on ops records — restores the scoping the root move removes |
| TASK-216 | todo | Med | `kb/` moves to root; framework gains a multi-source list (local + N external corpora) |
| BUG-215 | todo | Med | New move engine dropped batch moves (`fw-move 001,002,003 todo`) — regression vs old engine |
| TECH-177 | todo | Low | Obsidian checkbox states `[ ] [x] [/] [-]` + gate awareness in `fw-move.sh` |

**Why first:** TASK-213/216 relocate two top-level trees. Every command, script, and
doc that names a path is downstream. BUG-215 is a live regression on the single most-used
command. TECH-177 rides along because it edits the same `fw-move.sh` gate functions.

**Ready?** TASK-213/214/216 were filed 2026-09-01 and are freshly specified. Start here.

---

### D2 — Knowledgebase That Stays Trustworthy
**Rank 2 · 3 cards**

The kb is the asset with the longest half-life and the one Gary named as most at risk:
*"The long term viability of the kb is the biggest challenge in my opinion. […] Without
some means to flag potentially out of date info makes the kb unreliable."* (2026-09-01)

| Card | Folder | Pri | What |
|---|---|---|---|
| TASK-217 | todo | **High** | Staleness/provenance metadata — make the provenance rule a mechanism, not prose |
| FEAT-209 | todo | **High** | Sub-topic depth: `<domain>/<subtopic>/` with provenance folders at the leaf (decided: option (b), UAT-23) |
| TASK-216 | todo | Med | *(shared with D1 — the multi-source half belongs here)* |

**Why second:** an unreliable kb is worse than no kb, and every day of accumulated
content raises the cost of retrofitting provenance. TASK-217 is the ADR-008
*prose→mechanism* pattern applied to the kb.

---

### D3 — Command UX Good Enough to Hand Over
**Rank 3 · 3 cards**

Everything in D3 works today; none of it *feels* finished. This is the gap between
"the script runs" and "a person who is not Gary can use it."

| Card | Folder | Pri | What |
|---|---|---|---|
| FEAT-210 | todo | **High** | New-build command UX pass — all UAT 2026-08-26..29 findings, grouped by command |
| FEAT-211 | backlog | Med | Contact grammar rework: title vs function, `;` delimiter, batch assign |
| FEAT-191 | backlog | Med | Guided purpose intake for `/fw-new-workspace` — 3–4 questions, not one vague one |

**Why third:** this is the 1.0 quality bar. FEAT-210 is explicitly the collected UAT
findings and says *"split out any item that grows past a session's work"* — expect it
to spawn cards.

---

### D4 — Reporting, Roadmaps, and History Per Workspace
**Rank 4 · 4 cards**

ADR-009 makes the repo the *customer*, hosting many workspaces. The reporting layer has
not caught up: one board, one history, one roadmap — none of them sliceable.

| Card | Folder | Pri | What |
|---|---|---|---|
| FEAT-163 | todo | Med | Workspace-aware reporting and history (rewritten 2026-08-18 for ADR-009) |
| FEAT-196 | backlog | Med | Workspace progress reporting — exec summary + detail from one data set |
| FEAT-198 | backlog | Med | Per-workspace roadmaps — `/fw-roadmap` for repo-is-the-customer |
| feature-015 | backlog | Low | Executive summary reporting (A4 stakeholder output) — folds into FEAT-196 |

**Why fourth:** this is what a contractor shows a client. It needs D1's `Workspace:`
field settled first (TASK-214), which is why it sits behind the spine.

---

### D5 — Troubleshooting, Proven on Real Work
**Rank 5 · 3 cards**

`fw-troubleshoot` shipped (FEAT-202) and is the only skill in the new build. It was
built against fixtures.

| Card | Folder | Pri | What |
|---|---|---|---|
| TASK-205 | backlog | **High** | Dogfood on three real cases, then retro — *"the first three real incidents will rewrite it more than any amount of design"* |
| FEAT-203 | backlog | Med | Domain playbooks — "first five minutes" cookbook entries read at rung 6 |
| FEAT-204 | backlog | Med | Diagnostic collector scripts — pre-scrubbed evidence bundles as products |

**Why fifth:** TASK-205 is High and cheap, but it is **demand-driven** — it fires when
Honda/Toyota/SpearIT-internal sends the next real problem, not on a date. Treat it as
standing readiness that jumps the queue when a case arrives. FEAT-203/204 should wait
for its retro; building playbooks before the retro risks building the wrong shape.

---

### D6 — Time: Deadlines, Reminders, Calendar
**Rank 6 · 2 cards**

| Card | Folder | Pri | What |
|---|---|---|---|
| FEAT-199 | backlog | Med | Deadline awareness — surface dated obligations before they are late |
| FEAT-200 | backlog | Med | Schedule reminders + calendar view, layered above FEAT-199 |

**Why sixth:** genuinely new capability, coherent as a pair, but nothing else depends on
it and the framework is usable without it. FEAT-199 first — FEAT-200 explicitly layers
on it. Post-1.0 candidate.

---

### D7 — The ADR-008 Guards (carried forward, needs rewriting)
**Rank 7 · 4 cards · ⚠️ written against old paths**

These are the two root causes from ADR-008 — hand-synced duplication, and enforcement
written as prose. **The principles are permanent and already binding** (they are the
Single-Source Rule in the root `CLAUDE.md` and in `workspaces/framework/CLAUDE.md`).
The *cards* audit the old tree.

| Card | Folder | Pri | Fate |
|---|---|---|---|
| TECH-189 | backlog | **High** | **Re-earner.** The failing drift gate. The new build's whole design assumes it. Rewrite against `workspaces/framework/`. |
| TECH-186 | backlog | **High** | **Re-earner.** Chokepoint audit — every invariant behind a script. The new build has 7 scripts and 2 hooks to audit. |
| TECH-188 | backlog | **High** | **Partial re-earner.** "Test the built artifact" survives; but the new build publishes by junction, not archive, so the mechanism differs. |
| TECH-185 | backlog | **High** | **Mostly deprecated.** The duplication sweep inventoried the old 3-tier tree. The new build has one copy by construction — that *was* the fix. Keep only if a fresh sweep of `workspaces/framework/` is wanted. |

**Recommendation:** rewrite TECH-189 and TECH-186 as new cards scoped to the new build;
close TECH-185 as superseded-by-construction; re-scope TECH-188 to the junction publish
path. Do this *before* 1.0 — these are the guards that stop the onion regrowing.

---

### D8 — Deprecated: Old Framework, Templates, Plugins, Tools
**Rank 8 · ~75 cards · no work planned**

Every card below is written against `framework/`, `templates/`, `plugins/`,
`tools/`, or `project-hub/` structure that the ADR-009 build replaces. Per TECH-172's
re-scope note these are **dead work** unless individually re-earned.

**Dissolved by construction** — the new build has one copy, so the sync problem is gone:
DECISION-162 (command-tier sync), TECH-169 (reconcile `/fw-move` copies), FEAT-179
(plugin create-gate parity), TECH-160 (align plugin build model), SPIKE-178 (can a
plugin invoke its own script), FEAT-124 (plugin about), FEAT-125 (configurable paths),
FEAT-138 (plugin dev guidance), FEAT-148 (plugin preflight), CHORE-133 (plugin
submission follow-up), BUG-174 (dotfile count in old `fw-move.sh`).

**Old-framework docs and structure** — target files are maintenance-only:
TECH-182, TECH-183, TECH-158, TECH-187, TECH-100, TECH-102, TECH-067, TECH-058,
TECH-101, BUG-181 (starter CLAUDE.md — the new build's `CLAUDE.md` is authored fresh),
FEAT-102, FEAT-103, feature-004, feature-009, feature-010, feature-012, feature-013,
feature-014.

**Old setup/distribution tooling** — the commands build the structure now:
BUGFIX-045, FEAT-051, FEAT-107, FEAT-111, FEAT-112, FEAT-115 (`/fw-tour`), FEAT-157
(provenance stamp), feature-007, feature-008, DOCS-134, FEAT-028, feature-019.

**Old workflow policy cards** — many already implemented in the new engine, others
about a `project-hub/` lifecycle that no longer exists:
FEAT-021, FEAT-024, FEAT-030 (hold folder — new build has `onhold/`), FEAT-047,
FEAT-092, FEAT-093, FEAT-104, TECH-027 *(already marked Cancelled)*, TECH-033,
TECH-041, TECH-044, TECH-048, TECH-049, TECH-055, TECH-070, TECH-070.1, TECH-071,
TECH-072, TECH-073, TECH-077, TECH-078, TECH-080, TECH-082, TECH-096, TECH-098,
TECH-114, TECH-161, TECH-166, TECH-168, TECH-172, TECH-176.

**Decisions with no live subject:** DECISION-035, DECISION-036 *(already resolved by
DECISION-050)*, DECISION-110, DECISION-171 *(already Accepted)*.

**Guidance content, possibly re-earnable later as skills:** FEAT-052, FEAT-089,
FEAT-090, FEAT-139 (`claude-project.yaml` — superseded by the plugin model),
FEAT-149 (virtual staff transparency), FEAT-180 (mandatory `## Documentation`
section — *worth re-earning*, it is a create-gate/done-gate rule the new build could
adopt cheaply), FEAT-034, TECH-083.

**Recommendation:** bulk-move D8 to an `archive/deprecated/` bucket in one pass rather
than dispositioning 75 cards individually. Flag the three I'd re-earn as fresh cards:
**FEAT-180** (documentation as a gate), **FEAT-115** (`/fw-tour` for the new build),
**FEAT-157** (provenance — still useful when the plugin graduates).

---

### D9 — Blocked, External
**Rank — · 1 card · not schedulable**

| Card | Folder | What |
|---|---|---|
| BUG-144 | blocked | Anthropic plugin command namespace collision — [issue #26906](https://github.com/anthropics/claude-code/issues/26906). Platform fix required. Monitor only. |

Note: this one is *not* deprecated by ADR-009 — the new framework ships as a plugin, so
the collision risk applies to it too.

---

## Sequence

```
NOW      D1 spine ──► D2 kb trust ──► D3 command UX ──► 1.0
              │
              └────► D4 reporting (needs TASK-214)

STANDING D5 troubleshooting — jumps the queue when a real case arrives
BEFORE   D7 guards — rewrite TECH-189 + TECH-186 against the new build
1.0
LATER    D6 time/calendar
ONCE     D8 deprecation sweep — one bulk move, three re-earned cards
```

**The one-line answer:** finish the spine (D1), make the kb trustworthy (D2), polish the
commands (D3) — that is 1.0. Rebuild the two ADR-008 guards (D7) before you call it
1.0, or the onion grows back.

---

## Resolved Questions (2026-09-02)

1. **D8 destination — `project-hub/work/archive/deprecated/`.** Location is the
   status, so the cards move rather than gaining a `Deprecated:` field.
   **ID safety verified against both engines:**
   - Old (live for this board) — `Get-NextWorkItemId` in
     `framework/tools/FrameworkWorkflow.psm1:276` scans `work`, `releases`, `poc`,
     `history/spikes` with `-Recurse`, matching any `[A-Za-z]+-NNN` basename
     generically. `work/archive/deprecated/` is under `work/`, so it is counted.
     `work/archive/` already holds 8 cards today — the pattern is in use and working.
   - New — `workspaces/framework/scripts/fw-next-id.sh:33` scans the namespace root
     recursively. Its own header states the rule: *"status is only the first path
     segment under the root; deeper folders … are grouping, never status, and still
     count."* `archive/deprecated/` reads as status `archive`, grouping `deprecated`.

   **Constraint:** deprecated must live **under `work/`**. A sibling root such as
   `project-hub/deprecated/` would be invisible to the old scanner and would risk
   ID reissue.

2. **Card-by-card review before archiving — required, not optional.** D8 is a
   *proposed* bucket. Before any card moves, read it for content that outlived the
   old framework; anything that survives is re-written as a fresh card against
   `workspaces/framework/` **first**, and only then is the original archived. The
   three pre-flagged re-earners (FEAT-180, FEAT-115, FEAT-157) are candidates, not
   the finished list. The same rule governs D7's TECH-189/186/188/185.

3. **D5 trigger — no live case.** Troubleshooting is development-stage; TASK-205
   does not jump the queue. D5 stays at rank 5.
