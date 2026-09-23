# Feature: Dotted-Id Family Semantics in the New Engine

**ID:** FEAT-229.4
**Type:** Feature
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-09-22
**Workspace:** framework
**Depends On:** FEAT-229.2 (the gates a family move must run per member)
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Implement dotted-id family semantics in the ADR-009 engine: **address** a child, **move** a
family together, **gate** every member, and **count** a family as one WIP item. Closes
**BUG-241**, **BUG-239** and **BUG-240** together, because all three are the same gap.

## Why One Card and Not Three

**TASK-219 settled dotted-id semantics on 2026-09-09 and nothing ever mechanized them.** The
rule — *a dotted child lives and dies with the parent, moves with it, and counts as one WIP
item* — was written as a paragraph in a template comment. Three bugs fell out of it, all found
on 2026-09-22 within an hour of each other:

| Bug | Symptom | Root |
|---|---|---|
| **BUG-241** | A child cannot be addressed; asking for one silently moves the parent; a parent move splits the family | The id grammar has no dotted form |
| **BUG-239** | Children are carried past every gate (old engine) | Gates run on the named item, children are collected later |
| **BUG-240** | A family of 4 counts as 4 against WIP, not 1 | The count counts files, not work items |

**Fixing them separately means touching the same code three times** and deciding the same
question three times — *what is a family, and what operations treat it as one thing?* This card
answers that once.

**ADR-008 Root 2 is the lesson:** an instruction the AI merely reads is not a mechanism. The
convention was correct and documented for two weeks and the engine knew nothing about it.

## Design

### 1. The id grammar gains a dotted form (BUG-241)

Today (`scripts/fw-move.sh:211`):

```bash
NUM="$(printf '%s' "$ID_IN" | grep -oE '[0-9]+$' || true)"
```

`FEAT-001.1` yields **`1`**, which matches `FEAT-001`. Parse the base **plus** its dotted
suffix, and locate on the full id.

**An unmatched dotted id must fail loudly.** The current silent fallback to the base is the
most dangerous property of BUG-241: it reports success for a card the user never named.

### 2. A family moves together, or not at all

A parent move collects its children (the old engine's `find_children` is the precedent; the new
engine has none — `grep -c children` returns 0).

### 3. A family is gated as a family (BUG-239)

**The union rule:** a family's dependencies are the union of its members'. If any member cannot
legally make the transition, **the whole move is refused** — tight coupling means there is no
partial family move.

**The refusal must name the responsible member.** Gary, 2026-09-22: *"Perhaps the rule should
float up to the parent card, but how to designate the dependency is only on one sub-card?"*

> **This is the same shape as TECH-177's `[h]` vs `Depends On:` distinction.** The folder or
> field says *the family is stuck*; something must still name *which member*. A refusal reading
> "FEAT-229 is blocked" with no member named leaves the user to open every card.

**Chosen: union with attribution** — the gate checks every member's own `Depends On:` and the
refusal names the member and the unmet dependency's current folder. **No new field**: the data
already lives on the child, and a `Blocks Family:` marker would be a second home for a
dependency (ADR-008).

### 4. WIP counts collapse to the base id (BUG-240)

Count **distinct base ids**, not files. `FEAT-229` + `.1` + `.2` + `.3` = **1**. A
`Parent:`-field child has no dotted suffix and so still counts as its own item — correct, and
it falls out of the same logic rather than needing a special case.

**Combine with BUG-174** (dotfiles inflate the same count) — they are one line apart, and
FEAT-229.2 already fixes the dotfile half.

## Scope

- The id grammar, for both namespaces (operations ids are never dotted; a regression pass
  proves it is unaffected).
- Child collection on a parent move.
- Per-member gating with attribution in the refusal.
- Base-id collapsing in the WIP warning and the final count — **one implementation**, not two.
- Depth 3 (`FEAT-001.1.1`), which the template permits.

## Out of Scope

- **The old engine.** BUG-239 is filed against `.claude/scripts/fw-move.sh`, which retires at
  the ADR-009 D5 crossover. **Fixing it here retires it** — record that on BUG-239 rather than
  doing the work twice.
