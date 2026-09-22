# Tech: Shipping Content Cites Records a Consuming Repo Cannot Resolve

**ID:** TECH-238
**Type:** Tech
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-09-22
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Plugin content cites **113 records that do not exist in a consuming repo** — 42 ADR references
and 71 card references. Every one is a dangling pointer the moment the plugin is installed
anywhere but here. Replace the citations with the rule stated inline, marked by a **concept
slug** that resolves to the skill owning the policy — so a rule change has a `grep`-able
change-impact list instead of a hope.

## Problem Statement

### What is the current state (verified 2026-09-22)

`grep` over `commands/ skills/ scripts/ templates/ hooks/` in `workspaces/framework/`:

| Reference | Count |
|---|---|
| **ADR references** | **42** — ADR-009 ×18, ADR-008 ×17, ADR-006 ×5, ADR-007 ×2 |
| **Card references** | **71** — BUG-215 ×14, TASK-213 ×11, TECH-232 ×7, FEAT-195 ×5, BUG-225 ×5, and ~20 more |
| **Total** | **113** |

By area: scripts 19 ADR refs, templates 9, commands 8, skills 4, hooks 1 — plus card
references throughout.

**None of it resolves in a consuming repo.** ADRs live in `project-hub/research/adr/` and cards
in the board; **ADR-009 D3 makes `workspaces/`, `kanban/` and `history/` *generated*, never
packaged.** A consumer installs the plugin, reads `fw-new.sh`'s *"STRICT SCRIPT, LENIENT AI
(ADR-006 D6)"*, and has nothing to look up.

**This is not hypothetical drift — it is growing.** Four of the 42 ADR references were added in
this session, by the skill written to *fix* a single-source problem.

### The governing rule — stated 2026-09-22

> **No reference to anything that doesn't exist or has no context.** (Gary)

Shipping content cites **nothing external**. References in cards, ADRs and session histories
are fine and expected — that is this repo's record, and those records *should* cite each other.
The rule binds only what installs into a consuming repo.

### The 71 card references split three ways (verified 2026-09-22)

Every cited id was checked against the board and the release archive:

| Kind | Ids | Refs | State |
|---|---|---|---|
| **Illustrative examples** | `FEAT-003`, `TASK-004`, `FEAT-007` | 3 | Teaching examples, not citations. Doing their job — but indistinguishable from real citations to `grep` **or to a consumer** |
| **Released cards** | `FEAT-192`, `FEAT-194`, `FEAT-202`, `TASK-197` | 4 | Real, archived in `project-hub/history/releases/framework-dev/v0.4.0/`. Do not ship |
| **Live cards** | `BUG-215` ×14, `TASK-213` ×11, `TECH-232` ×7, `FEAT-195` ×5, `BUG-225` ×5, + 10 more | ~64 | Resolve here, absent there |

**The premature-id failure did not occur.** Gary raised it — *"we sometimes get card IDs that
don't exist because they sometimes get an ID before they're actually created, which we've agreed
is a no-no."* **Checked: zero instances.** The four ids with no card file are all illustrative
examples, not citations to unwritten cards. **The discipline is holding** — but nothing enforces
it, which is the argument for a check rather than for trust.

**Examples must be visibly examples.** `--parent FEAT-007` in `fw-new.md` and *"`FEAT-003` and
`TASK-004` cannot both exist"* in the kanban README are correct teaching, and a reader cannot
tell them from a real citation. A **reserved, never-allocated range** makes the distinction
mechanical — and it is what lets the pre-commit check below exist at all, since otherwise every
example is a false positive.

### Three kinds, and the kind decides the fix

| Kind | Example | In a fresh repo |
|---|---|---|
| **Load-bearing rationale** — the *why* is in the sentence | `fw-new.sh:209` "make each one a stale copy of the SoT (ADR-008)" | The reason is already there. The tag adds nothing a consumer can use. |
| **Bare citation** — the tag carries the meaning alone | `fw-move-ops.md:11` "root queues beside the board (ADR-009 D2 as amended by TASK-213)" | **Unresolvable.** The reader cannot act on it. |
| **Transitional** — about the crossover itself | `fw-move.sh:86` "until the ADR-009 D5 crossover" | Expires at graduation; deleted with the code that carries it. **4 sites; leave alone.** |

### Why it is a problem

**A broken pointer is worse than no pointer.** It implies a resolvable authority that does not
exist. Removing it loses the consumer nothing — they never had access — and stops the promise.

**And it hides the real cost, which is change impact.** The concern is not tidiness:

> *"What happens when the rule changes? Now we have to find that rule in multiple docs and hope
> we get all of them."* — Gary, 2026-09-22

**A correction that reframed this card.** Claude first argued *"strip the tag and nothing is
duplicated."* Gary: **"A copy IS duplication."** Correct — the rule sentence in `fw-new.sh:209`
was already a copy with or without the tag. The tag is not the duplication; it is a *pointer to
the original*, and removing it makes the copy **harder to trace back**. That is the opposite of
what a naive de-tagging pass would achieve, and it is why this card is not "delete the ADR
tags."

## Proposed Solution

**Ship the rule inline; mark it with a concept slug; let `grep` produce the change-impact list.**

```bash
# make each one a stale copy of the SoT [[single-source-rule]]
```

