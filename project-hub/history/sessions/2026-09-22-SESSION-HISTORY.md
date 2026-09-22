# Session History: 2026-09-22

**Date:** 2026-09-22
**Participants:** Gary Elliott, Claude Code
**Session Focus:** TECH-177 — the checkbox convention authored as a skill; two structural
findings that came out of authoring it

---

## Summary

TECH-177's specification was authored as `skills/fw-checkbox-states/SKILL.md` and ten of its
eleven criteria closed. Deciding *where* it lives turned into a real ADR-008 question that took
two wrong turns before settling. Authoring it then surfaced two problems bigger than the card:
**41 ADR references in shipping plugin content** that a consuming repo cannot resolve, and
**hidden dependencies** — 20 cards declaring dependencies in prose only, with TECH-177 itself
the worst offender. The second produced TECH-237.

---

## Work Completed

### TECH-177: the specification, authored

**`workspaces/framework/skills/fw-checkbox-states/SKILL.md`** — the six states, three gates
with deliberately different semantics, the note form, marker clearing, `[h]` vs. `Depends On:`,
why `[!]` is excluded, and the research facts (linters, GFM, the org-mode `[-]` collision)
recorded so they are never re-established.

**Ten of eleven criteria closed.** Two were closed on findings rather than work:

- **No new-build checkbox consumer exists.** All four hits are old-build or POC:
  `.claude/hooks/Validate-WorkItems.ps1:89`, `.claude/scripts/fw-move.sh:228`,
  `project-hub/poc/SPIKE-145-script-policy/poc-move-policy.sh:218,244`. The new build's
  `tools/pre-commit` has **no checkbox logic at all**. Nothing to regress.
- **The `workflow-guide.md` criterion could not be met as written.** That guide is old-build
  (`framework/docs/`), which this card scoped away from on 2026-09-21, and **the new build has
  no workflow guide**. The `[!]` exclusion went into the skill instead. Recorded on the card
  rather than silently retargeted.

**The work-item template was restating the done-gate rules inline** — an ADR-008 violation
predating this card. Replaced with a pointer to the skill.

### The home question — two wrong turns, both recorded

**Settled: a skill, at `workspaces/framework/skills/fw-checkbox-states/`.** Recorded on the
card as a *Home — DECIDED 2026-09-22* section so it is not re-litigated.

**Wrong turn 1: `standards/`.** Proposed before reading ADR-009 OQ1, which says that folder is
staging that **drains to zero** ("once empty, it is deleted"). Authoring a new file into a
folder designed to disappear adds to the thing being emptied. Withdrawn.

**Wrong turn 2: a false fork.** Posed "repo-wide `.claude/skills/` *or* plugin content?" — but
only one authored home exists. A consuming repo's `.claude/skills/` is the **fork-and-own
tailoring path** OQ1 already describes, not an authoring destination.

**The fork came from stale ADR wording, and Gary caught it.** Gary asked whether
`workspaces/framework/` is "effectively a working space for the new `.claude/` folder." Checking
rather than agreeing found: it is the **plugin source tree** (`.claude-plugin/plugin.json`,
`spearit-framework-dev` v0.4.7), and ADR-009 D3's `.claude/` language **predates "the framework
IS the plugin"**, settled the same day (2026-08-18) and recorded in D3's own closing paragraph.
`.claude/` there is shorthand for "plugin content, not generated structure."

---

## The Two Findings

### 1. ADR references leak into shipping content

**41 references across plugin content** — scripts 19, templates 9, commands 8, skills 4
(this session added those), hooks 1. In a fresh repo every one is a dangling pointer: ADRs live
in `project-hub/research/adr/`, and ADR-009 D3 makes `workspaces/` and `history/` *generated*,
never packaged.

**Three kinds, and the kind decides the fix:** load-bearing rationale (the reason is in the
sentence; the tag adds nothing), bare citation (unresolvable — the reader cannot act on it), and
transitional (about the crossover itself; dies at graduation anyway).

