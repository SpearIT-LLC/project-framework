# Bug: WIP Count Does Not Collapse Dotted Ids to Their Base

**ID:** BUG-240
**Type:** Bug
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-09-22
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

The WIP count counts **files**, not **work items**. A dotted family — `FEAT-229` plus
`FEAT-229.1/.2/.3` — counts as **four** against the limit when the settled convention says it is
**one**. The rule was decided by TASK-219 on 2026-09-09 and **nothing implements it.**

## Bug Description

**The convention (TASK-219 Group 1, line 149 — settled and in `done/`):**

> Dotted id = tight coupling, child dies with the parent, **counts as *one* WIP item**.
> `Parent:` field = provenance, child stands alone and **counts as its *own* WIP item**.

**What the engine does instead:**

```bash
COUNT=$(find "$WORK_DIR/doing" -type f ! -name ".limit" | wc -l)
```

A raw file count. `find_children()` exists at `.claude/scripts/fw-move.sh:129` but is used
**only for moving**, never for counting.

**Observed 2026-09-22, live:**

```
$ /fw-move 229 doing
⚠️  WIP limit: 2/2 items already in doing/
📊 doing/: 6/2 items
```

**`doing/` actually held 2 work items** — the FEAT-229 family (one item) and TECH-232. The
reported 6 is: 4 family files + TECH-232 + `.gitkeep`.

**Two separate defects stack here:**

| Defect | Effect | Card |
|---|---|---|
| Dotted ids not collapsed | family of 4 counts as 4, should be 1 | **this card** |
| `.gitkeep` counted | every folder inflated by 1 | **BUG-174** |

**Impact:** the WIP limit is unusable for any project using dotted sub-items. A single split
card trips the `doing/` limit of 2 on its own. The limit is warning-only, so nothing breaks —
but a warning that fires wrongly on correct work trains the user to ignore it, which costs the
limit its entire value.

## Was this ever implemented?

**No — verified 2026-09-22.** The old engine has never had base-id collapsing; the count has
always been `find | wc -l`. The convention was decided *after* the count was written and no card
connected the two. **TASK-219 settled the rule and left it a paragraph** — which is exactly the
failure mode ADR-008 Root 2 names: *an instruction the AI merely reads is not a mechanism.*

## Proposed Solution

Count **distinct base ids**, not files:

```bash
find "$WORK_DIR/$TARGET" -name '*.md' -type f \
  | sed 's|.*/||; s|^\([A-Z]*-[0-9]*\)\..*|\1|; s|-.*||' ...
```

The rule: strip the dotted suffix, then count unique `TYPE-NNN`. A `Parent:`-field child has no
dotted suffix and so still counts as its own item — which is the correct behaviour and falls out
of the same logic.

**Scope note:** this is the **new engine** (`workspaces/framework/scripts/fw-move.sh`), which
has no limit logic at all yet. The old engine is not fixed; it retires at the ADR-009 D5
crossover.

## Acceptance Criteria

- [ ] The WIP count collapses dotted ids to their base: `FEAT-229` + `.1` + `.2` + `.3` counts
      as **1**
- [ ] A `Parent:`-field child still counts as its **own** item (no dotted suffix, no collapse)
- [ ] Dotfiles are excluded (**BUG-174** — same count, fix both together)
- [ ] The final `📊` count uses the same logic as the limit warning — one implementation, not
      two
- [ ] Validated: **AI** — a folder holding a 4-file dotted family plus one standalone card
      reports **2** · **Human** — the reported count matches what a person counts on the board

## Related

- **TASK-219 Group 1** — decided the rule (`counts as one WIP item`) on 2026-09-09 and gave it
  no mechanism. **This card is that mechanism.**
- **BUG-174** — dotfiles inflate the same count. **Fix together**; they are one line apart.
- **FEAT-229.2** — writes the new engine's WIP warning from scratch. **Both this and BUG-174
  belong in that work** rather than as separate passes.
- **BUG-239** — dotted children bypass the gates. Same family semantics, different mechanism.
- **ADR-008 Root 2** — an instruction the AI merely reads is not a mechanism. The reason a
  settled convention drifted for two weeks.

---

## Fixed in the New Engine — 2026-09-22 (FEAT-229.4)

**Fixed in `workspaces/framework/scripts/fw-move.sh`** and validated across 9 cases; see
FEAT-229.4's validation run.

**This card stays open only for the OLD engine** (`.claude/scripts/fw-move.sh`), which retires
at the ADR-009 D5 crossover. **Do not fix it there** unless something starts depending on the
old engine after the crossover date — the correct behaviour ships with the new engine, and
patching a retiring script is work done twice.
