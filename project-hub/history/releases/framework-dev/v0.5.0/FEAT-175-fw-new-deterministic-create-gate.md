# Feature: `/fw-new` — Deterministic Create Gate for Board Items

**ID:** FEAT-175
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-07-08
**Workspace:** framework
**Completed:** 2026-09-10
**Theme:** Framework Consistency

> **RE-SCOPED 2026-09-02 for the ADR-009 build (TASK-218 Section E).** The old target
> (`.claude/scripts/fw-new.sh`, `Setup-Framework.ps1`, `/fw-help`, three-channel parity)
> is dead. **The gap is not — it is now the new build's most conspicuous missing create
> gate.** The new build has create gates for workspaces, ops records, contacts, and kb
> domains; it has **none for board items**. This card becomes the kanban namespace's
> create gate, and belongs with the ADR-009 D5 board crossover. The design work below
> (strict-script / lenient-AI, the rejection message as an education surface, the scoped
> ID scan) carries over intact — it was never pipeline-specific.

---

## Summary

Build `fw-new.sh` for the ADR-009 build: a deterministic create gate for board items that
**assigns the ID** and **enforces the accepted work-item type** from a single source of
truth, rejecting anything off-list with an actionable message. Discovery, scoping, and
writing stay AI-collaborative.

This is the create-side twin of `fw-move.sh`, and it completes the create-gate set.

---

## Current State (verified 2026-09-02)

The new build has **four** create gates and is missing the fifth:

| Namespace | Create gate | Status |
|---|---|---|
| Workspaces | `fw-new-workspace.sh` | ✅ ships |
| Operations | `fw-new-ops-record.sh` | ✅ ships (`INC-`/`REQ-`, shared sequence) |
| Contacts | `fw-new-contact.sh` | ✅ ships |
| kb domains | `fw-new-kb-domain.sh` | ✅ ships |
| **Board items** | **`fw-new.sh`** | ❌ **does not exist** |

Two consequences, both verified:

- **No type SoT exists in the new build.** No `work-item-types.txt` (or equivalent)
  anywhere under `workspaces/framework/`. The old one lives at
  `.claude/scripts/work-item-types.txt` — old-tree, does not ship. So the accepted set is
  currently unenforced *and* unstated in the new build.
- **The kanban namespace is not live yet.** `fw-move.sh:15-17` — *"not active in this repo
  until the board crosses over (ADR-009 D5); the policy slot exists so the crossover is a
  table entry, not a second engine."* The move engine reserved its slot; the create side
  has no slot at all.

**Sequencing consequence:** this card should land **with the D5 board crossover**, not
before it. Building a board create gate while the board namespace is inactive would be
speculative — and the ID engine (`fw-next-id.sh`) already refuses the `kanban` namespace
until crossover, by design.

---

## Design (carried forward — not pipeline-specific)

### The gate: strict script, lenient AI

The division of labor is the whole design. **The AI chooses and suggests; the script
decides.**

1. **AI infers the type** from conversation when not given (`/fw-new "add CSV export"` →
   proposes `FEAT`), or passes an explicit one through.
2. **AI may normalize or suggest before calling the script** — always as a suggestion the
   user confirms, never a silent substitution:
   - **Prefix normalization** (mechanical): a canonical name that is a prefix of what the
     user typed resolves to it. `FEATURE`→`FEAT`, `BUGFIX`→`BUG`, `TECHDEBT`→`TECH`.
     *Verified 2026-07-09 against 74 real type-name strings harvested from Jira, Jira
     Service Management, GitHub, Azure DevOps (Agile/Scrum/CMMI/Basic), GitLab, Linear,
     Redmine, Shortcut, Conventional Commits and SAFe: **zero false positives** — and it
     reproduces the old hand-maintained alias map exactly, with nothing to maintain.*
   - **Semantic suggestion** (judgment): the ~15 strings prefix-matching cannot reach and
     users actually type — `story`, `enhancement`, `defect`, `fix`, `incident`, `chore`,
     `refactor`, `docs`, `perf`, `research`. **No lookup table** — a table would be another
     copy of the type vocabulary, the exact fragmentation the SoT exists to prevent.
