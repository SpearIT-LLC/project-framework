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

   > **SETTLED 2026-09-21 — the AI attempts first, and defers when it cannot.** For `[?]`
   > the AI tries to answer the question itself (research, reading the tree, checking a
   > source) and clears the marker when it genuinely has the answer; where it cannot, it
   > defers to a human response and the marker stands. Self-healing where possible, audit
   > trail where not.
   >
   > **This applies to `[?]` only.** `[h]` is not researchable — no amount of reading
   > unlocks a file, grants an approval, or delivers hardware. An `[h]` is cleared when the
   > blocking condition changes, by whoever changes it.

2. **Does the note have a required shape**, or is free text beside the marker enough?
   Settled that a note is required; its form is not.

   > **SETTLED 2026-09-21 — fixed label, free text, task line preserved.** The note goes on
   > an indented continuation line beneath the marked item, introduced by a **fixed bold
   > label** (`**Hold:**` for `[h]`, `**Question:**` for `[?]`); the text after the label is
   > free.
   >
   > ```markdown
   > - [h] Verify the gate refuses a `[/]` criterion on `→ done`
   >       **Hold:** needs a fixture with a `[/]` line; `seed-uat-fixtures.sh` writes none.
   > ```
   >
   > **Why the task text stays on the marked line.** An inline form (`- [h] <reason>`)
   > destroys the criterion it replaces, and FEAT-221.2 step 1 requires marking *"the exact
   > criterion, checklist step, or acceptance line that tripped"*. Preserving it means
   > clearing the marker is just changing `[h]` back to `[ ]` — the line is already correct
   > — and grepping for the marker still lands on the task, which is the marker's whole job
   > as a cursor.
   >
   > **Why the label is fixed while the text is free.** The label is what makes *"a marker
   > with no note"* greppable, and that is the one thing here worth mechanizing: FEAT-221.2
   > says *"a run that marks but does not note has done half the job."* Without a fixed
   > label that check cannot be written. The reason itself is for a human to read, so a
   > schema would buy nothing and cost enforcement.
   >
   > **The inline form is tolerated, not documented.** Where the reason genuinely *is* the
   > whole item — a placeholder never written as a task — the two collapse and a rule would
   > be noise.
- **Decorative markers** (`[>]`, `[*]`, `["]`, etc.): mention as existing in the ecosystem but out of
  scope — they duplicate signals we already have (DECIDE marker, `blocked/` folder) or are cosmetic.

---

## Scope

> **RETARGETED 2026-09-21 — this card specifies the convention; FEAT-229 implements it.**
>
> The sections above were written against `.claude/scripts/fw-move.sh` (the **old** engine),
> whose `check_acceptance_criteria` is the unchecked-box grep this card set out to change.
> **That is no longer the target.** Verified 2026-09-21: the ADR-009 build's
> `workspaces/framework/scripts/fw-move.sh` is 263 lines with five functions — `die`, `row`,
> `fail_item`, `gmv`, `move_one` — and **has no checkbox gate at all**. The operations
> namespace does not need one; the gates arrive with kanban, in **FEAT-229**.
>
> Three options were weighed. *Old engine only* fixes today's board, ships nothing to the new
> build, and leaves FEAT-229 writing its gates without the convention — guaranteed rework.
> *Both engines* means two implementations of one rule, which is the duplication ADR-008
> exists to prevent. **Chosen: new engine only** (Gary, 2026-09-21), the old engine keeping
> its current behaviour until the D5 crossover retires it.
>
> **The consequence is a change of kind, not just of target.** This card stops being a code
> change and becomes the **authored specification** of the convention. FEAT-229 ports its
> three gates *checkbox-aware from the start*, rather than porting them and then revising
> them. That is also why TECH-177 was pulled into `doing/` ahead of FEAT-229.

**In scope:**

- **Author the convention as a specification** — the six states (`[ ]` `[x]` `[/]` `[-]` `[?]`
  `[h]`), their gate semantics, and the note form settled above. One authored source
  (ADR-008); FEAT-229 and `workflow-guide.md` refer to it rather than restating it.