- **`Parent:`-field children.** They stand alone by design and need no family handling.

## Acceptance Criteria

- [x] A dotted child is addressable by its own id and moves as itself
- [x] An id matching nothing **fails, naming the id** — no silent fallback to the base
- [x] Moving a parent moves its children; the family never splits
- [x] A family move is refused when **any** member's `Depends On:` is unsatisfied, naming the
      member and the dependency's current folder
- [x] A family move is refused when **any** member has blocking acceptance criteria on `→ done`
- [x] No partial family move under any refusal
- [x] WIP counts collapse dotted ids to the base: a folder with `FEAT-229`+`.1/.2/.3` plus one
      standalone card reports **2**
- [x] A `Parent:`-field child still counts as its own item
- [x] Depth 3 resolves correctly
- [x] Operations unaffected — regression pass
- [ ] Validated: **AI** — each case against a seeded fixture, including a dotted fixture set
      the seeder does not yet produce · **Human** — the same against the **installed plugin**

## Related

- **BUG-241**, **BUG-239**, **BUG-240** — the three bugs this closes. Each stays filed; this
  card is where the work happens.
- **TASK-219 Group 1** — settled the semantics and gave them no mechanism.
- **FEAT-229.2** — the gates this runs per member. **Must land first.**
- **TECH-237** — the create-gate question that would have caught all three at authoring time.
- **ADR-008 Root 2** — an instruction the AI merely reads is not a guardrail.


---

## Validation Run — 2026-09-22

Scratch repos, `--root`, cards created through `fw-new.sh --parent` so the fixtures are exactly
what the create gate produces.

| # | Case | Expect | Result |
|---|---|---|---|
| 1 | Move **parent** `FEAT-001` | family travels | ✅ `.1` and `.2` follow, each on its own row |
| 2 | Move **child** `FEAT-001.1` directly | that card moves, family follows | ✅ — **BUG-241's core** |
| 3 | `FEAT-001.9` (no such card) | **fail, no fallback** | ✅ *"no kanban record with that id"*, exit 1 |
| 4 | WIP count, 3 family files, limit 2 | counts **1**, no warning | ✅ — **BUG-240** |
| 5 | Family → doing, one child blocked | **refuse, name the child, move nothing** | ✅ (below) |
| 6 | Depth 3, `FEAT-001.1.1` | resolves | ✅ whole family travels |
| 7 | `Parent:`-field child | **does not** travel; own WIP item | ✅ stayed put; `todo/` counts 2 |
| 8 | Operations regression | unchanged | ✅ 5 moves + batch + sweep |
| 9 | FEAT-229.2 gate suite re-run | unchanged | ✅ 8/8 |

**Case 5's output is the answer to the design question:**

```
  FAILED   FEAT-001.2-child-b.md — depends on TECH-002 (currently in backlog/), which must reach done/ first
  FAILED   FEAT-001 family — not moved: tightly-coupled members move together or not at all
```

Two rows: the **member** that is blocked and why, then the **family** that therefore did not
move. That is *"float up to the parent"* with the sub-card still designated — Gary's question,
answered without adding a field. **Nothing moved**, verified on disk.

### A gate hole found by a faulty test

**Test 5 passed on the first run when it should have failed**, because the fixture still carried
the template's placeholder `**Depends On:** __TYPE-nnn …__` *above* the real field. `grep -m1`
matched the placeholder, whose `TYPE-nnn` is not an id, so the gate found nothing to check and
passed.

**My test was wrong — and so was the gate.** No live card is in that state (checked: zero across
`backlog/`, `todo/`, `doing/`), but **a gate that depends on the author having tidied up is not a
gate.** `gate_dependencies` now skips placeholder lines and takes the first real field.

### Design notes

**`family_members` takes any member's id and returns the whole family.** Tight coupling is a
property of the family, not of which member you typed — so moving a child gates its siblings too.

**Members are not counted in `MOVED`.** One `/fw-move` of one card that carries three files is
one work item moved. Counting 4 would be the same category error BUG-240 fixes in the WIP count.

**`Parent:`-field children need no special case.** They have no dotted suffix, so nothing
collects them and nothing collapses them — the distinction falls out of the id shape.