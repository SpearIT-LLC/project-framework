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

## FEAT-175 Implemented (Evening — Continuation)

Resumed from the handoff above. **The board create gate now exists**, completing the
create-gate set: workspaces, ops records, contacts, kb domains, and now board items.

### The handoff's plan was wrong on step 1, and Gary caught it twice

The handoff said *"Type SoT shipping inside the plugin"* and named
`.claude/scripts/work-item-types.txt` as the model to follow. The AI opened by offering
three locations for that file — including `standards/`.

**First correction — a question, not an answer.** Gary: *"Before I answer, do we have a
place in the new framework for framework standards? Do we need one or keep it self
contained in the command?"* The AI had offered `standards/` without checking what it is
for. The new build's own `CLAUDE.md` says: *"`standards/` is staging (ADR-009 OQ1): files
move in via `git mv`, convert to skills, and leave in the same commit. One home at all
times. It never ships."*

It is a **loading dock, not a home**, and its being empty is it working correctly. That
removed the option entirely — the new build has no "framework standards" folder by design.

**Second correction — the better idea.** Gary: *"PERHAPS the authoritive list should be in
the template?"*

That is what shipped, and the reason is stronger than convenience. FEAT-175's own
acceptance criterion is *"a new type needs a matching template."* With the list **in** the
template, that requirement becomes **structural rather than remembered** — you cannot add
a type without being in the template file. A standalone `.txt` lets someone add a line and
walk away, which is precisely the drift the SoT exists to prevent.

This only works because TASK-219 chose **one** template serving all five types via a
`Type:` field. Five near-identical templates would have had no single authoritative home —
an unplanned payoff from yesterday's decision.

### The D5 guard question, raised a third time and closed by the record

The AI's pre-implementation review again flagged D5 sequencing as open, and proposed a
guard making `fw-new.sh` refuse to run in this source repo.

Gary: *"Check the history. We said we'd allow creation with just a reminder... This is to
allow testing in the repo."* The record was unambiguous — `049e071`, committed that same
morning, states the resolution and its reason: the ignore rule serves the reminder
*"without repo-specific text living in shipped code."*

**The AI was about to write the guard that had already been rejected, hours earlier, in a
commit message written to prevent exactly that.** Third occurrence of this same question in
one day. The lesson is the one CLAUDE.md already states — read the source before raising
the question — and the failure mode is specifically *re-litigating a settled decision
because the record was not consulted*, which is the failure ADR-009 cited when it chose to
build in place rather than start a fresh repo.

### Delimiters beat line counts — caught in testing

First cut stripped the SoT block from created cards by dropping a **fixed number of lines**
after a matched phrase. It left an orphaned prose fragment (`supports it, so the two...`)
mid-comment in every card.

Replaced with `TYPES-SOT-BEGIN` / `TYPES-SOT-END` markers, so the boundary is **data rather
than a count that rots silently when the prose is reworded**. The block is stripped and
replaced with a pointer, so no card becomes a stale copy of the list (ADR-008).

Worth noting the failure was invisible in the script and obvious in the output — it was
caught only because a created card was actually read, not because a test asserted on it.

### Type-change blast radius — the question that produced the register

Gary asked two questions the card had not considered: *"Does fw-move care what a type is or
is it only looking for the ID?"* and *"What happens if we add/remove a type in the future?"*
Then: *"What about the other kanban commands from the old framework?"*

Verified rather than reasoned about, and the answer is uniform — **the type is load-bearing
for about one second, at creation:**

| Surface | Type-aware? | Evidence |
|---|---|---|
| `fw-move.sh` (both builds) | **No** | Locates by *number*; its own comment: *"the prefix is decoration"* |
| All 11 old commands | **No** | All 52 type mentions are illustrative (`FEAT-042` placeholders, sample output) |
| `/fw-release` | **No** | Version bumps come from the **`Version Impact:` field**, not the type |
| `fw-next-id.sh` | **No** | Matches any `[A-Za-z]+-[0-9]+` |
| `fw-new.sh` | **Yes** | The only consumer of the accepted set |

