# Kanban

The root board (ADR-009 D2) — a card store, not a workspace. Items are `FEAT`, `BUG`,
`TECH`, `TASK` and `SPIKE` records (ADR-006), created only by `/fw-new`; the folder
carries the status, and items are moved only by `/fw-move`. Working material lives in a
sibling folder named for the id (`FEAT-nnn/`) that moves with its record.

## Flow

```
backlog ──► todo ──► doing ──► accept ──► done ──► release/<product>/
              ▲        │          │
              └────────┘          └──► doing        (refine after review)

  backlog / todo / doing ──► blocked ──► back to any of them   (external blocker)
  backlog / todo / doing ──► hold    ──► back to any of them   (deprioritized)
  backlog / todo / doing ──► cancelled                          (terminal)
```

**`accept/` has exactly two exits — `done` and `doing`** (TASK-242). A card there has code
in the repo, so parking it or sending it back to a queue would strand known-imperfect work
with nothing scheduled to finish it. Going back to `doing/` costs queue position; that is
the cheaper price.

**`doing/` cannot reach `done/` directly.** `accept/` is the only route, which is what
makes the state mean anything.

- **`backlog/`** — captured, not committed to. Adding here is free; it is the safe place
  for an idea.
- **`todo/`** — committed to. Priority set. `.limit` = 10.
- **`doing/`** — being implemented. `.limit` = 2. The move here runs the
  pre-implementation review; nothing is implemented from anywhere else.
- **`accept/`** — finished, awaiting someone else's judgment: your own UAT, a customer
  sign-off, a colleague's review. Exits to `done/` when accepted, back to `doing/` to
  refine.
- **`done/`** — accepted, awaiting release. The acceptance-criteria gate is enforced on
  the way into `done/`, so nothing lands here with work outstanding.
- **`cancelled/`** — decided against. A lifecycle outcome, not a filing location:
  cancelled work is *finished*, it just did not ship. **Terminal**, and not reachable from
  `done/` — cancelling completed work contradicts the definition of done.
- **`blocked/`** — cannot proceed because of something **external**. Carries what is being
  waited on and what will unblock it.
- **`hold/`** — **a decision to prioritize other work.** Not blocked: nothing is stopping
  this card except the choice to do something else first.

  > **`blocked` and `hold` differ by cause, not severity** (TASK-242). A combined `park/`
  > was proposed and rejected: these two words are understood on arrival without a lookup.
  > There is no `blocked ↔ hold` transition — a changed cause goes via a real state.
- **`release/<product>/`** — shipped work, bucketed per product.

## Rules

- **The folder is the status.** No `Status:` field to contradict it.
- **One shared id sequence** across all types in this queue — `FEAT-003` and `TASK-004`
  cannot both exist. (Operations has its own separate sequence.)
- **Never delete a card.** Cancelled work moves to `cancelled/`; it is history, not
  clutter. Completed work *put away* goes to `history/archive/` — storage, never a
  lifecycle outcome.
- **WIP limits are a ceiling**, enforced at the move. A parent and its dotted children
  count as one item.
