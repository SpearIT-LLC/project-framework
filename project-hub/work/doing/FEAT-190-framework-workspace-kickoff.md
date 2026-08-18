# Feature: Framework Workspace Kickoff — Stand Up `workspaces/framework/`

**ID:** FEAT-190
**Type:** Feature
**Priority:** High
**Version Impact:** MAJOR
**Created:** 2026-08-18
**Theme:** Workflow
**Workspace:** framework
**Planning Period:** [Optional]

---

## Summary

Create the `workspaces/framework/` workspace in this repo and its minimal skeleton,
per ADR-009 Option C: the clean-slate home where the new framework is authored, with
a positional authority boundary so old and new instructions never conflict. Per
ADR-009 D3, **the framework IS the plugin** — this workspace is the plugin's source
tree. This item is the *kickoff only* — the smallest structure that lets work begin;
the commands themselves are FEAT-163/164 and successors.

## Motivation

ADR-009 (Accepted 2026-08-18) chose building fresh inside a workspace of this repo:
clean-slate authoring with connected history, zero migration churn, and the
old-vs-new instruction conflict reduced to a path boundary. Nothing can start until
the workspace and its boundary exist.

## Scope

**In:**
- `workspaces/framework/` folder with:
  - `CLAUDE.md` — the **authority boundary**: inside this directory, this file and
    this directory are the sole authority; the old framework's docs and structure
    are explicitly out of scope here. Kept short per current Anthropic guidance.
  - `README.md` — name, type (`application`), purpose, pointer to ADR-009.
  - `standards/` — empty staging folder for the TECH-187-audited docs
    (one-home-at-all-times move rule, ADR-009 OQ1; drains as skills are built).
  - Plugin skeleton: `.claude-plugin/plugin.json` named **`spearit-framework-dev`**
    (dev-channel name per the existing `-dev` version convention; publishes as
    `spearit-framework` at graduation), plus empty `commands/`, `skills/`,
    `scripts/` folders.
- Register the skeleton with the local dev marketplace
  (`tools/Publish-ToLocalMarketplace.ps1`) to prove the install path early —
  built-artifact verification from day one (TECH-188 class).
- Root `CLAUDE.md` gains **one pointer line** (no restatement): work inside
  `workspaces/framework/` follows that workspace's CLAUDE.md.

**Out (this item):**
- Any command implementation (`/fw-init`, `/fw-new-workspace` → FEAT-163/164 and
  successors).
- Moving any docs into `standards/` (gated on the TECH-187 restatement audit).
- Old-structure changes of any kind — ADR-009 D5: nothing in the old layout moves.

## Acceptance Criteria

- [x] `workspaces/framework/` exists with CLAUDE.md, README.md, `standards/`, and
      the plugin skeleton. *(2026-08-18)*
- [x] The workspace CLAUDE.md states the authority boundary in ≤30 lines. *(28
      lines, verified by `wc -l`)*
- [ ] The `spearit-framework-dev` skeleton installs from the local marketplace
      (verified, not assumed). *(Publish path verified 2026-08-18: junction
      resolves, `marketplace.json` valid. Remaining: Gary runs
      `/plugin marketplace add <parent>/fw-dev-marketplace`, installs
      `spearit-framework-dev@fw-dev-marketplace`, restarts Claude Code.)*
- [x] Root CLAUDE.md has the single pointer line (PROJECT INSTRUCTIONS region);
      nothing else in the old structure changed by this work. *(Scope note: the old
      `Publish-ToLocalMarketplace.ps1` scans only `plugins/` and wipes its
      marketplace each run, so the workspace got its own
      `tools/Publish-DevMarketplace.ps1` targeting a separate `fw-dev-marketplace`
      — keeps the old tool untouched, honoring this AC.)*
- [x] This item's `Workspace:` field and its siblings' (FEAT-163/164) demonstrate
      the field on the live board. *(2026-08-18)*

## Notes

- The old board (`project-hub/work/`) tracks this work per ADR-009 D5; the generated
  `kanban/` proof comes later with `/fw-init`, using throwaway items only.
- Naming settled 2026-08-18: workspace `framework` (relative names like "next" rot);
  plugin dev name `spearit-framework-dev` — a channel label, not a product name.

## Related

- ADR-009 (workspace model and fresh build in-place) — the governing decision
- FEAT-163 (workspace reporting), FEAT-164 (workspace scaffolding)
- BUG-181 (contract delivery — re-scoped: `/fw-init` becomes the composer; closes
  against this workspace's output)
- TECH-185/186/187/188 (consolidation pass, re-scoped by ADR-009), TECH-189 (drift
  guard — future invariant: nothing outside `.claude/` is hand-authored structure)