This confirms ADR-006's D6 amendment (*"the create path, not the move path"*) empirically,
and it is **why putting the list in the template is safe** — there is no second consumer to
fall out of sync with.

Adding a type: verified by adding a sixth (`CHORE`) — gate accepts it, rejection message
lists it, ids and moves work, nothing to sync. Removing: existing cards keep working, still
**count in the shared sequence so no id is ever reissued**, and the retired prefix becomes
legacy *by definition* under D2's disk-derived rule. **No migration in either direction.**

**The one hand-maintained surface** is the semantic-suggestion `case` block in `fw-new.sh`.
The accepted-set line updates itself; the *tutoring* around it does not. Adding a type means
revisiting it — a wrong-advice failure, never a broken-gate one.

### "In a year from now how do I find it?"

Three deferred items had accumulated — stale ADR-006 D4/D5, the dead
`work-item-types.txt`, the unported kanban move gates. The AI proposed deferring them to
the crossover. Gary: *"Let's defer but keep a list of transition issues/questions to resolve
so we don't forget about them"* — then, decisively: **"What I mean is in a year from now how
do I find it?"**

Checked first, and the finding reframed the answer: **D5 has no owner.** Thirteen cards
reference the crossover; none owns it. ADR-009:342 lists what the graduation commit *does*,
but nothing was collecting debt found along the way. A note filed "for the crossover" would
have had **nowhere to land** — which is exactly how it gets lost.

So: **TASK-224, a card in `backlog/`**, because the board is where we already look. An ADR
requires remembering to reread it; a card surfaces in `/fw-status` and every board sweep.

Each row carries **why deferring is safe** — the field that distinguishes a deliberate
deferral from something forgotten. The card also states what does *not* belong in it
(ordinary "later" work), since dilution until it stops being read is the failure mode a
register like this dies of. It gates nothing: registers that block get worked around.

**Row 3 is flagged as not self-resolving.** `fw-move.sh` declares the kanban folder set but
its transitions and gates are unported — creating works end-to-end, moving a created card
still reports *"declared but not active."* That must land **before** the
`git mv project-hub/work/* kanban/` commit, or graduation produces a board with no move
engine. Rows 1 and 2 resolve by deleting the old tree.

### Verification

22-case regression run from an **installed-plugin layout** (`scripts/` + `templates/` only,
no source tree in reach) into a fresh `git init` repo — the card's ADR-008 criterion,
verifying against what ships rather than the source. Covers: all five types, shared
sequence across types, lowercase normalization, 7 rejection paths, dotted children, **children
not consuming top-level ids**, bad parent, path traversal, no-args, and created cards
carrying neither the markers nor a copy of the list.

Also verified the gate **fails loudly** on a malformed SoT (missing markers, missing
`TYPES:` line, non-alphabetic entry) rather than degrading to "accept anything" — the one
failure a create gate must never have.

All testing ran outside the repo; no scratch `kanban/` was created here.

---

## Decisions Made (evening)

13. **The work-item template is the type SoT** — the `TYPES:` line inside
    `TYPES-SOT-BEGIN`/`END` markers, not a standalone `work-item-types.txt`. Makes *"a new
    type needs a template"* structural rather than remembered. Viable only because one
    template serves all five types (TASK-219).
14. **The SoT block is stripped from created cards** and replaced with a pointer. The rest
    of the header travels with the card (matching `ops-record.md` — guidance belongs where
    the author is), but a parsed list copied onto every card would be a stale copy per card.
15. **No D5 guard in `fw-new.sh`.** Settled that morning in `049e071`; the `.gitignore`
    carries it without repo-specific text in shipped code.
16. **Deferred items get a board card, not an ADR note** — TASK-224. Findability is the
    requirement, and the board is where we already look.