**A correction that mattered.** Claude claimed "strip the tag and nothing is duplicated." Gary:
*"A copy IS duplication."* **Correct, and the claim was wrong.** The rule sentence in
`fw-new.sh:209` was already a copy with or without the tag. The tag is not the duplication — it
is a pointer to the original, and removing it makes the copy *harder to trace back*, which is
the real concern. That reframed the question from "should we drop the tags" to **"when the rule
changes, how do we find every place that states it?"**

### 2. Hidden dependencies — and the order problem underneath

**Verified on the live board:** 12 cards declare `Depends On:` (2 in `archive/`); **20 state a
dependency in prose only**; TECH-177 alone has 12 such phrases and **no `Depends On:` field** —
while defining the macro/micro dependency distinction in four places.

**A declared dependency is never re-checked either.** FEAT-221 declares
`Depends On: TASK-219 (Group 2 — the accept/ state)`. **TASK-219 has been in `done/` since
2026-09-10**, its Group 2 work deferred to TASK-223 — which is in `backlog/` and which FEAT-221
does not name. The declared blocker is satisfied; the real one is unnamed. **That is why
FEAT-221 cannot move.**

**Gary reframed it, and the reframing was right:** *"Is the real gap the available states, or
the fact we're creating cards with hidden dependencies in the first place? AND we're perhaps
implementing in the wrong order."* Claude's first answer had led with the parked-state set
(`accept/`/`cancelled/`/`hold/`); that was wrong — the states answer *where a card sits*, not
*why it is stuck*.

---

## Decisions Made

1. **TECH-177's specification is a skill, not a document and not a `standards/` file.**
   - ADR-009 OQ1 already settled this class: standards end as skills, because SKILL.md is plain
     markdown, so *the skill is the human-readable standard* — one home. It ships as plugin
     content, so D3's authored/shipped boundary holds with no exception.
   - **Not data the gate reads** (TECH-232's `.limit` precedent): a WIP limit varies legitimately
     per repo; the meaning of `[x]` does not — it is the Obsidian convention, and a repo
     redefining it breaks ecosystem compatibility.
   - **Not embedded in command/script/hook alone.** Three audiences, three needs: gate semantics
     must be *executable* (prose is not a guardrail), judgment is skill-shaped, symbol meanings
     are reference. **Skill = contract, script = enforcement.**

2. **The ADR-009 D3 wording finding goes on TECH-233, not a new card.** (Gary: "note it")
   - It is an instance of TECH-233's fourth open question — the `.claude/` reading is exactly
     the plugin-tier/repo-tier confusion the three-tier model exists to settle. Fixing the
     wording without settling the tiers would move the ambiguity, not remove it.

3. **A single-source skill is a *policy*, not a list of rules.** (Gary asked which)
   - Evidence decided it: all 17 ADR-008 sites in shipping content state **the same one rule**
     applied to different things — contacts, types, workspace declarations, checkbox states, the
     ops namespace. One rule, seventeen applications.
   - A list would be a second copy of what the tree already holds and would go stale whenever an
     authored source is added — the exact failure the policy prevents. **`grep` produces the list
     on demand; the skill explains what the rule is.**

4. **The DRY plan for stated rules: ship the rule, mark it with a concept slug.**
   - Answers Gary's question — *"what happens when the rule changes?"* A stated rule carries
     `[[single-source-rule]]`; the slug resolves to the skill that owns the policy; the
     change-impact list is a `grep`, not a hope. A slug with no owning skill is a broken link the
     pre-commit hook can fail on (the TECH-189 drift-guard shape).
   - **Better than the ADR tag it replaces:** the slug *ships* (the skill ships), so a consumer
     can resolve it; the ADR number never could. And it is mechanically checkable.
   - **Honest limitation, recorded:** this finds the copies; it does not stop them drifting
     between changes. Nothing short of generating the text would. "Find all of them reliably" was
     the problem named, and this solves that one.

5. **Hidden dependencies are a create-side problem, and the fix is a question, not a field.**
   - `Depends On:` already exists and is ignored — `/fw-new` step 5 mentions it only among
     optional fields to *delete*. Adding structure to a template being skipped will not help;
     **the gate has to ask**, because that is the chokepoint the AI passes through.
   - **"Who validates this?" is asked nowhere at all**, and that is the half that produces
     *unfinishable* cards.

6. **TECH-177's `[h]` is a symptom of a seam error, not a dependency.** (Recommendation
   standing at session end)
   - The card wrote a validation criterion requiring gates **FEAT-229** builds. Declaring
     `Depends On: FEAT-229` would have **formalized the wrong structure and created a cycle** —
     FEAT-229's Scope item 8 depends on TECH-177's specification existing.
   - **The criterion belongs to FEAT-229**, which already carries the obligation to implement
     the contract; validating it is part of implementing it.

