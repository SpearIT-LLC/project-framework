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
     implementation and drift; the function does not.

     LENGTH RULE (settled 2026-09-11): not a line cap. Every line must have a
     purpose, state it as simply and directly as possible, and appear nowhere
     else. A cap is a bad proxy — it punishes a feature with genuinely many
     criteria and permits a short file full of padding. Detail that needs
     analysis belongs on a card, with one line here pointing at it. -->

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

## What Could Invalidate This

**Nothing — the mechanism is proven.** The board has run this project for months; the risk here
is not viability but *drift between the two boards* during the build, since `project-hub/work/`
stays live until the cutover.

<!-- "Nothing" is a legitimate answer to this section, given a reason (TECH-228).
     A feature whose mechanism is already running does not have a killer unknown. -->

**Recorded 2026-09-11, because a draft of this file claimed otherwise:** the FEAT-021 /
TECH-082 parent-child conflict was named here as the MVP blocker. **It is not a conflict.**
TASK-219 read both cards on 2026-09-09 and found them complementary — dotted ids for tight
coupling, `Parent:` for provenance — and **adopted both** with a rule for which applies. The
claim came from `ROADMAP-DELIVERABLES.md`, which is stale on card state by its own admission.

<!-- Every feature names the one unknown that could kill or block it, and that
     question is sequenced FIRST — before the valuable work, regardless of value. -->

---

## A. The Board

### §1. The board is a fixed, authored folder set

**Met when:** the board holds `backlog blocked todo doing accept done cancelled`, matching the
authored repo-structure diagram. The **live** board at `project-hub/work/` has five of the
seven — `accept/` and `cancelled/` are the delta, and arrive with the cutover.
**Validated by:** AI: folder set matches the authored set by inspection · Human: a card moved
into each folder lands where expected
**State:** **Built as a scaffold** — `templates/queues/kanban/` holds all seven plus `release/`,
with `.limit` files and a README (TASK-219, 2026-09-09). Pending: the live board gaining them
at the cutover, and Group 2a's open questions (below)

### §2. The lifecycle is specified as data, not as behaviour

**Met when:** the legal transitions between states are declared in one place as a table — not
scattered through code — including which states are **terminal** (`done`, `cancelled`: a card
there does not move again; reopening means a new card) and what each state *means*, in
particular **`accept/` = finished but not yet accepted**, distinct from `done/`.
**Validated by:** AI: every allowed and disallowed transition traced to the declared table ·
Human: an illegal move is refused with a message naming the allowed paths
**State:** Pending — the table exists for operations; kanban's row is declared empty

**Not every card leaves the board the same way.** The old framework distinguishes them and the
new build does not: a **spike archives to `history/spikes/`, never `history/releases/`** —
spikes are for learning, not delivering, so they produce no release. A **POC spike** archives
as a *folder* (doc plus code artifacts), not a file. The lifecycle must carry this, or
`done/` means two different things. — see TECH-228

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
**State:** Pending — **FEAT-229** builds the kanban namespace; the cutover to the live board is
a separate card

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

**Validated by:** AI: each convention traces to a mechanism, not a paragraph · Human: the
conventions hold when a real card is created and moved
**State:** **Built** — TASK-219 settled all five with mechanisms (2026-09-09) and authored
`templates/records/work-item.md`; FEAT-175's create gate shipped in 0.4.7. Fourteen further
conventions are TASK-223, none blocking.

### §7. Sub-work has three forms, and a rule for choosing

**Met when:** the three are distinguishable and the choice between them is stated where a card
author will see it:

- **Checkbox** — cannot move, be assigned, or be blocked on its own. Tracked inside the card.
- **Dotted id** (`FEAT-042.1`) — tight coupling: dies with the parent, moves with it, counts
  as **one** WIP item.
- **`Parent:` field** — provenance: stands alone, worked separately, counts as its **own** WIP
  item.

**The rule:** *does this make sense on its own?* Yes → `Parent:`. No → dotted. Neither → a
checkbox.
**Validated by:** AI: the engine moves dotted children with their parent and leaves `Parent:`
children alone · Human: a card with sub-work reads unambiguously
**State:** **Built** — TASK-219 (2026-09-09) adopted both id mechanisms with the rule in the
template's comment header, so it travels with every card

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
**State:** **Built for the board's card types** — FEAT-175 shipped in 0.4.7. Pending: scaffolding
`kanban/` on first use (FEAT-229), the `Feature:` field (§9), and the SPIKE shape (TECH-228)

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

- [x] ~~**Nothing owns the crossover.**~~ **Closed 2026-09-11 — FEAT-229** builds the board
      (transitions, gates, create and move functions, work-item template). The **cutover** —
      making `kanban/` live and retiring `project-hub/work/` — is deliberately a separate
      card, not yet written: building and switching are separable work with different risk.
      *The naming was the reason this stayed invisible: "the crossover" names a moment, so
      nobody noticed there was no card for the capability.*
- [ ] **§8** (criteria vs sub-tasks) — **not yet carded**
- [ ] **§9** (the `Feature:` field) — **not yet carded**
- [ ] **Group 2a leftovers** — transitions into `cancelled/`, whether it is terminal, a board
      closure code, and where the 27 `deprecated/` cards live (no `archive/` in the authored
      folder set). Explicitly left open by TASK-219; **carried by TASK-223**.
- [ ] **FEAT-030's hold state** — absent from the authored diagram. — TASK-223

## Change Log

| Version | Date | Change |
|---------|------|--------|
| v0.4 | 2026-09-11 | **Reconciled against the board, not the roadmap.** TASK-219 shipped 2026-09-09 and FEAT-175 in 0.4.7, so §1, §6, §7 and §12 move from Pending to Built or part-Built. **The FEAT-021/TECH-082 "conflict" was not one** — TASK-219 found the two complementary and adopted both with a selection rule; *What Could Invalidate This* is corrected to "nothing", and §7 now states the three forms of sub-work. Group 2a leftovers reassigned to TASK-223. **Cause of the errors: card state was taken from `ROADMAP-DELIVERABLES.md`, which says in its own header not to trust it for that.** |
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
