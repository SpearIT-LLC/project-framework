# Session History: 2026-09-10

**Date:** 2026-09-10
**Participants:** Gary Elliott, Claude Code
**Session Focus:** Contact records — `Group:` read at last, `Previously:` added, and a registry-wide view

---

## Summary

Started with a narrow question — *does anything read the `Group:` field?* — and the answer
was no. Fixing that surfaced two more gaps in sequence: a replaced contact loses their
history, and an unassigned person appears in no generated file at all. All three are now
closed. The driver throughout was real usage: Gary hand-rolled a contact on the Honda
HPCJobQueuePrototype and found no way to record a department.

---

## Work Completed

### `Group:` is now read, and drives the workspace view

Gary added `**Group:**` to `contact.md` (uncommitted from 2026-09-09). **Neither script
read it** — `fw-contacts.sh` parses exactly two things, the `# Name` heading and
`**Assigned:**` lines. Everything else is authored-but-inert.

Its job, in Gary's words, is **backup routing**: *"who to contact if that person is not
available, like a group manager"* — plus coverage, *"easier to visualize."* So the view
groups by it: groups alphabetical, unknown-group people last under *Group not recorded*,
flat list when no groups are recorded anywhere (so existing views are unchanged until a
`Group:` is filled in).

**Affiliation deliberately stays out of the view.** Gary: *"That's the file I'd likely
copy and paste into a ppt or project file for something visible to the whole group. Most
companies would frown on making an issue of affiliation from a contractor."* The fact
stays in the record, where it informs whose decision carries weight.

### `Previously:` — an assignment that has ended

Gary's scenario: Joe does server OS support, Frank replaces him mid-project. Remove Joe's
assignment and *"who was the guy who setup the servers initially?"* has no answer in the
working set. Joe's record survives (never-delete holds), but nothing connects him to the
workspace. Git has it; nobody runs `git log -p` on a contact record mid-project.

So an assignment now **ends rather than vanishes**: Joe's `Assigned:` line moves to
`Previously:`, Frank gets his own `Assigned:` line.

**No dates, and that constraint decided the design.** Gary: *"If we include dates in the
assignment, then we'll have to capture the start date right away or else we'll loose that
history."* A field you must remember to fill at the right moment is a field that stays
empty — which is exactly how `Group:` came to be missing. Moving a line happens at the
moment you actually know it.

Naming went through `Was:` (too terse, breaks the `**Noun:**` grammar) and
`PastAssignments:` (plural invites a list under one heading, breaking the repeatable-line
grammar) before landing on **`Previously:`** — reads naturally, stays singular so it
repeats like `Assigned:`, pairs obviously with it.

### Display: past holders sit in their own group (corrected)

First implementation put past holders in a trailing `## Previously` section. Gary:
*"Infrastructure is a group, Previously is a field indicating a past assignment."*

Correct, and worse than untidy — the section made an assignment **state** a sibling of
dept **names**, two axes rendered as the same markup, and it **stripped Joe of his group
entirely**, so "who else is in Infrastructure" no longer included him.

Now `Group:` is the only heading axis. A past holder sits in their own group beside the
current people, tagged `*(previously)*`; current first within a group, then past:

```markdown
## Infrastructure
- [Frank Jones](…) — server OS support
- [Joe Smith](…) — server OS support *(previously)*
```

**Tradeoff stated before Gary chose it:** inline tagging means omitting past holders from
a paste is per-line rather than dropping one trailing block. He accepted that knowingly.

### `CONTACTS-ALL.md` — the registry-wide view

UAT-12's master-view suggestion, built now rather than left in FEAT-210. Everyone in the
registry grouped by `Affiliation:`, with group and role.

It is the only view showing affiliation, and **the only place a person with no assignment
appears at all** — in the fixture, Nora (a vendor AE, unassigned) was in the registry but
visible in no generated file before this. That was UAT-12's original complaint.

Naming: Gary flagged the collision with the kb's `INDEX.md`. The sharper reason to avoid
it is that the kb `INDEX.md` is **hand-authored** while this is **generated and
overwrites** — one filename for two opposite contracts is a trap. `CONTACTS-MASTER.md`
was considered and dropped ("master" claims an authority the file doesn't have; the
records are the source). `CONTACTS-ALL.md` states the actual distinction, which is scope.

### FEAT-210 / FEAT-211 updated

Both asked for the master view that shipped today, so both were updated to stop requesting
done work. FEAT-211's open question — *does the master view land first?* — is answered yes,
with a caveat: `CONTACTS-ALL.md` deliberately does **not** list assigned workspaces (those
are in each workspace's own `CONTACTS.md`; repeating them is the second copy ADR-008 exists
to prevent). If batch assignment needs one place to see every assignment, that is a **new**
requirement for that card to state.

---

## Decisions Made

1. **`Group:` drives grouping in the workspace view.** Backup routing and coverage are the
   use; a sparse or missing section is the signal.
2. **Affiliation never appears in a workspace `CONTACTS.md`** — that file gets pasted into
   decks. It appears only in `CONTACTS-ALL.md`, the internal master list.
