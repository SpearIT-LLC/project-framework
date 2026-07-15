# Tech Debt: Retire `framework/CLAUDE.md` and `CLAUDE-QUICK-REFERENCE.md` (ADR-007 D2/D6)

**ID:** TECH-182
**Type:** Tech Debt
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-07-15
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Distribution & Onboarding
**Depends On:** BUG-181

---

## Summary

ADR-007 (Accepted 2026-07-15) decided to **retire two duplicate contract documents**: `framework/CLAUDE.md`
(501 lines, ~95% restatement, a `CLAUDE.md` Claude never auto-loads — **D2**) and
`framework/CLAUDE-QUICK-REFERENCE.md` (334 lines, claims "<200", never shipped, the fourth copy of the
contract — **D6**). This item performs the deletions and relocates the ~8 genuinely-unique lines. It is
split from **BUG-181** because the deletions carry a different, higher risk profile than the delivery fix
and must not share an acceptance gate with it.

**This item is BLOCKED on BUG-181.** The contract must be authored (`.claude/framework-contract.md`) and
composed into each channel's `CLAUDE.md` **before** the old files are safe to delete — otherwise the
salvaged rules have no home.

---

## Problem Statement

Two files, both retired by ADR-007, both still present:

- **`framework/CLAUDE.md`** (D2) — a `CLAUDE.md` that Claude never auto-loads (only the *root* `CLAUDE.md`
  is auto-loaded). It is a documentation file wearing a reserved filename, ~95% duplicate of guides that
  already own the content, and carrying **8 verified drift defects** (stale command list, nonexistent ADR
  template paths, phantom Step-9 references, a materially-false permissions section, a wrong folder tree,
  self-referential dead links, contradictory size guidance, and a false "pre-commit hook validates done/"
  claim).
- **`framework/CLAUDE-QUICK-REFERENCE.md`** (D6) — 334 lines while declaring itself *"<200"*; **does not
  ship** (the build copies `framework/docs/`, `templates/`, `tools/`, and `framework/CLAUDE.md` by name —
  this file is in none); the onboarding aid that never reached a newcomer. Its onboarding goal transfers
  to **FEAT-115 (`/fw-tour`)**, which stays in `backlog/` and is not part of this item.

**Desired state:** both files deleted; their ~8 unique lines salvaged into the contract fragment (via
BUG-181) or the correct owning guide; every reference to either file repointed or removed.

---

## Scope

**In scope:**
- Salvage the genuinely-unique content, then delete both files.
- Repoint/remove every reference to either file across the repo.
- The **Claude Code Permissions** section (currently false) → rewrite into
  `docs/collaboration/security-policy.md` or a `docs/ref/` page (D2 table).

**Out of scope:**
- `framework.yaml:76` repoint + phantom `workflow-guide.md` Step 7.5/9 pointers → **TECH-183** (separable,
  mechanical). *Exception:* if `framework.yaml:76` still points at `framework/CLAUDE.md` at deletion time,
  it MUST be repointed here or the deletion breaks `/fw-topic-index` — coordinate with TECH-183.
- Authoring the contract fragment / composer / drift-guard → **BUG-181**.
- `/fw-tour` — **FEAT-115**.

---

## ⚠️ The re-verify caution (ADR-007, carried verbatim — read before any `rm`)

> The audit behind ADR-007's "everything else is deleteable" claim was a **single pass** across ~2,000
> lines of comparison. It is reliable about the *shape* (overwhelmingly duplicate) but **"safely
> deleteable" is a summary judgment.** Before deleting any section, **re-verify that its content actually
> exists in the file that supposedly owns it** — section by section, against the real file, at deletion
> time. The line counts are not a licence to `rm`. A single unique rule that exists only here, deleted, is
> not noticed until the behavior it prevented happens.

**The ~8 unique lines to salvage before deletion** (per ADR-007 D2 table — re-verify each is truly
unique at implementation time):
- **"Resume work" rule** — *"ALWAYS read `work/doing/` … NEVER suggest next actions without verifying
  current work state"* → into the contract fragment (BUG-181). Genuinely load-bearing.
