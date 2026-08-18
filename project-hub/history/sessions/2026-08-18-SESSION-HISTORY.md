# Session History: 2026-08-18

**Date:** 2026-08-18
**Participants:** Gary Elliott, Claude Code
**Session Focus:** Future shape of the Framework — workspace model, delivery model, and ADR-009

---

## Summary

Reviewed Gary's Lucid mind-graph of the proposed folder structure and worked it, over a
long back-and-forth, into **ADR-009: The Workspace Model, and Building It Fresh In-Place**
(Proposed, supersedes ADR-005). The session settled the container name (`workspace`), the
delivery model (only `.claude/` ships; commands generate structure), the build strategy
(fresh build inside `workspaces/framework-next/` in this repo — no reorg, no fresh repo),
and closed all six open questions raised along the way, including standards-as-skills.
Current Anthropic best-practices guidance was verified against the live docs and recorded
in the ADR.

---

## The Journey (how we got to ADR-009)

The path mattered as much as the destination — several positions taken early in the
session were reversed by evidence before the ADR was drafted:

1. **Mind-graph review.** Initial read: top half (kanban/, history/, .claude/) a clear
   win; `workspaces/` flagged as the load-bearing change. AI initially asked whether
   multi-stream was a proven need — **withdrawn** after Gary pointed to the session
   record: ADR-005, FEAT-163/164/165, Honda and Boston Dynamics are the proven need.
2. **Impact mapping.** Verified blast radius: mechanisms are narrow (one `WORK_DIR`
   constant in `fw-move.sh:54`, one schema enum, one roles entry); the volume is in
   output-writing commands (`/fw-swarm` alone: 56 hardcoded `project-hub/*` paths) and
   docs.
3. **Fresh repo?** Gary proposed treating this repo as a prototype and starting clean.
   Pushed back on ADR-008 grounds (Option A already rejected; discovery lives in this
   repo's artifacts). Recommended consolidate-then-migrate — **later revised**, see 6.
4. **Delivery model insight (Gary).** "Only the `.claude` content ships; commands build
   the structure." Verified against `Build-FrameworkArchive.ps1` (which already hand-curates
   a `.claude/` allow-list) — upgrade collisions disappear because upgrades replace
   behavior only. Correction recorded: upgrade doesn't vanish, it relocates to the
   plugin, which already has a mechanism.
5. **Does `framework/` survive?** Sorted its contents: structure docs die (commands
   become the SoT), `framework/tools/` is behavior mislocated (belongs with scripts),
   templates consolidate into the plugin, and ~4,000 lines of genuine standalone
   standards (security, testing, code-quality, troubleshooting, architecture) survive
   and need a home.
6. **The pivot (Gary): build fresh in a workspace of this repo.** Resolves the
   fresh-vs-reorg dilemma both ways: clean-slate authoring AND connected history, zero
   churn, and the old-vs-new instruction conflict becomes a *positional* boundary
   instead of an advisory rule. This became ADR-009 Option C.
7. **Field evidence inspected** (both live client structures):
   - `HPC/HPCJobQueuePrototype` — the chameleon: job-queue product at root,
     `customers/honda/*` grown by accretion, `hpc-2019-upgrade/` nested inside.
   - `Clients Current/Boston Dynamics` — not a git repo; `Jobs/BD-SOW-001..003`;
     binary/business content (signed PDFs, .docx, .rdp, recovery key);
     `src.orig - Copy` as the no-version-control tell.
   These two stress the model in opposite directions (depth vs. floor) and became the
   ADR's named test cases. `Jobs/` was considered as the container name on BD's
   evidence; Gary kept `workspaces/` because Jobs fits only the SOW-shaped case.
8. **ADR-009 drafted**, then extended in review (D5, settlements below).

---

## Decisions Made (recorded in ADR-009, status: Proposed)

1. **D1 — the term is `workspace`**, replacing stream/engagement/jobs and all
   2026-07-16 alternates. A workspace = bounded body of work, user-chosen granularity.
2. **D2 — everything is a workspace; root owns only the spine** (`.claude/`, `kanban/`,
   `history/`, `framework.yaml`, `CLAUDE.md`). Nesting is flat: `hpc-2019-upgrade`
   becomes a peer workspace; parent/customer relationships ride on work items.
