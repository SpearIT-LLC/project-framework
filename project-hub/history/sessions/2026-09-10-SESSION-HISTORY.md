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

**Last Updated:** 2026-09-10
