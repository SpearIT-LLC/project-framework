# Tech Debt: Adopt Obsidian-Style Checkbox-State Convention (with Gate Awareness)

**ID:** TECH-177
**Type:** Tech Debt
**Priority:** Low
**Version Impact:** MINOR
**Created:** 2026-07-08
**Theme:** Workflow Precision

---

## Summary

Adopt the established (Obsidian Tasks) checkbox-state convention — `[ ]`, `[x]`, `[/]`, `[-]`
(and document `[?]`, `[!]` as recognized-but-deferred) — and teach the `fw-move.sh` gates to
distinguish them. Today the done-gate counts only `[ ]` as incomplete, so a struck-through /
cancelled criterion has to be faked as `[x]` or hidden, and an in-progress `[/]` subtask silently
passes the done-gate. A first-class "cancelled" state (`[-]`) and an in-progress state (`[/]`) that
correctly blocks *done* fix both.

---

## Problem Statement

**What is the current state?** (verified 2026-07-08)

- `fw-move.sh` acceptance-criteria check (`check_acceptance_criteria`) and readiness check
  (`check_readiness`) both count `grep -c '- \[ \]'` — i.e. only the space state `[ ]` is treated as
  incomplete. `[x]`, `[/]`, `[-]` all pass.
- There is **no way to mark a criterion "cancelled / not-applicable / moved-out"** that the gate
  understands. TECH-173 hit this: several checklist items were deliberately moved to follow-ups
  (FEAT-175/TECH-176) or superseded; they were struck through with `~~...~~` but remained `- [ ]`, so
  the done-gate wrongly counted them as pending. (Worked around by marking them `[x]`.)
- An **in-progress `[/]`** subtask currently passes the done-gate, which is semantically wrong — you
  should not be able to complete an item whose subtasks are still in progress.

**Why is this a problem?**

- Struck-through-as-`[ ]` is a hack the deterministic gate can't read; it forces dishonest `[x]` or
  removal of real history.
- The gate can't express "this criterion was intentionally dropped" vs. "this is genuinely pending."

**What is the desired state?**

- A documented, framework-wide checkbox-state convention with clear gate semantics.

---

## Decisions carried in from the 2026-07-08 discussion

- **States to implement now:** `[ ]` pending · `[x]` done · `[/]` in-progress · `[-]` cancelled/N-A.
- **Gate behavior (done-gate only):** `[ ]` **and** `[/]` block moving to `done/`; `[x]` and `[-]`
  pass. (An in-progress subtask means the item isn't finished.)
- **Readiness-gate (→ todo/backlog/blocked/archive): leave as-is** — only `[ ]` blocks there. Gary:
  no clear value in blocking a *queue* move on an in-progress `[/]` subtask; keep it simple and touch
  only the done-gate. (`[-]` already passes the current grep.)
- **`[?]` (question) and `[!]` (important/blocked):** document as recognized markers, intended to be
  **blocking** eventually (a `[?]` is unresolved; `[!]` ≈ blocked). **Deferred** — not yet used, and
  we don't want to add complexity now. Tiered rollout.
- **Decorative markers** (`[>]`, `[*]`, `["]`, etc.): mention as existing in the ecosystem but out of
  scope — they duplicate signals we already have (DECIDE marker, `blocked/` folder) or are cosmetic.

---

## Scope

**In scope:**
- Update `fw-move.sh` done-gate to block on `[ ]` **and** `[/]` (currently only `[ ]`).
- Document the convention in `workflow-guide.md` (a "Checkbox States" subsection) — all four active
  markers + the deferred `[?]`/`[!]` + a note on decorative ones. *(Note: workflow-guide is already
  large; a docs-restructure is a separate concern.)*
- Thread the convention into work-item templates' guidance where checklists appear.
- Verify no other checkbox consumer (pre-commit hook, other scripts) regresses.

**Out of scope:**
- Implementing `[?]`/`[!]` gate behavior (deferred tier).
- Restructuring workflow-guide.md.

---

## Acceptance Criteria

- [ ] `fw-move.sh` done-gate blocks on both `[ ]` and `[/]`; `[x]` and `[-]` pass
- [ ] Readiness-gate behavior unchanged (only `[ ]` blocks)
- [ ] `workflow-guide.md` documents the four active states + deferred `[?]`/`[!]` + decorative note
- [ ] Templates' checklist guidance references the convention
- [ ] Verified: an item with a `[-]` criterion moves to done; an item with a `[/]` criterion is blocked

---

## Related

- **TECH-173** — surfaced this: its struck-through moved-out criteria couldn't be expressed to the
  done-gate (worked around with `[x]`). This item makes `[-]` a first-class, gate-aware state.
- **`.claude/scripts/fw-move.sh`** — `check_acceptance_criteria` (done-gate) is the code to change.
- Convention basis — Obsidian Tasks custom statuses (`[ ] [x] [/] [-] [?] [!]` …).
