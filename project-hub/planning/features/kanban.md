# Feature: Kanban

**Workspace:** framework
**MVP Target:** 1.0 (ADR-009 D5 crossover)
**Last Reviewed:** 2026-09-11

<!-- Membership is derived: cards carry `Feature: Kanban`. This file never lists
     them. The field and its validation are not built yet (see Open Questions).

     Cite sections as `kanban§N`. Numbering is FLAT across all three groups —
     groups are headings, not namespaces — so a citation is unambiguous. Numbers
     are stable once published: retire a criterion by marking it superseded and
     pointing at its replacement; insert with §Na rather than renumbering.

     This file names FUNCTIONS, never commands. "A card enters the board through
     a create gate" — not the name of the script that does it. Command names are
     implementation and drift; the function does not. -->

---

## Definition

**A file-based kanban board.** Work items are **plain Markdown files in folders**, and a
card's **folder is its status** — moving the file moves the card. No database, no server, no
app: the board is the filesystem, so it is readable by hand, editable in any editor, diffable
in git, and legible to an AI with nothing but file access.

A **card** is one file (`<TYPE>-<nnn>-<slug>.md`) holding its own description, its sub-tasks,
and its acceptance criteria. Bulky or binary working material lives in a **sibling folder
named for the card's id** (`FEAT-042/`) that travels with it. Cards move between a fixed set
of folders along defined paths, guarded by **gates** — the checks that decide whether a move
is allowed.

Board, cards, and gates are one feature because they are one design: status *is* folder, so
the card's format and the board's states cannot be specified apart from each other.

## Why It Exists

Work that is not on a board is invisible to the next session. The framework's premise is that
an AI resumes where the last one stopped, and that only holds if the state of the work is *on
disk, in one place, in a form both a human and an AI can read and trust*. Plain files in
folders is the format that survives: no tool to install, no export, no API, no vendor.

The gates exist because an unenforced convention drifts silently — the failure this framework
was built to prevent.

---

## A. The Board

### §1. The board is a fixed, authored folder set

**Met when:** the board holds `backlog blocked todo doing accept done cancelled`, matching the
authored repo-structure diagram. Today's board has five of the seven — `accept/` and
`cancelled/` are the delta.
**Validated by:** AI: folder set matches the authored set by inspection · Human: a card moved
into each folder lands where expected
**State:** Pending — TASK-219 (Group 2a owns the `accept`/`cancelled`/`blocked` metadata)

### §2. The lifecycle is specified as data, not as behaviour

**Met when:** the legal transitions between states are declared in one place as a table — not
scattered through code — including which states are **terminal** (`done`, `cancelled`: a card
there does not move again; reopening means a new card) and what each state *means*, in
particular **`accept/` = finished but not yet accepted**, distinct from `done/`.
**Validated by:** AI: every allowed and disallowed transition traced to the declared table ·
Human: an illegal move is refused with a message naming the allowed paths
**State:** Pending — the table exists for operations; kanban's row is declared empty

### §3. Entry to the board is two folders, and only two

**Met when:** a card may be created into **`backlog/` (normal)** or **`todo/` (urgent)**, and
nowhere else. Creation directly into `doing/`, `accept/`, `done/`, `blocked/` or `cancelled/`
is refused.

**Why it is closed rather than permissive** (decided 2026-09-11): *"Anything else destroys
planning."* A card that appears mid-board was never planned, never estimated, and never
queued — it is invisible to every decision made before it arrived.
**Validated by:** AI: creation into each disallowed folder is refused · Human: both legal
entry paths behave as specified
**State:** Pending — decided, not built; enforced by §12

### §4. One implementation serves both namespaces

**Met when:** kanban and operations are two rows of one policy table, sharing the move
implementation — no second engine, no namespace-specific copy of the move logic. The
namespace is always an argument, never inferred from an id or a folder name.
**Validated by:** AI: one code path serves both, verified at the call sites · Human: UAT cases
for kanban mirroring the operations set
**State:** Door — opens at the ADR-009 D5 crossover *(no card owns this — see Open Questions)*

### §5. WIP limits warn loudly, and never block

**Met when:** a folder declares its own limit (`todo` 10, `doing` 2 today), the gate reads it
as data, and **every move into an over-limit folder produces a loud warning** naming the
folder and the count. The move proceeds — a WIP breach is never a block.

**Warn, not block** (decided 2026-09-11, reversing an in-discussion lean toward blocking).
Evidence: across many projects exactly one has persistently exceeded its limits, and that
board needs *grooming*, not a refusal. Blocking would have forced a backlog problem to
surface as a fight with the tooling, and the predictable workaround — editing the limit to
get unblocked — is worse than the breach: a permanent change made to solve a temporary
problem, with nothing recording that it happened.

