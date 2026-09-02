# Deprecated Work Items

Cards archived here target the **old** framework — `framework/`, `templates/`,
`plugins/`, `tools/`, or the old `project-hub/` lifecycle — which is maintenance-only
at v5.6.0. The live build is `workspaces/framework/` (ADR-009).

**Nothing here was deleted, and nothing here is a judgment that the idea was bad.**
Each card names a *specific dead file* as its deliverable. The file is not coming back;
the card went with it.

## Why this folder exists

Archived on **2026-09-02** by **TASK-218**, which holds the full disposition table —
every card, its reason code, and what was checked. Read that card before reversing
anything.

Location is status: `archive/` is the status, `deprecated/` is the grouping.

## Reason codes

| Code | Means |
|---|---|
| `OLD-DOCS` | Targets `framework/docs/` or `framework/CLAUDE.md` |
| `OLD-SETUP` | Targets `Setup-Framework.ps1` or the archive distribution |
| `OLD-LIFECYCLE` | A `project-hub/` work-item lifecycle the new layout drops |
| `OLD-ENGINE` | The old board's own `.claude/` commands and scripts |
| `OLD-PLUGIN` | The two retired marketplace editions |
| `TIER-SYNC` | Existed only because the command sets were hand-synced |

## What is NOT here

TASK-218 started at ~75 candidates and archived 26. The other ~49 stayed on the board
because they still apply to the new build:

- **Commands, plugins, scripts and hooks** — the migration is mid-flight (the new build
  ships 5 commands against the old set's 11). Those cards are requirements input.
- **Board conventions the new build has not defined** — parent/child items, numbering,
  cross-references, never-delete, release archival.
- **Product ideas** unbuilt in *both* frameworks (sprints, velocity, team IDs).

If you are looking for a card and it is not here, it is still on the board.

## Reversing a card

```bash
git mv project-hub/work/archive/deprecated/<CARD>.md project-hub/work/backlog/
```

Then **remove the `**Deprecated:**` stamp and re-scope the card against
`workspaces/framework/`** before working it. The archived text describes old-framework
paths and will mislead if taken at face value.

The ID is still unique and was never reissued — both ID engines scan recursively and
count archived cards (verified in TASK-218). Reversal is cheap and expected; that is
what this folder is for.

## Do not

- **Delete anything here.** Deletion leaves unexplained ID gaps (the never-delete
  principle — itself argued in TECH-077, which is *not* archived because the new build
  has not written that policy down yet).
- **Move a card out of `work/`.** Both next-ID engines scan recursively from `work/`;
  a sibling root such as `project-hub/deprecated/` would be invisible and could let an
  ID be reissued.

---

**Archived:** 2026-09-02 · **Card:** TASK-218 · **Cards:** 26