- **Gate semantics for the new engine, written as a contract FEAT-229 implements:**
  - **done-gate:** `[ ]` and `[/]` block; `[x]` and `[-]` pass. `[-]` passes **by design**,
    not by the accident of a grep that only counts unchecked boxes.
  - **`→ doing` gate:** `[?]` and `[h]` block, each naming the marked line and its note.
  - **readiness (`→ todo`/`backlog`/`blocked`): unchanged** — only `[ ]` blocks (2026-07-08).
- **Document the ADR-007 D7 boundary in the gate's own documentation.** A `[?]`/`[h]` records
  **an event that happened** — a specific line stopped a specific run — not a ripeness
  *judgment*. The card argues this above; it must be written where the gate lives, or the
  next reader takes these markers as a general ripeness gate and D7 is quietly overturned.
- **Document the convention in `workflow-guide.md`** — a "Checkbox States" subsection, pointing
  at the authored source, plus the note that `[!]` is deliberately not used.
- **Thread the convention into the work-item template** (`templates/records/work-item.md`)
  where checklists appear.
- **Verify no other checkbox consumer regresses** — the pre-commit hook and any script that
  greps for unchecked boxes.

**Out of scope:**

- **Changing the old engine.** `.claude/scripts/fw-move.sh` keeps its current behaviour until
  the D5 crossover retires it. Its passes-by-accident `[-]` is left alone.
- **Implementing the gates.** FEAT-229 does that; this card is the contract it implements.
- Restructuring `workflow-guide.md`.
- ~~Implementing `[?]`/`[h]` gate behavior (deferred tier).~~ Promotion recorded 2026-09-07.

---

## Acceptance Criteria

- [x] The convention is authored in **one** place, and `workflow-guide.md`, the template and
      FEAT-229 point at it rather than restating it (ADR-008)
      — `workspaces/framework/skills/fw-checkbox-states/SKILL.md` (2026-09-22). See the
      **Home** note below for why a skill and not `standards/`.
- [x] The six states are specified with their gate semantics: `[ ]`/`[/]` block `→ done`;
      `[x]`/`[-]` pass; `[?]`/`[h]` block `→ doing`; readiness unchanged
- [x] **`[-]` is specified as passing by design**, with the accident it replaces called out —
      today both engines count only unchecked boxes, so `[-]` already passes for the wrong
      reason
- [x] The note form is specified: task text preserved on the marked line, indented
      continuation, fixed label (`**Hold:**` / `**Question:**`), free text after it
- [x] `[?]` clearing is specified: the AI attempts an answer first and clears only when it
      genuinely has one; it defers to a human otherwise. `[h]` is not researchable and is
      cleared when the blocking condition changes
- [x] The ADR-007 D7 boundary (marker = recorded event, not ripeness judgment) is written in
      the gate's own documentation, not only in this card
      — in the skill, under *"read this before adding a gate"*. The skill **is** the gate's
      documentation: it is the contract FEAT-229's gates implement, and no other gate
      documentation exists in the new build.
- [x] `workflow-guide.md` records that `[!]` is **not** used, and why (it means *important* in
      all four Obsidian theme collections)
      — **recorded in the skill instead.** `workflow-guide.md` is old-build
      (`framework/docs/`), which this card scoped away from on 2026-09-21. The new build has
      **no workflow guide** (verified 2026-09-22); when one is written it points at the skill.
- [x] The work-item template's checklist guidance references the convention
      — `workspaces/framework/templates/records/work-item.md`. It had been **restating** the
      done-gate rules inline (an ADR-008 violation predating this card); replaced with a
      pointer.
- [x] No other checkbox consumer regresses — pre-commit hook and any unchecked-box grep audited
      — **audited 2026-09-22, no new-build consumer exists.** All four hits are old-build or
      POC: `.claude/hooks/Validate-WorkItems.ps1:89`, `.claude/scripts/fw-move.sh:228`, and
      `project-hub/poc/SPIKE-145-script-policy/poc-move-policy.sh:218,244`. The new build's
      `tools/pre-commit` has **no checkbox logic at all**. Nothing to regress.
- [x] **FEAT-229 carries a criterion making it responsible for implementing this contract**,
      so the specification cannot land with nothing obliged to honour it
      — verified 2026-09-22: FEAT-229 Scope item 8 (line 89) and acceptance criterion
      (line 145), both added 2026-09-21.
