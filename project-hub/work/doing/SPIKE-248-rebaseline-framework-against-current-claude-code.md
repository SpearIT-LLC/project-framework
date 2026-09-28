# Spike: Re-baseline the Framework Against Current Claude Code

**ID:** SPIKE-248
**Type:** Spike
**Priority:** High
**Version Impact:** NONE
**Created:** 2026-09-27
**Workspace:** framework
**Timebox:** 4 hours
**Depends On:**
**Completed:**

---

## The Question

**Which parts of the framework still earn their keep, a year on, given what Claude Code now
does natively? And what should `CLAUDE.md` contain once everything that can be enforced is
moved into skills and hooks?**

The framework began on 2025-12-19. Its principles were set against the tooling of that time,
when ADR-007's premise held: "`CLAUDE.md` is the only file Claude Code auto-loads." That
premise no longer holds. There are now skills (loaded on demand from their descriptions),
hooks (enforced by the harness), plugins, user-level memory and output styles. This spike
sorts the framework into what to keep, what to move and what to delete. It works from the
framework's primary purpose, not from how it works today.

## Why Now

- **The purpose holds; the delivery channel has aged.** My reading of the primary purpose:
  one person runs many bodies of work with an AI partner, stays in control of what gets
  built, and keeps a record that outlasts any single session.
- **The meta-cost is visible.** In the last month most of the effort went into the framework
  itself (engines, gates, UAT). ADR-008 recorded that the "onion" was already blocking live
  client work in July. Every part we build ourselves that Claude Code now does natively is
  maintenance we don't need.
- **ADR-009 is mid-build.** The new plugin's shape is still flexible, so this is the cheap
  moment to re-baseline. After graduation it would cost more.

## Evidence Already Found (2026-09-27, verified)

- **`CLAUDE.md` has drifted from its own single source.** The root `CLAUDE.md` Response Style
  ("optimize for skippability") was edited directly on 2026-09-10. The authored source,
  `.claude/framework-contract.md`, still has "Default to 5 lines or fewer" and was last
  changed on 2026-07-22. ADR-007 and ADR-008 were written to protect this file, and it now
  breaks the Single-Source Rule itself. CLAUDE.md's own note that this rule "has drifted
  twice" is the same symptom.
- **Two bootstrap steps are prose standing in for mechanisms, by ADR-008's own test.**
  - Step 3 (report `doing/`) could be a `SessionStart` hook, the same kind that already
    refreshes contacts (UAT-30..32).
  - Step 4 (`git mv` only) could be a `PreToolUse` hook that blocks `mv`, `Move-Item` and `cp`
    on `project-hub/work/`.

## Starting Hypotheses (to confirm or refute)

**Keep (these principles are durable, some more so than a year ago):**
- ADR-001's rule: implement only approved work. More capable models make it more important,
  not less.
- ADR-008's rule, mechanism over prose: "commands own chokepoints; documents do not."
- One authored source per concept, and a written record in git (ADRs and session histories),
  because the AI still starts each session without memory.
- The Epistemic Standards.

**Move out of `CLAUDE.md`:**
- The bootstrap steps: into hooks (see above).
- Response Style: into user-level memory or an output style. It describes Gary, not this
  project, so it should follow him into client repos too.
- Persona framing (`roles.default`, "adopt a … mindset"): replace it with a statement of the
  expected output, or drop it.

**Can now be partly enforced:** the Implementation Rule. A `PreToolUse` hook on Edit and Write
could warn when source files change while `doing/` is empty. It can't judge whether an edit
belongs to the card. It catches the commonest failure, starting work with no card at all.
*(My opinion; not yet tested.)*

**Question each of these:**
- Ceremony sized for a team, run by one person: nine board folders, `accept/` as a separate
  stage, `hold` and `blocked` as two states. The measure is Gary's review attention, not
  coding speed.
- Prompting style from 2025 models, such as "**CRITICAL: Do NOT use Task tool**" and
  "YOU parse…". Keep the script-first approach; drop the shouting.
- Framework features that overlap native ones. Example: plan mode covers some of what
  "`→ doing` validates the plan" does.

## What to Determine

1. **Inventory:** list every rule, command, hook and document that ships in the new build
   (`workspaces/framework/`), plus the root `CLAUDE.md`. Mark each one keep, mechanize, move
   to a skill, move to user level, or delete. Give a one-line reason for each. The root
   `.claude/` is deleted at graduation (ADR-009); look at its parts only where they are meant
   to carry over. *(Scope narrowed at the pre-implementation review, 2026-09-28, to fit the
   timebox.)*
2. **Native overlap:** for each framework feature, is there a current Claude Code feature that
   does the job? Verify against current Claude Code documentation, not memory.
3. **`CLAUDE.md` target:** what is the smallest set that must be auto-loaded? Test the draft in
   `SPIKE-248/claude-md-slim-draft.md` against real sessions: does the AI still do the things
   that mattered? **Method (2026-09-28):** a few fresh sessions doing ordinary tasks, with no
   mention of the spike or the draft (a session that knows it is under test proves little;
   see TECH-249). Check whether these still happen: implement only from `doing/`, `git mv`
   for board moves, lead with the answer, verify before stating.
4. **The drift:** decide the fate of `.claude/framework-contract.md`. Either the build composes
   `CLAUDE.md` from it and a check fails on drift (TECH-189), or it is deleted and `CLAUDE.md`
   becomes the only source.
5. **Scope of change:** which findings go into the ADR-009 build before graduation, and which
   wait until after it? *(Reworded 2026-09-28: the question originally asked what waits until
   after `framework-dev-v0.5.0`, which shipped that day.)*

## Exit Criteria

A spike ends in a **decision, not a document**:

- [ ] The inventory is complete, and every item has a keep / mechanize / move / delete verdict
      with its reason
- [ ] Native-overlap claims are verified against current Claude Code docs, with a source for
      each
- [ ] The `CLAUDE.md` target is decided: the slim draft is accepted, or revised with reasons
- [ ] The contract drift is resolved: the fate of `framework-contract.md` is decided
- [ ] Follow-up cards are filed for each accepted change, or an ADR if the change is
      architectural (it likely amends ADR-007)

## Related

- **ADR-007**: its premise (`CLAUDE.md` is the only auto-loaded channel) is the one being
  re-examined
- **ADR-008**: the test applied throughout (mechanism over prose, one source)
- **ADR-009**: the build this re-baseline feeds
- **TECH-189**: the drift guard, which the contract drift shows is still needed
- `project-hub/research/jev-typesafe-evaluation.md` (2026-09-27): a decision-only model
  that could make the judgment half of the framework (the Implementation Rule, card
  ripeness) callable from hooks. The recommendation is not yet. If it is trialled, it is
  advisory and fails open, and only facts block.
- `project-hub/history/sessions/2026-09-27-SESSION-HISTORY.md`: the conversation that
  produced this card