---

## Files Created

- `workspaces/framework/skills/fw-checkbox-states/SKILL.md` — the authored source for the
  checkbox convention; TECH-177's deliverable.
- `project-hub/work/backlog/TECH-237-create-gate-asks-for-dependencies-and-validation-ownership.md`
  — the create-side half of the dependency fix.
- `project-hub/history/sessions/2026-09-22-SESSION-HISTORY.md` — this file.

## Files Modified

- `project-hub/work/doing/TECH-177-checkbox-state-convention.md` — ten criteria closed with
  evidence; a *Home — DECIDED 2026-09-22* section recording the reasoning against all five
  alternatives including both wrong turns; validation criterion marked `[h]` with a hold note.
- `project-hub/work/backlog/TECH-233-repo-level-configuration-in-the-new-build.md` — fifth open
  question added: ADR-009 D3's `.claude/` wording is stale and actively misleads, with the cost
  it incurred this session.
- `workspaces/framework/templates/records/work-item.md` — inline restatement of done-gate rules
  replaced with a pointer to the skill.

---

## Current State

### In doing/ — 3/2, over WIP
- **TECH-177** — ten of eleven criteria closed. The eleventh is `[h]`, held on FEAT-229, and is
  under a standing recommendation to move to FEAT-229 instead.
- **TECH-232** — workspace declarations. **Further along than 2026-09-21 recorded:**
  `workspace.yaml` exists, is authored, and the README points at it. Worth reconciling.

### In todo/ — 15/10, over WIP
- **FEAT-229** — carries TECH-177's contract as Scope item 8 and an acceptance criterion.

### In backlog/
- **TECH-237** — filed today.
- **TECH-233** — gained a fifth open question today.
- **FEAT-221** — **stalled on a stale dependency**, diagnosed today. Its declared blocker
  (TASK-219) is in `done/`; its real blocker (TASK-223) is unnamed on the card.

### In done/
- 11 items; a release remains due.

---

## Next Session

1. **The ADR-leak card** — 41 sites, the concept-slug plan, the three-kinds classification.
   Not yet written.
2. **TECH-177's `[h]`** — move the validation criterion to FEAT-229, closing TECH-177 cleanly.
3. **FEAT-221's dependency** — correct it to name TASK-223; it is the live instance of the
   problem TECH-237 prevents.
4. **TECH-232 reconcile** — three of its criteria look satisfied by work already in the tree.
5. **Carried, unchanged from 2026-09-21:** BUG-237 (fixture Outcome gap) still unwritten; the
   four uncovered UAT paths; `git mv` BUG-225 to `archive/` (fourth session); a release (11 in
   `done/`); a `/fw-backlog` pass (two WIP limits over).

---

**Last Updated:** 2026-09-22

---

# (Later) — The Two Open Items, Closed

**Session Focus:** the ADR-leak card written, and TECH-177's `[h]` resolved rather than carried.

---

## Summary

Both items from the "Next Session" list above were done in the same session. The ADR leak
turned out to be **nearly three times larger than reported** once card references were counted.
TECH-177 reached **11/11 with nothing held**, by moving its validation criterion to the card
that can actually perform it.

---

## Work Completed (Later)

### TECH-238 — and the count that grew under investigation

