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

## Files Modified

- `project-hub/research/adr/007-ai-collaboration-contract-and-claude-md.md` — OQ5 written in (D4 `/init`
  Negative Consequence + observed live-test result; OQ1 broadened + region-owner mechanism; OQ5 rewritten
  to resolved); OQ7 bonus finding appended; 3× `USER INSTRUCTIONS` → `PROJECT INSTRUCTIONS`; Last Updated
  → 2026-07-15

## Files Created

- `project-hub/history/sessions/2026-07-15-SESSION-HISTORY.md` — this file

## Files Deleted

- `CLAUDE copy.md` — the untracked safety-net backup from 2026-07-14; removed once the `/init` question
  closed (CLAUDE.md verified unchanged first; git covers it at `74442cd`)

---

## Current State

### ADR-007 — **Status: Proposed** (not yet Accepted)

**Decided:** D1, D2, D2a, D3, D4, D5, D6, D7

**Open Questions remaining:**
- **OQ1** — detection of a modified contract region. **Now broader** (tool-rewrite, not just human-edit)
  and **now carries a candidate repair mechanism** (region-owner `/fw-init`). Detection half still
  unsolved. Does not block acceptance.
- **OQ2** — where the contract fragment lives / what it is named. **NEXT UP this session.** Must not be
  named `CLAUDE.md`; must be excluded from the `framework/docs/` bulk copy (Step 3) or it ships twice.
- ~~**OQ5**~~ — **RESOLVED this session.** Folded into OQ1; not a FEAT.
- **OQ6** — contract-less plugin channel. D6 supplies evidence it may be a false choice.
- **OQ7** — is the framework just a collection of commands? *(flagged, unanswered; gained a third data
  point this session)*

### In doing/
*(empty)*

### In todo/
FEAT-092, FEAT-163, FEAT-164, FEAT-175, TECH-172, TECH-177

---

## Next Session / Next Step

**Immediate:** **OQ2** — name and locate the contract fragment (candidate placeholder was
`framework/docs/ref/ai-contract.md`; the two constraints are the name and the bulk-copy exclusion).

**Then:** ratify ADR-007 (Proposed → Accepted). OQ1/OQ6/OQ7 may remain open — none block acceptance;
OQ2 is the last substantive gap.

---

**Last Updated:** 2026-07-15
