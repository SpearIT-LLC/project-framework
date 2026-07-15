# Session History: 2026-07-15

**Date:** 2026-07-15
**Participants:** Gary Elliott, Claude Code
**Session Focus:** ADR-007 — write OQ5 (`/fw-init`) into the ADR; run the live `/init` test; close the
`/fw-init` question

---

## Summary

Finished the `/fw-init` investigation carried over from 2026-07-14: wrote its three agreed edits into
ADR-007 (D4 risk note, OQ1 broadening, OQ5 rewrite), then **ran the live `/init` test on this repo** and
folded the observed result back into the ADR. The test confirmed `/init` *suggests rather than
overwrites* — but its suggestions would contaminate the framework region anyway, which **strengthens**
D4's risk note rather than softening it. A candidate "clean win" (undocumented build/test commands)
**dissolved on inspection**: `framework.yaml` already indexes every build script and a testing SoT, so
`/init` was trying to restate in prose what the framework already derives from config — itself more OQ7
evidence.

---

## Work Completed

### ADR-007: OQ5 written into the ADR (three edits, all agreed 2026-07-14, none previously made)

1. **D4 Negative Consequences — `/init` collision added.** Documented behavior recorded first
   (`/init` updates in place, does not regenerate; threat = *contamination* of the framework region, not
   *destruction*; ref bug anthropics/claude-code#21795 as the not-bulletproof caveat). Noted the risk
   **exists independently of whether `/fw-init` is ever built** — the collision is with a *built-in*
   command.
2. **OQ1 broadened + region-owner folded in.** Detection must now cover a *tool* rewriting the file, not
   only a human editing text ("region contaminated / drifted / gone," not just "differs"). `/fw-init` as
   the idempotent region-owner / repair command added as a **candidate mechanism** for OQ1's *repair*
   half — explicitly *not* a replacement for the still-unsolved *detection* half. Version-stamp
   sub-question extended to double as a cheap contamination check.
3. **OQ5 rewritten** from the draft's "does `/fw-init` get filed as a FEAT?" to the resolved direction:
   the four readings (shell-composer / scaffolder / brownfield-adopter / region-owner) collapse — three
   are parked (redundant / waits-on-OQ7 / waits-on-OQ1) and the region-owner reading folds into OQ1.
   **Not filed as a standalone FEAT.** If any parked reading is ever wanted, it is a *different command
   with a different name* — three jobs, three names, not one overloaded `/fw-init`.

Also fixed three stray `USER INSTRUCTIONS` → `PROJECT INSTRUCTIONS` occurrences (residue of 2026-07-14's
D4 rename).

### The live `/init` test (Gary authorized: "Run it now")

**Setup:** snapshotted `CLAUDE.md` bytes to scratchpad (md5 `fe69a147…`); confirmed the untracked
`CLAUDE copy.md` backup was byte-identical (CRLF vs LF was the only diff — normalized md5 matched
`HEAD:CLAUDE.md`). Three recovery paths in place before running.

**Discipline that preserved the experiment:** the `/init` command says *"if there's already a CLAUDE.md,
suggest improvements to it."* Claude followed that literally — analyzed and produced suggestions but
**did not write** — so what we observed is what `/init` *proposes*, with the human deciding whether it
applies. That is precisely the datum the ADR needed.

**Result (verified by md5 before/after):** `CLAUDE.md` **byte-identical** — nothing written. `/init`
**suggests, does not overwrite**, confirming the documented behavior empirically on this repo.

**The finding that matters:** the *suggestions themselves* would contaminate the framework region if
accepted — `/init` wanted to (a) replace the `# Claude Context` heading + Bootstrap block with its own
standard `# CLAUDE.md` prefix, and (b) inline a build/test command section. So the threat is not "`/init`
writes uninvited"; it is that **accepting `/init`'s suggestions *is* the edit**, and `/init` has no
concept of the framework markers when it composes them. The `DO NOT EDIT` banner is the only guard, and
whether a model composing suggestions honors a banner it can see is **still unproven**. → folded into the
D4 note as an observed data point.

### The "build-commands gap" — investigated, then dissolved (Gary drove this)

`/init`'s one substantive-looking hit was that `CLAUDE.md` documents no build/test commands. Claude first
treated this as a clean win worth capturing. **Gary pushed on the premise twice:**

1. *"How do you build/test a Framework? or are we just talking about the handful of executables?"* —
   forced honesty: there is **no compiler, no test runner, no lint**. "Build" = the packaging scripts
   (`Build-FrameworkArchive.ps1`, `Build-Plugin.ps1`); "test" = a **manual** click-through
   (`plugins/TESTING.md`); `Validate-WorkItems.ps1` is wired to nothing (the 8th drift defect). `/init`
   pattern-matched "codebase → must have build+test commands" and would have listed things that don't
   run as if they do.
2. *"Isn't `framework.yaml` the correct place for these pointers?"* — **the decisive correction.**
   Verified: `framework.yaml` already carries them — `release:*.build_script` names all three packagers
   per-channel (`:22/:29/:36`), and `sources.testing` → `framework/docs/collaboration/testing-strategy.md`
   (948 lines, exists). The Bootstrap block already routes the AI to `framework.yaml`. **There was no
   gap.** `/init` wanted to restate in a *document* what the framework already indexes in *config*.

**Outcome:** no work item filed. Recorded in ADR-007 OQ7 as a third-direction confirmation of the
document-vs-executable thread — the reflex of a general tool is to write pointers into prose; the
framework's design is to derive them from a machine-readable index.

---

## Decisions Made

1. **OQ5 resolved — `/fw-init` is not a standalone FEAT.** Its live reading (idempotent region-owner /
   repair command) folds into OQ1 as a candidate *repair* mechanism. The other three readings are parked
   with distinct fates; if wanted, each is a differently-named command. **Rationale:** one name was doing
   four jobs, and the naming collides with the built-in `/init` in a way that only *helps* the
   region-owner reading.

2. **`/init` risk recorded as *contamination via accepted suggestions*, not *destruction*.** The live
   test overturned the earlier (2026-07-14) too-strong "plausibly destroys the region" claim in the
   correct direction, but did **not** produce an all-clear — the suggestion path is the real vector, and
   the banner's effect on a model is unproven.

3. **No build-commands work item.** `framework.yaml` already indexes build scripts and a testing SoT;
   restating them in `CLAUDE.md` is the exact D3 anti-pattern. **Confirmation, not new work.**

---

## Work Completed (Later — OQ2)

### ADR-007: OQ2 resolved → `.claude/framework-contract.md`

**The question:** where the authored-once contract fragment lives, and what it is named. Two hard
constraints: not named `CLAUDE.md`; not swept into the archive as a loose doc.

**Verified the build first** (`Build-FrameworkArchive.ps1`, read in full) so the decision rested on
ground truth, not the ADR's summary:
- Step 3 (`:213-218`) recursively copies **all** of `framework/docs/*` → a fragment there *would* ship.
- Steps 1.5/1.6/1.6b (`:155-207`) copy `.claude/commands/*.md`, `.claude/scripts/*.sh`, and
  `work-item-types.txt` **fresh from canonical** — the author-once/copy-fresh pattern D4's composer
  should join.
- The plugin build (`Build-Plugin.ps1:318`) copies **only** `plugins/{plugin}/*` — pulls nothing from
  the repo root `.claude/` or `framework/`. **So the fragment's location is irrelevant to plugin
  delivery** — that is OQ6's call, cleanly separated from OQ2.
- Drift-guard (`:113-132`) hard-fails the build if `.claude/commands` or `framework/` reappear in
  `templates/starter/` — the framework already treats "same content authored in two editable places" as
  a build error.

**The discussion worked through four sub-questions Gary raised, each sharpening the answer:**

1. *"Is `framework.yaml` going to point to this doc?"* → **No.** `sources:` indexes *runtime* SoTs the
   AI consults while working; the fragment is *build input*, consumed once at composition. The AI never
   reads the fragment at runtime — it reads the assembled `CLAUDE.md`. Pointing `sources:` at it would
   revive the "is the contract in the fragment or in `CLAUDE.md`?" confusion.
2. *"Isn't `CLAUDE.md` the AI contract by Claude's design?"* → Yes — and that is the delivery/authoring
   split. `CLAUDE.md` is the *channel* (auto-loaded); the fragment is the *authored source* of the
   universal part. Not competitors; the fragment is the shared substring of two `CLAUDE.md` files
   extracted to one place.
3. *"Is it duplication or a definitively cleaner construct?"* → **Derivation, not duplication —
   provided the composed region is generated and drift-guarded, never hand-edited.** The test is not
   "does the text appear twice at rest" but "can the two copies drift." Regenerated-every-build copies
   cannot (like a compiler's object files). The build already makes this exact bet three times; the
   drift-guard is the proof. The fragment model *removes* an editable copy (today `framework/CLAUDE.md`
   **and** `starter/CLAUDE.md` are both hand-authored and both ship), it does not add one.
4. **Naming** (Gary's instinct: folder and name should agree; both words — "claude" and "framework" —
   present). Resolved to `.claude/framework-contract.md`: the **folder** supplies *claude*, the **name**
   supplies *framework-contract* (matching the D4 marker `BEGIN FRAMEWORK CONTRACT` word-for-word), both
   words present with no stutter, and **D4's marker text needs no edit.**

**Ripple fixes made in the same pass:**
- D4 decomposition table (`:298`) — placeholder `framework/docs/ref/ai-contract.md` → the resolved
  `.claude/framework-contract.md`.
- `framework.yaml:76` Negative Consequence — now that OQ4 (→D7) *and* OQ2 are resolved, the repoint
  target is known: point `ai-checkpoint-policy` at **ADR-001** (the rule's authority), not at any
  `CLAUDE.md` copy (only its delivery).

---

## Files Modified

- `project-hub/research/adr/007-ai-collaboration-contract-and-claude-md.md` — **OQ5 written in** (D4
  `/init` Negative Consequence + observed live-test result; OQ1 broadened + region-owner mechanism; OQ5
  rewritten to resolved); OQ7 bonus finding appended; 3× `USER INSTRUCTIONS` → `PROJECT INSTRUCTIONS`.
  **OQ2 resolved** (→ `.claude/framework-contract.md`; D4 table `:298` repointed; `framework.yaml:76`
  Negative Consequence sharpened to target ADR-001). Last Updated → 2026-07-15

## Files Created

- `project-hub/history/sessions/2026-07-15-SESSION-HISTORY.md` — this file

## Files Deleted

- `CLAUDE copy.md` — the untracked safety-net backup from 2026-07-14; removed once the `/init` question
  closed (CLAUDE.md verified unchanged first; git covers it at `74442cd`)

---

## Current State

### ADR-007 — **Status: ACCEPTED (2026-07-15)**

**Decided:** D1, D2, D2a, D3, D4, D5, D6, D7. Ratified this session after the OQ2 resolution + a full
read-through that fixed four internal-consistency defects (defect count 7→8, line total ~800→~827,
mis-dated `/init` bullet, stale "pending D4" hedges). Header flipped Proposed→Accepted; no ADR
index/registry exists to sync.

**Open Questions remaining:**
- **OQ1** — detection of a modified contract region. **Now broader** (tool-rewrite, not just human-edit)
  and **now carries a candidate repair mechanism** (region-owner `/fw-init`). Detection half still
  unsolved. Does not block acceptance.
- ~~**OQ2**~~ — **RESOLVED this session** → `.claude/framework-contract.md`. Both constraints met; joins
  the existing `.claude/` build-input pattern; `framework.yaml` deliberately does NOT index it.
- ~~**OQ5**~~ — **RESOLVED this session.** Folded into OQ1; not a FEAT.
- **OQ6** — contract-less plugin channel. D6 supplies evidence it may be a false choice. Does not block.
- **OQ7** — is the framework just a collection of commands? *(flagged, unanswered; gained a third data
  point this session)*

**All substantive OQs are now resolved or explicitly non-blocking. The only thing between ADR-007 and
ratification is a final review pass.**

### In doing/
**BUG-184** — readiness check fix (started this session; not implemented — deferred to next session)

### In todo/
FEAT-092, FEAT-163, FEAT-164, FEAT-175, TECH-172, TECH-177, **BUG-181**

### New in backlog/ (ADR-007 implementation)
**TECH-182** (retire the two contract docs; depends on BUG-181), **TECH-183** (framework.yaml repoint +
phantom pointers)

---

## Next Session / Next Step

**ADR-007 is ratified — the deciding phase is complete. What remains is implementation, which needs work
items** (an ADR decides; it does not implement). Suggested queue:

1. **Re-scope BUG-181** against D4's composition mechanism — it is now an *instance* of the ADR (starter
   `CLAUDE.md` does not deliver the contract). Likely the anchor item.
2. **Author `.claude/framework-contract.md`** (OQ2) — extract the universal contract from this repo's root
   `CLAUDE.md` + the ~8 unique rules D2 salvages; ZERO placeholders (D4 two-stage constraint).
3. **Add the composer step** to `Build-FrameworkArchive.ps1` — literal concat of contract + shell into
   each channel's guarded region (D4 "keep the composer stupid") + drift-guard extension so a hand-edited
   contract region fails the build (OQ2 implementation note (c)).
4. **The D2/D6 deletions** — retire `framework/CLAUDE.md` and `CLAUDE-QUICK-REFERENCE.md`,
   **re-verifying each section against its supposed owner at deletion time** (the ADR's own ⚠️ caution;
   the line counts are not a licence to `rm`). Repoint `framework.yaml:76` → ADR-001. Fix the phantom
   `workflow-guide.md` Step 7.5/9 pointers.
5. **Deferred / non-blocking:** OQ1 (detection mechanism — settle before building in-place upgrade),
   OQ6 (contract-less plugin channel — own ADR), OQ7 (framework-as-commands — own ADR).

---

## Transition to Implementation (Later)

ADR-007 accepted; began queuing the implementation work items one by one (see Next Steps above for the
queue). Work items filed/started this phase are recorded below as they happen.

**Work items filed/moved this phase:**

1. **BUG-181 re-scoped** as the ADR-007 implementation anchor (unblocked; superseded pointer-fix replaced
   with the accepted D1–D7/OQ2 design; real checklist enumerated). Committed `8db29a7`.
2. **TECH-182 filed** — retire `framework/CLAUDE.md` + `CLAUDE-QUICK-REFERENCE.md` (D2/D6), carries the
   re-verify caution; **Depends On BUG-181**.
3. **TECH-183 filed** — repoint `framework.yaml:76`→ADR-001, fix `:79` dead link, fix `workflow-guide.md`
   phantom Step 7.5/9 pointers; independent, mechanical. Both committed `874daf9`.
4. **BUG-181 moved → todo** (`--force` past BUG-184's false positives; committed `4bce1c5`).

### BUG-184 discovered — the readiness check blocks legitimate `→ todo` moves

Moving BUG-181 toward `doing/` exposed a defect in `.claude/scripts/fw-move.sh`. `check_readiness()`
blocked a freshly, thoroughly re-scoped item from even reaching `todo/`, with **three false positives**:
the 11 unchecked implementation-checklist `[ ]` (which are *supposed* to be unchecked), the word "decide"
in prose (matched as a `DECIDE` marker), and Markdown link syntax `[label]` (matched by the placeholder
regex `\[.{3,40}\]`).

**Diagnosis (two root causes):** (a) **miscalibrated greps** — the unchecked-`[ ]` check is the done-gate's
job (already lives correctly in `check_acceptance_criteria`), and the marker/placeholder patterns match
legitimate content; (b) **wrong transition gate** — readiness runs on `→ todo` (blocking *commitment*) and
is absent on `→ doing` (where ADR-007 D7 places the ripeness gate). Filed as **BUG-184** (committed
`d0ae145`). Self-demonstrating: BUG-184's own bug report trips every flag it documents
(`markers: DECIDE Decide TBD TODO decide todo`).

**Root cause confirmed via git:** `check_readiness` entered in `3b9da8d` — **FEAT-145, the
AI→deterministic-`.sh` migration of `/fw-move`.** Gary's hypothesis (*"something we introduced when we
migrated that command to the deterministic script"*) is correct — the blunt greps got teeth when the move
stopped being AI-interpreted.

**Disposition:** BUG-181 and BUG-184 both `--force`d past the check. BUG-184 moved → `todo` → `doing`
(it directly affects Gary's daily workflow, so it jumps the ADR-007 implementation queue). **Left in
`doing/`, not implemented this session** — deferred to next session per Gary.

### The "onion" observation (Gary) — flagged for a full retrospective

Gary: *"We keep moving backwards and deeper… perhaps signs of either we build a complex system with too
many moving parts or we're not prioritizing on the big picture very well. Maybe both."*

**The pattern, named:** today began as "finish a discussion" and produced a ratified ADR + 3 implementation
items + a 4th bug about the tool used to file them. Every action surfaced the next defect. **The tell:**
*not one* of today's items is a feature a client project would use — BUG-181/TECH-182/TECH-183 are documents
*about* the framework; BUG-184 is tooling enforcing the framework's rules *on* the framework. This is the
same drift **OQ7** already named (*"every artifact that rotted is a document"*). The self-referential layers
are cheaper to work on than the client-facing surface, and they generate unbounded legitimate work.

**Candidate lightweight guardrail (Claude's suggestion, not yet adopted):** before starting any item, ask
*"if I finish this, what does a client project get?"* Internal-hygiene items are allowed but may not preempt
mission work. Costs one sentence per item; no tooling. **Deferred to the planned retrospective** — Gary:
*"We'll do a full retrospective and soul searching soon."*

---

**Last Updated:** 2026-07-15
