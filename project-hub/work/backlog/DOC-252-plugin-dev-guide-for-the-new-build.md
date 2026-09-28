# DOC-252: Plugin Development Guide for the New Build

**ID:** DOC-252
**Type:** DOC
**Priority:** Medium
**Version Impact:** None (developer documentation; does not ship)
**Created:** 2026-09-28
**Workspace:** framework
**Depends On:**
**Completed:**

---

## Summary

The new build (`spearit-framework-dev`, source `workspaces/framework/`) has no developer guide.
The only one, `framework/docs/plugin-development-guide.md`, was written for the old light
plugin and gets the new build's development loop wrong (DOC-234). Graduation deletes
`framework/`, so fixing that file is wasted work. This card writes the guide for the new
build, in the new build's tree.

## Problem Statement

The loop is not obvious, and getting it wrong has already cost time:
- **2026-09-12:** a debugging session was lost to the stale guide (DOC-234).
- **2026-09-28:** after the v0.5.0 bump, the advice given was "`/plugin marketplace update` and
  restart". That was incomplete, because `marketplace.json` records the version at publish time.

## Content (verified facts to carry, from DOC-234's findings)

- **Versioning:** plain semver `0.x`; the `-dev` in the plugin name marks the channel. No
  `-devN` suffixes. Release tags are `framework-dev-vX.Y.Z` (`framework.yaml`).
- **Publishing is by junction:** `claude-local-marketplace/framework` → `workspaces/framework/`
  (verified 2026-09-28). File edits take effect immediately. The routine loop is: edit, then
  `/reload-plugins`.
- **Full cycle, only when a plugin is added, renamed or version-bumped:** run
  `.\tools\Publish-ToLocalMarketplace.ps1` (it takes no parameters), then
  `/plugin marketplace update dev-marketplace`, then restart. Bumping `plugin.json` alone
  changes nothing that the marketplace advertises.
- **Skill bodies are cached per session:** after editing a `SKILL.md`, restart to pick up
  the change (UAT-29).
- **Testing:** UAT runs in `framework-uat` against the installed plugin, not the source
  tree (`workspaces/framework/tests/UAT-COMMANDS.md`); fixtures come from
  `tests/seed-uat-fixtures.sh`.
- **Releasing:** `/fw-release framework-dev`. There is no status file (the version lives in
  `plugin.json`) and no build step until TECH-188 defines one.

## Open at Review

- **Where the guide lives.** It must not ship. Candidates: `workspaces/framework/README.md`
  or a dev-only doc beside `tests/`. It must be on the dev-only side of TECH-188's
  published file list.
- **What to do with DOC-234's side finding:** the repo-level `.claude-plugin/marketplace.json`
  is a fossil, stale at 0.4.3 with no reader or writer. Decide it together with TECH-188's
  marketplace-host decision.

## Acceptance Criteria

- [ ] A developer guide for `spearit-framework-dev` exists in the new build's tree, outside the published file list
- [ ] It covers the versioning, the edit loop, the full publish cycle, the skill-cache restart, UAT and release facts above
- [ ] Following it from a clean checkout reaches an installed plugin that reports the current `plugin.json` version

## Related

- **DOC-234**: the old guide's findings; stays as Legacy
- **TECH-188**: published file list and marketplace host
- **ADR-009**: `workspaces/framework/` is the plugin's source tree
