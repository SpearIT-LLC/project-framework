# Tech: A Workspace Declares Its Own Conventions, and the Gates Read Them

**ID:** TECH-232
**Type:** Tech
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-09-11
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

A workspace records its type at creation and **nothing ever reads it back**. Make the type —
and the conventions that follow from it — a declaration the gates consult, so a command can ask
the right question and a cold session can find the answer without being told.

## The Trigger

FEAT-231 adds `Serves: feature/kanban` to every card. Two questions fell out that nothing in
the repo can answer:

1. **What kind of thing does a card serve here?** A *product* workspace has **features**, a
   *project* has **deliverables**, a *knowledgebase* has **domains** (settled 2026-09-11). The
   create gate must ask the right question; the word is the hint that sets direction for both
   the human and the AI.
2. **Where do those live?** `Serves: feature/kanban` must resolve to a file. Today nothing
   states where features live, so **a newcomer cannot find it** — and per
   `workspaces/framework/CLAUDE.md`, every session starts as a newcomer.

## Current State

**The type is declared and orphaned.** `fw-new-workspace.sh` composes a workspace from
`templates/workspaces/` — a shared `floor/` plus a per-type overlay — and the type lands in the
workspace's README:

```
workspaces/framework/templates/workspaces/product/README.md:3:**Type:** product
workspaces/framework/templates/workspaces/project/README.md:3:**Type:** project
```

**Verified 2026-09-11: no script reads `Type:` back.** `grep -rn "Type:" workspaces/framework/scripts/`
returns nothing. It is written once and never consulted.

**And the new build has no index at all.** The old framework has `framework.yaml` with a
`sources:` block mapping topic → source-of-truth; `workspaces/framework/` has no equivalent.
That was fine while every convention was hard-coded. It stops being fine the moment a
convention varies per workspace.

## Design

### What a workspace declares

The four types are not variations of one shape — `product` has `dist src tests poc`, `project`
has `requirements`, `floor` has `agreements deliverables meetings`, `knowledgebase` has domains.
So the declaration is per workspace, not per repo:

```yaml
type: product
serves:
  kind: feature          # the word the create gate asks with
  location: planning/features/
```

**Why per workspace and not a repo-wide index:** ADR-009 makes the repo the customer, hosting
many workspaces of different types. One repo-wide answer cannot serve a product and a project
sitting side by side.

**Why a declaration and not hard-coding:** a workspace that organizes differently is a
legitimate variation, not an error — the same reasoning that made `.limit` files per-folder
data the gate reads rather than a constant (`kanban§5`).

**Why not prose in a CLAUDE.md:** ADR-008 Root 2 — an instruction the AI merely reads is not a
mechanism. This session hit that failure twice in one day.

### The format — DECIDED 2026-09-11: `workspace.yaml`

A **`workspace.yaml` beside the README**, with the README *pointing* at it rather than restating
it (ADR-008: one authored source, the other a pointer).

**Why not the README's front matter**, which already carries `**Type:**`: it is authored prose
that people reformat, and parsing prose for configuration is fragile. The `**Type:**` line stays
as human-readable text; `workspace.yaml` is what the gates read.

**Permanent, not a stopgap.** It is *not* a per-workspace proxy for the old `framework.yaml` and
does not consolidate into one at the cutover. They answer different questions: `framework.yaml`
is a repo-level index of framework-internal paths; `workspace.yaml` holds what only the repo can
know — *this* workspace is a product, *its* features live *here*. ADR-009 hosts many workspaces
of different types in one repo, so a product and a project side by side genuinely need different
answers; collapsing them to one repo-level file reintroduces the problem.

**Repo-level configuration is deliberately out of scope — see TECH-233.** That card owns what
the new build does about `framework.yaml`'s role now that ADR-009 D3 removed the archive that
seeded it. Keeping it separate is what stops this card growing into the configuration-model
decision.

### What must read it

- **The create gate** — to ask *"which feature?"* / *"which deliverable?"* / *"which domain?"*
- **The `Serves:` validator** — to resolve `feature/kanban` and refuse an unknown value, and to
  refuse a `deliverable/` prefix on a product workspace
- **Reporting** (FEAT-163, FEAT-196) — to slice by the right unit per workspace

## Acceptance Criteria

- [ ] A workspace declares its type and its `serves` kind and location in one place
- [ ] `fw-new-workspace.sh` writes the declaration for every type
- [ ] At least one gate reads it back — the create gate asks the workspace's own word
- [ ] The declaration is discoverable by a cold session: a stated, findable location, not
      knowledge that has to be carried in
- [ ] Two workspaces of different types in one repo each get their own vocabulary
- [ ] Existing workspaces gain the declaration without being recreated
- [ ] Validated: **AI** — creating a card in a project workspace asks about *deliverables*, and
      `Serves: feature/x` is refused there · **Human** — a newcomer can answer "where do
      features live?" from the repo alone

## Tasks

- [ ] Update the four workspace overlays
- [ ] Update `fw-new-workspace.sh`
- [ ] Backfill existing workspaces

## Related

- **FEAT-231** — `Serves:` **depends on this.** The field cannot be validated, and its question
  cannot be asked in the workspace's own vocabulary, without the declaration. Build this first.
- **kanban§5** — the `.limit` precedent: declared as data, per-repo editable, read by the gate.
- **ADR-009** — repo-is-the-customer, which is why this is per workspace.
- **ADR-008** — one authored source; the README points at the declaration rather than
  restating it.
- **FEAT-163 / FEAT-196** — reporting needs the same declaration to slice correctly.
- **TECH-233** — repo-level configuration: what replaces `framework.yaml`'s role now that
  ADR-009 D3 removed the archive that seeded it. **Deliberately separate from this card**, and
  independent of it.
- **FEAT-198** — `/fw-roadmap` reads the same declaration for its vocabulary (features /
  deliverables / domains).
- **TASK-197** — named the type set (`product`, `project`, `floor`, `knowledgebase`).