**Into, not on every move.** A board sitting over limit stays quiet while cards move *out* of
the full folder — that direction drains it. The warning fires when you add to the problem.

**The limit is editable on purpose.** Each repo tunes its own balance, so the limit is a
per-repo declaration the gate reads rather than a constant it enforces. No mechanism can stop
someone editing a declaration, and the feature does not pretend otherwise: what is required is
that the limit is *declared as data* and a breach is *surfaced*.

**No remedy advice in the message.** Suggesting "move something out or finish something
nearly done" would not change the behaviour and reads as noise. **The purpose of a WIP limit
is to encourage focus, not to obtain compliance** — a nag that does not block is honest about
being a nudge.
**Validated by:** AI: the limit is read from the folder, not hard-coded; a move into a full
folder warns and still succeeds · Human: the warning is noticeable in ordinary use, and does
not fire when draining an over-limit folder
**State:** Built in the old engine (warning only, `→ doing`) · **Pending in the new engine** —
it has no limit handling at all, and the old engine checks only moves into `doing/`

---

## B. Cards

### §6. A card's anatomy is defined and mechanized

**Met when:** each of these has a *mechanism* — a template field, a script check, or a hook —
or an explicit statement that it cannot be mechanized:

- **Id and shared sequence** — one sequence per board, the prefix carries the type
- **Filename convention** — `<TYPE>-<nnn>-<slug>.md`, with the id parsed unambiguously (a
  bare `901` must not match `9010`)
- **Supporting material** — a sibling folder named for the id (`FEAT-042/`) that moves with
  the card
- **Sub-tasks** — see §7
- **Cross-references** between cards
- **Required fields**, including the feature the card serves (§9)

The new build currently defines none of these and ships **no work-item template of any kind**.
**Validated by:** AI: each convention traces to a mechanism, not a paragraph · Human: the
conventions hold when a real card is created and moved
**State:** Pending — TASK-219 owns the set; Group 1 is the blocker

### §7. Sub-tasks have one defined form

**Met when:** it is settled *when* a piece of work is a checkbox inside a card versus a child
card of its own, and the chosen mechanism is the only one in use.

**The conflict to resolve:** FEAT-021 proposes dotted sub-ids (`FEAT-042.1` — a real file, its
own lifecycle), TECH-082 proposes a `Parent:` field on independently numbered cards. **The
board uses both today.** A checkbox and a child card are not interchangeable: a checkbox
cannot move, be assigned, or be blocked on its own; a child card cannot be ticked off in a
list.
**Validated by:** AI: one mechanism present, the other absent · Human: a card with sub-work
reads unambiguously
**State:** Pending — TASK-219 Group 1; blocks §6

### §8. Acceptance criteria are distinguishable from sub-tasks

**Met when:** a card's *testable conditions* are machine-distinguishable from its *work
checklist*. Today both are `[ ]` boxes and the done-gate counts them together, so "all boxes
checked" means **the work was done**, not **the result was verified** — which is precisely the
claim the gate is supposed to protect.

Each criterion names who validates it: **AI**, **human**, or both; anything user-facing needs
both.
**Validated by:** AI: a card with all sub-tasks done but criteria unmet is refused at `→ done`
· Human: a real card reads clearly under the split
**State:** Pending — **not yet carded**

### §9. Every card names the feature it serves

**Met when:** cards carry a `Feature:` field, validated at creation against the set of feature
files; an unknown value is refused and offers to create the feature file.
**Validated by:** AI: a card with an unknown feature is refused · Human: the create gate asks,
and the answer is usable
**State:** Pending — **not yet carded**

**Why it belongs here:** it makes feature membership *derivable* rather than hand-kept, and it
catches a card that serves no feature — usually scope creep, caught cheaply at creation.

### §10. Checkbox states carry what the folder cannot

**Met when:** `[ ] [/] [x] [-] [?] [h]` are understood by the gates, so a card can be recorded
as *in progress* or *blocked* **at a sub-task**, without changing folder. Folder granularity is
the whole card; blocking usually is not — a card blocked on one sub-task is not a blocked card,
and moving it to `blocked/` would misreport the other 90%.
**Validated by:** AI: each state read correctly by the gate · Human: a card with a `[h]`
sub-task behaves as specified on a move attempt
**State:** Pending — TECH-177

---

## C. Gates

### §11. Movement is guarded

