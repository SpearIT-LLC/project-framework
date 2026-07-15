# Bug: `check_readiness` blocks legitimate `→ todo` moves — miscalibrated and gated at the wrong transition

**ID:** BUG-184
**Type:** Bug
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-07-15
**Theme:** Framework Consistency

---

## Summary

`.claude/scripts/fw-move.sh`'s `check_readiness()` blocks a thoroughly-planned work item from moving
`backlog → todo`, because it treats three normal features of a good work item — an unchecked
implementation checklist, the word "decide" in prose, and Markdown link syntax — as signs of an
*unripe* plan. Two problems compound: (1) the check is **miscalibrated** (blunt greps that cannot tell a
template stub from legitimate content), and (2) it is **gated at the wrong transition** — it runs on
`→ todo`, where committing to work should not require a ripe plan, and does **not** run on `→ doing`,
where ADR-007 D7 says the ripeness gate belongs.

Discovered 2026-07-15 while moving BUG-181 (the ADR-007 anchor) toward `doing/` — a freshly, thoroughly
re-scoped item was blocked from even reaching `todo/`.

---

## Bug Description

**What is happening (actual behavior)?**

`bash .claude/scripts/fw-move.sh 181 todo` fails with 3 readiness issues on a mature, just-reviewed item:

```
⚠️  11 unchecked criteria ([ ])
⚠️  Unresolved markers: decide
⚠️  Unfilled placeholder text detected
❌ ... 3 readiness issue(s) — use --force to queue anyway
```

All three are **false positives**:

| Flag | Source in BUG-181 | Why it's a false positive |
|---|---|---|
| **11 unchecked `[ ]`** | the Implementation Checklist + Acceptance Criteria | These are *supposed* to be unchecked until the work is done. A well-planned item **has** a checklist of future steps. Treating that as "not ready" is backwards. |
| **marker "decide"** | prose: *"decide deliberately where it goes"* (Notes) | `check_readiness` greps `\b(TODO\|TBD\|DECIDE)\b` case-insensitively; it hits the ordinary English word "decide," not a `DECIDE` decision marker. |
| **placeholder** | `[ADR-007](...)` and other bracketed text | The placeholder regex `\[.{3,40}\]` (`:282`) matches **any** bracketed 3–40 char string — including Markdown link text. Any richly-linked item trips it. |

**What should happen (expected behavior)?**

Moving an item to `todo/` — *committing to work on it* — should not be gated on plan ripeness at all
(ADR-007 D7: ripeness is the `→ doing` gate). And whatever ripeness signal exists must not fire on
legitimate content: an unchecked checklist, the word "decide," or a Markdown link are not incompleteness.

**Impact:**

Every thoroughly-planned item hits this. The better the plan (detailed checklist, cross-references via
Markdown links, prose that discusses decisions), the *more* likely it is blocked. `--force` works but
trains users to reflexively bypass a safety check — which erodes the check's value everywhere, including
where it is legitimate.

---

## Reproduction Steps

1. Take any work item with an Implementation Checklist (unchecked `[ ]` steps) and Markdown links.
2. `bash .claude/scripts/fw-move.sh <id> todo`
3. Observe it blocks on "unchecked criteria" + "placeholder text detected" (and "decide"/"TODO"/"TBD"
   if any appear anywhere in prose).

**Reproducibility:** Always, for any well-planned item.

**Verified 2026-07-15** against BUG-181.

---

## Root Cause Analysis

**File affected:** `.claude/scripts/fw-move.sh`

**Cause A — miscalibrated checks (`check_readiness`, `:245-291`):**
- **`:254` unchecked `[ ]`** — counts *all* unchecked boxes. This is the **done-gate's** concern and is
  already implemented correctly and separately as `check_acceptance_criteria()` (`:222`, runs on
  `→ done`). It does not belong in a readiness check at all.
- **`:264` markers** — `\b…\b` on `DECIDE` matches the common word "decide"/"decides"/"decided". Needs a
  stricter form (e.g. require the marker to be standalone/uppercase, or a `**DECIDE:**`-style token),
  not any occurrence of the substring.
- **`:282` placeholder** — `\[.{3,40}\]` is far too broad; it matches Markdown link text `[label]`,
  bracketed asides, and table cells. Should be scoped to known template tokens only (`NNN`,
  `YYYY-MM-DD`, `{{…}}`), dropping the catch-all bracket match.

**Cause B — wrong transition gate (`:387`):**
```bash
if [ "$TARGET" = "todo" ] || [ "$TARGET" = "backlog" ] || [ "$TARGET" = "blocked" ] || [ "$TARGET" = "archive" ]; then
```
`check_readiness` runs on `todo/backlog/blocked/archive` and is **excluded from `doing`** (`:386`
comment: "Skipped for → doing"). So the ripeness signal fires when *committing* to work (too early, per
D7) and is **absent** when *starting* work (where D7 puts it). Per ADR-007 D7, committing to work in
`todo/` is not gated on ripeness; the `→ doing` transition is the ripeness chokepoint.

