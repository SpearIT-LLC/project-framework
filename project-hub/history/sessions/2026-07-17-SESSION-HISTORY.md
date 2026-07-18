# Session History: 2026-07-17

**Date:** 2026-07-17
**Participants:** Gary Elliott, Claude Code
**Session Focus:** BUG-181 Decision 3 — settled the contract delivery mechanism (compose vs. verify)

---

## Summary

Resolved BUG-181's final open design decision (Decision 3), which had been pending since 2026-07-16.
The session was a design conversation, not implementation — Gary pushed back on the plan as written
and the pushback reshaped it. The contract-delivery model that emerged is materially simpler than the
one carried into the session: **one authored SoT, starter composed from it, root verified against it,
plus a build-time snapshot shipped into the archive as a safety net.** No code or work-item files were
edited — the session ended at the ADR-001 pre-edit checkpoint, with the BUG-181 checklist update
proposed and approved-in-principle but **not yet written** (deferred to tomorrow at Gary's direction).

---

## Work Completed

### BUG-181: Starter CLAUDE.md does not deliver the framework collaboration contract

**Decision 3 fully settled (was PENDING coming in).** Pre-implementation review is now conceptually
complete; the checklist edit that records it is the first task tomorrow.

The session was a walk-through of the runtime execution, driven by Gary's questions. Each question
exposed an imprecision or an over-engineered assumption in the plan-as-written, and the correction
simplified the design. The journey (below) is the point — the end-state alone loses why we got here.

---

## Decisions Made

### Decision 3 — Contract delivery: compose starter, verify root (SETTLED)

**This supersedes the "shells shrink" framing from 2026-07-16, which described the *what* but not the
*mechanism*. The mechanism is what changed this session.**

**Final shape:**

| Artifact | Relationship to contract SoT | Enforcement |
|---|---|---|
| `.claude/framework-contract.md` | **is** the SoT (inert build-input) | authored by hand |
| `templates/starter/CLAUDE.md` region | **composed** from SoT at build | hard-fail drift-guard (copy-fresh) |
| repo root `CLAUDE.md` region | **verified** against SoT | advisory `tools/Check-ContractDrift.ps1` |
| derived project's shipped contract | **snapshot** of SoT at build time | same check ships as a safety-net tripwire |

**Invariant:** the region byte-matches the contract; everything outside the markers is user-owned and
never inspected.

**The shrink (unchanged from 07-16):** summary sections — Key Documents / Framework Documentation /
Project Structure / Workflow Quick Reference — delete from both shells in a one-time manual edit,
because the contract region now owns that knowledge by reference (D3: no summary layers). Root
additionally drops "Which Project Are You Working On?" (D2a).

**How we got here — the journey (preserve this; it is the rationale):**

1. **Started from the 07-16 plan:** contract composed into *both* shells (starter + root, root as
   dogfood). Gary's objection: "we started wanting *one* file to keep current; now there are *two* to
   sync — that adds complexity, not removes it. What am I missing?"

2. **The reframe that dissolved the objection:** the count never went 1→2. Before ADR-007 there were
   **three** hand-synced contract copies (`framework/CLAUDE.md`, `CLAUDE-QUICK-REFERENCE.md`, root
   shell), none in sync — that is the disease. The plan goes **3 hand-synced → 1 authored + N
   machine-derived.** That *is* the simplification. But the exchange surfaced the real question: does
   root need to be *composed* at all, or only *checked*?

3. **Gary's counter-proposal (considered, then refined):** author the contract *between root's own
   markers* (root is the SoT + dogfoods for free), build *extracts* root→starter.
   - **Issue found (load-bearing):** root's region can't be pure contract — it carries repo-specific
     framing (the clearest case: "Which Project Are You Working On?", correct for this repo, wrong for
     a derived project = the D2a leak). A verbatim root→starter extraction would ship repo bytes into
     every new project. Extraction would need transformation → the templating D4 forbids.
   - **Issue Gary valued:** a separate contract file is *not susceptible to random mid-session edits*;
     authoring the SoT inside the live root CLAUDE.md means editing the contract that governs the AI
     doing the editing. Gary kept the separate file specifically to preserve this property.

4. **The synthesis (Gary's, final):** keep the separate contract file as SoT; **build composes starter**
   from it; **a check script verifies root** against it (drift *detection*, not composition). This
   splits compose-from-verify across the two shells — the correct asymmetry, because starter has no
   history to protect and root does. It also dissolves the earlier "nothing guards root" gap: the
   contract file *is* root's upstream, so root drift is now catchable.

5. **Sizing the root check (empirical):** checked `git log --follow -- CLAUDE.md`. Root changes ~monthly,
   always in a deliberate titled commit, no accidental churn. Confirmed Gary's memory that the
   `framework.yaml` idea and a root-CLAUDE.md simplification were the same era (FEAT-037 `ea36a17` /
   bootstrap-block `12142aa`). **Conclusion:** root drift is a rare deliberate-edit risk, not
   constant churn → the check should be **advisory** (flag + human reconciles), not a build-blocking
   hard-fail like starter's copy-fresh guard.

6. **Byte-match scope (Gary):** the check compares only *inside* the markers. Outside the markers is
   presumed intentional user edits and is never inspected.

7. **Ship check + contract into the archive (Gary):** so a new project has the anchor if needed.
   - Roles flip in the derived project: the shipped contract is no longer SoT but a **snapshot** — "the
     contract as it was valid at build time." The check becomes a **safety-net tripwire** ("did
     something clobber your region?"), *not* a governance mechanism imposing framework opinion
     post-scaffold. The derived project owns the snapshot; if they evolve it, the net just keeps
     confirming region == snapshot.

### Decisions 1 & 2 — unchanged (settled 2026-07-16)

- **D1:** manual compose script is the only writer; build verifies only.
- **D2:** contract markers ship unversioned; version stamp deferred to FEAT-157.

---

## Follow-ups Noted (not filed this session)

- **`tools/Check-ContractDrift.ps1`** — new artifact. Home: `tools/`, beside `Build-FrameworkArchive.ps1`
  (Gary's call). Advisory, not hard-fail. Job: region == contract, inside markers only.
- **Archive ships check + contract snapshot** — new build-step scope on top of the 07-16 checklist.
- **FEAT-157 note (provenance):** the shipped snapshot ideally carries a framework-version stamp so a
  derived project knows which era its anchor is from. Nice-to-have, **not** a BUG-181 blocker — same
  seam Decision 2 deferred.

---

## Files Modified

- *(none — design session; no code or work-item edits)*
- `project-hub/retrospectives/2026-07-16-garys-thoughts.md` — carried in from before this session
  (Gary's own edits to yesterday's retro notes); committed with this history.

## Files Created

- `project-hub/history/sessions/2026-07-17-SESSION-HISTORY.md` — this file

---

## Current State

### In doing/
- **BUG-184** — readiness check blocks legitimate `→ todo` moves (untouched again this session; still
  the recommended next *implementation* before BUG-181 enters `doing/`).

### In todo/
- **BUG-181** — Decisions 1–3 **all settled**. Pre-implementation review is conceptually complete but
  the checklist edit recording it is **not yet written** (session ended at the pre-edit checkpoint).

---

## Next Session — continue from here

1. **Write the BUG-181 checklist update** (docs-only edit, already scoped + approved-in-principle):
   - Record Decision 3 in its final compose-vs-verify form.
   - Make the **compose-vs-verify split explicit**: starter is *composed* (hard-fail guard), root is
     *verified* (advisory check) — the current checklist (lines 218–223, 227) implies both shells are
     composed and must be corrected.
   - Add the `tools/Check-ContractDrift.ps1` step.
   - Add the archive ships-check-and-snapshot step.
   - Mark **PRE-IMPLEMENTATION REVIEW COMPLETED** (checklist line 208).
2. **Implement BUG-184** (frees `doing/`, fixes the gate BUG-181 must move through).
3. **Retrospective** when Gary's thoughts doc is ready.

---

**Last Updated:** 2026-07-17
