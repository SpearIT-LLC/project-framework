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

---

# (Later, cont.) — TECH-177 Completed, and the Gate That Almost Stopped It

## TECH-177 → `done/`

**`Completed: 2026-09-22`**, stamped by the engine. 11/11 criteria, no artifact folder.
`done/` is now **12**; `doing/` drops to **1** (TECH-232) — **back under its 2-item WIP limit**
for the first time since 2026-09-21.

## The move was refused first — a false positive, known since 2026-07-02

```
❌ TECH-177 has 1 unchecked acceptance criteria — cannot move to done/
```

**There were zero unchecked criteria.** The gate matched **line 33** — historical prose, inside
backticks, describing the very problem the card fixes: *"they were struck through with `~~...~~`
but remained `- [ ]`"*.

`check_acceptance_criteria` runs `grep -ce '- \[ \]'` across the **whole file**, unanchored. It
does not scope to the Acceptance Criteria section and does not exclude inline code. The earlier
verification in this session used `^- \[ \]` (line-anchored) and correctly reported zero — the
anchor is the whole difference.

**This is TECH-166 item 4, verbatim**, filed 2026-07-02 and in `backlog/` since. That card names
the exact case, notes it is **not `--force`-able** (acceptance checks ignore the flag), records
that the only workaround is rewording the quoted content, and prescribes the fix: count
checkboxes only in the Acceptance Criteria section, or exclude fenced/inline-code and table
content.

## The workaround was taken deliberately, and marked

