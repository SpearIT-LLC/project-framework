# DOC-234: plugin-development-guide is stale for framework-dev

**Type:** DOC
**Status:** backlog
**Created:** 2026-09-12

## Problem

`framework/docs/plugin-development-guide.md` predates `spearit-framework-dev` and
misdescribes the testing loop for it. It cost a debugging session on 2026-09-12.

## Findings (verified 2026-09-12)

1. **Title/scope is wrong.** Doc is titled "SpearIT Framework Light Plugin" and was
   never updated to cover `spearit-framework-dev`.

2. **Version rule is wrong for framework-dev.** Lines 9-13 mandate `1.0.0-devN`.
   framework-dev uses plain semver `0.x` (currently 0.4.7, no `-dev` suffix).
   The plugin is correct; the doc is behind.

3. **Missing: re-publish after a version bump.** Lines 52-59 say incrementing the
   version forces a cache refresh. But `marketplace.json` snapshots the version at
   publish time (`Publish-ToLocalMarketplace.ps1:181`), so bumping `plugin.json`
   alone changes nothing the marketplace advertises. The doc never says to re-run
   the publish script after a bump. **This is the gap that caused the confusion.**

4. **Junction model under-explained.** Because plugins are published as directory
   junctions (`:175`), file edits are live — the full cycle is only needed when a
   plugin is added, renamed, or version-bumped. Routine edit loop is:
   edit `workspaces/framework/` -> `/reload-plugins`.

## Also correct (outside this doc)

- Memory `MEMORY.md` "Quick Start" shows `.\tools\Publish-ToLocalMarketplace.ps1 -Build`.
  The script takes no parameters (`param()`, line 35). `-Build` is from an older revision.

## Related

- Repo-level `.claude-plugin/marketplace.json` is a fossil, stale at 0.4.3, with no
  reader or writer (verified by grep + reading the publish script). Deletion was
  discussed and not yet actioned — one open question: whether it serves as a fallback
  if someone adds *this repo* directly as a marketplace source.
- ADR-009 (workspaces/framework is the framework-dev source tree)
- ADR-008 (Single-Source Rule — the stale duplicate is a textbook instance)