3. **D3 — authored vs. generated: only `.claude/` ships.** `kanban/`, `history/`,
   `workspaces/` are command-generated (`/fw-init`, `/fw-new-workspace`); this repo
   generates its own as proof (converts the never-executed `Setup-Framework.ps1` path
   into a continuously exercised one — the BUG-170 class, fixed structurally).
4. **D4 — git is required at the repo root; the floor is "no source tree required."**
   No non-git mode; BD becomes a git repo at migration. Binary artifacts commit as
   opaque blobs; their "history" is work items + session history, not diffs.
5. **D5 — the old board stays authoritative until graduation.** `project-hub/work/`
   remains the single board (one ID namespace, one WIP limit) for ALL work including
   framework-next; generated `kanban/` is a throwaway test fixture. Crossover is one
   atomic `git mv` in the graduation commit. Rejected: day-one migration; parallel boards.
6. **Sequencing: BD first, Honda second, Toyota third** — BD is the harder floor test
   and can't be cheated by hand-editing. ADR-008's "coupling first" re-interpreted, not
   overridden: a fresh build inherits no coupling; TECH-185–188 re-scoped (187 feeds the
   docs audit; 188 becomes a graduation criterion).

### Open-question settlements (afternoon, Gary's review)

- **OQ1 (docs home) — settled in two rounds.** First round: Gary proposed `standards/`
  (repo-wide standards). Then, on his prompt "how does this fit Anthropic best
  practices?", verified against current official docs — answer revised to
  **standards-as-skills** (`.claude/skills/<name>/`, progressive disclosure, the skill
  IS the human-readable standard). Final (Gary): skills are the end state; interim
  `standards/` folder lives **inside `workspaces/framework-next/`**, not repo base,
  under a **one-home-at-all-times move rule** (git mv in, move-on-convert, delete when
  drained, never ships). Dissolves D3's third category.
- **OQ2 — `Workspace:` is a distinct work-item field**, orthogonal to `Theme:` (multiple
  applications can serve one theme). FEAT-163 unblocked.
- **OQ3 — closed by D4** (git required).
- **OQ4 — BD hygiene direction:** customer repos private; installers/secrets ignored
  from day one; `/fw-init` generates the seed `.gitignore`.
- **OQ5 — workspace types: yes** — application, knowledgebase, sow, operations —
  differing ONLY in initial scaffolding, never runtime branching. Library/toolkit fold
  into application; PARA note (sow/application end → `deliverables/`; kb/operations
  ongoing → intake/reference).
- **OQ6 — numbered kanban folders rejected** (ordering belongs in the transition matrix).

### Anthropic alignment (verified against live docs, recorded in ADR)

Confirmed: hooks-over-prose is now the platform's own framing ("CLAUDE.md instructions
are advisory; hooks are deterministic"); plugins as distribution unit; short CLAUDE.md;
verify-with-a-check; scripts for deterministic work. Revised by the past year: skills'
progressive disclosure natively does what the AI Reading Protocol and `sources:`
index-and-load did by hand; `disable-model-invocation` fits `/fw-move`//fw-release`;
Stop hooks are a platform-native home for done-gates/drift guard.

---

## Files Created

- `project-hub/research/adr/009-workspace-model-and-fresh-build-in-place.md` — the ADR
  (Proposed; all open questions settled; ready for Gary's full read-through → Accepted)
- `project-hub/history/sessions/2026-08-18-SESSION-HISTORY.md` — this file

## Files Referenced (inputs, not modified)

- `project-hub/retrospectives/FrameworkPlanning-FolderStructure-Proposed.png` — Gary's
  mind-graph (added to repo this session, untracked at session end)
- ADR-005/006/007/008, the onion retrospective, 2026-07-16 Gary's-thoughts doc
- External: `HPC/HPCJobQueuePrototype`, `Clients Current/Boston Dynamics` (inspected)

---

## Current State

### In doing/
- (none — this was a planning/decision session; no work items moved)

### Next steps
1. Gary's full read-through of ADR-009 → flip to Accepted, commit (ADR + mind-graph PNG
   remain uncommitted pending that review).
2. Rewrite FEAT-163/164 in `workspace` vocabulary; create the framework-next kickoff
   work item(s).
3. Stand up `workspaces/framework-next/` and begin with the BD-shaped floor.

---

## ADR-009 Review and Approval (Later — Continuation)

**Continuation:** Resumed after the morning session history was committed; Gary called
the review to approve.

### Consistency pass (pre-approval fixes)

