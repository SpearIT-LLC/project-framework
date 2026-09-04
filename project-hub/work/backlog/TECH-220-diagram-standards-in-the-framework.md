# Tech Debt: Diagram standards as a framework collaboration doc (Mermaid, diagram-type conventions, verification)

**ID:** TECH-220
**Type:** Tech Debt
**Priority:** Low
**Version Impact:** MINOR
**Created:** 2026-09-04
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Developer Guidance
**Planning Period:** Opportunistic

---

## Summary

The framework has no guidance on diagrams — which format, which diagram
type answers which question, how a diagram is verified and versioned, or
how it is rendered. The Accounting project wrote that guidance for itself
under its TECH-122 (architecture diagrams) and the result is generic: only
one of its seven sections is project-specific. Promote it to
`framework/docs/collaboration/diagram-standards.md` so every downstream
project inherits it, and let the Accounting copy shrink to the
project-specific remainder.

**Source document (the draft to promote):**
`Accounting/docs/architecture/diagram-standards.md` — written 2026-09-04
from the review of the first diagram drawn under it
(`Accounting/docs/architecture/invoice-lifecycle.md`). Read the review
history in `Accounting/project-hub/work/doing/TECH-122-architecture-diagrams-in-docs.md`
(Notes, 2026-09-04) for the rulings and why each was made.

---

## Problem Statement

**What is the current state?**

- The framework's documentation standards (`workflow-guide.md#documentation-standards`)
  cover files, version fields and session history; nothing on diagrams.
- The `architecture-guide.md` describes the framework's own architecture;
  it does not tell a project how to draw its own.
- Downstream projects either draw nothing, or paste generated PNGs
  (Accounting trialled CodeViz on 2026-09-03 — accurate at one altitude,
  shallow, one misleading label, and an image that would rot), or invent
  notation as they go (Accounting's first redraw put an artifact box in a
  state diagram before Gary called it: *"keep the standard convention and
  not make things up"*).

**Why is this a problem?**

A diagram that is wrong is worse than none, because it is believed. Without
a standard, every project re-derives the same rulings — format, type per
question, how notes are kept short, one altitude per picture, verified
against code with an as-of stamp — and some get them wrong first.

**What is the desired state?**

One collaboration doc, `framework/docs/collaboration/diagram-standards.md`,
registered in `framework.yaml` `sources:` as `diagram-standards`, linked
from the collaboration README and the workflow guide's documentation
standards section. Projects reference it and add only their own
project-specific section (where their diagrams live, which of their docs
already hold diagrams).

---

## Proposed Solution

Lift the Accounting document, generalise the project-specific bits, and
place it beside the other collaboration guides.

**Sections to carry over as-is (generic):**

1. **Format** — Mermaid fenced blocks in markdown; draw.io `.drawio.svg`
   only as a layout fallback with the reason stated; never a generated PNG.
2. **Rendering** — GitHub native; VS Code ≥ 1.136 built-in
   `mermaid-markdown-features`; the marketplace *Markdown Preview Mermaid
   Support* extension is deprecated and, alongside the built-in, blanks the
   diagram after a flash (diagnosed 2026-09-04 — both renderers process
   the same block). Review rendered, not in source.
3. **Pick the diagram for the question** — the table: lifecycle →
   `stateDiagram-v2` under **UML convention** (boxes are the enum's values,
   arrows are the methods/events, `[*]` is the initial pseudo-state and the
   arrow leaving it names the creating event, artifacts are not states);
   data movement → `flowchart`; tables → `erDiagram`; parts and who talks
   to whom → C4-style context `flowchart`; where things live → `flowchart`.
   **Do not invent notation** — a different type or a second diagram, never
   a custom symbol.
4. **One altitude per diagram.**
5. **Drawn from a source, not from memory — and say which** — as-built
   diagrams draw the code (sources named in the header; "as of vX.Y.Z" +
   "Verified: date (card)"; re-verify on change and at release); planned
   diagrams draw a card, spec or decision, are labelled so, and stay
   separate from the as-built picture until redrawn from code;
   modeled-but-not-driven is called out as design, not behaviour. **Git is
   the archive**, no snapshot copies (a schema archives because it is a
   contract; a diagram is a description); findings are recorded and
   carded, never fixed silently nor drawn as if intended.
6. **Layout of a diagram file** — title and "what this shows"; header
   lines; diagrams with notes of two or three short lines and detail in a
   table below; **a table that matches the graph, one row per arrow, same
   labels**; a See-also list.

**Section to generalise:** 7, *Where diagrams live* — Accounting says
`docs/architecture/` indexed by its README, data model in `schema.md`. The
framework version says: an `architecture/` folder under the project's docs
root, one file per diagram, indexed by a README that also holds the
system-context diagram; data-model diagrams stay with the schema doc.

**Files Affected:**
- `framework/docs/collaboration/diagram-standards.md` — new
- `framework/docs/collaboration/README.md` — add to the guide list and the
  "read these when" navigation ("Drawing or reviewing a diagram →")
- `framework/docs/collaboration/workflow-guide.md` — one line under
  Documentation Standards pointing at the new doc (no restatement — ADR-008
  single-source)
- `framework.yaml` — `sources:` entry `diagram-standards`
- `CHANGELOG.md`
- Downstream, when Accounting next pulls the framework: its
  `docs/architecture/diagram-standards.md` shrinks to section 7 plus a link
  (tracked on the Accounting side, not here)

---

## Acceptance Criteria

- [ ] `diagram-standards.md` exists in `framework/docs/collaboration/` with
      the seven sections above, project-specific content removed
- [ ] Registered in `framework.yaml` `sources:` and linked from the
      collaboration README and the workflow guide (link only)
- [ ] Contains at least one worked example per diagram type in the table,
      each rendering on GitHub and in VS Code's built-in preview
- [ ] The Accounting original is referenced as the origin in the doc's
      header, and nothing in the framework copy contradicts it

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
<!-- User can say "continue to completion" to approve remaining steps at once. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED**
  - AI presents: Current vs desired state, proposed solution, scope
  - User explicitly approves before proceeding

- [ ] Code/documentation changes implemented
- [ ] Changes follow coding-standards.md (if applicable)
- [ ] Tests updated (if applicable)
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Acceptance criteria verified

---

## Notes

- Gary, 2026-09-04: *"Having a diagram-standards.md in the master framework
  is a good idea."* Raised the same day the Accounting doc was written,
  after asking for "a more visible location" than a one-line standard
  because "I can see the potential to add more direction later."
- Let the Accounting doc accumulate a few more rulings first (four more
  diagrams are scoped under its TECH-122) so the framework version is
  promoted from something exercised, not from a first draft.
- The worked examples should be small and generic (a three-state
  lifecycle, a four-node flow), not lifted from Accounting's invoice
  domain.

---

## Related

- `Accounting/docs/architecture/diagram-standards.md` — the source draft
- `Accounting/docs/architecture/invoice-lifecycle.md` — the diagram whose
  review produced the rulings
- `Accounting/project-hub/work/doing/TECH-122-architecture-diagrams-in-docs.md`
- `framework/docs/collaboration/workflow-guide.md#documentation-standards`
  — where the pointer goes
- ADR-008 — single-source rule: link from the workflow guide, do not
  restate
