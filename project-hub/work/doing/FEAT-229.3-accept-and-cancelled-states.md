# Feature: The `accept/` and `cancelled/` States, and Terminal Archival

**ID:** FEAT-229.3
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-09-22
**Workspace:** framework
**Depends On:** FEAT-229.2 (the gates), TASK-242 (the terminal/parked-state set)

<!-- Retargeted 2026-09-22: was TASK-223. Group 2a split out of that card into TASK-242
     precisely because it was the only part blocking this one. TASK-223 keeps its other
     eleven conventions and blocks nothing here. -->
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Add the two deferred folders — `accept/` and `cancelled/` — to the kanban transition matrix,
with their terminal semantics and spike archival. **Deliberately split off so FEAT-229.1 and .2
run straight through** (Gary, 2026-09-22).

> **On this card's folder:** it sits in `todo/` with its parent and siblings because a dotted
> id moves with the parent and the family counts as one WIP item (TASK-219 Group 1). Its
> `Depends On: TASK-223` is what records that it cannot start — not its folder.

## Why This Is Separate

**Both folders are already in `kanban_FOLDERS`; neither has settled semantics.** The engine
declares:

```bash
kanban_FOLDERS="backlog blocked todo doing accept done cancelled"
kanban_TERMINAL="done cancelled"
```

**`kanban_TERMINAL` presumes an answer TASK-223 has not given.** Its Group 2a open questions
are explicit: *transitions into `cancelled/`, whether it is terminal, a board closure code,
where the 27 `deprecated/` cards live* — and `accept/`'s relationship to `done/` and to
FEAT-030's hold state.

**TASK-223 requires these to be decided as a set** (line 198: *"The terminal/parked-state set
is decided as a set (Group 2a) — `accept/`, `cancelled/`, and FEAT-030's hold"*). Three folder
questions arrived within one week; answering one alone produces the fourth uncoordinated answer.

**So the dependency is real and this card waits.** FEAT-229.1 and .2 do not — that is the whole
point of the split. The two folders stay declared and simply get no transitions until this card
runs.

## Scope

1. **Transitions into and out of `accept/`** — the state between `doing` and `done`, per
   TASK-223's decision.
2. **Transitions into `cancelled/`**, and whether it is genuinely terminal.
3. **`kanban_TERMINAL` corrected** to match what TASK-223 settles, rather than presuming it.
4. **Terminal-state archival** — a spike moved to a terminal state archives to
   `history/spikes/`; a POC spike archives as a **folder**; neither produces a release
   (`kanban§2`, TECH-228).
5. **The board closure code**, if TASK-223 decides there is one (the operations namespace has
   `CODES`; the board may or may not want an equivalent).

## Out of Scope

- **Deciding the semantics.** TASK-223 does that; this card *encodes* the decision. If it turns
  out TASK-223 settles them and this card is trivial, that is the correct outcome — the
  encoding is still a mechanism that has to exist.
- **FEAT-030's `hold/` folder** — part of TASK-223's set, but a `project-hub/work/` folder
  question, not a kanban-engine one. It may or may not produce work here.
- **The cutover.**

## Acceptance Criteria

- [ ] `accept/` has transitions in and out, matching TASK-223's decision
- [ ] `cancelled/` has transitions in, and its terminal status matches the decision rather than
      the current presumption
- [ ] `kanban_TERMINAL` is correct and traces to TASK-223, not to an assumption
- [ ] A spike moved to a terminal state archives to `history/spikes/`; a POC spike archives as
      a folder; neither produces a release
- [ ] No transition is added that TASK-223 did not settle — an unsettled pair stays illegal
- [ ] Validated: **AI** — every new pair exercised against a seeded fixture · **Human** — a
      card through `doing → accept → done` and a card to `cancelled/`, against the **installed
      plugin** (TECH-188)

## Related

- **FEAT-229** — parent · **FEAT-229.2** — the gates these transitions pass through.
- **TASK-223** — **Group 2a, the blocker.** Decides `accept/`, `cancelled/` and FEAT-030's hold
  **as a set**.
- **FEAT-030** — the `hold/` folder, open since 2026-01-08; the third member of that set.
- **FEAT-221 / FEAT-221.1** — `accept/` is *their* blocker too, via TASK-223. This card does
  not unblock them; TASK-223 does.
- **TECH-228** — the SPIKE template, which affects what archival resolves for one type.