A full read of the much-edited draft found three defects, fixed before review:
- **D4's heading still said "non-git workspace"** — contradicting its own body, which
  had settled git-required earlier in the day. Now "document-only workspace (no source
  tree required)."
- `workspaces/` was missing from D2's root-spine list.
- The graduation step glossed where `research/` and the ADRs land (the mind-graph's
  "items needing a home" sticky) — now named explicitly, with the constraint that ADRs
  must remain live session-start context (Decision Driver 2).

### Retrospectives question (Gary)

*Keep retros focused on one workspace? What about evaluating the entire customer
account?* Answered with the model's own rule and added to D2: **one timeline at the
spine (`history/retrospectives/`), scope declared in the document** via a `Workspace:`
field — one workspace, several, or account-wide. An account-level evaluation is a retro
whose scope is "all," possible precisely because the timeline is never split into
per-workspace folders. This also closes the 07-16 doc's open question ("retrospectives:
project wide or stream focused?") — both, by declaration.

### Approval

Two soft spots were surfaced explicitly and accepted with the approval:
1. **The ADR-008 reinterpretation** — "coupling first" satisfied by inheriting no
   coupling (fresh build) rather than consolidating this repo first. Approving ratifies
   that reading.
2. **OQ4 remains directional** — BD hygiene detail deferred to its migration work item.

**ADR-009 → Accepted** (`77a5ab6`), committed with the mind-graph PNG. Per the
immutable-ADR supersede discipline (onion retrospective), **ADR-005's status flipped to
"Superseded by ADR-009"** — the one edit permitted on a prior ADR.

### State at session end

- Committed: session history (`e20566a`), ADR-009 + ADR-005 stamp + mind-graph PNG
  (`77a5ab6`).