17. **`standards/` is not a home for anything.** It is `git mv` staging that never ships;
    empty is correct.

---

## Files Created (evening)

- `workspaces/framework/scripts/fw-new.sh` — the create gate: strict type enforcement,
  `fw-next-id.sh` for ids, scaffold on first use, `--parent` dotted children
- `workspaces/framework/commands/fw-new.md` — the lenient AI layer (prefix normalization,
  semantic suggestion, sub-item guidance); deliberately **no** alias lookup table
- `project-hub/work/backlog/TASK-224-graduation-transition-register.md`

## Files Modified (evening)

- `workspaces/framework/templates/records/work-item.md` — now the authoritative type SoT
- `workspaces/framework/CHANGELOG.md` — the create gate and the SoT decision
- `project-hub/work/doing/FEAT-175-*.md` — checklist, criteria, implementation notes,
  type-change blast radius

---

## Current State (end of day)

**Board:** 74 backlog · 13 todo · **2 doing** · 9 done · 1 blocked.

**`doing/`:**
- **FEAT-175** — implemented and verified. One criterion left `[ ]`: commit-on-create is
  specified in the command doc but is an AI-layer step with no script surface to test.
  **Not moved to `done/`** — the move side is unported, so the gate is only half-exercised
  in practice.
- **BUG-215** — unchanged; a built-plugin UAT pass is all that remains.

### Next

**FEAT-175's remaining question is whether it is done.** It meets its own acceptance
criteria, but a create gate whose companion move engine cannot move what it creates is
worth a deliberate call rather than an automatic `→ done`.

Then: **TASK-224 row 3** (port the kanban transitions and gates) is the largest unowned
piece of the crossover, and the only register row that does not resolve by deletion.

### Still not carded (carried from the afternoon, unchanged)

- The WIP counter counts `.gitkeep` and `.limit` as items.
- `fw-move.sh` / `fw-next-id.sh` kanban refusals point at old-framework command names that
  will not exist in BD's repo. Message wording only.

**`done/` is at 9.** The release nudge fires at 10.

---

## Response Style Rewritten (Late Evening — Continuation)

No work-item work. A meta-conversation about **why the AI keeps drifting from the
contract's own Response Style rule**, ending in a rewrite of that section.

### The trigger: a badly-shaped question

The AI ended a three-paragraph explanation with *"Want me to draft the revised Response
Style section against that trigger?"* Gary had to re-read to work out what "that trigger"
referred to — the AI had introduced `/fw-decide` in the immediately preceding paragraph,
so the nearest antecedent was the wrong one.

Gary: *"I read three paragraphs that starts as explanation and ends with a call to
action."*

Two distinct defects, and the second causes the first: an **ambiguous referent**, and an
**ask buried at the end of an explanation**. Had the ask come first, the referent would
have been unambiguous because nothing would have sat between them.

### The diagnosis: same failure as framework policy enforcement

Gary: *"We're running into the same issues we had months ago trying to enforce policy in
the framework. When you read and adhered to the policies we wrote together it worked
great. The problem is you don't always do that."*

This session was itself the evidence — the contract said *"Default to 5 lines or fewer.
No headers or tables unless asked"* and the AI produced headers and tables in nearly every
response.

**A command was considered and rejected.** `/fw-move` and `/fw-session-history` work
because they are chokepoints. Gary: *"I don't think a command is the answer for this one.
At least I can't think of an occassion for it right now... the bigger issue comes from the
casual converstations as we try to work through issues."*

Correct, and it is a genuine limit rather than a missing mechanism: **conversational style
has no chokepoint to hang a gate on.** The rule holds by adherence or not at all — so the
rewrite says that outright rather than pretending otherwise.

### Two ideas raised and set aside (recorded because they will recur)

**1. Address Gary by role — "Project Manager" or "Executive Developer".** Rejected as the
primary fix: it does not match how he works. This same session he asked the AI to verify
whether `fw-move` cares about types, checked what `standards/` is for, and caught the D5
error by reading a commit message. Taking "PM" literally would have produced conclusions
where he wanted evidence.

