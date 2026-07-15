# Tech Debt: Repoint `framework.yaml` SoT and Fix Phantom `CLAUDE.md` Step Pointers (ADR-007)

**ID:** TECH-183
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-07-15
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Framework Consistency

---

## Summary

Three small, mechanical reference defects surfaced by ADR-007, split out of BUG-181 because they are
independent, low-risk, and touch different files than the delivery fix: (1) `framework.yaml:76` routes the
`ai-checkpoint-policy` SoT into `framework/CLAUDE.md` (the file ADR-007 D2 deletes); (2) `framework.yaml:79`
(repo root) points `project-structure` at `PROJECT-STRUCTURE-STANDARD.md`, **which does not exist**; (3)
`workflow-guide.md` cites *"CLAUDE.md Step 7.5"* and *"Step 9"* in four places — **steps that have never
existed in any file** (D7 established there is no such workflow).

None of these block ADR-007 acceptance (already Accepted), and none block BUG-181. This is cleanup.

---

## Problem Statement (all verified via ADR-007, 2026-07-13/14)

**1. `framework.yaml:76` → a file being deleted.**
```
ai-checkpoint-policy: framework/CLAUDE.md#ai-workflow-checkpoint-policy-critical---adr-001
```
The framework's own SoT index points at `framework/CLAUDE.md`. ADR-007 resolves the target: the checkpoint
policy's **authority is ADR-001** (D7 — ADR-001 decided the one checkpoint and stands unrewritten);
`CLAUDE.md` is only its *delivery*. Repoint at ADR-001, not at any `CLAUDE.md` copy.

**2. `framework.yaml:79` (repo root) → a nonexistent file.**
```
project-structure: framework/docs/PROJECT-STRUCTURE-STANDARD.md
```
The real file is `framework/docs/PROJECT-STRUCTURE.md`. `/fw-topic-index` reads this block, so the repo's
topic index currently resolves to a missing file. **`templates/starter/framework.yaml` already has it
right** — the distribution's config is more correct than the framework's own; fix the repo's to match.

**3. `workflow-guide.md` phantom step pointers.**
- `:212` and `:1760` cite *"CLAUDE.md Step 9"*
- `:2246` and `:2290` cite *"CLAUDE.md Step 7.5"*

`workflow-guide.md` has **5 phases**; ADR-001 has **8 steps**; there is no 7.5 and no 9 anywhere. These
point into a workflow that has never existed. Per D7, repoint each to `fw-move.md` (the pre-implementation
review / done-gate that actually owns the behavior) or inline the content.

---

## Scope

**In scope:** the three defects above, verified and repointed.

**Out of scope:**
- Deleting `framework/CLAUDE.md` itself → **TECH-182**. (This item only fixes the *pointer* at
  `framework.yaml:76`; if TECH-182 runs first and already repointed it, mark this sub-item done.)
- The names "Step 4 / 7.5 / 8.5" as a *set* → their retirement is D7's; this item only fixes the dangling
  *pointers* to them.

---

## Straggler Inventory (VERIFY AT IMPLEMENTATION TIME — line numbers drift)

- [ ] `framework.yaml:76` (repo root) — `ai-checkpoint-policy` → `research/adr/001-…` anchor
- [ ] `framework.yaml:79` (repo root) — `project-structure` → `framework/docs/PROJECT-STRUCTURE.md`
- [ ] `framework/docs/collaboration/workflow-guide.md` — `:212`, `:1760` ("Step 9"); `:2246`, `:2290`
      ("Step 7.5") → repoint to `fw-move.md` or inline
- [ ] Grep `PROJECT-STRUCTURE-STANDARD`, `Step 9`, `Step 7.5` repo-wide to catch any siblings

---

## Acceptance Criteria

- [ ] `framework.yaml:76` no longer points at `framework/CLAUDE.md` (→ ADR-001)
- [ ] `framework.yaml:79` points at an existing file; `/fw-topic-index` resolves `project-structure`
      cleanly
- [ ] No `workflow-guide.md` reference to a nonexistent "Step 7.5" or "Step 9" remains
- [ ] Grep clean for `PROJECT-STRUCTURE-STANDARD`, `Step 7.5`, `Step 9`
- [ ] `framework/CHANGELOG.md` updated (patch)

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED**
- [ ] Repoint `framework.yaml:76` → ADR-001 (verify the anchor exists in `001-…md`)
- [ ] Fix `framework.yaml:79` → `PROJECT-STRUCTURE.md`; confirm against `templates/starter/framework.yaml`
- [ ] Repoint the four `workflow-guide.md` phantom pointers → `fw-move.md`
- [ ] Grep clean; CHANGELOG updated

---

## Documentation

<!-- Dogfooding FEAT-180 (mandatory documentation section). -->

| Surface | What it must say | Audience |
|---|---|---|
| `framework/CHANGELOG.md` | SoT pointers corrected; phantom step references removed | upgraders |

---

## Related

- **ADR-007** (Accepted 2026-07-15) — surfaced all three defects (`framework.yaml:76` in Negative
  Consequences; `:79` as a "bonus, found while verifying"; the phantom pointers in D7).
- **ADR-001** — the checkpoint policy; the correct target for `ai-checkpoint-policy`.
- **TECH-182** — deletes `framework/CLAUDE.md`. Coordinate on `framework.yaml:76`: whichever item runs
  first repoints it; the other marks that sub-item done.
- **BUG-181** — the ADR-007 anchor. This item is independent of it (can run before, after, or in parallel).

---

**Last Updated:** 2026-07-15
