# Documentation DRY — Applying the Single-Source Rule

**Purpose:** The *mechanical how-to* for keeping documentation single-sourced. The **authority** is the
**Single-Source Rule** in the framework collaboration contract (`CLAUDE.md` → *The Single-Source Rule*,
ADR-008); this document does not restate it — it shows how to apply it.
**Last Updated:** 2026-07-22

---

## The rule this document serves

> **One authored source per concept. Everything else is derived or a pointer — never a hand-kept copy.**
> Invariants that must hold live behind a command/script chokepoint, not a paragraph.

That is the binding rule (see the contract). Everything below is *how* to comply. Note what changed in
2026-07 (ADR-008, after BUG-181): the framework no longer blesses "acceptable summary" or "quick-reference
extract" duplication. Those were the exact copies that rotted — the contract was found in five hand-synced
copies, each a "summary" that drifted. **A summary that restates its source is a copy.** DRY held only
where it was *mechanical*, not where it was a discipline the author was trusted to maintain.

---

## Where the source of truth for a topic lives

**Do not maintain a table here.** The authoritative topic → source map is `framework.yaml`'s `sources:`
block — that index is the one home for "where does X live?", and it is machine-readable and verifiable.
To find a topic's source, read `sources:`; to add one, add an entry there. A hand-kept table in this
document would be exactly the duplication the rule forbids.

A `sources:` target may be a doc, a section anchor, **or a command doc** — wherever the concept is
actually authored. Every target must resolve to a real file (verified; see the docs-audit workstream,
TECH-187).

---

## How to comply

### Reference, don't duplicate
Other documents **link to** the source; they do not copy it. Links are maintenance-free; copies rot.
Prefer a bare pointer over a summary. If context genuinely helps the reader decide whether to follow the
link, one sentence is the ceiling — never a paragraph that reproduces the source's content.

### Reference with purpose
Only link where the reader would be blocked or confused without it. Reflexive "see also" links are noise.
**Test:** would the reader need this to understand or act on what they're reading? If no, skip it.

### Derive, don't hand-maintain (the strongest form)
Where an index, roster, or rollup *can be computed from the files*, compute it — do not hand-keep a copy.
A hand-written "active projects" list is stale the moment a project closes; a derived one never is. The
framework's deterministic commands (`/fw-status`, `/fw-wip`, `/fw-topic-index`) are the mechanism: they
read the files and produce the view, so there is no second copy to drift. This is single-source **by
construction** — the preferred implementation whenever it is available.

### Chokepoint, not paragraph
If something *must* hold, it belongs behind a command/script that enforces it — not in prose the AI is
trusted to obey. An instruction the AI merely reads is not a guardrail (contract; ADR-008).

---

## When topics genuinely overlap

Two documents may legitimately cover adjacent ground from different angles.

1. Each covers only its specific angle; neither tries to be comprehensive about the other's domain.
2. Each links to the other for the related perspective.
3. Neither copies the other's content.

*Example:* `code-quality-standards.md` owns error-handling patterns; `security-policy.md` owns
security-specific error handling; each links to the other.

---

## Update process

1. **Find the source of truth** — via `framework.yaml`'s `sources:` block.
2. **Change the source only.** Never edit a copy or a summary into currency; if a summary exists and is
   now misleading, prefer replacing it with a bare pointer over expanding it.
3. **Verify references resolve** — links still valid, `sources:` targets still exist. Reference-based
   single-sourcing rots silently without a verify step; where possible this is a command/check, not a
   manual ritual.

---

## Related

- **The Single-Source Rule** — the binding authority (`CLAUDE.md`, contract region; `.claude/framework-contract.md` is its SoT). This document is subordinate to it.
- **ADR-008** — consolidate-not-rewrite; establishes DRY-by-mechanism and the chokepoint principle.
- **ADR-007** — one-authored-source + per-channel derivation for the collaboration contract (the pattern this applies).
- **TECH-185 / TECH-187** — the duplication sweep and docs-restatement audit that apply this rule across the framework.
- `framework.yaml` `sources:` — the authoritative topic → source-of-truth index.

---

*Superseded model note: before 2026-07 this document permitted "acceptable" summary/quick-reference
duplication and kept its own SoT table. Both are removed — the summary allowance is what BUG-181 showed
rots, and the table is now owned by `framework.yaml`'s `sources:` index. History in git.*
