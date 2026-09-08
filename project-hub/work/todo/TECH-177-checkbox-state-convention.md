# Tech Debt: Adopt Obsidian-Style Checkbox-State Convention (with Gate Awareness)

**ID:** TECH-177
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-07-08
**Workspace:** framework
**Theme:** Workflow Precision

---

## Summary

Adopt the established (Obsidian Tasks) checkbox-state convention — `[ ]`, `[x]`, `[/]`, `[-]`
(plus `[?]` and `[h]`, promoted 2026-09-07) — and teach the `fw-move.sh` gates to
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

  > **Superseded 2026-09-07 — deferral lifted; `[!]` replaced by `[h]`.** See
  > *"`[?]` and `[h]` promoted"* below. The 2026-07-08 reason ("not yet used") expired:
  > unattended batch implementation (FEAT-221) is the consumer, and it needs both.

---

## `[?]` and `[h]` Promoted from Deferred (2026-09-07)

The 2026-07-08 deferral rested on *"not yet used."* FEAT-221's unattended batch run uses
both, and the use case makes their semantics concrete rather than speculative.

### What each means

| Marker | Means |
|---|---|
| `[?]` | **I need more information to complete the job.** |
| `[h]` | **Something prevents completion of this item.** A technical limitation (a file is locked), a procedural one (approval required), a resource one (hardware not yet available), or another card that this sub-task waits on. |

Both **block `→ doing`** — `[?]` because the information is missing, `[h]` because *"it's
something that prevents COMPLETE implementation"* (Gary, 2026-09-07). An unresolved
marker means the card will simply fail again.

**Both carry a note** saying what is needed to clear them. The marker is the *location*;
the note is the *reason*.

**Deliberately not sub-categorised.** An earlier draft split `[h]` into technical /
procedural / resource cases with different ask-or-park behaviour per case. Gary,
2026-09-07: *"I don't think we need to pigeon hole the exact scenarios, just define what
? and ! mean and use them where they apply, when they apply."* The definitions are the
contract; placement is judgment.

**Either marker may be written at planning time or mid-run.** A card can be marked ready
to go *except* for one blocked item — the `[h]` sits on that line from the start and
takes a reader straight to it, even when the blocker is a card still in `backlog/`. This
is why ask-or-park behaviour is not a property of the marker: it depends on the moment,
not the symbol.

### `[h]` vs. `Depends On:` — micro vs. macro

Both express blocking; they operate at different levels and do not compete.

| | Scope | Mechanism |
|---|---|---|
| `Depends On:` | **Macro** — the *whole card* waits on another card | `check_dependencies` hard-blocks `→ doing`, naming the dependency's current folder |
| `[h]` | **Micro** — *one sub-task* is blocked, whatever the blocker is | marks the exact line; blocks `→ doing` |

Gary, 2026-09-07: *"Depends On means the whole card depends on another card at the macro
level. `[!]` identifies a blocking issue at one sub task."* (the symbol became `[h]`
later the same day, on the theme-collection evidence below)

A card whose every remaining line is clear but for one blocked sub-task is not
`Depends On:` — it is a card with one `[h]`.

### Why `[h]` and not `[!]` (settled 2026-09-07)

An earlier draft of this card used `[!]` for blocked. **That conflicts with the very
convention this card adopts.** Verified against the Obsidian Tasks documentation:

| | Finding |
|---|---|
| `[!]` | **"important" in all four theme collections** — Minimal, Things, ITS, SlRvb. Unanimous. Not blocked |
| | Worse: imported into Tasks, `[!]` is classified as status type **TODO** — an ordinary not-done task. A blocking gate on it would fight the tool's own model |
| `[?]` | **"question"** in all four — which is what we meant. Keep as-is |
| `[h]` | **Free in all four collections**, and the symbol the Tasks docs use to illustrate the `ON_HOLD` status type. Right connotation to anyone who has read the docs; collides with no one who has not |

**Candidates checked and rejected:** `[b]` (bookmark in all four), `[B]` (Brainstorm in
ITS/SlRvb), `[O]` (Outline/Plot in ITS/SlRvb). `[o]` is genuinely free everywhere but
carries no meaning and renders confusingly beside an empty checkbox.

**Case is significant and deliberate** — ITS/SlRvb assign `[b]`/`[B]`, `[i]`/`[I]`,
`[p]`/`[P]`, `[c]`/`[C]` as *distinct* entries, and Tasks matches symbols
case-sensitively. Dodging a collision by flipping case just claims the other half of
someone's pair.

**`ON_HOLD` is a close semantic match**, not merely a free character: Tasks added it in
7.23.0 for work that is "not actionable right now", and its docs contrast it with
dependencies, which are *sequencing*. That is the same macro/micro line this card draws
between `Depends On:` and `[h]`.

**`[!]` is left alone**, meaning "important". The framework does not need it today; if it
is ever wanted, the conventional meaning stays available.

### Context recorded so it is not re-researched

Neither point is an objection to the choice — this card scopes itself to Obsidian
notation and makes no cross-ecosystem claim. Recorded because both cost real time to
establish:

- **Linters and formatters are safe.** Prettier 3 and markdownlint-cli2 (all rules) were
  run against a fixture of `[ ] [x] [X] [/] [-] [h] [?] [!] [o]`: every non-standard
  character survived byte-identical, zero checkbox complaints. Prettier's only change was
  `[X]` to `[x]`.
- **GFM renders only `[ ]`, `[x]`, `[X]`.** Per the cmark-gfm spec, anything else is not a
  task-list node — it degrades to literal bracketed text. This already applies to `[/]`
  and `[-]` on GitHub today, so `[h]` adds no new cost. It is also *why* the formatters
  leave it alone: there is no checkbox node to normalize.
- **`[-]` collides across ecosystems.** org-mode defines `[-]` as *partial progress* —
  roughly Obsidian's `[/]` — while Obsidian reads it as cancelled/dropped. Inherited with
  the Obsidian set, not introduced here.

### Why a marker, when `blocked/` already exists

**The folder is a status; the marker is a location.** `blocked/` says *this card is
stuck*. It cannot say *which of 200 lines is stuck*. The marker is a cursor: grep it and
land on the exact criterion, checklist step, or acceptance line.

This closes a real gap. The framework identifies blocking at the card level and not
below it:

| Layer | What identifies it | Mechanized? |
|---|---|---|
| Whole card waits on another card | `Depends On:` field | **Yes** — `check_dependencies` hard-blocks `→ doing` and names the dependency's folder |
| Whole card waits on an external party | `Blocked By:` / `External Reference:` | Fields exist; nothing enforces them |
| **One sub-task is blocked** | **nothing before this card** | **No** → `[h]` |

`Blocked By:` is shaped for an external party blocking a whole card (see `BUG-144`:
*Blocked By: Anthropic*). It does not fit "checklist line 4 is waiting on approval while
the rest of the card is ready."

### Two lifecycle moments, one symbol

A marker is **written** mid-implementation when a run trips, and **read** by the gate on
the next `→ doing`. The card cannot re-enter `doing/` until the thing that stopped it is
cleared, so the marker is its own unblock condition. No separate "parked" state is
needed.

### Does this reverse the readiness-gate decision?

Partly, and deliberately. The 2026-07-08 ruling left the readiness gate alone (*"no clear
value in blocking a queue move on an in-progress `[/]` subtask"*). That still holds for
`[/]`. `[?]` and `[h]` are different: they are **not** ripeness judgments.

**This does not contradict ADR-007 D7 / BUG-184.** D7 says plan *ripeness* cannot be
mechanized — an unchecked box or the word "decide" is normal in a well-planned card, so
`grep` must not adjudicate readiness. A `[?]`/`[h]` records **an event that happened**: a
specific line stopped a specific run. That is a fact, not a judgment.

**Write this distinction down in the gate's own documentation.** Without it, a future
reader will take these markers as a general ripeness gate and D7 gets quietly overturned.

### Open questions

1. **Who clears the marker?** If the AI clears `[?]` after applying the user's answer, it
   self-heals. If only a human clears it, it is an audit trail. Different mechanisms —
   decide before implementing.
2. **Does the note have a required shape**, or is free text beside the marker enough?
   Settled that a note is required; its form is not.
- **Decorative markers** (`[>]`, `[*]`, `["]`, etc.): mention as existing in the ecosystem but out of
  scope — they duplicate signals we already have (DECIDE marker, `blocked/` folder) or are cosmetic.

---

## Scope

**In scope:**
- Update `fw-move.sh` done-gate to block on `[ ]` **and** `[/]` (currently only `[ ]`).
- Document the convention in `workflow-guide.md` (a "Checkbox States" subsection) — all four active
  markers + `[?]`/`[h]` + a note on decorative ones. *(Note: workflow-guide is already
  large; a docs-restructure is a separate concern.)*
- Thread the convention into work-item templates' guidance where checklists appear.
- Verify no other checkbox consumer (pre-commit hook, other scripts) regresses.

**Out of scope:**
- ~~Implementing `[?]`/`[h]` gate behavior (deferred tier).~~ **Now in scope** — see the 2026-09-07 promotion above.
- Restructuring workflow-guide.md.

---

## Acceptance Criteria

- [ ] `fw-move.sh` done-gate blocks on both `[ ]` and `[/]`; `[x]` and `[-]` pass
- [ ] Readiness-gate behavior unchanged (only `[ ]` blocks)
- [ ] `workflow-guide.md` documents the four active states + `[?]`/`[h]` + decorative note,
      and records that `[!]` is deliberately NOT used (it means "important" in the theme
      collections)
- [ ] Templates' checklist guidance references the convention
- [ ] Verified: an item with a `[-]` criterion moves to done; an item with a `[/]` criterion is blocked

---

## Related

- **TECH-173** — surfaced this: its struck-through moved-out criteria couldn't be expressed to the
  done-gate (worked around with `[x]`). This item makes `[-]` a first-class, gate-aware state.
- **`.claude/scripts/fw-move.sh`** — `check_acceptance_criteria` (done-gate) is the code to change.
- Convention basis — Obsidian Tasks custom statuses plus `[h]` for ON_HOLD. Only
  `[ ]`/`[x]` are core to Tasks; `[/]`/`[-]` ship as editable defaults; `[?]` and `[!]`
  come from the theme collections. Verified 2026-09-07.