- **Claude Code Permissions** → rewritten (it is currently false) into a `docs/` page.
- The checkpoint Rule 1 (D7) → already going to the contract via BUG-181; confirm not double-counted.

---

## Straggler Inventory (references to repoint/remove — VERIFY AT IMPLEMENTATION TIME)

Line numbers will drift; locate by content. Known references from ADR-007's blast radius:

- [ ] `framework.yaml:76` — `ai-checkpoint-policy: framework/CLAUDE.md#…` (→ ADR-001; see TECH-183 / coordinate)
- [ ] `QUICK-START.md` (root) — "Full Reference" previously → `framework/CLAUDE.md` (already repointed to
      `framework-commands.md` 2026-07-14; **re-verify** it does not point at a deleted file)
- [ ] `docs/collaboration/README.md`, `architecture-guide.md`, `workflow-guide.md` — reference
      `CLAUDE.md`'s structure (including the nonexistent Step 9); fix, do not orphan
- [ ] `Build-FrameworkArchive.ps1` **Step 5.5** — copies `framework/CLAUDE.md` by name and **hard-errors if
      missing**. Deleting the file without removing this step breaks the build. Remove Step 5.5.
- [ ] Re-run a repo-wide grep for `framework/CLAUDE.md` and `CLAUDE-QUICK-REFERENCE` to prove zero
      dangling references remain

---

## Acceptance Criteria

- [ ] BUG-181 is complete (contract authored + composed) — this item's precondition
- [ ] The ~8 unique lines are salvaged to their correct homes, each **re-verified unique** at deletion time
- [ ] Claude Code Permissions section rewritten (correctly) into a `docs/` page, not lost
- [ ] `framework/CLAUDE.md` deleted (via `git rm`)
- [ ] `framework/CLAUDE-QUICK-REFERENCE.md` deleted (via `git rm`)
- [ ] `Build-FrameworkArchive.ps1` Step 5.5 removed; build succeeds
- [ ] Zero dangling references to either file (grep clean)
- [ ] `framework/CHANGELOG.md` updated

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

- [ ] **BLOCKED — BUG-181 must complete first.** Do not delete until the contract has a home.
- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED**
- [ ] Section-by-section re-verify `framework/CLAUDE.md` content against owning guides (the caution above)
- [ ] Salvage the ~8 unique lines; rewrite the Permissions section into a `docs/` page
- [ ] `git rm framework/CLAUDE.md` and `git rm framework/CLAUDE-QUICK-REFERENCE.md`
- [ ] Remove `Build-FrameworkArchive.ps1` Step 5.5; run the build; confirm success
- [ ] Repoint/remove all stragglers; grep clean
- [ ] CHANGELOG.md updated

---

## Documentation

<!-- Dogfooding FEAT-180 (mandatory documentation section). -->

| Surface | What it must say | Audience |
|---|---|---|
| `framework/CHANGELOG.md` | the two contract docs are retired; contract now derives from `.claude/framework-contract.md` | upgraders |
| `docs/` permissions page | the (corrected) Claude Code permissions posture | AI + human |

---

## Related

- **ADR-007** (Accepted 2026-07-15) — **D2** (retire `framework/CLAUDE.md`) and **D6** (retire
  `CLAUDE-QUICK-REFERENCE.md`) own this item's decision. Carries the re-verify caution.
- **BUG-181** — the delivery fix and this item's **hard dependency**. Authors the contract fragment the
  salvaged rules move into.
- **TECH-183** — `framework.yaml:76` repoint + phantom pointer fixes. Coordinate on `framework.yaml:76` if
  it is still live at deletion time.
- **FEAT-115** (`/fw-tour`) — inherits D6's onboarding goal. Not part of this item.
- **FEAT-180** — mandatory `## Documentation` section. Dogfooded above.

---

## Notes

**Also observed while auditing** (ADR-007 / BUG-181, low severity — fix if touched during deletion):
- `framework/CLAUDE.md:417` — Emergency Reference still uses `cp templates/FEATURE-TEMPLATE.md …`: the
  pre-**TECH-176** template name, and `cp` where the framework mandates `git mv`. Moot once the file is
  deleted, but noted so it is not mistaken for salvageable content.

---

**Last Updated:** 2026-07-15