The sharper read: **the role does not change, the mode does.** Sometimes deciding,
sometimes working the problem — which varies per message, so a standing title cannot
capture it.

**2. Gary declares a hat per task, mirroring the AI's role feature.** Gary: *"It would be
something that would be easy for me to forget but might be helpful at times. What holes do
you see in that?"*

Three holes: he would have to remember (least likely exactly when drifting); it inverts
the working mechanism (he declares, AI infers — the "instruction merely read" problem
again); and **his hats do not map to what he needs** — he wore "developer" all session
while needing executive-summary answers at every commit and approval point. The hat was
constant; the mode flipped inside it.

**Kept, narrowed:** role-invocation is genuinely useful for **stance** — *"review this as
a security engineer," "argue against this"* — because it changes what the AI looks for,
not merely how it writes. Not a fix for verbosity. Not added to the contract.

### The reframe that produced the rule

Gary: *"I'm naturally a very detailed person. The BLUF response style though was an attempt
at reducing the verbosity and the mental fatigue that produces over the course of a day."*

**That is the actual objective, and it changes the instrument.** If the cost is fatigue,
the enemy is not word count — it is **how much work it takes to extract the point**. A
5-line answer that buries the recommendation costs more than a 12-line one that leads with
it. The old cap measured the wrong thing: it constrained length without requiring
structure, so a 5-line survey still satisfied it.

It also resolves the apparent contradiction of a detail-oriented person asking for
brevity. He does not want less information — he wants **the decision free of the work of
extracting it**. Detail *after* the bottom line is nearly free to skip; detail *before* it
is mandatory reading.

**So the rule now optimizes for skippability, not length.**

### What changed in the section

| Old | New | Why |
|---|---|---|
| "Default to 5 lines or fewer" | Skippability; no line cap | The cap constrained length without requiring structure |
| Escape hatch: say "detail" to go long | BLUF always; depth follows when exploring | The old hatch required Gary to predict his mode *before* asking |
| "No headers or tables unless asked" | A test: do they help the reader skip? | Violated on sight all session; some tables did earn their place. A rule ignored is worse than one calibrated |
| — | One ask per turn, stated as an ask | The defect that started this conversation |
| — | No ambiguous referents | "That trigger," and the re-read it cost |
| — | "When action is required, tighten" | Gary's own trigger, verbatim in intent |
| — | Blockquote: this cannot be mechanized, has drifted twice | Honesty matching the rest of the contract |

Gary also noted **bold text aids focus** — kept deliberately as a scanning aid rather than
emphasis.

### Notes for future sessions

- **The new rule takes effect next session.** It is read at session start; this
  conversation had the old one loaded throughout.
- **Expect drift, and correct it normally.** The rewrite explicitly frames *"you're being
  verbose"* as an ordinary correction, not an exceptional failure. Its predicted failure
  mode is casual problem-solving with no command in play.
- **Not pursued, still open:** nudges inside `/fw-move`, `/fw-roadmap`, `/fw-swarm`, which
  Gary flagged as *"MIGHT benefit from an extra nudge in the response"* since each produces
  a decision point. Not carded — mentioned here so it is findable.

---

## Decisions Made (late evening)

18. **Response Style optimizes for skippability, not line count.** Fatigue is the cost;
    extraction effort drives it, not word count.
19. **No command for conversational style.** No chokepoint exists to hang one on; the rule
    holds by adherence, and the contract now says so.
20. **No standing role/hat for Gary.** His mode varies per message inside a constant role.
    Role-invocation kept as an occasional tool for *stance*, not style.
21. **Headers/tables governed by a test, not a ban** — do they help the reader skip.

## Files Modified (late evening)

- `CLAUDE.md` — Response Style section rewritten (commit `9b20cda`)

---

**Last Updated:** 2026-09-10
