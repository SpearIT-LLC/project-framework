# Tech: Acceptance Criteria Are Claims, Not Tasks

**ID:** TECH-230
**Type:** Tech
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-09-11
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

A card's **work checklist** and its **testable conditions** are the same syntax in the same
section today, so the done-gate counts them together. "All boxes checked" therefore means *the
work was done*, not *the result was verified* — which is the exact claim the gate exists to
protect.

Fix it in three parts: **separate the sections**, give criteria their **own marker vocabulary**
(`[ ] [P] [F] [I]`), and let a criterion carry a **one-line attempt log** when it has ever
failed.

## The Problem

`fw-move.sh`'s `→ done` gate counts unchecked `[ ]` boxes under `## Acceptance Criteria`. It
cannot distinguish:

- *"Comma-separated, space-separated, and mixed forms all parse"* — a **claim about the
  result**, true or false independent of what work was done
- *"Command doc shows the batch form"* — a **task**, done when you have done it

**BUG-215 is the live example**: nine criteria, both kinds, all `[x]`. A reader cannot tell
which were verified, and neither can the gate.

**The distinguishing test:** *could a stranger check this without being told what work was
performed?* A criterion survives that; a task does not.

**And `[x]` is the wrong word for a criterion.** "Done" is a task concept. A criterion passed,
failed, or could not be determined — and today **a failed criterion is indistinguishable from
an untested one**, which is the information most worth having.

## Design

### 1. Two sections

- `## Acceptance Criteria` — claims. Gated.
- `## Tasks` — work. Not gated.

The gate keeps counting exactly one section, and a reader can see at a glance what was actually
verified.

### 2. A marker vocabulary for criteria

| Marker | Meaning |
|---|---|
| `[ ]` | Untested |
| `[P]` | Passed |
| `[F]` | Failed |
| `[I]` | Inconclusive — **a reason is required** |

Tasks keep `[ ]` / `[x]`.

**This makes the two syntactically distinct**, so the gate does not depend on section headers
to tell a criterion from a task — a criterion filed under the wrong heading is still
recognizable. It also lets the gate **refuse on `[F]` explicitly**, which it cannot do today.

**`[F]` is a legitimate resting state**, not a defect in the card. It means *this was tested and
it did not work*. A convention that made failure embarrassing would be a convention that gets
deleted rather than recorded.

**Deliberate divergence from Obsidian** (settled 2026-09-11): Obsidian has no pass/fail concept
— the Tasks plugin resolves every custom status to `TODO`, `IN_PROGRESS`, `DONE` or
`CANCELLED`, and *cancelled* means "we are not doing this," not "this was checked and it is
wrong." `P`/`F`/`I` are unused by the common theme collections, so nothing collides. **Recorded
so nobody later "fixes" this back to theme-compatible markers.** Gary does not use Obsidian;
TECH-177's `[ ] [/] [x] [-] [?] [h]` still governs **tasks**, where the Obsidian rendering
argument does apply.

### 3. The attempt log

**The marker is current state, overwritten.** A criterion that failed then passed is `[P]` — a
sticky `[F]` would block the gate forever and push people to delete the line rather than record
it, so the mechanism would punish honesty.

**The journey is appended beneath it, one line per attempt, never rewritten:**

```markdown
- [P] Batch moves attribute a bundle on a non-first record correctly
      *Validated by: AI — source-tree fixture · Human — UAT-33*
      - 2026-09-11 [F] exit 1, cfg had the wrong root path
      - 2026-09-11 [P] re-ran after fixing cfg
```

**One line, and it says what failed and why — not what was done about it.** The fix belongs in
the commit or an Actions section. Gary: *"it would be useful history to know why a test failed
but it shouldn't be an essay."*

**Required only when a criterion has ever been `[F]` or `[I]`.** A criterion that passed first
time needs no history, and demanding one adds ceremony to the common case.

**Precedent:** BUG-215's verification section already does this by hand — the box stays open
while dated notes accumulate under it, including the structural reason a publish did not close
it. That worked; this gives it syntax.

### 4. Validators

Each criterion names who checks it: **AI**, **Human**, or both. Anything user-facing needs both.
This is the convention the feature files already use, so cards and features match.

**The honest limit:** the gate can enforce that criteria exist, are marked, and are not `[F]`.
It **cannot** tell a real criterion from a task filed under the wrong heading — that is a
judgment step, like ripeness (ADR-007 D7). Stated here rather than pretended away.

## Acceptance Criteria

- [ ] `## Acceptance Criteria` and `## Tasks` are separate sections in the work-item template,
      with the distinction stated in the template's comment header so it travels with every card
- [ ] The done-gate refuses on any `[ ]` or `[F]` criterion, naming which
- [ ] The gate ignores the `## Tasks` section entirely
- [ ] `[I]` without a reason is refused
- [ ] Existing cards migrate: criteria converted to the new vocabulary, tasks moved to `## Tasks`
      — *mixed notation during the transition is worse than either state, so this lands in one pass*
- [ ] Validated: **AI** — a card with one `[F]` criterion cannot reach `done/`; a card whose
      only unchecked boxes are tasks can · **Human** — a real card reads clearly under the split,
      and the attempt log is usable without being an essay

## Tasks

- [ ] Update `templates/records/work-item.md`
- [ ] Update the done-gate in `fw-move.sh`
- [ ] Migrate open cards
- [ ] Note the divergence in the framework's marker documentation alongside TECH-177

## Related

- **kanban§8** — the criterion this card closes.
- **TECH-177** — the Obsidian marker set for **tasks** and sub-task state. This card
  deliberately does *not* extend it to criteria; see the divergence note.
- **BUG-215** — the worked example of the problem, and the hand-rolled precedent for the
  attempt log.
- **TASK-219** — settled the work-item template this card modifies.
- **FEAT-221.1** — moves the acceptance-criteria gate to fire on either exit from `doing/`.
  Same gate, different trigger; they should land aware of each other.
