---
name: fw-checkbox-states
description: The framework's checkbox-state convention and its gate semantics - use when writing or reading a checklist on a work item, when a gate refuses a move because of a checkbox, when an implementation run trips and must mark the line that stopped it, or when deciding which of [ ] [x] [/] [-] [?] [h] a line should carry. Also the authored source for what each marker means and why [!] is not used.
---

# Checkbox States — the Convention and What the Gates Do With It

This is the **authored source** for the framework's checkbox convention (ADR-008:
one home, everything else a pointer). `workflow-guide.md`, the work-item template
and the move engine's gates refer to this file rather than restating it.

Two things live here and they are not the same:

- **The six states and their meanings** — what a human reads on a card.
- **The gate semantics** — what `fw-move.sh` does about them. Prose cannot enforce
  this; the greps in the engine are the guardrail, and this file is the contract
  they implement.

## The six states

The set is the Obsidian Tasks custom-status convention, plus `[h]` for ON_HOLD.

| State | Means | Blocks |
|---|---|---|
| `[ ]` | **Pending** — not started, or genuinely still to do | `→ done` |
| `[x]` | **Done** — completed | — |
| `[/]` | **In progress** — started, unfinished | `→ done` |
| `[-]` | **Cancelled / not applicable** — deliberately dropped, moved to a follow-up, or superseded | — |
| `[?]` | **Question** — more information is needed to complete this line | `→ doing` |
| `[h]` | **Hold** — something prevents completion of this line | `→ doing` |

Only `[ ]` and `[x]` are core to Obsidian Tasks; `[/]` and `[-]` ship as editable
defaults; `[?]` comes from the theme collections. `[h]` is the symbol the Tasks
docs use to illustrate the `ON_HOLD` status type.

## Gate semantics

Three gates, three different questions. **The differences are deliberate** — do not
unify them.

### The done-gate (`→ done`)

**`[ ]` and `[/]` block. `[x]` and `[-]` pass.**

An in-progress sub-task means the item is not finished, so `[/]` blocks — this is
the case a plain unchecked-box grep gets wrong.

**`[-]` passes by design, not by accident.** This distinction is the point of
specifying it. An engine that counts only `- [ ]` lets `[-]` through because it
never looked, which is indistinguishable from correct behaviour until someone
writes `[/]` and it sails past too. The rule is *"cancelled work does not block
completion"*, and it must be implemented as that rule.

### The doing-gate (`→ doing`)

**`[?]` and `[h]` block**, and the refusal **names the marked line and its note**.

Both mean the card will fail again if it re-enters implementation: `[?]` because
information is missing, `[h]` because something prevents completion. An unresolved
marker is not a warning, it is a known-cause failure waiting to repeat.

### The readiness gate (`→ todo`, `→ backlog`, `→ blocked`, `→ archive`)

**Only `[ ]` blocks. Unchanged.**

There is no value in blocking a *queue* move because a sub-task is in progress.
Moving a card between queues is not a claim that it is finished.

## The ADR-007 D7 boundary — read this before adding a gate

**D7 says plan ripeness cannot be mechanized.** An unchecked box, or the word
"decide", is normal in a well-planned card. `grep` must never adjudicate whether a
plan is *ready*.

**`[?]` and `[h]` do not cross that line, and the reason is exact:**

> A `[?]`/`[h]` records **an event that happened** — a specific line stopped a
> specific run. That is a fact. Ripeness is a judgment.

The doing-gate blocks on these markers because a fact was recorded, not because the
gate formed an opinion about the plan's quality.

**This paragraph is load-bearing.** Without it the next reader takes these markers
as a general ripeness gate, starts adding judgment checks beside them, and D7 is
overturned without anyone deciding to overturn it.

## The note form

**A marker without a note has done half the job.** The marker says *where*; the note
says *why*. Writing the note is part of writing the marker, not a later step.

The note goes on an **indented continuation line** beneath the marked item,
introduced by a **fixed bold label** — `**Hold:**` for `[h]`, `**Question:**` for
`[?]`. The text after the label is free.

```markdown
- [h] Verify the gate refuses a `[/]` criterion on `→ done`
      **Hold:** needs a fixture with a `[/]` line; `seed-uat-fixtures.sh` writes none.

- [?] Decide whether the sweep runs per-year or per-quarter
      **Question:** no precedent in the tree; needs Gary's call.
```