**Claude stopped rather than working around it**, because the offered recovery (*"Mark them
complete?"*) was wrong: there was nothing to mark, and the only path through was **editing a
true sentence in the card's historical record to satisfy a faulty grep** — the dishonest-`[x]`
failure TECH-177 exists to end.

**Gary: *"I was concerned about this one. Reword line 33 and move on."*** — one word changed
(`- [ ]` → "unchecked"), with a **blockquote left on the line recording the protest**: what was
changed, why, that nothing was wrong with the original, and that TECH-166 item 4 is the real
defect.

**The irony is load-bearing, not decorative:** the card specifying correct checkbox semantics
was hard-blocked by incorrect checkbox semantics — in the old engine it *deliberately chose not
to fix* (2026-09-21, "new engine only"). That choice was right and this is its cost, paid once.

## Decisions Made (Later, cont.)

12. **Reword the line; record the protest in place.** The alternatives were worse: parking a
    finished card in `doing/` indefinitely, or hand-`git mv`-ing around the chokepoint. Editing
    the record is the lesser evil **and is marked as such**, so the next reader does not mistake
    it for a correction.

13. **TECH-166 item 4 must not be inherited by the new engine.** FEAT-229 ports the gates;
    TECH-177's specification — now in `done/` — is what tells it to count checkboxes in the
    Acceptance Criteria section only. **Flagged for FEAT-229's pre-implementation review.**

## Files Modified (Later, cont.)

- `project-hub/work/doing/TECH-177-...md` → **`project-hub/work/done/`**; line 33 reworded with
  the protest note; `Completed: 2026-09-22` stamped by the engine.

---

## Current State (Final)

### In done/ — 12 items
- **TECH-177** completed today. **Release nudge band (10–14): worth releasing soon.**

### In doing/ — 1/2, back under WIP
- **TECH-232** — workspace declarations; still to reconcile against `workspace.yaml`, which is
  already in the tree.

### In backlog/ — filed today
- **TECH-237** (create-gate question), **TECH-238** (113 unresolvable references).

### Still over WIP
- `todo/` at 15/10. A `/fw-backlog` pass remains due.

---

## Next Session (Final)

1. **FEAT-221's stale dependency** — correct it to name TASK-223. The live instance of TECH-237's
   problem, and what is actually blocking the card.
2. **FEAT-229 → `doing/`** and its pre-implementation review. Its contract exists now, and
   **TECH-166 item 4 must be raised in that review** so the new gates do not inherit the
   unanchored grep.
3. **A release** — 12 in `done/`.
4. **TECH-232 reconcile** — three criteria look satisfied by work already in the tree.
5. **Carried:** BUG-237 unwritten; the four uncovered UAT paths; `git mv` BUG-225 to `archive/`
   (fourth session); a `/fw-backlog` pass.

---

**Last Updated:** 2026-09-22 (final)

---

# (Later, cont.) — FEAT-221 Corrected; FEAT-229 Split Into Three

## FEAT-221's stale dependency — three cards, not one

**FEAT-221, .1 and .2 all named TASK-219**, in `done/` since 2026-09-10 with its Group 2 work
deferred to **TASK-223**, which none of them named. Declared blocker satisfied; real blocker
invisible. **That is why FEAT-221 could not move.**

**FEAT-221.2 also named TECH-177**, which completed today. **Retargeted to FEAT-229** — TECH-177
is the *specification*; that card needs the markers to actually **gate**, which FEAT-229
implements. Naming the spec would have read as satisfied while the behaviour was still absent.

Each correction carries an inline note recording what it read before and why it was wrong.

**Board scanned for others:** only FEAT-179 also names a `done/` card (FEAT-175) — correctly,
since SPIKE-178 still blocks it. Left alone.

## FEAT-229 — TECH-237's test applied to it, on Gary's prompt

**Gary: *"Does FEAT-229 include our new card test we added today (TECH-237)? If not let's apply
the spirit of TECH-237 so we don't run into the dependency issue on this one."***

**It did not, and applying it found a hidden dependency.** FEAT-229 had **no `Depends On:`
field** while carrying a TASK-223 dependency through `accept/` — both `accept/` and `cancelled/`
sit in `kanban_FOLDERS` with semantics TASK-223 has not settled, and `kanban_TERMINAL="done
cancelled"` presumes an answer it has not given. **The same defect that stalled FEAT-221, caught
before it stalled anything.**

## Two scope items were already done — found by running the code

Before splitting, the card's claims were tested in a scratch repo rather than read:

```
$ fw-new.sh FEAT test-scaffold
Created kanban queue at kanban/ (first use)          ← scaffold: ALREADY WORKS
Created: kanban/backlog/FEAT-001-test-scaffold.md    ← create:   ALREADY WORKS
$ fw-new.sh BUG t2  →  BUG-002                        ← shared sequence: correct
$ fw-move.sh kanban FEAT-001 todo
❌ namespace 'kanban' is declared but not active      ← the ONLY real gap
```

`fw-new.sh:155-163` scaffolds on first use (FEAT-175, 0.4.7). **Gary's proposed split
(scaffold → create → move) collapsed on this evidence** — two of its three stages were built
months ago. The card's own *"narrower than first written"* note had not gone far enough.

## The split — three children, smallest bite first

**Gary: *"a. Split. Smaller bites are better."***

| Child | Scope | Depends On |
|---|---|---|
| **.1** | Wire `kanban_TRANSITIONS` (five settled folders); retire the not-wired refusal; teach the seeder | *(nothing)* |
| **.2** | The gates — dependency, acceptance with TECH-177's contract, WIP warnings | .1 |
| **.3** | `accept/` + `cancelled/` + terminal archival | .2, **TASK-223** |

**Nothing blocks .1 or .2** — that is what deferring `accept/`/`cancelled/` bought (Gary:
*"Let's defer accept/ and cancelled/ for a followup enhancement, then we should be able to get
straight through FEAT-229 without the churn"*).

## Decisions Made (Later, cont.)

14. **Defer `accept/` and `cancelled/` to .3.** Both are declared in `kanban_FOLDERS` with
    unsettled semantics; TASK-223 requires the parked-state set to be decided **as a set**.
    Deferring them moves the only external dependency off the critical path.

15. **BUG-174 and TECH-166 are not dependencies — they are warnings.** Verified: the new engine
    has **zero** limit logic and **zero** acceptance-criteria logic, so there is nothing to
    inherit yet. Both are old-engine defects in code retiring at the D5 crossover. They became
    **acceptance criteria on .2** (exclude all dotfiles; scope the checkbox scan to the
    Acceptance Criteria section) rather than `Depends On:` entries.
    - **A note was appended to both cards:** if .2 lands correctly they become old-engine-only
      defects with a shelf life — *do not work them twice*.

16. **The dotted-id family stays in one folder — the engine was right, the plan was wrong.**
    `.3` was written expecting `backlog/`; `/fw-move 229 todo` moved all three children with
    the parent. That is TASK-219 Group 1 working as designed: tight coupling, one WIP item.
    **`.3`'s `Depends On: TASK-223` is what records that it cannot start — not its folder.**
    Both cards corrected to say so.

## Files Created (Later, cont.)

- `project-hub/work/todo/FEAT-229.1-wire-kanban-transitions.md`
- `project-hub/work/todo/FEAT-229.2-port-the-three-kanban-gates.md`
- `project-hub/work/todo/FEAT-229.3-accept-and-cancelled-states.md`

## Files Modified (Later, cont.)

- `project-hub/work/backlog/FEAT-221*.md` (three cards) — dependencies corrected, each with an
  inline note.
- `project-hub/work/todo/FEAT-229-...md` — split header; Scope items annotated with their
  destination, two marked **ALREADY DONE**; moved `doing/` → `todo/`.
- `project-hub/work/backlog/BUG-174-...md`, `TECH-166-...md` — shelf-life notes.

---

## Current State (Final, revised)

### In doing/ — 1 card
- **TECH-232** only. (The engine reports 2/2 because of **BUG-174** — `.gitkeep` is counted.
  Gary caught this misreport during the session; `done/` is really **11**, not 12.)

### In todo/ — 16 cards
- **FEAT-229 + .1/.2/.3** — one WIP item by the dotted-id rule. **.1 is the next implementation
  card and is blocked by nothing.**

### In backlog/
- **TECH-237**, **TECH-238** filed today · **FEAT-221** family now naming real blockers.

---

## Next Session (Final, revised)

1. **FEAT-229.1 → `doing/`** — wire the transitions. Blocked by nothing; the smallest slice.
2. **FEAT-229.2** — the gates, with TECH-177's contract and the two must-not-inherit defects.
3. **A release** — 11 in `done/`.
4. **TECH-232 reconcile** · **`/fw-backlog` pass** (`todo/` at 16).
5. **Carried:** BUG-237 unwritten; four uncovered UAT paths; `git mv` BUG-225 to `archive/`.

---

**Last Updated:** 2026-09-22 (final, revised)

---

# (Later, cont.) — The Kanban Board Moves and Gates

**Session Focus:** FEAT-229.1 and .2 implemented; three bugs filed from one root cause.

---

## Summary

The kanban namespace went from **declared-and-refused** to **moving and gated** in two slices.
Along the way a third hidden dependency surfaced — and Gary's *"here we go again"* forced the
question of whether it actually blocked anything. **It did not**, and testing that properly is
what let .2 finish today.

---

## FEAT-229.1 — transitions wired

**`kanban_TRANSITIONS` is an allowlist**, not the old engine's denylist. The old engine lists
*invalid* pairs and permits everything else, which silently allows every pair nobody thought to
forbid — `backlog:done` among them. The new row enumerates what is legal.

**`accept/` and `cancelled/` stay declared with no transitions**, so every move into them is
refused. That is the allowlist doing its job, not an omission.

**The not-wired guard needed no code change.** It fires on empty transitions, so it stopped for
kanban by itself and still protects any future namespace between declaration and wiring. Only
its comment was stale — worth noting as the *cheapest* possible outcome of a design that put
the signal in data rather than in an `if`.

**The seeder was generalized** from operations-only. The kanban set seeds **one fixture per
checkbox state**, so .2's gate work had something real to read the moment it started.

**Validated: 11 transition cases, bundle travel, and a clean operations regression.**

---

## FEAT-229.2 — the gates

**Three gates, declared as DATA:** `kanban_GATES="gate_dependencies gate_markers
gate_acceptance"` sits in the policy table beside the transitions. Adding a gate to a namespace
is a row edit, not a new branch in the mover — the same shape BUG-215 established for
namespaces themselves.

**All gates run.** One invocation names every reason a move is refused, rather than making the
user fix one thing and run again.

**TECH-177's contract implemented, not restated** (ADR-008 — the skill is the authored source).

### The validation run — 9 cases, every branch

| Case | Fixture | Result |
|---|---|---|
| All `[x]` → done | FEAT-906 | ✅ moves |
| `[/]` in progress → done | BUG-907 | ✅ **blocked** — the case the old engine gets wrong |
| `[-]` cancelled → done | TECH-908 | ✅ **passes by design** |
| Marker quoted in prose → done | FEAT-911 | ✅ **passes** — TECH-166 item 4 |
| `[?]` → doing | TASK-909 | ✅ blocked, line **and** `**Question:**` note printed |
| `[h]` → doing | SPIKE-910 | ✅ blocked, line **and** `**Hold:**` note printed |
| Unmet + met dependency | FEAT-904 | ✅ names **only** the unmet one, with its folder |
| Met dependency only | FEAT-904 | ✅ moves |
| 2 cards + 2 dotfiles, limit 2 | — | ✅ warns **2/2** not 4/2, and still moves |

**FEAT-911 is the row that matters.** That fixture is the exact shape that hard-blocked
TECH-177 **this morning** — a marker quoted in prose, counted by a whole-file grep. It now moves
cleanly. **The defect that cost a reworded record at 11am was fixed by 4pm, in the engine that
will inherit the board.**

**Operations regression clean — 5 cases**, including a batch that continues past a bad id.
Gates are inert there via an empty `operations_GATES` row: an operations record has no
acceptance criteria and no dependencies.

---

## Three Bugs, One Root Cause

**BUG-239, BUG-240 and BUG-241 all trace to the same gap:** TASK-219 settled dotted-id
semantics on 2026-09-09 — *a child lives and dies with the parent, moves with it, counts as one
WIP item* — **and nothing ever mechanized it.** It was a paragraph in a template comment.

| Bug | Found by | Symptom |
|---|---|---|
| **BUG-239** | Moving FEAT-229's own family | Children carried past every gate (old engine) |
| **BUG-240** | Gary questioning the WIP count | A family of 4 counts as 4, not 1 |
| **BUG-241** | Testing `--parent` before writing gates | A child cannot be addressed; asking for one **silently moves the parent** |

**BUG-241 is the severe one.** `grep -oE '[0-9]+$'` on `FEAT-001.1` captures the trailing `1`,
which matches `FEAT-001`; and the locating pattern requires a hyphen after the digits, so
`FEAT-001.1-slug.md` is unreachable by any input. The engine reported
`SKIPPED FEAT-001-parent-card.md` for a card the user never named, and exited 0.

**ADR-008 Root 2, demonstrated three times in one afternoon:** an instruction the AI merely
reads is not a guardrail.

---

## Decisions Made (Later, cont.)

17. **FEAT-229.4 created to absorb all three bugs** — after Gary pushed back on yet another
    hidden dependency: *"What happens if we leave it as a bug unique to dotted IDs? Can we move
    on then?"*
    - **Tested rather than assumed.** Two of the three gates have **no** dotted-id dependency:
      the dependency gate reads a field on one card, the acceptance gate reads one card's
      criteria. Only WIP-collapsing and family-gating need addressable members.
    - **Every fixture is flat** (FEAT-901…FEAT-911), so nothing .2 validates was left untested
      by the split.
    - **The answer was yes** — and .2 finished the same afternoon because of it.

18. **The cost of the split is stated on the card, not hidden.** The WIP warning ships counting
    a dotted family as N rather than 1, so it over-warns until .4 lands. Cosmetic — the limit
    is warning-only — and it is the behaviour today regardless.

19. **Ripeness is not a gate, and the reason lives in the code.** A gate may read a **fact that
    happened** (a dependency's folder, a checkbox's state); it may never read a **judgment**
    about whether a plan is ready (ADR-007 D7). Without that paragraph beside the gates, the
    next person adds a ripeness check next to them and D7 erodes with nobody deciding to erode
    it. This is TECH-177's `[?]`/`[h]` argument, applied where the gate lives.

20. **The WIP warning fires once per invocation, not per record.** A batch of three into an
    over-limit folder is one situation a human is being told about, not three.

---

## Files Created (Later, cont.)

- `project-hub/work/backlog/BUG-239-dotted-children-bypass-every-move-gate.md`
- `project-hub/work/backlog/BUG-240-wip-count-does-not-collapse-dotted-ids.md`
- `project-hub/work/backlog/BUG-241-new-engine-cannot-address-a-dotted-child.md`
- `project-hub/work/doing/FEAT-229.4-dotted-id-family-semantics.md`

## Files Modified (Later, cont.)

- `workspaces/framework/scripts/fw-move.sh` — kanban transitions (allowlist), the three gates,
  `*_GATES` policy rows, WIP warning. 291 → ~460 lines.
- `workspaces/framework/tests/seed-uat-fixtures.sh` — generalized to both namespaces; kanban
  fixtures seed one card per checkbox state.
- `project-hub/work/doing/FEAT-229.1` (8/8), `FEAT-229.2` (9/10) — validation runs recorded.
- `project-hub/work/backlog/BUG-174`, `TECH-166` — shelf-life notes: FEAT-229.2 fixed both in
  the new engine, so they are now old-engine-only defects that retire at the crossover.

## Commits (Later, cont.)

- `a01551d` — FEAT-221 dependencies corrected
- `96a18d5` — FEAT-229 split into three children
- `47344b9` — FEAT-229.1 transitions wired; BUG-239, BUG-240 filed
- `4493d60` — BUG-241 filed
- `4252e86` — FEAT-229.2 the gates

---

## Current State (End of Session)

### In doing/ — 2 WIP items (6 files)
- **FEAT-229** family: parent + `.1` (8/8 ✅) + `.2` (9/10) + `.3` (blocked on TASK-223) +
  `.4` (the dotted-id work). One WIP item by the dotted-id rule.
- **TECH-232** — workspace declarations, still to reconcile.

### In done/ — 12 cards
Release overdue. *(Engine reports 13 — BUG-174 in the old engine, unfixed by design.)*

### In backlog/ — 89
Five filed today: TECH-237, TECH-238, BUG-239, BUG-240, BUG-241.

---

## Next Session

1. **FEAT-229.4** — dotted-id family semantics. Closes BUG-239/240/241 together; unblocks the
   two criteria deferred from .2. **The engine cannot address a dotted child, so this is
   load-bearing for the crossover.**
2. **FEAT-229.2's last criterion** — human UAT against the installed plugin (needs a publish).
3. **A release** — 12 in `done/`.
4. **TASK-223** — unblocks `.3` *and* FEAT-221. The parked-state set decided as a set.
5. **Carried:** TECH-232 reconcile · `/fw-backlog` pass · BUG-237 unwritten · four uncovered
   UAT paths · `git mv` BUG-225 to `archive/`.

---

**Last Updated:** 2026-09-22 (end of session)