**Filed: `TECH-238-shipping-content-cites-records-a-consuming-repo-cannot-resolve.md`.**

**The number in the morning's finding was wrong — too small.** It reported 41 ADR references.
Counting card references as well, which are the *same defect*, the real figure is **113**:

| Reference | Count |
|---|---|
| ADR references | **42** — ADR-009 ×18, ADR-008 ×17, ADR-006 ×5, ADR-007 ×2 |
| Card references | **71** — BUG-215 ×14, TASK-213 ×11, TECH-232 ×7, FEAT-195 ×5, BUG-225 ×5, ~20 more |

**Recorded on the card as a note**, because the miss is instructive: the investigation looked
for what it had named (`ADR-\d+`) rather than for the *class* (records that do not ship). A
`BUG-215` citation in `fw-move.sh` dangles in a consumer's repo exactly as an ADR tag does.

**Priority set Medium, not High, deliberately** — nothing is broken *here*; the cost lands at
the first external install and at every rule change before then.

### TECH-177 — 11/11, nothing held

**The `[h]` was removed by fixing the structure, not by satisfying the criterion.**

The gate-exercising validation moved to **FEAT-229**, which builds the gates. Both cards now
carry the reasoning: a *Validation Ownership* section on TECH-177, and a quoted note on
FEAT-229's new criterion explaining why it lives there.

**The generalizable lesson, written onto TECH-177:**

> **A correct hold on a card's own acceptance criterion is a signal that the card was split at
> the wrong seam.**

The marker was used correctly — not researchable, blocked on other work — and that is precisely
why it deserved a second look rather than acceptance.

**And the trap it avoided:** declaring `Depends On: FEAT-229` would have formalized a **cycle**,
since FEAT-229's Scope item 8 depends on TECH-177's specification existing. Two cards, each
correctly waiting on the other, permanently.

**The resolving test, now recorded for reuse:** *can this card, finished, verify this criterion
without another card shipping first?*

---

## Decisions Made (Later)

7. **The ADR-leak fix is not "delete the tags."**
   - Following the morning's correction (*"A copy IS duplication"*), a naive de-tagging pass
     would make each copy **harder to trace back** — the opposite of the goal. The card says so
     explicitly, so the next reader does not take the shortcut.
   - **Three kinds, three treatments:** load-bearing rationale (state the rule, slug it, drop
     the tag), bare citation (**write the rule the citation stood in for** — the real work,
     because a bare citation means the rule was *never* stated in shipping content), and
     transitional (**4 sites, leave alone** — they expire at graduation with the code).

8. **TECH-177's validation belongs to FEAT-229, not to a dependency declaration.**
   - The seam was wrong, not the dependency. Validating a contract is part of implementing it.
   - TECH-177 closes as a completed specification with **no `Depends On:` field** — correctly,
     since it now has no dependency.

---

## Files Created (Later)

- `project-hub/work/backlog/TECH-238-shipping-content-cites-records-a-consuming-repo-cannot-resolve.md`

## Files Modified (Later)

- `project-hub/work/doing/TECH-177-checkbox-state-convention.md` — `[h]` replaced with a closed
  criterion; *Validation Ownership — DECIDED 2026-09-22* section added. **11/11.**
- `project-hub/work/todo/FEAT-229-build-the-kanban-board-in-the-new-engine.md` — gained the
  validation criterion with its why; the contract criterion now names the skill and says
  *implement it, do not restate it*.

## Commits (Later)

- `df0cc83` — TECH-177 specification authored as the `fw-checkbox-states` skill
- `b41de58` — TECH-238 filed; TECH-177's validation moved to FEAT-229

---

## Current State (End of Day)

### In doing/ — 3/2, over WIP
- **TECH-177** — **11/11, nothing held, ready for `→ done`.** Not moved: the move is Gary's
  call, and `/fw-move` runs the done-gate.
- **TECH-232** — workspace declarations; still to reconcile against work already in the tree.