- [h] Validated: **AI** — every state exercised against a scratch fixture once FEAT-229 ships
      the gates; **Human** — a `[-]` criterion moves to done and a `[/]` criterion is blocked,
      against the **installed plugin** (TECH-188)
      **Hold:** there is no gate to validate against — FEAT-229 builds it. Clears when
      FEAT-229 ships the three gates. Not researchable; the blocking condition is other work.

---

## The Home — DECIDED 2026-09-22

**`workspaces/framework/skills/fw-checkbox-states/SKILL.md`.** The specification is a skill,
not a document and not a `standards/` file.

**Why a skill.** ADR-009 OQ1 already settled this class: standards end as skills, because
SKILL.md is plain markdown, so *the skill is the human-readable standard* — one home. It
ships as plugin content, so ADR-009 D3's authored/shipped boundary holds with no exception.

**Why not `standards/`.** That folder is **staging that drains to zero** (ADR-009 OQ1:
"drains as skills are built; once empty, it is deleted"). Authoring a *new* file into a
folder designed to disappear adds to the thing being emptied. It was proposed earlier this
session and withdrawn on reading OQ1.

**Why not data the gate reads** (the `.limit` precedent from TECH-232): a WIP limit varies
legitimately per repo; the meaning of `[x]` does not. It is the Obsidian convention, and a
repo redefining it breaks compatibility with the ecosystem this card researched. Configurable
is the wrong shape.

**Why not embedded in the command, the script, or a hook.** Three audiences, three needs: the
*gate semantics* must be executable (ADR-008 — prose is not a guardrail), so they live in
`fw-move.sh` as FEAT-229 writes them; the *judgment* (when to mark, the note form, the D7
boundary) is skill-shaped; the *symbol meanings* are reference. Script-only leaves the human
nothing readable; skill-only leaves the gate ungated. **The split is deliberate: skill =
contract, script = enforcement.**

**A false fork was posed and withdrawn** — "repo-wide `.claude/skills/` or plugin content?"
Only one authored home exists. A consuming repo's `.claude/skills/` is the *fork-and-own
tailoring path* OQ1 describes, not an authoring destination. The confusion came from ADR-009
D3's stale `.claude/` wording, which predates *"the framework IS the plugin"* settled the same
day. **Recorded as an open question on TECH-233**, which owns the tier model this misreads.

---

## Related

- **FEAT-229** — **implements this contract.** Ports the three kanban gates into the ADR-009
  build; this card's specification is what makes them checkbox-aware from the start rather
  than revised afterwards.
- **FEAT-221.2** — the consumer that promoted `[?]`/`[h]` from deferred. Its three steps
  (*mark the exact line · note the reason · move*) are why the note form preserves the task
  text and why a fixed label matters.
- **TECH-173** — surfaced this: its struck-through moved-out criteria could not be expressed to
  the done-gate (worked around with `[x]`). This card makes `[-]` a first-class, gate-aware
  state.
- **BUG-215** (done 2026-09-21) — hit the same gap from the other side. Its out-of-scope kanban
  criterion could not be `[x]` (dishonest) or `[ ]` (blocking), so it was **struck as prose**.
  With `[-]` specified and implemented, that line and `FEAT-175:178` — the one `[-]` already in
  the tree, written ahead of its mechanism — convert in a mechanical pass.
- **`workspaces/framework/scripts/fw-move.sh`** — the engine the gates land in. **No checkbox
  gate exists there today** (verified 2026-09-21); FEAT-229 adds it.
- **`.claude/scripts/fw-move.sh`** — the old engine's `check_acceptance_criteria`. **Retargeted
  away from 2026-09-21**; left unchanged until the D5 crossover.
- **ADR-007 D7** — the ripeness boundary these markers must not erode.
- **ADR-008** — why the convention is authored once and pointed at, never restated.
- Convention basis — Obsidian Tasks custom statuses plus `[h]` for ON_HOLD. Only `[ ]`/`[x]`
  are core to Tasks; `[/]`/`[-]` ship as editable defaults; `[?]` and `[!]` come from the theme
  collections. Verified 2026-09-07.