3. **The script is strict.** It accepts only a member of the SoT's accepted set,
   case-insensitively. No aliases, no fuzzy matching, no opinion about whether the *right*
   type was chosen. A corrected type re-enters through the gate on its own merits —
   nothing is admitted by AI assertion.

**Why not fuzzy-match in the script:** prefix matching is safe against today's five types
by *property of the current list*, not by property of the rule. Add a type whose name
prefixes another and it silently picks wrong — and whoever adds a line to a text file has
no reason to think about prefix collisions. A create gate bakes its answer into a filename
that lives forever. Rejection costs one round-trip; a wrong type committed and
cross-referenced is expensive. This mirrors `fw-move.sh`: hard block in the script,
interactive recovery in the command.

### The rejection message is the primary education surface

A lesson, not a wall. It must:
- name the accepted set;
- note that legacy prefixes are recognized on existing items but never offered for
  creation;
- when the input maps semantically, say so **and why** (`chore` → *"`TECH` covers work on
  the system itself — docs, chores, refactors"*);
- when the input is a **structural** request rather than a type, answer the real question.
  The common case is `story`: a Jira user typing it is asking *how do I model a story with
  tasks under it?* The framework's answer is hierarchical sub-items — and note that
  `fw-move.sh:6` **already** treats child items as grouping that moves with its parent, so
  the machinery exists on the move side and the create side must match it.

### ID assignment — reuse `fw-next-id.sh`, do not reimplement

`fw-next-id.sh` is already *"THE one home for next-ID logic across namespaces"* and it
scans recursively, counting every record and bundle under the namespace root. `fw-new.sh`
must call it, not roll its own scan.

**The scoped-scan hazard is real and verified (2026-07-09):** a naive `TYPE-NNN` grep
across `project-hub/` returned `202`, matching `ROADMAP-2026-02-04.md` as `ROADMAP-202`,
where the correct scoped scan returned `178`. An unscoped implementation would silently
burn 25 IDs on first run and corrupt the shared namespace. The new engine avoids this by
scanning a *namespace root* rather than a directory tree of mixed content — preserve that
property; do not widen the scan.

---

## Scope

**In scope:**
- A **type SoT that ships with the plugin** — the accepted set (`FEAT`, `BUG`, `TECH`,
  `TASK`, `SPIKE`), with header guidance on adding a type and the requirement that a new
  type needs a matching template.
- `fw-new.sh`: strict type gate + ID assignment via `fw-next-id.sh` + template resolution.
- `/fw-new` command doc: discovery, prefix-normalize, semantic-suggest, confirm, write,
  and commit-on-create.
- **Work-item templates for the new build** — it currently ships none (see Dependencies).
- The rejection-message education surface.

**Out of scope:**
- The type taxonomy itself (ADR-006 settled the five and the "why").
- Plugin-edition parity, `Build-Plugin.ps1` derivation, cross-channel equivalence — the
  framework **is** the plugin now; there is one copy by construction. *(This is why
  FEAT-179 and SPIKE-178 no longer gate this card.)*
- `Setup-Framework.ps1` and `/fw-help` education surfaces — both are old-tree. The new
  build has no `/fw-help` yet; when it is built, it inherits the requirement.

---

## Dependencies

- **ADR-009 D5 board crossover** — sequence with it. `fw-next-id.sh` refuses the `kanban`
  namespace until the board crosses over, and a create gate for an inactive namespace is
  speculative.
- **Work-item templates do not exist in the new build.** `templates/records/` holds only
  `contact.md`, `ops-record.md`, and `ts-case.md`. A create gate must resolve a template
  per type, so the templates are a prerequisite — and their *conventions* (fields,
  naming, numbering, cross-references) are the C6 cards held by TASK-218
  (FEAT-021, TECH-027, TECH-033, TECH-041, TECH-082). **Resolve those conventions before
  authoring the templates**, or the templates will encode guesses.

---

## Acceptance Criteria

**Gate + engine**
- [x] A type SoT ships inside `workspaces/framework/` and is the only place the accepted
      set is written down *(2026-09-10 — the `TYPES:` line in
      `templates/records/work-item.md`, inside `TYPES-SOT-BEGIN`/`END` markers)*
- [x] `fw-new.sh` reads it and **rejects** any non-accepted type, case-insensitively,
      exiting non-zero *(verified: 7 rejection cases, all exit 1)*
- [x] The script contains **no alias or fuzzy logic** — normalization is AI-layer only
      *(verified: the script rejects `FEATURE`, which the AI layer would normalize)*
- [x] Legacy prefixes are recognized by scanning but never offered for creation
      *(`fw-next-id.sh` counts any `[A-Za-z]+-[0-9]+`; creation reads only the SoT)*
- [x] ID assignment calls `fw-next-id.sh` rather than reimplementing the scan
- [x] Created item lands in the correct namespace folder with the correct filename shape
      *(`kanban/backlog/TYPE-nnn-slug.md`; dotted children inherit the parent's folder)*
- [-] New item is committed once fully drafted (prompt-first, default-yes) — *specified at
      step 6 of the command doc, which is what this criterion asks for. Marked `[-]`
      rather than `[x]`: it is an AI-layer behaviour with no script surface, so it cannot
      be verified the way the criteria above were. Not applicable to script verification,
      not outstanding work.*

**Education**
- [x] Rejection names the accepted set, notes legacy-recognized-not-creatable, and gives a
      semantic suggestion where one applies
- [x] Rejection on `story` explains hierarchical sub-items rather than merely rejecting
- [x] The SoT header explains how to add a type and that a new type needs a template
- [x] Plugin CHANGELOG updated

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

- [x] **Gate design settled** — 2026-07-09: strict-script/lenient-AI, prefix-normalization
      validated against 74 real-world type strings, rejection-as-education, scoped-ID
      hazard documented.
- [x] **Re-scoped for the ADR-009 build** — 2026-09-02 (TASK-218 Section E). Plugin-parity
      scope dropped (one copy by construction); target moves to the kanban namespace.
- [x] **PRE-IMPLEMENTATION REVIEW** — 2026-09-10. **Both blockers had already cleared, and
      one design assumption was wrong:**
      - *Templates:* TASK-219 Group 1 landed `templates/records/work-item.md` and the
        kanban queue scaffold (2026-09-09). The five C6 conventions that blocked the
        template are settled; the other fourteen were split to TASK-223 and never blocked
        this card.
      - *D5 sequencing:* this card said "land **with** the crossover." Superseded by
        `049e071` the same morning — `.gitignore` makes `/kanban/` scratch in this repo,
        so the command runs here for development without touching the live board. **No
        repo-specific guard belongs in shipped code**; the ignore rule carries it.
      - *Where the SoT lives:* the plan assumed a `work-item-types.txt` beside the script.
        Rejected — `standards/` is staging that never ships (new build's `CLAUDE.md`), and
        a standalone data file lets someone add a type without touching a template. **The
        template is authoritative instead**, which makes "a new type needs a template"
        structural rather than remembered.
- [x] Author the type SoT inside the plugin — the marked `TYPES:` block in `work-item.md`
- [x] Author work-item templates for the accepted set — *already existed (TASK-219); one
      template serves all five via the `Type:` field, so there is one file to be
      authoritative*
- [x] Build `fw-new.sh` (gate + `fw-next-id.sh` call + template resolution)
- [x] Write the `/fw-new` command doc (AI layer)
- [x] Rejection-message education
- [x] Verify against a **generated** repo, not this source tree (ADR-008) — *ran from an
      installed-plugin layout (`scripts/` + `templates/` only, no source tree in reach)
      into a fresh `git init` repo. 22-case regression: create for all five types, shared
      sequence across types, lowercase normalization, 7 rejection paths, dotted children,
      children not burning ids, bad parent, path traversal, no-args, and the created card
      carrying neither the markers nor a copy of the list.*
- [x] Plugin CHANGELOG

---

## Documentation

| Surface | What it must say | Audience |
|---|---|---|
| `/fw-new` rejection | why this type isn't accepted; what to use instead | user who guessed wrong |
| Type SoT header | how to add or edit a type safely | whoever edits the SoT |
| `/fw-new` command doc | syntax; the accepted types | any user |
| Plugin CHANGELOG | the board create gate exists | upgraders |

**Deliberately not documented:** the semantic alias mapping. It lives in AI judgment
informed by the SoT and the "why five" rationale; writing it down creates the second copy
of the type vocabulary.

---

## Related

- **ADR-006** — **D6** (deterministic enforcement at the create gate) and **D7**
  (`/fw-new` named as future work). This card implements D6 for the new build.
- **ADR-009 D5** — the board crossover this card sequences with.
- **`fw-next-id.sh`** — the one home for next-ID logic; this card consumes it.
- **`fw-move.sh`** — the sibling gate. Same posture: hard block in the script, interactive
  recovery in the command. Also already handles child items, which the create side must
  match.
- **TASK-218 C6** — the board-convention cards (FEAT-021, TECH-027, TECH-033, TECH-041,
  TECH-082) that must be resolved before the templates can be authored.
- **SPIKE-178 / FEAT-179 / TECH-169** — the old three-channel parity work. **No longer
  gates this card**: the framework is the plugin, so there is one copy by construction.
- **TASK-218** — the disposition that re-scoped this card instead of archiving it.
- **TASK-224** — the graduation transition register, created from this card's leftovers:
  ADR-006 D4/D5 naming a superseded SoT location, the dead
  `.claude/scripts/work-item-types.txt`, and the unported kanban move gates.

---

## Implementation Notes (2026-09-10)

**The SoT went into the template, not a data file.** The card assumed a
`work-item-types.txt`. Two things ruled it out: `standards/` is staging that never ships,
and — the substantive reason — a standalone list lets someone add a type and walk away,
which is the drift the SoT exists to stop. Putting the list in the template makes the
acceptance criterion *"a new type needs a matching template"* structural. This only works
because TASK-219 chose **one** template serving all five types via a `Type:` field; five
templates would have had no single authoritative home.

**The block is stripped from created cards.** The header comment otherwise travels with
the card (matching `ops-record.md`, deliberately — guidance belongs where the author is),
but the `TYPES:` line is *parsed data*, and copying it onto every card would make each one
a stale copy. `fw-new.sh` replaces the marked block with a pointer.

**Delimiters, not line counts.** The first cut stripped a fixed number of lines and left an
orphaned prose fragment in the output — caught in testing. `TYPES-SOT-BEGIN`/`END` make the
boundary data, so the prose inside can be reworded freely.

**Malformed input fails loudly.** Missing/duplicated markers, a missing `TYPES:` line, or a
non-alphabetic entry each abort with a message naming the fix. A gate that silently
degrades to "accept anything" would be worse than no gate.

**The move side is adjacent work, not a gate on this card.** `fw-move.sh` declares the
`kanban` folder set but its transitions and gates are not ported (its own header says so),
so moving a created card reports *"declared but not active."* **That does not gate this
card** — no acceptance criterion here concerns the move path, and ADR-006's D6 amendment
is explicit that type enforcement is *"the create path, not the move path."* The two
halves were always independent; the folder set produced here matches what the engine
declares, so the crossover stays a table edit rather than a second engine.

*Recorded because the AI twice proposed holding this card open on the move engine's
readiness — once at implementation, once at the `→ done` call. Gary: "Why is FEAT-175
gated on fw-move?" It wasn't. The work is real and is **TASK-224 row 3**, but it belongs
to the crossover, not here.*

**Type-change blast radius — verified 2026-09-10.** Adding or removing a type is a
one-line edit to the `TYPES:` line, with **no downstream migration in either codebase**:

- **`fw-move` is type-agnostic** in both builds. It locates records by *number*; its own
  comment says *"the prefix is decoration."* This confirms ADR-006's D6 amendment
  (*"the create path, not the move path"*) empirically.
- **All eleven old commands are type-agnostic.** All 52 type mentions across them are
  illustrative — sample output and `FEAT-042`-style placeholders. Decisively,
  `/fw-release` derives version bumps from the **`Version Impact:` field, not the type** —
  the one place hardcoding would be expected, and it isn't there.
- **Removing a type needs no migration.** Existing cards keep working, still count in the
  shared sequence (so no id is ever reissued), and the retired prefix becomes legacy *by
  definition* under D2's disk-derived rule — nothing to mark or migrate. Verified by
  adding then removing a sixth type against a generated repo.

**The one hand-maintained surface** is the semantic-suggestion `case` block in
`fw-new.sh` (~lines 105-135). The accepted-set line updates itself everywhere; the
*tutoring* around it does not. Adding a type means revisiting that block, or its advice
goes quietly stale — a wrong-advice failure, never a broken-gate one.

---

**Last Updated:** 2026-09-10
