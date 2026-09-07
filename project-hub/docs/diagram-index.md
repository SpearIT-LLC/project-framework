# Diagram Index

**Last Updated:** 2026-09-07
**Purpose:** Single place to find the published source link for every diagram of the
**master framework itself**. Registered in `framework.yaml` `sources:` as `diagram-index`.

Scope: this repo's own design diagrams. It is not a standard derived projects inherit —
see TECH-220 below for that.

---

## Why this file exists

Diagrams are authored in external tools and exported into the repo as static images.
The export is what git tracks; the *published link* is the only way back to the
editable original. Without this index that link lives in someone's browser history.

**Rule:** any diagram exported into this repo gets a row here, naming both the export
path and the published source. One row per diagram document; pages within a document
are listed under it.

---

## Lucid

### FrameworkPlanning — folder structure / workspace model

**Published link:** https://lucid.app/lucidchart/414bbb9d-9e4d-4e72-ac69-13d70e1cfef2/view
**Tool:** Lucidchart
**Owner:** Gary Elliott

| Page | Export in repo | Consumed by |
|------|----------------|-------------|
| (folder structure mind-graph) | [`../retrospectives/FrameworkPlanning-FolderStructure-Proposed.png`](../retrospectives/FrameworkPlanning-FolderStructure-Proposed.png) | [ADR-009](../research/adr/009-workspace-model-and-fresh-build-in-place.md), [2026-08-18 session history](../history/sessions/2026-08-18-SESSION-HISTORY.md) |
| `fw-implement-todo` | [`../poc/fw-implement-todo/`](../poc/fw-implement-todo/) | *(in discussion 2026-09-07)* |

---

## Related

- [TECH-220 — diagram standards as a framework collaboration doc](../work/backlog/TECH-220-diagram-standards-in-the-framework.md)
  — generic drawing/verification standards (mostly Mermaid) that **derived projects**
  inherit. Different scope entirely: TECH-220 is the shipped standard, this index is the
  master framework's own diagram sources.
- [external-references/README.md](../external-references/README.md) — why these links are
  not stored there (that folder is for authoritative third-party sources that pass the
  deletion test; an authored working diagram does not).