Three properties, each earning its place:

1. **The rule is stated in context** — a reader acts on the sentence without resolving anything.
   This is what makes the inline form worth having at all.
2. **The slug resolves to a skill that ships.** `[[single-source-rule]]` → the skill owning the
   policy. Unlike `ADR-008`, a consumer can actually read it.
3. **The change-impact list is mechanical.** `grep -rn '\[\[single-source-rule\]\]'` over
   shipping content returns every site stating that rule. When the policy changes, there is a
   list — not a recollection.

**The slug is checkable, which the ADR tag never was.** A slug with no owning skill is a broken
link the pre-commit hook can fail on — the **TECH-189 drift-guard shape**: an invariant behind a
chokepoint, not a paragraph.

### The skill is a policy, not a list of rules — DECIDED 2026-09-22

Gary asked which. **The evidence decides it:** all 17 ADR-008 sites state **the same one rule**
applied to different things — contacts, types, workspace declarations, checkbox states, the ops
namespace. One rule, seventeen applications.

**A list would be a second copy of what the tree already holds**, and would go stale every time
an authored source is added — the exact failure the policy exists to prevent. `grep` produces
the list on demand; the skill explains what the rule *is*, why duplication is a tax rather than
untidiness, and how to distinguish an authored source from derived output.

**Consequence worth stating:** the skill changes only when the **policy** changes, never when a
new application appears.

### Honest limitation, recorded so it is not discovered as a surprise

**This finds the copies; it does not stop them drifting between changes.** Nothing short of
generating the text would. *"Find all of them reliably"* is the problem named, and this solves
that one. A card proposing generated rule text is a different and much larger card.

## Scope

**In scope:**

- **Classify all 113 sites** against the three kinds above. Mechanical per site; the judgment is
  which kind.
- **Load-bearing rationale** → state the rule, add the slug, drop the tag.
- **Bare citation** → write the rule the citation was standing in for, then slug it. This is the
  real work: a bare citation means the rule was *never* stated in shipping content.
- **Transitional** (4 sites) → **leave alone.** They expire at graduation with the code.
- **The 71 card references**, by the three-way split above: examples converted to the reserved
  range, released and live citations removed — the rule they stood for stated inline and
  slugged where one exists.
- **Reserve and document the example range**, following the template's `TYPE-nnn` precedent.
- **Author the owning skill(s)** for the slugs used. `single-source-rule` is certain; others
  emerge from the classification.
- **A pre-commit check**: no `ADR-\d+` or card reference in shipping content, and no slug
  without an owning skill.

**Out of scope:**

- **Generating rule text** rather than stating it. Named as the limitation above; a different
  card if ever wanted.
- **The old build.** `framework/`, `plugins/`, `tools/`, root `.claude/` keep their references;
  they retire at the D5 crossover.
- **TECH-233's tier model.** That card owns *what a consuming repo knows*; this one owns *what
  shipping text may cite*. Related, independent.
- **Session histories, ADRs and cards themselves** — they are this repo's record and *should*
  cite each other.

## Acceptance Criteria

- [ ] All 113 sites are classified and resolved: rationale re-stated and slugged, bare citations
      written out and slugged, the 4 transitional sites left intact
- [ ] **Every id in shipping content is either a reserved example or is removed.** No shipping
      file cites a real card id — live, released or archived
- [ ] **A reserved example range is documented and never allocated**, so an example is
      distinguishable from a citation by both a reader and a script. The work-item template's
      `TYPE-nnn` placeholder form is the existing precedent
- [ ] Every slug used resolves to a skill that **ships**
- [ ] The owning skill is a **policy**, not a list of applications, and says so
- [ ] `grep -rn 'ADR-[0-9]' commands/ skills/ scripts/ templates/ hooks/` returns **only** the
      transitional sites
- [ ] A pre-commit check fails on a new ADR/card reference in shipping content, and on a slug
      with no owning skill. **The card-id arm also catches the premature-id no-no at its
      source**: an id cited before its card exists is outside the reserved range and trips the
      same check
- [ ] Validated: **AI** — a rule change can be traced to every stating site by `grep` alone ·
      **Human** — a consumer reading an installed plugin can resolve every reference it makes

## Notes

**The count grew during investigation.** The session that found this reported "41 ADR
references." Including card references the real figure is **113** — card citations
(BUG-215 ×14, TASK-213 ×11) are the same defect and were initially missed.

**Priority is Medium, not High, deliberately.** Nothing is broken *here* — the references
resolve in this repo. The cost lands at the first external install, and at every rule change
before then.

## Related

- **TECH-177** — the session that surfaced this, and the card whose skill **added four more ADR
  references** while fixing a single-source problem.
- **TECH-233** — repo-level configuration; owns what a consuming repo knows, and carries the
  related finding that **ADR-009 D3's `.claude/` wording is stale**. Independent of this card.
- **TECH-189** — the drift-guard shape this card's pre-commit check follows: an invariant behind
  a chokepoint, not prose.
- **ADR-009 D3** — `workspaces/`, `kanban/` and `history/` are generated, never packaged. The
  decision that makes every one of these references dangle.
- **ADR-008** — the policy the `single-source-rule` slug will point at, and the most-cited tag
  in the leak (17 sites).