**Met when:** a move is refused unless the transition is legal (§2), its dependencies are
satisfied (`→ doing` requires them complete), and its acceptance criteria are met
(`→ done`) — each refusal naming what is missing. **Ripeness stays a judgment step**: per
ADR-007 D7 a grep cannot decide whether a plan is ripe, so it is enforced by the command's
judgment, never claimed as a script check.
**Validated by:** AI: each gate refused with a fixture that violates it · Human: UAT cases for
each refusal
**State:** Pending — the old engine implements all three; porting is the work

### §12. Creation is guarded

**Met when:** a card enters the board through a gate that assigns the next id from the shared
sequence, resolves a template for its type, enforces the required fields (§6, §9), and
respects the legal entry points (§3).
**Validated by:** AI: ids never collide, template fields present, unknown feature refused ·
Human: a UAT case per card type
**State:** Pending — FEAT-175 (blocked on the conventions in §6)

### §13. Batch moves work, with per-item outcomes

**Met when:** a list of ids moves in one invocation; items validate individually; the run
continues past a failure; the summary reports moved/skipped/failed; a failure exits non-zero.
**Validated by:** AI: source-tree cases (BUG-215) · Human: UAT-33..36 in `framework-uat`
**State:** Built for operations (BUG-215) · Pending for kanban — inherited via §4

### §14. Gates run in the mechanism, not in prose

**Met when:** every gate above is enforced by a script or hook, not by an instruction in a
command file. An AI that never reads the guidance must still be unable to move past a gate.
**Validated by:** AI: each gate fires when invoked directly, bypassing the command layer ·
Human: n/a
**State:** Pending — the standard is ADR-008; several gates are prose today

---

## Out of Scope

- **Orchestration** — driving the board in bulk (batch implementation runs, WIP-aware
  scheduling). A *consumer* of the board, not part of it. → its own feature; FEAT-221 today.
- **Reporting, roadmaps, and history** — reading across the board and other namespaces.
  → the "other" feature (roadmap D4: FEAT-163, FEAT-196, FEAT-198).
- **Operations records** — same engine, different namespace. → the Operations feature; see
  Related for how far the analogy holds.
- **The knowledgebase** — → the kb feature. The `→ closed` hand-off is FEAT-226 and is
  operations-side anyway.
- **Sprints, velocity, team ids** — unbuilt in both frameworks, not planned (roadmap D8, C2).

## Open Questions

- [ ] **Nothing owns the crossover.** The ADR-009 D5 board crossover is referenced from four
      places in `ROADMAP-DELIVERABLES.md` and has no card, no rank, no acceptance criteria.
      §4 cannot open until one exists. *Recommended: one card owning the kanban transition
      table and the kanban move function, with TASK-219 and TECH-177 as dependencies.*
      — owned by **nobody yet**
- [ ] **§8** (criteria vs sub-tasks) — **not yet carded**
- [ ] **§9** (the `Feature:` field) — **not yet carded**
- [ ] **Where the 27 `deprecated/` cards live** — no `archive/` in the authored folder set.
      — owned by TASK-219 (Group 2a)
- [ ] **FEAT-030's hold state** — absent from the authored diagram. — owned by TASK-219

## Change Log

| Version | Date | Change |
|---------|------|--------|
| v0.3 | 2026-09-11 | **§3 decided** — entry is `backlog/` (normal) or `todo/` (urgent), nothing else; anything else destroys planning. **§5 decided** — WIP limits warn loudly on moves *into* an over-limit folder and never block; limits stay per-repo editable by design; no remedy advice in the message. Both moved from open question to settled criterion. |
| v0.2 | 2026-09-11 | Grouped into Board / Cards / Gates; lifecycle, entry points, WIP limits, and card anatomy added as criteria; "file-based" stated in the Definition; command names removed in favour of functions; §10 (was §7) sharpened to say what the states buy. |
| v0.1 | 2026-09-11 | Initial draft. First feature file — the template-by-example for the other four. |

---

## Related

- **ADR-009** — governs the new build; decision **D5** is the board crossover. *Note the
  collision:* roadmap deliverable "D5" is troubleshooting, an unrelated thing.
- **Operations** — the sibling namespace. Gary's claim, worth testing as operations is
  defined: *"operations is really just a variation of the kanban."* The move engine agrees —
  one engine, two policy rows differing in folders, transitions and terminal states. **The
  caveat found 2026-09-11:** operations needs a gate type kanban does not have — a *judgment*
  the script cannot compute (the resolution code). So operations ≈ kanban + different folders
  + a judgment gate.
- **Roadmap D1 / D1b** — the spine and the board conventions; the card inventory behind §6.