**The task text stays on the marked line.** An inline form (`- [h] <reason>`)
destroys the criterion it replaces. Keeping the line intact means three things:
clearing the marker is just `[h]` → `[ ]`, because the line is already correct;
grepping the marker lands on the *task*, which is the marker's whole job as a
cursor; and the note travels with the item on a move.

**The label is fixed so that "a marker with no note" is greppable.** That is the one
thing here worth mechanizing. The reason itself is for a human to read — a schema
would buy nothing and cost enforcement.

**The inline form is tolerated, not documented.** Where the reason genuinely *is*
the whole item — a placeholder never written as a task — the two collapse and a rule
would be noise.

## Clearing a marker

**`[?]` — attempt first, defer when you cannot.** Try to answer the question
yourself: research it, read the tree, check the source. Clear the marker only when
you **genuinely have the answer**. Where you cannot, defer to a human and leave the
marker standing. Self-healing where possible, audit trail where not.

**`[h]` — not researchable.** No amount of reading unlocks a file, grants an
approval, or delivers hardware. An `[h]` clears when the **blocking condition
changes**, by whoever changes it.

The distinction is load-bearing: *attempt an answer, then defer* is coherent for a
question and incoherent for a hold. Do not collapse the two markers.

## `[h]` vs. `Depends On:` — micro vs. macro

Both express blocking, at different levels. They do not compete.

| | Scope | Mechanism |
|---|---|---|
| `Depends On:` | **Macro** — the *whole card* waits on another card | `check_dependencies` hard-blocks `→ doing`, naming the dependency's folder |
| `[h]` | **Micro** — *one sub-task* is blocked, whatever the blocker is | marks the exact line; blocks `→ doing` |

A card whose every remaining line is clear but for one blocked sub-task is not
`Depends On:` — it is a card with one `[h]`.

**And the folder is a status, the marker is a location.** `blocked/` says *this card
is stuck*; it cannot say *which of 200 lines is stuck*. Before this convention the
framework could identify blocking at the card level and nowhere below it.

## Why `[!]` is not used

`[!]` means **"important" in all four Obsidian theme collections** — Minimal,
Things, ITS, SlRvb. Unanimous, and not "blocked". Worse: imported into Tasks, `[!]`
classifies as status type **TODO** — an ordinary not-done task — so a blocking gate
on it would fight the tool's own model.

`[h]` is free in all four collections and carries the right connotation to anyone
who has read the Tasks docs.

**`[!]` is left alone, meaning "important".** The framework does not need it today;
if it is ever wanted, the conventional meaning stays available.

**Case is significant.** ITS/SlRvb assign `[b]`/`[B]`, `[i]`/`[I]`, `[p]`/`[P]`,
`[c]`/`[C]` as *distinct* entries and Tasks matches case-sensitively. Dodging a
collision by flipping case just claims the other half of someone's pair.

**Decorative markers** (`[>]`, `[*]`, `["]`, …) exist in the ecosystem and are out
of scope — they duplicate signals the framework already has.

## Facts established once, recorded so they are not re-researched

- **Linters and formatters are safe.** Prettier 3 and markdownlint-cli2 (all rules)
  were run against a fixture of `[ ] [x] [X] [/] [-] [h] [?] [!] [o]`: every
  non-standard character survived byte-identical, zero checkbox complaints.
  Prettier's only change was `[X]` → `[x]`.
- **GFM renders only `[ ]`, `[x]`, `[X]`.** Per the cmark-gfm spec anything else is
  not a task-list node and degrades to literal bracketed text. This already applies
  to `[/]` and `[-]` on GitHub, so `[h]` adds no new cost. It is also *why* the
  formatters leave these alone: there is no checkbox node to normalize.
- **`[-]` collides across ecosystems.** org-mode defines `[-]` as *partial
  progress* — roughly Obsidian's `[/]` — while Obsidian reads it as
  cancelled/dropped. Inherited with the Obsidian set, not introduced here.

Verified 2026-09-07. This convention scopes itself to Obsidian notation and makes no
cross-ecosystem claim.

## Sources

- **TECH-177** — the card that authored this convention and settled every decision
  in it.
- **FEAT-229** — implements the gate semantics above in
  `workspaces/framework/scripts/fw-move.sh`.
- **FEAT-221.2** — the unattended implementation run that writes `[?]`/`[h]` markers
  and their notes mid-run.
- **ADR-007 D7** — the ripeness boundary these markers must not erode.
- **ADR-008** — why this convention is authored once and pointed at.
- Obsidian Tasks custom statuses; `ON_HOLD` added in Tasks 7.23.0 for work that is
  "not actionable right now".
