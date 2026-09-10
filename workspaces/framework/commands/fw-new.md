---
description: Create a board work item (FEAT, BUG, TECH, TASK, SPIKE) with the next shared id
argument-hint: "[type] <what the work is>"
---

# /fw-new - Create a Board Work Item

Board items are created by a command, never by hand — the id comes from one
shared sequence per kanban queue (FEAT-195), the shape from the plugin's
`templates/records/work-item.md` (a project's `.claude/templates/records/`
overrides), and the item lands in `kanban/backlog/`. The queue scaffold is
created automatically on first use. **The prefix carries the type; the folder
carries the status.**

**Creation is always into `backlog/`.** Adding an idea there is free and commits
to nothing; `/fw-move` promotes it when it is actually committed to.

## The division of labor — read this before helping

**You choose and suggest; the script decides.** The script accepts only a type
in the SoT, case-insensitively, and has no aliases, no fuzzy matching and no
opinion about whether the *right* type was chosen. That strictness is the
design, not a limitation: a create gate bakes its answer into a filename that
lives forever, so a rejection costs one round-trip while a wrong type committed
and cross-referenced is expensive.

So **never work around a rejection** — don't hand-create a file, and don't retry
with a type the user didn't agree to. Bring the user a suggestion, get a yes,
and call the script again. A corrected type re-enters the gate on its own merits.

## Steps

1. **Infer the type** when the user didn't give one. `/fw-new "add CSV export"`
   → propose `FEAT`. State the type you picked and why, in a few words, so the
   user can correct it. If the work is genuinely ambiguous, ask rather than guess.

2. **Normalize or suggest — always as a suggestion the user confirms, never a
   silent substitution:**

   - **Prefix normalization** (mechanical): a canonical type that is a prefix of
     what the user typed resolves to it — `FEATURE`→`FEAT`, `BUGFIX`→`BUG`,
     `TECHDEBT`→`TECH`. *(Validated against 74 real type-name strings from Jira,
     Jira Service Management, GitHub, Azure DevOps, GitLab, Linear, Redmine,
     Shortcut, Conventional Commits and SAFe: zero false positives.)*
   - **Semantic suggestion** (judgment): for what prefix-matching can't reach —
     `story`, `enhancement`, `defect`, `fix`, `chore`, `refactor`, `docs`,
     `perf`, `research`. Use the type definitions and ADR-006's rationale to
     judge. **There is deliberately no lookup table here**: a table would be a
     second copy of the type vocabulary, which is exactly what the SoT prevents.

   `story` is a special case worth recognizing: someone typing it is usually
   asking *how do I model a story with tasks under it?* Answer that question —
   see sub-items in step 4 — rather than just mapping it to `FEAT`.

3. **Run the script** — the create gate:

   ```bash
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/fw-new.sh" <type> <slug> [--title "<title>"] [--parent <id>]
   ```

   Build the slug from the work itself (`csv-export-for-reports`) — short,
   lowercase, hyphenated, no dates or ids. If the script errors, **report its
   message verbatim and stop**: the rejection text is written to teach, and
   paraphrasing it loses the lesson.

4. **Sub-items — pick the right mechanism** (TASK-219 Group 1). The question to
   ask is *does this make sense on its own?*

   - **`--parent FEAT-007` → a dotted id** (`FEAT-007.1`). Tight coupling: the
     child lives and dies with the parent, moves with it, and counts as part of
     the **same one item** against the WIP limit. Use when the child would be
     meaningless alone. Max depth 3; needing a 4th level means the parent is too
     big.
   - **The `Parent:` field → provenance.** The child stands alone, is worked and
     moved separately, and counts as its **own** item. Use for work *discovered*
     during a parent — the common case. Create it normally and fill `Parent:`.

5. **Fill the card with the user** (the judgment step): write the Summary so a
   reader who has never seen the card knows whether it concerns them, then the
   Problem Statement and Proposed Solution — recording *why* the chosen approach
   won, since a decision without its reason gets re-litigated. Write Acceptance
   Criteria that can be **checked, not admired** (the done-gate reads them).
   Set `Priority`, and **delete optional fields that don't apply** (`Workspace`,
   `Parent`, `Depends On`) rather than leaving placeholders. Leave `Completed:`
   blank — the move engine stamps it.

6. **Commit once the card is fully drafted** — prompt first, default yes. A
   half-written card in the tree is worse than none.

7. **Report** the created path and the id.

## Adding a new type

The accepted set is the `TYPES:` line in `templates/records/work-item.md`,
inside the `TYPES-SOT-BEGIN`/`END` markers — the single authored home (ADR-008).
It lives in the template on purpose: **a new type needs a template that serves
it**, so the two cannot drift apart. Editing that line is the whole change; the
script picks it up with nothing to sync.

Any prefix found on disk that isn't listed is **legacy** — recognized when
scanning and parsing, never offered for creation. Legacy is per-project and
self-discovered, so there is nothing to ship or hand-maintain.
