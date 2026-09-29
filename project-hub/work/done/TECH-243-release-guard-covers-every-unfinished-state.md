# Tech: The Release Guard Must Cover Every Unfinished State, Not Just `doing/`

**ID:** TECH-243
**Type:** Tech
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-09-23
**Workspace:** framework
**Depends On:**
**Depended On (satisfied):** TASK-242, released in framework-dev v0.5.0. Moved off the `Depends On:` line on 2026-09-29: the old engine reads that line word by word and only searches `project-hub/work/`, so it refused the move.
**Completed:** 2026-09-29

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
- **Post-release archival** — the step *after* a release; this is the gate *before* one.
  TECH-078 owned it; archived 2026-09-29 and carried by **FEAT-028**.
- **Release automation** — FEAT-028.

## Review Findings and Decisions (2026-09-29)

- **The live board has no `accept/` or `hold/`.** Its folders are backlog, todo, doing, done,
  blocked, archive. The guard skips a missing folder, so both are guarded the day they exist.
  On the live board, `blocked/` is the new case today.
- **The old guard was prose, not a script.** Step 2a told the AI to run `ls`. It is now
  `.claude/scripts/fw-release-guard.sh`, and `fw-release.md` acts on its exit code
  (0 clear · 1 blocked · 2 confirm).
- **The open question has an answer: a `**Started:**` stamp** (Gary challenged "no cheap
  signal"). Git history cannot tell: folder moves reach git only when committed, and TASK-223's
  history shows `backlog → done` for a card that went through `doing/`. Both engines now stamp
  `**Started:**` on `→ doing`, first start only, never overwritten. The guard warns on a parked
  card with a `Started:` date and prints an info line for one without.
- **Full move history** (Gary's "big perhaps") is filed as **FEAT-260**, not built. Session
  history already answers "which day", roughly.

## Acceptance Criteria

- [x] `accept/` is a hard block on release, naming the cards *(guard exit 1; scratch-tested)*
- [x] `blocked/` and `hold/` warn, name the cards, and require confirmation *(started cards only;
      never-started cards get an info line; exit 2; scratch-tested)*
- [x] `doing/` behaves exactly as today — no regression to the one guard that works *(BLOCK,
      `--force` bypasses; live board: blocked on TECH-243 itself)*
- [x] The severity table is written down **where the guard lives**, so the next reader does not
      flatten it back to one rule *(`fw-release-guard.sh` header, and as data in `POLICY`)*
- [x] One implementation serves all four folders — no copy per folder *(one loop)*
- [x] Validated: **AI** — each state, one at a time, on a scratch board *(2026-09-29)* ·
      **Human** — replaced: the live board has no `accept/`. Instead, the next real release
      runs the guard and reports BUG-144 as `INFO … (never started)`
- [x] `**Started:**` stamped on `→ doing` by both engines, first start only; the path
      todo → doing → hold → doing → accept → done keeps the first date *(scratch-tested,
      new engine; old engine tested with blocked)*
- [x] FEAT-028 carries the guard as a requirement for the new release command

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
