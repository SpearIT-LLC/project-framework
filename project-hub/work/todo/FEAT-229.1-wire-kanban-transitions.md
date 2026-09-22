# Feature: Wire the Kanban Transition Matrix

**ID:** FEAT-229.1
**Type:** Feature
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-09-22
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Fill `kanban_TRANSITIONS` for the **five settled folders** and retire the not-wired refusal for
the namespace. This makes kanban a live namespace in the engine — moves work, gates do not yet.

**The smallest slice that turns the namespace on.** A table edit, immediately testable, and the
thing every other kanban card waits on.

## Current State (verified 2026-09-22)

The engine declares kanban and refuses it before parsing any id:

```bash
kanban_ROOT="kanban"
kanban_FOLDERS="backlog blocked todo doing accept done cancelled"
kanban_TRANSITIONS=""          # ← the declared-but-not-wired signal
kanban_TERMINAL="done cancelled"
```

**Verified by running it** in a scratch repo:

```
$ fw-move.sh kanban FEAT-001 todo
❌ namespace 'kanban' is declared but not active in this engine yet
```

**Scaffold and create already work** — this was confirmed by execution, not assumption, and it
is why this card is only about transitions:

```
$ fw-new.sh FEAT test-scaffold
Created kanban queue at kanban/ (first use)
Created: kanban/backlog/FEAT-001-test-scaffold.md
$ fw-new.sh BUG t2  →  kanban/backlog/BUG-002-t2.md    (shared sequence, correct)
```

`fw-new.sh:155-163` scaffolds the queue on first use (mirroring `fw-new-ops-record.sh`), and
id assignment delegates to `fw-next-id.sh`. **FEAT-229's Scope items 4 and 5 were already
satisfied** — its own "narrower than first written" note did not go far enough.

## Scope

1. **Populate `kanban_TRANSITIONS`** for the five settled folders: `backlog blocked todo doing
   done`.
2. **Remove the not-wired refusal** for kanban (the `[ -z "$NS_TRANSITIONS" ]` guard keeps
   working for any future declared-but-unwired namespace).
3. **Teach `seed-uat-fixtures.sh` the kanban namespace** — it refuses kanban today by design
   (`seed-uat-fixtures.sh:55`), and nothing downstream can be tested without it.

**The allowlist/denylist inversion — the one real design note.** The old engine uses a
**denylist** (`INVALID_TRANSITIONS`: `backlog:doing`, `done:backlog`, `done:todo`,
`done:doing`); the new engine uses an **allowlist** (`NS_TRANSITIONS`, as operations does:
`open:onhold onhold:open open:closed onhold:closed`). **Do not port the denylist.** Enumerate
what is legal. A denylist silently permits every pair nobody thought to forbid, which is how
`backlog:done` would slip through.

## Out of Scope

- **The three gates** — FEAT-229.2. This card makes moves *happen*; it does not make them
  *checked*.
- **`accept/` and `cancelled/`** — FEAT-229.3, deferred with TASK-223 (Gary, 2026-09-22) so
  this card is not blocked by a backlog item. They stay in `kanban_FOLDERS`; they simply get no
  transitions yet.
- **The cutover** — `project-hub/work/` stays the live board. This card leaves kanban working
  and unused.

## Acceptance Criteria

- [ ] `kanban_TRANSITIONS` enumerates the legal pairs among `backlog blocked todo doing done`,
      as an **allowlist** — the denylist is not ported
- [ ] `backlog:doing` is **not** legal (commit to work first: `backlog → todo → doing`)
- [ ] `done:backlog`, `done:todo`, `done:doing` are **not** legal — completed items are not
      reopened
- [ ] The not-wired refusal no longer fires for kanban, and still fires for a namespace
      declared with empty transitions
- [ ] `seed-uat-fixtures.sh` seeds kanban fixtures
- [ ] A card created by `fw-new.sh` moves `backlog → todo → doing → done` through the engine
- [ ] An illegal pair is refused, naming the pair and the legal path
- [ ] Validated: **AI** — every legal and illegal pair exercised against a seeded fixture ·
      **Human** — a move through the full chain against the **installed plugin** (TECH-188)

## Related

- **FEAT-229** — parent. This is the first of three slices.
- **FEAT-229.2** — the gates, which need a live namespace to attach to.
- **BUG-215** — established the one-engine/policy-table shape and that the namespace is always
  an argument.
- **`kanban.md§4`** — the Door this opens.