**Why this appeared now:** the item that exposed it (BUG-181) is unusually thorough — a long checklist,
many ADR cross-links, prose discussing decisions — so it maxed out every false-positive path at once. A
thin item slips through precisely because it has less content to trip the greps, which is the opposite of
what a ripeness check should reward.

---

## Fix Design (to be finalized at pre-implementation review)

**Direction (not yet a committed plan — this item still needs its `→ doing` review):**

1. **Remove `check_readiness` from `→ todo`.** Committing to work is not a ripeness assertion (D7).
   Whether it should run on `blocked`/`archive` at all is open — likely not.
2. **Move the meaningful ripeness signal to `→ doing`**, or accept that `→ doing` already enforces what
   matters (dependency check, plus the behavioral pre-implementation review the command layer forces).
   Decide whether a *mechanized* readiness check adds value at `→ doing` beyond the forced review, given
   D7's honest admission that `grep` cannot judge plan maturity.
3. **Drop the unchecked-`[ ]` check from readiness entirely** — it is the done-gate's job and already
   lives there (`check_acceptance_criteria`).
4. **Tighten the two remaining greps** so they match template stubs, not legitimate content:
   - markers → a standalone/token form, not any occurrence of "decide"
   - placeholders → known tokens (`NNN`, `YYYY-MM-DD`, `{{…}}`) only; drop `\[.{3,40}\]`

**Regression risk:** this is the engine that governs the AI running it (ADR-007 D4 "keep the composer
stupid" logic applies to `fw-move` too). Test against both a thin/stub item (should still warn) and a
thorough item (should pass clean).

---

## Acceptance Criteria

- [ ] `→ todo` is not blocked by unchecked checklist items, Markdown links, or the word "decide" in prose
- [ ] BUG-181 (and any thoroughly-planned item) moves `backlog → todo` with **no `--force`**
- [ ] The unchecked-`[ ]` signal no longer participates in readiness (remains enforced at `→ done` via
      `check_acceptance_criteria`)
- [ ] Marker + placeholder greps match template stubs but not legitimate content (verified against a
      link-heavy item and a genuine stub item)
- [ ] Ripeness enforcement aligns with ADR-007 D7 (the `→ doing` transition is the gate; `→ todo` is
      commitment, not ripeness)
- [ ] A genuine stub item (real `TODO`/`{{PLACEHOLDER}}`/undecided options) still warns appropriately
- [ ] `framework/CHANGELOG.md` updated

---

## Implementation Checklist

<!-- AI: Complete items in order. STOP at each [ ] and wait for approval. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED** — finalize the fix design above (what runs where; exact
      regex forms) before editing the script
- [ ] Adjust the transition gate (`:387`) so `check_readiness` no longer runs on `→ todo`
- [ ] Remove the unchecked-`[ ]` sub-check from `check_readiness`
- [ ] Tighten marker + placeholder detection to template stubs only
- [ ] Test: thin/stub item still warns; thorough item passes clean; `→ done` still blocks on unchecked
      acceptance criteria
- [ ] CHANGELOG updated

---

## Documentation

<!-- Dogfooding FEAT-180 (mandatory documentation section). -->

| Surface | What it must say | Audience |
|---|---|---|
| `.claude/commands/fw-move.md` | which checks run on which transition (correct the "readiness → todo" description) | AI running `/fw-move` |
| `framework/docs/collaboration/workflow-guide.md` | ripeness gates at `→ doing`, not `→ todo` (align with D7) | human + AI |
| `framework/CHANGELOG.md` | readiness check corrected | upgraders |

---

## Related

- **ADR-007 / D7** (Accepted 2026-07-15) — establishes the model this bug violates: `→ doing` is the
  ripeness chokepoint; `→ todo` is commitment. The readiness check predates D7 and was never reconciled
  to it. D7 also documents the honest limit this fix must respect: *"`grep` cannot see a
  confident-but-thin plan."*
- **BUG-181** — the item whose move surfaced this. It was `--force`d (or waited) to `todo/` pending this
  fix; note which in its history.
- **`.claude/scripts/fw-move.sh`** — `check_readiness` (`:245`), transition gate (`:387`),
  `check_acceptance_criteria` (`:222`, the correct home for the unchecked-`[ ]` signal).
- **FEAT-175** — `/fw-new` create gate ("strict script, lenient AI"). Same engine, same
  deterministic-vs-probabilistic tension; keep the two gates' philosophies consistent.

---

**Last Updated:** 2026-07-15
