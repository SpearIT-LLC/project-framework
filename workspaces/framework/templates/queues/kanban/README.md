# Kanban

The root board (ADR-009 D2) — a card store, not a workspace. Items are `FEAT`, `BUG`,
`TECH`, `TASK` and `SPIKE` records (ADR-006), created only by `/fw-new`; the folder
carries the status, and items are moved only by `/fw-move`. Working material lives in a
sibling folder named for the id (`FEAT-nnn/`) that moves with its record.

## Flow

```
backlog ──► todo ──► doing ──► accept ──► done ──► release/<product>/
              ▲        │          │
              └────────┴──────────┘   accept ──► doing  (refine after review)
                       │
                    blocked          any pre-terminal state ──► cancelled
```

- **`backlog/`** — captured, not committed to. Adding here is free; it is the safe place
  for an idea.
- **`todo/`** — committed to. Priority set. `.limit` = 10.
- **`doing/`** — being implemented. `.limit` = 2. The move here runs the
  pre-implementation review; nothing is implemented from anywhere else.
- **`accept/`** — finished, awaiting someone else's judgment: your own UAT, a customer
  sign-off, a colleague's review. Exits to `done/` when accepted, back to `doing/` to
  refine.
- **`done/`** — accepted, awaiting release. The acceptance-criteria gate is enforced on
  the way out of `doing/`, so nothing lands here with work outstanding.
- **`cancelled/`** — decided against. A lifecycle outcome, not a filing location:
  cancelled work is *finished*, it just did not ship.
- **`blocked/`** — waiting on something outside this card. Carries what is being waited
  on and what will unblock it.
- **`release/<product>/`** — shipped work, bucketed per product.

## Rules

- **The folder is the status.** No `Status:` field to contradict it.
- **One shared id sequence** across all types in this queue — `FEAT-003` and `TASK-004`
  cannot both exist. (Operations has its own separate sequence.)
- **Never delete a card.** Cancelled work moves to `cancelled/`; it is history, not
  clutter.
- **WIP limits are a ceiling**, enforced at the move. A parent and its dotted children
  count as one item.
