# Session History: 2026-07-08

**Date:** 2026-07-08
**Participants:** Gary Elliott, Claude Code
**Session Focus:** Implement TECH-173 (ADR-006 work-item type taxonomy) — then a taxonomy
sanity-check that reshaped the outcome

---

## Summary

Implemented TECH-173 (the mechanism for ADR-006's work-item type system), then subjected the
taxonomy to an industry-standards sanity-check that **reduced the canonical set from 8 types to 5**
and **replaced the authored legacy list with a disk-derived model**. Two follow-ups filed (FEAT-175,
TECH-176). TECH-173 is implemented, verified by dogfooding, and awaiting review to move to done/.

---

## Work Completed

### TECH-173: Enforce Accepted Work-Item Types (implement ADR-006)

Started from the pre-implementation review gate. The work evolved through **three framings** in one
session — the journey matters here, so it's documented below rather than just the end state.

**Phase 1 — Pre-implementation review exposed a mis-scope (create-not-move).**
- The item (and ADR-006 D6's wording "create/move engine") implied wiring type enforcement into
  `fw-move.sh`. Grounding in the actual code showed this was wrong: a move operates on an
  *already-created* file, so it can never introduce a bad type, and gating it would wrongly reject
  legacy `DECISION-*`/`BUGFIX-*` items.
- **Correction:** type enforcement belongs at **creation, not move**. `fw-move.sh` stays
  type-agnostic. The deterministic create gate (D6) split out to **FEAT-175** (`/fw-new`), which
  ADR-006 D7 had already named as separate work.
- Also discovered: the full framework has **no create command** at all (only the AI-driven plugin
  `new.md`); `Build-FrameworkArchive.ps1` Step 1.6 shipped `*.sh` only and would have dropped the
  new SoT; and `FrameworkWorkflow.psm1`'s hardcoded `$validPrefixes` was **incomplete** (omitted
  DOCS/CHORE/REFACTOR/TASK etc.) — a latent max-ID bug.

**Phase 2 — Built the mechanism (SoT + build-ship + DRY).** Authored the SoT, shipped it via the
full-framework build, and DRY'd every human-facing type list to agree with it. Created the 4 missing
templates so types↔templates matched (per Gary: "the types and templates should match"). Deferred
the FEATURE/TECHDEBT template *rename* (40+ references) to **TECH-176**.

**Phase 3 — Taxonomy sanity-check (Gary's prompt: "do our definitions and usage match industry
standards?") reshaped the result.** See Decisions below. Net effect: 8→5 types, disk-derived legacy,
SoT format simplified from `.tsv` to `.txt`. ADR-006 amended accordingly.

**Final delivered state:**
- **Accepted set (5):** FEAT, BUG, TECH, TASK, SPIKE — authored in
  `.claude/scripts/work-item-types.txt` (newline-delimited, `#` comments, case-insensitive).
- **Legacy = disk-derived:** any on-disk prefix (within work-item folders) not in the accepted set
  is legacy by definition — recognized for parsing, never offered for creation. Nothing legacy is
  authored or shipped; new projects carry zero baggage.
- **`FrameworkWorkflow.psm1`:** `Get-WorkItemTypeData` reads the accepted set (+ tiny fixed
  spelling-alias map FEATURE→FEAT/BUGFIX→BUG/DOC→DOCS/TECHDEBT→TECH); max-ID scan now matches
  prefixes generically off disk (fixing the latent incomplete-list bug).
- **`Build-FrameworkArchive.ps1`:** ships `work-item-types.txt` (Step 1.6b).
- **DRY:** workflow-guide (type table→5, ID-namespace prose, collision-scan glob→generic),
  plugin `new.md` + `skills/work-items.md` + light `README` (both editions) reconciled to 5.
- **Templates:** added `TASK-TEMPLATE.md`; deleted retired `DECISION-TEMPLATE.md`;
  DOCS/CHORE/REFACTOR templates were created in Phase 2 then removed in Phase 3 (fold into TECH).

**Verification (dogfooded against this repo):**
- psm1 live: 5 accepted; legacy discovered = BUGFIX, CHORE, DECISION, DOCS, FEATURE; `DECISION-042`
  normalizes to itself (not rewritten to ADR); next ID = 177.
- `fw-move.sh` moved a real legacy `DECISION-035` end-to-end, then restored.
- Rebuilt archive ships `.claude/scripts/work-item-types.txt` (no stray `.tsv`); zip reverted for
  release.

---

## Decisions Made

1. **Type enforcement is at creation, not move (create-not-move correction).**
   - `fw-move.sh` stays type-agnostic; the deterministic gate lives in `/fw-new` (FEAT-175).
   - **Rationale:** a move can't introduce a bad type; gating it would only mis-reject legacy items.

2. **Canonical type set reduced 8 → 5: FEAT, BUG, TECH, TASK, SPIKE** (amends ADR-006 D1).
   - Dropped DOCS, CHORE, REFACTOR (fold into TECH); reinstated TASK.
   - **Rationale — usage data:** FEAT (105) and TECH (65) dominate all 239 items; every other type
     was ≤6 uses, with CHORE/REFACTOR/DOCS overlapping ("work on the system"). **Simplicity:** the
     framework is a simple file-based Kanban; a type only picks a prefix/template (drives no
     automation), so fine discrimination has little payoff. **Interop:** researched Jira & GitHub —
     both default to Feature/Bug/**Task**; neither ships CHORE/REFACTOR/SPIKE as a default *type*
     (labels instead). So TASK earns its place (tracker-standard, HPC/Jira-link precedent), TECH
     stays (2nd-most-used; product-vs-internal distinction; maps to a Jira Task + `tech-debt` label),
     SPIKE stays (unmergeable research lifecycle + `poc/` handling).
   - **Considered and rejected:** rolling TECH into TASK (would dissolve the 2nd-most-used type into
     the least-used — 65 vs 2); dropping SPIKE for TASK only (SPIKE is distinct, TASK is the vague
     bucket — so keep both).

3. **"Legacy" is disk-derived, not an authored list** (amends ADR-006 D2/D4/D5).
   - **Gary's insight ("this thing is like an onion"):** legacy is *this repo's* accumulated history;
     a new project created from the distribution has none, so shipping a legacy list imposes our
     baggage as their default.
   - **Gary's algorithm:** "if I find an item type not in the list, that item is by definition a
     legacy item." Adopted — recognized set = accepted ∪ prefixes-found-on-disk. Self-scaling, no
     list to maintain, nothing legacy shipped.
   - **Consequence:** the SoT ships the **accepted set only**, as a flat newline-delimited **`.txt`**
     (the TAB/alias columns of the old `.tsv` design became obsolete). A small fixed spelling-alias
     map stays in the tooling (closed set, not history).

4. **Type matching is case-insensitive** (uppercase canonical, lowercase accepted) — Gary's call.

5. **Dogfooding caught a scan-boundary subtlety.** A broad diagnostic wrongly surfaced `ROADMAP`
   (fw-roadmap output) and `TEST` (test fixtures) as "legacy types." Root cause was the *diagnostic*
   scanning the whole repo; the framework's `Get-NextWorkItemId` already scopes to work-item folders
   (`work/`, `releases/`, `poc/`, `history/spikes/`), which correctly excludes them. **No code fix
   needed** — the boundary reasoning is now documented in ADR-006 (2026-07-08 amendment). Gary
   flagged both false positives; verified ROADMAP lives in `history/archive/` and TEST fixtures under
   `history/releases/.../TECH-094/`, neither in the scan path.

---

## Files Modified

- `framework/tools/FrameworkWorkflow.psm1` - `Get-WorkItemTypeData` rewritten (accepted-from-file +
  fixed alias map); generic case-insensitive disk-scan for max-ID; comments updated.
- `tools/Build-FrameworkArchive.ps1` - Step 1.6b ships `work-item-types.txt` (was `.tsv`).
- `framework/docs/collaboration/workflow-guide.md` - type table → 5; ID-namespace prose;
  collision-scan glob → generic; per-template sections (TASK kept, DOCS/CHORE/REFACTOR folded, DECISION retired).
- `plugins/spearit-framework/commands/new.md` + `plugins/spearit-framework-light/commands/new.md` -
  valid types → 5.
- `plugins/spearit-framework/skills/work-items.md` + light edition - types section → 5, TECH absorbs note.
- `plugins/spearit-framework-light/README.md` - type list + table → 5.
- `project-hub/research/adr/006-work-item-type-taxonomy.md` - amended D1 (8→5), D2 (disk-derived
  legacy + scan-scope note), D5 (`.txt`), top banner, footer.
- `framework/CHANGELOG.md` - Added/Changed/Removed entries for the 5-type/.txt/disk-derived model.
- `project-hub/work/doing/TECH-173-...md` - re-scope notes (create-not-move; 8→5), struck moved-out
  items, checked completed ACs/checklist.

## Files Created

- `.claude/scripts/work-item-types.txt` - the accepted-set SoT (FEAT/BUG/TECH/TASK/SPIKE).
- `framework/templates/work-items/TASK-TEMPLATE.md` - template for the reinstated TASK type.
- `project-hub/work/backlog/FEAT-175-fw-new-deterministic-create-gate.md` - the deterministic create
  gate (D6) split out of TECH-173.
- `project-hub/work/backlog/TECH-176-rename-work-item-templates-to-canonical-prefixes.md` -
  FEATURE→FEAT / TECHDEBT→TECH template rename (40+ refs; coord TECH-158).

## Files Removed

- `framework/templates/work-items/DECISION-TEMPLATE.md` - DECISION retired to the ADR series.
- (Transient) `DOCS/CHORE/REFACTOR-TEMPLATE.md` - created in Phase 2, removed in Phase 3 when the set
  was cut to 5 (fold into TECH). Never committed.

---

## Current State

### In done/ (awaiting release) — 4 items
- BUG-167, BUG-170, FEAT-165, TECH-079 (from prior sessions). Unchanged this session.

### In doing/
- **TECH-173** — implemented, verified, documented. Awaiting review to move to done/.

### In backlog/ (new this session)
- **FEAT-175** — `/fw-new` deterministic create gate + plugin `Build-Plugin.ps1` SoT derivation.
- **TECH-176** — rename FEATURE/TECHDEBT templates to canonical prefixes.

### In research/adr/
- **ADR-006** — Accepted, **amended 2026-07-08** (8→5, disk-derived legacy, `.txt`).

---

## Next Steps

1. **Move TECH-173 → done/** (via `/fw-move`, stamps Completed) once review is accepted.
2. **FEAT-175** — build the deterministic create gate (the real home of D6 enforcement); it also
   carries the deferred plugin `Build-Plugin.ps1` SoT derivation.
3. **TECH-176** — template rename (coordinate with TECH-158 stale-links).
4. **Release** the 4 done/ items (+ TECH-173) via `/fw-release` when ready.

---

## Known Issues / Follow-ups

- **BUG-174 (backlog, prior session)** — WIP/final-move count in `fw-move.sh` includes `.gitkeep`.
  Untouched this session.
- **Generic prefix matching is folder-scoped, not shape-validated.** A stray non-work-item `WORD-NNN`
  file placed *inside* a scanned folder would still match. Risk is low (pre-existing design; the
  scan folders are curated), documented in ADR-006. Revisit only if it bites.

---

## Session Close

Long, productive session. TECH-173's real value emerged through iteration: a create-not-move
correction, then a standards-driven simplification (8→5) and an elegant disk-derived legacy model
that keeps new projects baggage-free. Dogfooding against this repo's messy history validated the
model and caught (then dismissed, correctly) a scan-boundary scare. Committing all work now.

---

## Addendum — TECH-173 moved to done/ (later)

After committing the implementation, ran `/fw-move 173 done`. The done-gate hard-blocked on 5
unchecked `- [ ]` lines — but all 5 were **struck-through items deliberately moved out**
(to FEAT-175/TECH-176) or **superseded** (the old YAML-enum spec), not real pending work. The gate
can't read `~~strikethrough~~`; it only distinguishes `[ ]` from `[x]`.

**Decision (new work filed):** rather than a one-off cleanup, adopt the established Obsidian
checkbox-state convention. Filed **TECH-177** (Low) to implement `[ ]`/`[x]`/`[/]`/`[-]` with
gate-awareness: the **done-gate** should block on `[ ]` **and** `[/]` (in-progress), while `[x]` and
`[-]` (cancelled) pass; readiness-gate stays `[ ]`-only (no value blocking a *queue* move on an
in-progress subtask); `[?]`/`[!]` documented as recognized-but-deferred blocking markers. Researched
the ecosystem — the four core states are the right scope; `[>]`/`[*]`/etc. duplicate signals we
already have (DECIDE marker, `blocked/` folder) or are decorative.

**For TECH-173 now:** per Gary, marked the 5 struck items `[x]` to unblock (the honest `[-]` state
arrives with TECH-177), added a note in TECH-173 explaining why, then moved to done/. Completed date
auto-stamped 2026-07-08. done/ now holds 5 items (under the release-nudge threshold).

### Files (addendum)
- **Created:** `project-hub/work/backlog/TECH-177-checkbox-state-convention.md`
- **Moved:** `TECH-173-...md` doing/ → done/ (Completed stamped)
- **Modified:** TECH-173 file (5 struck items `[ ]`→`[x]`, added checkbox-convention note)

### Current State (updated)
- **done/ (5):** BUG-167, BUG-170, FEAT-165, TECH-079, **TECH-173**
- **doing/:** empty
- **backlog/ (new this session):** FEAT-175, TECH-176, **TECH-177**

---

**Last Updated:** 2026-07-08 (TECH-173 moved to done/)

---

## Addendum 2 — Queued next work + commit-on-create decision (session close)

Set up the next slice of work and settled a small policy question, then called it a day.

**Queued FEAT-175 + TECH-177 → todo/.** Both tripped the readiness-gate (unchecked acceptance
criteria — normal for un-started items — plus false-positive `DECIDE`/`todo` **prose** matches in
TECH-177, e.g. "the DECIDE marker", "→ todo/backlog"). Verified the marker hits were descriptive,
not real unresolved markers, and moved both with `--force`. Per the `→ todo` path the move needs no
commit, but the staged renames were committed explicitly (see below) at Gary's request.

**Decision — new work items should be committed at creation.** Gary: "New work items should be
auto committed... that should be added to fw-new criteria." Agreed, with two refinements:
- This is a **creation** concern (`fw-new`), **not** a move concern. `fw-move` deliberately
  auto-commits only `→ done`/`→ archive`; todo/doing/backlog moves stay lightweight/batchable. The
  gap was that FEAT-175/TECH-177 were *created* earlier folded into other commits — so the fix
  belongs in FEAT-175 (the create command).
- **Prompt, not silent (for now).** Start with a commit prompt (default-yes) once the item is fully
  drafted and settled — matching today's plugin `new.md` Step 8 — and tighten to silent auto-commit
  later only if the prompt becomes annoying. Added to FEAT-175 as desired-state item 4, an AC, and a
  checklist step.

### Files (addendum 2)
- **Moved:** `FEAT-175-...md`, `TECH-177-...md` backlog/ → todo/
- **Modified:** `FEAT-175-...md` (added commit-on-create requirement)

---

## Session Close (final)

Full day across three commits, all on `main`:
- `d36e5e8` — TECH-173 implementation (5-type taxonomy, disk-derived legacy, `.txt` SoT)
- `4871b70` — TECH-173 → done/; filed TECH-177 (checkbox convention)
- `9920f77` — queued FEAT-175 + TECH-177 to todo/; added commit-on-create to FEAT-175

The session's throughline: **make the implicit explicit and enforce it structurally.** TECH-173
started as "enforce a type list" and, through iteration, became a much cleaner system — 5 types
grounded in usage + interop, legacy discovered from disk (zero baggage for new projects), enforcement
correctly located at creation. Two dogfooding moments (the scan-boundary scare, the strikethrough
done-gate block) each surfaced a real refinement and one new work item (TECH-177).

**Resume here next session:**
- **doing/ is empty.** todo/ has FEAT-175, TECH-177, TECH-172, FEAT-092/163/164.
- **FEAT-175** (`/fw-new` deterministic create gate) is the natural next build — it's the real home
  of ADR-006 D6 enforcement, carries the deferred plugin `Build-Plugin.ps1` SoT derivation, and now
  the commit-on-create requirement. Its checklist opens with a pre-implementation review gate.
- **TECH-177** (checkbox convention) is a small, self-contained alternative — would let future items
  express cancelled criteria honestly (`[-]`) instead of the `[x]`-workaround used on TECH-173.
- **done/ holds 5** (BUG-167, BUG-170, FEAT-165, TECH-079, TECH-173) — under the release-nudge
  threshold, but a `/fw-release` is available whenever you want to ship them.

---

**Last Updated:** 2026-07-08 (session close)
