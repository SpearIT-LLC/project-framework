# Tech: The Release Guard Must Cover Every Unfinished State, Not Just `doing/`

**ID:** TECH-243
**Type:** Tech
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-09-23
**Workspace:** framework
**Depends On:** TASK-242 (the parked-state set must be decided before a guard can name it)
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

`/fw-release` blocks on `doing/` and **nothing else**. Once `accept/` exists — and given
`blocked/` and `hold/` already do — a release can ship with **half-finished code in the repo**
that no guard mentions. Widen the guard to every state that means *"this work is not finished."*

## Why It Exists

Raised by Gary, 2026-09-23, while settling TASK-242's `accept/` transitions:

> *"We should also put guards on release to check for cards in accept/, blocked/, hold/.
> Half done items in there could affect a release."*

**The insight behind it is the same one that settled `accept/`'s exits.** A card in `accept/`,
`blocked/` or `hold/` may have **code merged in the repo** — that is precisely what distinguishes
those states from `todo/` and `backlog/`. A release cuts from the repo, not from `done/`, so
unfinished code ships whether or not its card is in `done/`.

## Current State (verified 2026-09-23)

`.claude/commands/fw-release.md` step 2a:

```bash
ls project-hub/work/doing/
```

> ❌ **Release blocked — items in doing/**
> … Releasing with in-progress work risks an incomplete or out-of-sync release.

**The reasoning is already correct — it is just applied to one folder.** Every word of that
warning is equally true of `accept/`, `blocked/` and `hold/`.

| Folder | Code in repo? | Guarded today |
|---|---|---|
| `doing/` | maybe | ✅ blocks |
| `accept/` | **yes, by definition** — implemented, awaiting UAT | ❌ nothing |
| `blocked/` | **maybe** — a card blocked mid-implementation | ❌ nothing |
| `hold/` | **maybe** — a card paused mid-implementation | ❌ nothing |
| `todo/` / `backlog/` | no — never started | correctly unguarded |

**`accept/` is the sharpest case:** a card only reaches it by being implemented. A release with
cards in `accept/` is a release shipping code the user has explicitly not yet accepted.

## Design

**Not a uniform hard block — the states differ in what they mean for a release.**

| State | Proposed | Why |
|---|---|---|
| `doing/` | **hard block** (unchanged) | actively changing; may be mid-edit |
| `accept/` | **hard block** | implemented but unaccepted — the whole point of the state |
| `blocked/` · `hold/` | **warn, name the cards, require confirmation** | a card parked *before* implementation is harmless; one parked *after* is not, and the folder cannot tell them apart |

**Why `blocked`/`hold` warn rather than block:** a card blocked in `backlog` before any code
existed does not affect a release, and blocking on it would make the guard the thing people
`--force` past habitually — which is how a guard stops being read. **A warning that names the
cards puts the judgment where it belongs.**

**Open question for implementation:** can the guard tell *"parked with code in the repo"* from
*"parked before starting"*? A `Completed:` stamp does not exist yet at that point. Candidates: the
folder it was parked *from* (not currently recorded), or a marker written at park time. **If no
cheap signal exists, warn on all of them** — imprecise and loud beats silent.

## Scope

- Widen `/fw-release`'s pre-release validation to `accept/`, `blocked/`, `hold/`.
- Name the cards in every message, as step 2a already does.
- **One implementation, not four copies** — the folders differ only in severity and message.
- Decide the `--force` story per severity: `--force` past a hard block, confirm past a warning.

**Out of scope:**

- **The new engine's release command**, which does not exist yet. This card fixes the **old**
  engine's `/fw-release`, because that is the one that will cut the next release. Record the
  requirement so the new one is born with it rather than inheriting the hole.
- **Post-release archival** — **TECH-078** owns moving `done/` items to
  `history/releases/vX.Y.Z/`. That is the step *after* a release; this is the gate *before* one.
- **Release automation** — FEAT-028.

## Acceptance Criteria

- [ ] `accept/` is a hard block on release, naming the cards
- [ ] `blocked/` and `hold/` warn, name the cards, and require confirmation
- [ ] `doing/` behaves exactly as today — no regression to the one guard that works
- [ ] The severity table is written down **where the guard lives**, so the next reader does not
      flatten it back to one rule
- [ ] One implementation serves all four folders — no copy per folder
- [ ] Validated: **AI** — a release attempted with a card in each state, one at a time ·
      **Human** — a real release cut with `accept/` occupied is refused, and the message says
      what to do about it

## Related

- **TASK-242** — decides the parked-state set. **A guard cannot name `hold/` before that card
  says `hold/` exists**, which is why this depends on it.
- **FEAT-221.1** — puts the acceptance-criteria gate on `doing → accept`. That gate stops
  *unfinished* work entering `accept/`; this one stops *unaccepted* work leaving in a release.
  Complementary, not overlapping.
- **TECH-078** — post-release archival of `done/`. The step after; deliberately separate.
- **FEAT-028** — release automation, which should inherit this guard rather than reimplement it.
- **ADR-008 Root 2** — the guard is a mechanism; the warning text is not. That is why this card
  changes a script and not a document.
