# Session History: 2026-09-01

**Date:** 2026-09-01
**Participants:** Gary Elliott, Claude Code
**Session Focus:** BUG-212 completion — verify the contact create gate against the installed plugin, then close the refresh gap that verification surfaced (0.4.4 → 0.4.6)

---

## Summary

BUG-212's last acceptance criterion required verification against the built plugin.
Getting there meant committing the pending 0.4.4 auto-refresh work, clearing a stale
plugin install record, and running UAT-13's name-only case on the installed plugin —
which passed. The verification run then surfaced a real gap: a contact record edited
outside Claude Code left `CONTACTS.md` stale for the rest of the session. No open card
covered it, so it was folded into BUG-212 and fixed in 0.4.5 with a `SessionStart`
refresh. 0.4.6 renamed the manual regen to `/fw-contacts refresh`, and UAT-30..32 were
back-recorded so the three refresh paths are numbered tests rather than prose.

---

## Work Completed

### BUG-212: Contact create gate seeds placeholder tokens → **done**

- Verified the create gate on the **installed** plugin in `framework-uat` (0.4.4):
  `/fw-contacts Wilma Flintstone` produced a valid name-only record — display name
  title-cased from the slug, all other fields blank, `Assigned: Unassigned`, no `__`
  tokens. Registry-wide grep for `__` clean across all five records.