3. **Assignments end, they do not vanish** — `Previously:`, same grammar as `Assigned:`.
4. **No dates on assignments.** A start date must be captured at assignment time to be
   true; that field would stay empty.
5. **`Group:` is the only heading axis in the workspace view.** Past holders are tagged
   inline, not sectioned — a state heading beside dept names conflates two axes and loses
   the past holder's group.
6. **`CONTACTS-ALL.md`, not `INDEX.md`** — hand-authored vs generated is the distinction
   that matters, not just visual similarity.
7. **`CONTACTS-ALL.md` lists no assignments** — they live in the per-workspace views.
8. **Scope stayed narrow**, on Gary's framing: *"The framework is to help us do our job."*
   This records what SpearIT needs to find a person, not the customer's assignment history,
   which lives in whatever system they use.

---

## Files Modified

- `workspaces/framework/scripts/fw-contacts.sh` — reads `Group:`, `Affiliation:`, `Role:`
  and `Previously:`; groups the workspace view; emits `CONTACTS-ALL.md`
- `workspaces/framework/templates/records/contact.md` — `Group:` (Gary's, committed here)
  and `Previously:` with its meaning in the header
- `workspaces/framework/commands/fw-contacts.md` — the two views, the replacement rule,
  why affiliation is absent, why not `INDEX.md`
- `workspaces/framework/CHANGELOG.md`
- `project-hub/work/todo/FEAT-210-*.md` — master-view bullet marked done
- `project-hub/work/backlog/FEAT-211-*.md` — open question answered, with the caveat

## Files Created

- (none — `CONTACTS-ALL.md` is generated at run time, not committed)

---

## Current State

### In doing/ (2 items, at the WIP limit)
- **BUG-215** — both halves shipped; built-plugin UAT pass remains
- **TASK-219** — Group 1 settled 2026-09-09; fourteen conventions deferred

### Next
**FEAT-175 (`fw-new`)** — unblocked by yesterday's Group 1 work. It creates cards and
scaffolds `kanban/` on first use. Then the kanban row in `fw-move.sh`, then FEAT-222.
The BD deadline (~2026-09-28) still drives the order.

### Unanswered, raised today
**Is there a Teams/Outlook connector to query contacts from source?** No Microsoft
connector is available in this session — Gmail, Calendar and Drive are configured and
currently unauthorized. Whether one exists for claude.ai generally is unverified; the
connector settings page is authoritative. Argued against runtime dependence regardless: a
directory knows the org chart, not which people matter to this SOW; client directories are
usually closed to a contractor; and records that resolve from a live service stop working
when access ends. A creation-time *assist* (pre-fill name/title/dept for confirmation)
would be the safe version.

---

## TASK-219 Split, FEAT-175 Opened (Later — Continuation)

**Continuation:** contacts work finished; moved to start FEAT-175 (`fw-new`), the BD
critical path.

### The WIP limit forced a card-size decision

`/fw-move 175 doing` would have made `doing/` hold three against a limit of two. Both
existing cards were near-dormant — BUG-215 needing only a built-plugin UAT pass, TASK-219
with its live slice settled — so the obvious move was to close one.

**TASK-219 could not close.** Eight of its acceptance criteria were unchecked, and the
done-gate blocks on `[ ]` — correctly. The card genuinely was not done; only its Group 1
slice was.

Three options were put up: split the card, finish all fourteen remaining conventions, or
just go over the limit. Gary initially said "simpler to just finish 219" — but finishing
meant deciding the terminal-state set, never-delete-with-a-check, the `fw-` namespace rule,
issue response, session handoff, concurrent work, two templates, and closing every source
card. Days of design, none of it on the BD path, with Sept 28 approaching.

Gary, on hearing that: **"I'm thinking we're making our cards too large. Split 219."**

### The split, and the lesson

**TASK-219** keeps Group 1's five settled conventions and the work-item template they
produced, and closed to `done/`. **TASK-223** (`backlog/`) carries the remaining fourteen
across Groups 2, 2a, 3, 4 and 5.

The split line already existed inside the card: Group 1 blocked the work-item template and
therefore BD; nothing else did.

**The lesson, recorded on TASK-223:** a card owning nineteen decisions under **one**
acceptance-criteria block cannot be closed until the least urgent of them is done. Five
shipped, and were held hostage by fourteen that had not started.

Deliberately *not* done in the split: the five Group 1 source cards (FEAT-021, TECH-082,
TECH-041, TECH-027, TECH-033) stay in `todo/`. Their conventions are settled and recorded;
closing them is bookkeeping that blocks nothing, and TASK-223 carries the criterion.

### FEAT-175 pre-implementation review

Moved to `doing/`. Two of its stated blockers were **already cleared** by yesterday's work
and the card is stale on both:

- *"Work-item templates do not exist in the new build"* — `templates/records/work-item.md`
  was authored 2026-09-09.
- *"Resolve those conventions before authoring the templates"* — Group 1 settled, each with
  a named mechanism.

### The kanban guard — an AI error, corrected twice by Gary

The AI raised the card's *"sequence with the D5 crossover"* note as an open question,
framing it as a conflict needing an ADR amendment.

**First correction.** Gary: *"I don't see the overlap. The new commands are in a different
namespace. TECHNICALLY they both could exist in the same repo."* Right — the AI had
conflated command namespacing with D5's actual concern, which is two boards sharing one
**id namespace** in *this* repo. BD is a fresh repo; nothing collides.

**Then the code answered the rest.** `fw-next-id.sh`'s kanban refusal is conditional on
the directory existing (`if [ ! -d "$NS" ]`) — not a blanket block. In a repo with a real
`kanban/` it resolves and works today. Should have been read before the question was
raised.

**Second correction — the useful one.** The AI then proposed dropping the guard. Gary:
*"The tension I'm getting at is if we block, then we cannot test in this repo."* That is
the real constraint, and it reframed the problem: the guard's cost is not tidiness, it is
whether the source repo can exercise its own work.

Resolved by separating two testing needs that had been conflated:

| Need | Path |
|---|---|
| Development iteration | `--root` against a scratch fixture — never touches this repo's `kanban/` |
| Acceptance | framework-uat, against the **built plugin** (FEAT-175's own criterion, and how all 30 UAT tests ran) |

So the guard blocks neither. **It stays as-is.**

### Generated roots ignored

Gary: *"We should be able run the command here during development and in framework-uat for
validation."* `--root` covers direct script calls, but running the actual *command* here
resolves to this repo's root, so its output has to land somewhere harmless.

`kanban/`, `operations/`, `kb/` and `workspaces/*` are now gitignored, with
`workspaces/framework/` excepted — it is the new framework's **source tree**, not generated
output. A test card cannot be mistaken for a real one because it never appears in the tree.

This also serves Gary's original framing of the guard — *"a reminder to not create any
official cards in `kanban/` until the cutover"* — without repo-specific text living in
shipped code.

Verified: six paths resolve correctly, and nothing was orphaned (only
`workspaces/framework`, 66 files, was tracked under those roots).

---

## Decisions Made (afternoon)

9. **Split TASK-219 rather than finish it.** Group 1 shipped; the other fourteen are
   TASK-223 in `backlog/`. Cards owning many independent decisions under one acceptance
   block cannot close incrementally.
10. **Group 1's five source cards stay in `todo/`** — bookkeeping, carried by TASK-223.
11. **`fw-next-id.sh`'s kanban guard stays.** It blocks neither development (`--root`) nor
    acceptance (framework-uat), and it does prevent real cards landing in this repo's
    fixture board.
12. **Generated roots are gitignored here**, `workspaces/framework/` excepted.

---

## Files Created (afternoon)

- `project-hub/work/backlog/TASK-223-remaining-board-conventions.md`

## Files Modified (afternoon)

- `.gitignore` — generated roots
- `project-hub/work/done/TASK-219-*.md` — trimmed to Group 1; criteria and checklist
  rewritten to what the slice actually covers

## Files Moved (afternoon)

- `project-hub/work/doing/TASK-219-*.md` → `project-hub/work/done/`
- `project-hub/work/todo/FEAT-175-*.md` → `project-hub/work/doing/`

---

## Handoff — starting a fresh session

**Board:** 73 backlog · 13 todo · **2 doing** · 9 done · 1 blocked.

**`doing/`:**
- **FEAT-175** — pre-implementation review **done and approved**; no code written yet.
- **BUG-215** — both halves shipped; a built-plugin UAT pass is all that remains.

**Next action: implement FEAT-175, starting with the type SoT.** Its remaining scope, in
the card's own order:

1. Type SoT shipping **inside the plugin** — the accepted five (`FEAT BUG TECH TASK SPIKE`,
   ADR-006). None exists in the new build today; the old one is `.claude/scripts/work-item-types.txt`,
   old-tree, does not ship.
2. `fw-new.sh` — strict type gate + `fw-next-id.sh` for the id + template resolution.
   **Do not reimplement the id scan**: an unscoped `TYPE-NNN` grep returned `202`
   (matching `ROADMAP-2026-02-04.md`) where the scoped scan returned `178`.
3. `/fw-new` command doc — the lenient AI layer: infer type, prefix-normalize, semantic
   suggestion, confirm, write, commit-on-create.
4. Rejection-as-education — name the accepted set; explain *why* a suggestion applies;
   answer `story` with hierarchical sub-items rather than merely rejecting.

**Design already settled, do not re-open:** strict script / lenient AI, prefix
normalization validated against 74 real-world type strings, ADR-006's five types.

**Stale on the card, fix while working it:** its Dependencies section still claims
work-item templates do not exist and the conventions are unresolved. Both are done.

**Two things noted across the week, still not carded:**
- The WIP counter counts `.gitkeep` and `.limit` as items (reported `3/2` for two cards).
- `fw-move.sh` / `fw-next-id.sh` kanban refusals point at *"the root /fw-move"* and
  *"/fw-next-id"* — old-framework commands that will not exist in BD's repo. Message
  wording only; the branch cannot fire there.

**`done/` is at 9.** The release nudge fires at 10.

---

**Last Updated:** 2026-09-10