- Untouched working-tree changes (pre-existing, not this session's scope):
  `.claude/settings.local.json`, `project-hub/retrospectives/2026-07-16-garys-thoughts.md`,
  `research/claude-code-workflows-consulting-guide.md`.
- Next: rewrite FEAT-163/164 in `workspace` vocabulary; create framework-next kickoff
  work item(s); stand up `workspaces/framework-next/` starting from the BD-shaped floor.

---

## Execution: Board Prep, Naming, and the Kickoff Build (Evening — Continuation)

**Continuation:** "Let's do it" — moved from decisions to execution.

### Workflow-loop question (Gary)

Would Claude Code dynamic workflows help here (per
`research/claude-code-workflows-consulting-guide.md`)? Answer: **not for FEAT-190**
(sequential, small — orchestration overhead), **yes for the TECH-187 standards
conversion** — per-doc classify → draft skill → verify-against-source is exactly the
guide's #1-ranked documentation shape, and doubles as the guide's planned first dry
run. Boundary stated: agents for judgment passes; deterministic sweeps stay scripts
(TECH-189 class).

### Board prep (planning, then the gate)

- FEAT-163/164 rewritten in `workspace` vocabulary and renamed (`git mv`):
  163 → workspace-reporting-and-history (field decision recorded as settled);
  164 → workspace-scaffolding (inverted per D3: *implement* `/fw-new-workspace`,
  don't document a layout). FEAT-190 kickoff created (next ID verified = 190).
- `/fw-move 190 todo` → `doing` — the doing/ WIP warning said 3/2, actual is 2/2
  (**BUG-174 dotfile-count bug observed live**: `.gitkeep` counted).
- **BUG-181 verified against the files** (Gary: "I think it's done"): **half done.**
  Authored half real — `.claude/framework-contract.md` (2026-07-22), region markers
  in both shells, root CLAUDE.md in ≤150-line contract form. Mechanism half never
  built — no composer, no starter drift-guard, no `Check-ContractDrift.ps1`. The
  item's own Root-2 lesson repeating: prose landed, mechanism didn't.

### Decisions (recorded in ADR-009 change log, commit `d78b8fb`)

1. **Naming:** workspace is `workspaces/framework/` (not `framework-next` —
   "relative names rot," Gary); dev plugin is **`spearit-framework-dev`** (channel
   label per the existing `-dev` version convention; publishes as
   `spearit-framework` at graduation). `jobs/` had earlier been considered and
   dropped (fits BD, not Honda).
2. **The framework IS the plugin** (Gary's sharpening question, added to D3): the
   archive channel retires at graduation — no zip, no starter template (`/fw-init`
   is the starter); Claude Code becomes a hard dependency (accepted deliberately).
3. **BUG-181 re-scoped, not finished:** the missing mechanisms target the old
   pipeline scheduled for deletion; the composer becomes `/fw-init`. Verified-done
   boxes checked, superseded items struck with reasons, new done-gate added
   (`/fw-init` delivers the contract to a derived project). Moved back to todo/.

### FEAT-190 implemented (commit `2d8c7d8`)

- `workspaces/framework/` skeleton: boundary CLAUDE.md (28 lines), README,
  `standards/` staging (empty), plugin manifest `spearit-framework-dev` 0.1.0-dev1,
  empty `commands/`/`skills/`/`scripts/`.
- **Scope adaptation (recorded in the item):** old `Publish-ToLocalMarketplace.ps1`
  scans only `plugins/` and wipes its marketplace per run — modifying it would
  violate the no-old-layout-changes AC. The workspace got its own
  `tools/Publish-DevMarketplace.ps1` → separate **`fw-dev-marketplace`**. Publisher
  ran clean: junction resolves, manifest valid.
- Root CLAUDE.md: one pointer line, PROJECT INSTRUCTIONS region only.
- 4 of 5 ACs verified and checked. **Open AC:** install proof — Gary runs (in his
  Claude terminal, his usual surface):
  `/plugin marketplace add <Projects>/fw-dev-marketplace`, then
  `/plugin install spearit-framework-dev@fw-dev-marketplace`, then restart.

### State at day end

- In doing/: **FEAT-190** (one AC open — install proof).
- In todo/: BUG-181 (re-scoped), FEAT-163, FEAT-164 (workspace vocabulary).
- Commits this session: `e20566a`, `77a5ab6`, `35f8a82`, `d78b8fb`, `2d8c7d8`.
- **Next session:** verify `spearit-framework-dev` installed after restart → close
  FEAT-190 → begin FEAT-164 (`/fw-new-workspace`) inside the workspace, BD floor
  first.

---

## Install Proof, Marketplace Consolidation, and FEAT-190 Done (Night — Continuation)

**Continuation:** Gary ran the install steps; verification and two same-day course
corrections followed before the close.

### Install proof (the open AC)

Verified, not assumed: `spearit-framework-dev` v0.1.0-dev1 present in
`installed_plugins.json` (user scope) and cached with the full skeleton. AC checked —
then two redirects from Gary reshaped *how* it ships before the item closed:

### Redirect 1 (Gary): one marketplace, not two

"We should have created our local marketplace next to the other plugins" — i.e. in the
existing `claude-local-marketplace/` (= `dev-marketplace`), not a separate sibling
`fw-dev-marketplace`. The separate marketplace had been created solely to honor the
no-old-layout-changes AC (the old publisher wipes its marketplace each run); Gary
overrode that trade explicitly. Resolution — **one marketplace, one writer**:
- `tools/Publish-ToLocalMarketplace.ps1` now also scans `workspaces/framework`
  (the one old-structure change, at Gary's direction; FEAT-190 scope note updated).
- Workspace `Publish-DevMarketplace.ps1` deleted; `fw-dev-marketplace/` folder, its
  cache, and its `installed_plugins.json`/`known_marketplaces.json` entries removed.
- Rejected alternative: both scripts writing one manifest (two writers = drift; the
  old script's wipe-and-rebuild would silently drop the workspace entry).
- Docs synced: `plugins/TESTING.md`, workspace README. `plugins/README.md` checked,
  still accurate, left alone.

### Redirect 2 (Gary): version convention — the one-time shot

With nothing yet installed from the consolidated marketplace, the last cheap moment to
drop `-dev<n>`. Decision: **plain semver for the new plugin** — the `0.x` series IS the
dev series; the `-dev` in the plugin *name* carries the channel, so the version needs no
suffix. `0.1.0-dev1` → **`0.1.0`**, republished. Old plugins keep `-dev<n>` (already
released under it; not backported). Recorded in workspace README, FEAT-190 notes, and
project memory.

### Close

- Republished; manifest verified: `spearit-framework`
  1.0.1, `spearit-framework-light` 1.0.5, `spearit-framework-dev` 0.1.0, junctions
  resolving. Gary reloaded his Claude terminal; install re-verified at 0.1.0.
- Old plugins not reinstalled after the wipe — fine: the root `.claude/commands/`
  copies still provide `/fw-*` locally (Gary confirmed).
- **FEAT-190 → done/** (all 5 ACs verified; `/fw-move 190 done`, script clean, done/
  at 8 items — under release threshold). doing/ is now empty.

### State at close

- In done/: FEAT-190 joins 7 others (8 total).
- In todo/: BUG-181 (re-scoped), FEAT-163, FEAT-164.
- Still untouched, pre-existing: `.claude/settings.local.json`, 07-16 retrospective
  edits, `research/claude-code-workflows-consulting-guide.md` (untracked).
- **Next session:** begin FEAT-164 (`/fw-new-workspace`) inside the workspace, BD
  floor first.

---

## Plugin Enablement Scope Fix (Late Night — Continuation)

**Continuation:** After the FEAT-190 commit, Gary spotted that
`.claude/settings.local.json` listed only two plugins under `enabledPlugins` —
shouldn't there be three?

**Diagnosis:** Correct instinct. The dev plugin had been installed at *user* scope
(the default when `--scope local` is omitted), so its enablement landed in
`~/.claude/settings.json` instead of the project file. That user file also still
carried consolidation debris: a dead `spearit-framework-dev@fw-dev-marketplace`
enablement and an `extraKnownMarketplaces` block pointing at the deleted
`fw-dev-marketplace` folder.

**Fix (three places), aligning with the `--scope local` convention in
`plugins/TESTING.md`:**
- `.claude/settings.local.json` — `spearit-framework-dev@dev-marketplace` added;
  all three plugins now project-enabled.
- `~/.claude/settings.json` — both `spearit-framework-dev` enablements and the
  stale `fw-dev-marketplace` marketplace entry removed; only `code-simplifier`
  remains at user level.
- `installed_plugins.json` — the dev plugin's install record converted from user
  scope to local scope with this project's path, matching its siblings' shape.

**Lesson for future installs:** always pass `--scope local` for project plugins —
the user-scope default scatters enablement into `~/.claude/settings.json`, where
the project file can't show it.

---

## FEAT-164: `/fw-new-workspace` Implemented (Late Night — Continuation)

**Continuation:** `/fw-move 164 doing` — the first real command built inside the
framework workspace. (WIP warning again showed 2/2 for 1 actual item — BUG-174's
dotfile count, second live sighting today.)

### Pre-implementation review → a model correction (Gary)

The review surfaced the plan (bash script as the single home for structure, AI
only for README purpose, scratch-root verification) — and drew a correction that
reshaped the item: **"BD is not the right foundation for the workspace. The repo
is the customer; workspaces are its parts."** A customer repo composes:
`<application-name>/`, `knowledgebase/` (singleton), `operations/` (singleton),
`<sow-id>/` (e.g. `BD-SOW-001`). The "BD floor test" therefore means a repo of
sow + kb workspaces with no source tree anywhere — not one document-only
mega-workspace. Recorded in the item's Notes; the floor AC reworded to the `sow`
type. Naming falls out: applications/sows carry user names; kb/operations
default their name to the type (command allows one-arg form for those two).

### Implementation (commit `e97ce97`, plugin 0.2.0)

- `workspaces/framework/scripts/fw-new-workspace.sh` — THE one home for the
  structure (header says so): common floor `meetings reference deliverables
  contacts agreements` for every type; `application` adds poc/src/tests/dist;
  `knowledgebase` domain/cookbook/faq; `sow` requirements/reports; `operations`
  intake/requests + intake/incidents. `--root` flag enables scratch-root testing
  without touching the repo. Guards: unknown type, name required for
  application/sow, existing workspace, path-like names.
- `workspaces/framework/commands/fw-new-workspace.md` — runs the script, then
  the one judgment step (ask purpose, fill README's `_PURPOSE_PENDING_`);
  deliberately does NOT restate the folder tree (AC 4, TECH-189 pattern).
- Scratch verification passed: all four types, BD-SOW-001 document-only, all
  four error cases. Republished; manifest at 0.2.0.
- Stale cross-ref noted in review, no action: the item said `/fw-init` was
  "scoped under FEAT-190," but 190 closed kickoff-only; BUG-181's re-scope owns
  `/fw-init` as the composer.

### State: FEAT-164 in doing/, 2 of 5 ACs checked

Remaining three ACs await **built-plugin proof** (the workspace's own
verify-against-the-built-artifact rule): Gary updates dev-marketplace, restarts
(first live test of the settings.local.json auto-reinstall of all three
plugins), then runs `/fw-new-workspace` from the installed plugin.

---

**Last Updated:** 2026-08-18