### In backlog/ — filed today
- **TECH-237** — the create-gate question (dependencies + validation ownership).
- **TECH-238** — the 113 unresolvable references.

### In done/
- 11 items; a release remains due. TECH-177 would make 12.

---

## Next Session (Revised)

1. **TECH-177 → `done/`** — 11/11 and gate-ready.
2. **FEAT-221's stale dependency** — correct it to name TASK-223. It is the live instance of the
   problem TECH-237 prevents, and it is what is actually blocking FEAT-221.
3. **FEAT-229 → `doing/`** and its pre-implementation review. Its contract now exists.
4. **TECH-232 reconcile** — three criteria look satisfied by `workspace.yaml` already in the tree.
5. **Carried:** BUG-237 unwritten; the four uncovered UAT paths; `git mv` BUG-225 to `archive/`
   (fourth session); a release; a `/fw-backlog` pass (two WIP limits over).

---

**Last Updated:** 2026-09-22 (later)

---

# (Later, cont.) — The Reference Rule, Stated and Checked

## The governing rule

> **No reference to anything that doesn't exist or has no context.** (Gary, 2026-09-22)

**Scope confirmed first:** the 113 count covers **deliverables only** — `scripts/`, `commands/`,
`skills/`, `hooks/`, `templates/` in `workspaces/framework/`. Nothing under `project-hub/` was
scanned. References in cards, ADRs and session histories are fine and expected; the rule binds
only what installs into a consuming repo.

## The 71 card references, split three ways

Every cited id checked against the board and the release archive:

| Kind | Ids | Refs |
|---|---|---|
| **Illustrative examples** | `FEAT-003`, `TASK-004`, `FEAT-007` | 3 |
| **Released cards** (in `history/releases/framework-dev/v0.4.0/`) | `FEAT-192`, `FEAT-194`, `FEAT-202`, `TASK-197` | 4 |
| **Live cards** | `BUG-215` ×14, `TASK-213` ×11, `TECH-232` ×7, + 12 more ids | ~64 |

## The premature-id no-no: checked, zero instances

Gary raised it — *"we sometimes get card IDs that don't exist because they sometimes get an ID
before they're actually created, which we've agreed is a no-no."*

**It has not happened.** The four ids with no card file are **all illustrative examples**, not
citations to unwritten cards. **The discipline is holding** — and nothing enforces it, which is
the argument for a check rather than for trust.

## What the worst offenders are, and why one matters more

| File | Refs |
|---|---|
| `scripts/fw-move.sh` | 19 |
| `scripts/fw-new-workspace.sh` | 12 |
| `commands/fw-move-ops.md` | 9 |
| `skills/fw-checkbox-states/SKILL.md` | 7 *(written this session)* |
| `templates/records/work-item.md` | 4 |

**The template is the one that propagates.** Every card a consumer creates is born citing
ADR-006 and ADR-008 — records they will never have. The others are read; this one *reproduces*.

## Decisions Made (Later, cont.)

9. **Examples must be visibly examples, via a reserved never-allocated range.**
   - `--parent FEAT-007` and *"`FEAT-003` and `TASK-004` cannot both exist"* are correct
     teaching, and **indistinguishable from real citations** to a reader or a script.
   - The reserved range is what makes the pre-commit check possible at all — otherwise every
     example is a false positive. The template's `TYPE-nnn` placeholder is the existing
     precedent.

10. **The check catches the premature-id no-no at its source.** An id cited before its card
    exists falls outside the reserved range and trips the same arm. One mechanism, two problems.

11. **The `fw-checkbox-states` skill is not patched piecemeal.** It is fourth on the offender
    list with 7 references. Converting it alone would produce exactly the half-converted state
    TECH-238 exists to avoid; it converts with the rest.

## Files Modified (Later, cont.)

- `project-hub/work/backlog/TECH-238-...md` — the governing rule, the three-way split of the 71
  card references, the premature-id finding, the reserved-range requirement, and the
  pre-commit arm that catches both problems.

---

**Last Updated:** 2026-09-22 (later, cont.)