- Scope extended mid-session to cover stale views after an outside-Claude edit (see
  Decisions #1). Fixed in 0.4.5; criterion added and ticked.
- Moved to `done/` via `/fw-move` (Completed date stamped automatically).

### 0.4.4 — CONTACTS.md auto-refresh from both ends (committed, was pending)

- `hooks/hooks.json` + `hooks/refresh-contacts.sh` (PostToolUse), `fw-contacts.sh
  --check`, `tools/pre-commit`, `tools/install-git-hooks.sh`.
- `--check` verified green against `framework-uat`. Note it exits 1 in *this* repo by
  design — the framework source tree has no `workspaces/kb/company`, so it has no
  contacts to check. Relevant if `--check` is ever wired into CI here.

### 0.4.5 — SessionStart refresh

- `hooks.json` gains `SessionStart` (`startup|resume|clear`) running
  `refresh-contacts.sh --all`: skips the stdin `file_path` parse, resolves the repo root
  via `git rev-parse`, regenerates unconditionally.
- Verified by direct invocation: outside-Claude edit picked up; no-registry repo silent
  at exit 0; non-git directory silent at exit 0; PostToolUse path and its
  unrelated-file no-op unregressed. Later confirmed live by Gary at session start.

### 0.4.6 — `/fw-contacts refresh`

- Self-documenting name for what was the bare argument-less form (which still works).
- Follows `/fw-move`'s existing bare-`sweep` keyword convention.
- `refresh` reserved in that slot; a person named Refresh is addressed by slug
  (`/fw-contacts refresh-smith`). Documented in the command file.

### UAT-30..32 back-recorded

- Numbered tests added to section C: PostToolUse refresh on a Claude edit; outside-Claude
  edit *not* caught mid-session (expected, not a defect); `/fw-contacts refresh`.
- Results marked back-recorded with per-observation provenance. **These have never been
  executed as written, start to finish** — they describe what was observed, not a clean
  run. Worth an actual pass in a restarted `framework-uat` session.

---

## Decisions Made

1. **Fold the outside-edit refresh gap into BUG-212 rather than file a new card.**
   - Checked first: no open card in `backlog/`, `todo/`, or `doing/` covered it.
   - Gary's call — "if not, just extend BUG-212, fix it and move on." Arguably out of
     BUG-212's original create-gate scope, but filing a card to immediately close it
     added ceremony without adding information.

2. **Reject `FileChanged` as the mechanism for outside-edit detection.**
   - It is the hook designed for this, but its matcher takes literal filenames from a
     narrow character set (letters, digits, `_`, `|`) and cannot express "any record in
     `contacts/`" when filenames are arbitrary person-slugs. Docs also leave its
     watch-list construction and payload unspecified.
   - `SessionStart` chosen instead: documented, sufficient, and the earliest boundary at
     which an outside edit can be caught. Revisit if `FileChanged` semantics change.

3. **No real-time filesystem watcher.**
   - Gary: a contacts list changes mostly at project start and very little mid-project,
     so a watcher is disproportionate to the problem.
   - Accepted contract: Claude edits refresh themselves; `/fw-contacts refresh` is the
     mid-session catch-up; session start and pre-commit are the backstops.

---

## Corrections Recorded

Both are written into `UAT-RESULTS-2026-08-26.md` so the record isn't misleading:

1. **`fw-contacts.sh` is not case-buggy.** It was briefly mis-diagnosed as having a
   case-sensitivity/overwrite defect after an `Assigned: Widget` record produced a view
   missing that contact. A `bash -x` trace showed the parse and write paths are sound —
   `Widget` and `widget` are the same directory on Windows, and the two `WSLIST` passes
   overwrote each other. Diagnosis was made from a code read before running the script;
   running it first would have avoided the error.
   - **Real latent risk noted for FEAT-211:** on a case-sensitive filesystem the same
     record yields a genuinely separate `Workspace/` directory, and two assignment
     spellings resolving to one directory silently clobber each other.

2. **Our `hooks.json` schema is correct.** A subagent reported that a plugin's
   `hooks/hooks.json` should not wrap the event map in a top-level `"hooks"` key. The
   official docs show the wrapper *is* correct for plugins — consistent with the hook
   demonstrably firing. Primary source beat the summary.

---

## Environment Fix

**Stale plugin install records cleared.** `~/.claude/plugins/installed_plugins.json` held
two entries for `spearit-framework-dev@dev-marketplace`, both 0.4.3, both pointing at a
`cache/dev-marketplace/...` directory that does not exist. Gary edited the file (writes
to it were blocked for the AI, and Claude Code appended a duplicate entry mid-session).
The plugin then loaded correctly at 0.4.4 with **no cache directory at all** — a
`directory`-source marketplace resolves in place rather than through the cache, so the
missing directory was never a fault. No defect filed.

---

## Files Modified

- `workspaces/framework/.claude-plugin/plugin.json` — 0.4.3 → 0.4.6
- `workspaces/framework/CHANGELOG.md` — SessionStart refresh; `/fw-contacts refresh`
- `workspaces/framework/commands/fw-contacts.md` — `refresh` keyword, when to use it,
  reserved-word escape hatch; manual-rerun instruction dropped
- `workspaces/framework/scripts/fw-contacts.sh` — `--check` mode
- `workspaces/framework/hooks/hooks.json` — SessionStart entry added
- `workspaces/framework/hooks/refresh-contacts.sh` — `--all` branch
- `workspaces/framework/tests/UAT-COMMANDS.md` — UAT-30..32 + two run-log rows
- `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md` — 2026-09-01 sections
- `project-hub/work/done/BUG-212-*.md` — criteria ticked, scope-extension section
- `claude-local-marketplace/.claude-plugin/marketplace.json` (outside repo) — 0.4.6

## Files Created

- `workspaces/framework/hooks/hooks.json` — plugin hook declaration
- `workspaces/framework/hooks/refresh-contacts.sh` — PostToolUse + SessionStart refresh
- `workspaces/framework/tools/pre-commit` — blocks a commit with stale views
- `workspaces/framework/tools/install-git-hooks.sh` — per-clone hook installer

## Files Moved

- `project-hub/work/doing/BUG-212-contact-create-gate-seeds-placeholder-tokens.md` →
  `project-hub/work/done/`

---

## Commits

- `466114c` feat: CONTACTS.md views auto-refresh from both ends; 0.4.4
- `a850222` fix: Complete BUG-212 — session-start refresh closes the outside-edit gap; 0.4.5
- `8929c1e` feat: /fw-contacts refresh — self-documenting name for the view regen; 0.4.6
- `79853bb` docs: back-record UAT-30..32 — the three CONTACTS.md refresh paths

---

## Current State

### In done/ (awaiting release) — 6 items
- BUG-207, BUG-208, BUG-212, FEAT-193, FEAT-195, TASK-206

### In doing/
- *(empty)*

### Open threads for next session
- **UAT-30..32 never executed as written.** Back-recorded from observation; worth a
  clean pass in a restarted `framework-uat` session.
- **FEAT-211** carries the `Role:` vs per-assignment function work, plus the new
  case-sensitivity risk in `Assigned:` values.
- **CI not wired for `--check`.** Ready to drop into a workflow; `framework-uat` has no
  `.github/`. Note the source repo itself has no contact registry, so `--check` exits 1
  there by design.
- **6 items in done/** — under the 10-item nudge threshold, but a release is approaching.

---

**Last Updated:** 2026-09-01

---

# Afternoon Session — Workspace Model: Do `kb/` and `operations/` Belong in `workspaces/`?

**Session Focus:** Architecture discussion, no implementation. Five cards filed.

---

## Summary

Gary questioned whether `kb/` and `operations/` belong under `workspaces/` at all — "the
fact we had to treat them differently was the first tell," referring to their opting out
of the shared floor and taking no user-chosen name. Discussion concluded **both should
move to the repo root**, for *different* reasons, and produced five cards. Nothing was
implemented; this was a design session.

---

## The Journey (including the reversal)

**First read (Claude): don't move them.** Initial position was that the special-casing
reduces to **cardinality** — both are one-per-repo singletons, so they need no name
argument, and their internal shape differs enough that a floor built for client
engagements does not fit. Moving them would not remove either property, and would cost a
second top-level location every path-resolving script must know about.

**Then we checked what a "workspace" actually means** — Gary's suggestion, and the right
call. `TASK-197-workspace-type-taxonomy.md` (released, v0.4.0) defines four types
discriminated by lifecycle, and **nowhere defines a workspace as client-facing or
engagement-shaped**. So the counter-argument's premise was unfounded.

TASK-197 also supplied what looked like a blocker — **Decision 5**: "one real-world
activity may split across types — that is the taxonomy working," with Toyota app support
decomposing into operations + product + kb as peers. And a stronger principle from the
`sow` removal: **"type must never branch runtime behavior"** (ADR-009 OQ5), whose
implication is to *remove* type-shaped divergence rather than relocate the type.

**On that reading Claude reversed to "don't move them," now with documentary backing.**

**Gary's reframe broke the deadlock:**

> "operations is a lot like kanban. It contains cards/tickets for a variety of
> projects/products. The only difference is in the origin of the card (FEAT, TASK, BUG,
> TECH vs INC, REQ)."

This turned out to be already true in the code: `fw-move.sh` is written as **one engine
with a policy table per namespace**, and `kanban` is a declared namespace with a reserved
slot — commented "so the crossover is a table entry, not a second engine." And ADR-009
**D5** lands the board at `kanban/` **at the repo root** at graduation. So the end state
already has a root-level card queue; operations is a second one with identical structure,
and the only one living inside `workspaces/`.

**Decision 5 survives the move** rather than blocking it: its requirement is that each
part has one home and they *link rather than nest*. Moving both to root keeps them peers
— the peer set becomes "spine things work refers to" rather than "workspaces."

---

## Decisions Made

1. **Operations moves to root, as a peer queue beside the board** (TASK-213).
   - The anomaly is not that operations sits in `workspaces/` — it is that operations is
     a **queue pretending to be a workspace** while its twin sits at root. The floor
     opt-out (FEAT-193) was the symptom: a queue has no `deliverables/` or `agreements/`.
   - Requires an ADR-009 **D2** amendment ("all work is in a workspace"). Argument: a
     queue is an **index of** work, not work — which is why the board was never a
     workspace either.

2. **Separate id sequences per namespace** — INC/REQ independent of FEAT/BUG/TASK/TECH.
   Already how the engine works; D5's warning that a shared ID namespace invites
   collisions is the reason.

3. **Ops records gain `Workspace:`, blank-or-real** (TASK-214).
   - This is what makes root placement *better* rather than merely tidier: today an ops
     record is scoped by living inside `workspaces/operations/`; at root that implicit
     scoping disappears.
   - **Freeform workspace names considered and rejected** (Gary): arbitrary text drifts —
     `honda`, `Honda`, `honda-hpc`, `Honda HPC` become four values and every derived view
     splits silently. Same class as the `Assigned: Widget` casing collision found this
     morning.
   - **Blank is a legal resting state**, not a gap: a ticket may arrive before anyone
     knows where it belongs, belong nowhere, and legitimately close unattached. Forcing a
     value would recreate the trap BUG-212 just fixed.
   - An unresolvable value **warns, does not fail** — matching `fw-contacts.sh`'s live
     `ghost-ws` behaviour.
   - Gary: "we can note somewhere else where the issue relates to." Prose in
     `## What happened` already carries the subject; a general freeform field would be a
     second home for the same fact (ADR-008). A `Related:` field for **record-to-record
     links only** is filed as a proposal, **not decided**.

4. **kb moves to root — different argument from operations** (TASK-216).
   - Operations converged with kanban on **shape**; kb diverges on **scope**. Gary: "the
     kb can apply to any project, product, or topics outside of those… A kb can expand
     very quickly in many directions."
   - Three legs: **scope** (referenced by everything, owned by nothing — one-to-many, not
     peer); **lifecycle** (fails TASK-197's close-test in *both* directions: a product
     persists, a project ends, a kb accretes — which is why FEAT-209 caps depth by
     decree); **locality** (FEAT-210 line 79 already anticipates an external shared
     SpearIT-KB, and **a workspace cannot be somewhere else**).

5. **The framework may reference multiple kbs** (TASK-216): the internal kb, SpearIT-KB,
   and others parallel to it (corporate, web-based), potentially of different shapes.
   SpearIT-KB should be referenceable **from GitHub** so it works off this machine.
   Direction: one authored home + N consulted sources listed in `framework.yaml` —
   mirroring the `reference/`-is-theirs / `research/`-is-ours line one level down.

6. **Local caching of an external kb: not adopted** (Gary) — "over time, the challenge
   becomes what is the current info?" Resolved by TASK-217's metadata: a cache carrying
   retrieval date, source, and upstream version *is* a `reference/` doc with correct
   provenance.

7. **kb staleness is the biggest long-term risk** (Gary), filed **High** (TASK-217).
   - Claude's refinement, accepted: the problem is not that we cannot tell what is old —
     it is that **we do not record what a claim depends on**.
   - **A generic "last reviewed" date is rejected** as the primary mechanism: age is a
     weak proxy in both directions (a 2019 FlexLM recipe may be current; a six-month-old
     Kubernetes note may be dangerous), and an unactionable date trains people to ignore
     the signal.
   - The domain README **already** has the right decomposition — `reference/` stale by
     *release*, `research/` stale by *refutation* — but it is prose, and the plugin's own
     rule says an instruction the AI merely reads is not a guardrail.
   - **Sequencing: staleness before federation.** Searching across N sources whose
     freshness is unknown makes the problem worse.

---

## Files Created

- `project-hub/work/todo/TASK-213-operations-as-root-queue-namespace.md`
- `project-hub/work/todo/TASK-214-workspace-field-on-ops-records.md`
- `project-hub/work/todo/BUG-215-new-move-engine-drops-batch-moves.md`
- `project-hub/work/todo/TASK-216-kb-at-root-and-multi-source-referencing.md`
- `project-hub/work/todo/TASK-217-kb-staleness-provenance-metadata.md`

## Commits (afternoon)

- `07473fe` docs: file TASK-213/214, BUG-215 — operations as a root queue namespace
- `e0ba483` docs: file TASK-216/217 — kb at root, multi-source referencing, staleness

---

## Incidental Finding

**BUG-215 — the new move engine dropped batch moves.** Gary: "before we used to be able
to move multiple cards in one pass using `fw-move 001,002,003 todo`. Now we have to add
the prefix." Investigation split that report in two: **bare numerics still work** (the
new engine maps an empty prefix to operations), but the **batch was lost** — the new
engine hard-requires exactly two arguments where the old one splits on commas and loops.
Recorded because the two are easy to conflate. Must close before the D5 crossover, or the
board loses batch moves at graduation.

---

## Current State (end of day)

### In done/ (awaiting release) — 6 items
- BUG-207, BUG-208, BUG-212, FEAT-193, FEAT-195, TASK-206

### In doing/
- *(empty)*

### New in todo/ — this thread
- TASK-213, TASK-214, BUG-215, TASK-216, TASK-217

### Open threads for next session
- **Nothing implemented from this discussion.** All five cards are design + decisions;
  each carries open questions to resolve before `→ doing`.
- **TASK-213 and TASK-216 should land as ONE migration.** Both change root layout and
  both break the same relative paths (`../kb/company/contacts/` is embedded in every
  generated `CONTACTS.md` and in the ops record template).
- **The workspace type enum drops from four to two** if both land. TASK-197's scenario
  table should be re-checked to confirm `product` and `project` still partition it
  cleanly — that taxonomy took two sessions of scenario walking to settle.
- **Sequencing question, unresolved:** does the root move land before or after the D5
  board crossover? Doing them together is cheaper; doing operations first changes the
  root layout twice.
- **TASK-214 `Related:` field** — proposed, awaiting Gary's call.

---

**Last Updated:** 2026-09-01 (afternoon)
