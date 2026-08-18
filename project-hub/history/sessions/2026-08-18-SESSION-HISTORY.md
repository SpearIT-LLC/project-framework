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

**Last Updated:** 2026-08-18
