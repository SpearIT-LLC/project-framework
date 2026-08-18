# ADR-009: The Workspace Model, and Building It Fresh In-Place

**Status:** Accepted
**Date:** 2026-08-18
**Deciders:** Gary Elliott, Claude Code
**Impact:** Major
**Supersedes:** ADR-005 (multi-SOW customer repo model) — the model is kept, the
vocabulary and the delivery mechanism change. See *Relationship to ADR-005*.

---

## Context and Problem Statement

Three forces arrived at the same conclusion from different directions:

1. **ADR-005 (2026-07-02)** established that one customer repo should host multiple
   bounded bodies of work. It named them **streams**, gated them behind a new
   `engagement` project type, and left two questions open: what carries stream
   identity on a work item, and what the folder structure actually is.
2. **ADR-008 (2026-07-22)** found the framework's two root causes — hand-synced
   duplication, and enforcement written as prose rather than mechanism — and
   sequenced the work: *coupling first, streams after, on the consolidated base.*
3. **The 2026-08-18 mind-graph** proposed a repo shape (`kanban/`, `history/`,
   `.claude/`, `workspaces/`) that drops `project-hub/` and `framework/` entirely,
   and shifts the framework's delivery model: **the commands build the structure**
   rather than an archive shipping it.

The field evidence that forced the issue (inspected 2026-08-18):

- **`HPCJobQueuePrototype`** began as an HPC job-queue utility and grew a
  `customers/honda/` tree containing `docs/ hpc-2019-upgrade/ jira/ meetings/
  operations/ planning/ poc/ released/ reports/ src/ tests/`. The original tool's
  `dist/ installers/ manifests/ scripts/ wrappers/` still sit at repo root. One repo,
  a product at the root and a customer beneath it. Gary: *"the repo is a chameleon."*
- **`Clients Current/Boston Dynamics`** is **not a git repo**. It holds
  `Jobs/BD-SOW-001..003`, `General Reference/`, `Network/`, `POC/`, `Time and
  Billing/`, and a `.claude/` with two commands. Its contents are `.docx`, `.pdf`,
  signed DocuSign packets, `.afdesign`, `.rdp`, a vendor form, a security
  questionnaire. It also contains `src`, `src.orig`, and `src.orig - Copy` — what
  happens without version control.

These two fail in **opposite** directions, which is what makes them the test pair.
Honda stresses *depth* (a mini-project nested inside a customer, plus a root-level
product owned by no customer). BD stresses the *floor* (no git, no source tree,
business documents as the primary artifact).

**Key requirements:**
- One repo per customer; shared customer context stored once, never duplicated.
- A container that fits both a source-bearing customer and a document-bearing one.
- The framework must not require restructuring this repo to deliver the new model.
- Old instructions must not silently conflict with the new direction during the build.

**Constraints:**
- Solo contractor. One pair of hands, low ceremony, no fleet of repos to administer.
- ADR-008's roots must not regenerate: no hand-synced duplication, no invariant that
  lives only in prose.
- Three live client projects (Honda/HPC, Boston Dynamics, Toyota) are waiting.

---

## Decision Drivers

1. **Serve Gary-the-contractor first** — the tiebreaker reaffirmed in the onion
   retrospective. A structure that demos well but fits no live client fails.
2. **Preserve the discovery, not just the files** — ADR-005/006/007/008 and the
   session logs are the asset the last three weeks bought. They must stay *live*
   documents read at session start, not an archive someone must be told to find.
3. **Avoid churn** — a repo-wide reorganization is cost without a customer benefit.
4. **Make the transition boundary positional, not advisory** — "ignore the old docs"
   is prose, and prose rots (ADR-008, Root 2). A path boundary is checkable.

---

## Options Considered

### Option A: Reorganize this repo in place

Rename `project-hub/` → `kanban/` + `history/`, add `workspaces/`, migrate every path
reference, empty `framework/` by attrition.

**Pros:** history stays connected; one repo; incremental.

**Cons:** a large migration whose cost lands entirely on framework-internal work with
no client benefit. Worse, it creates a **half-migrated state** in which both layouts
are documented as current — the AI loads `framework/CLAUDE.md` (which still describes
`project-hub/`) and `framework.yaml:sources:` at session start and acts on the stale
map. That is the BUG-170 silent-degradation class applied to instructions.

### Option B: Fresh repo

Start a fresh framework repo clean; carry forward only proven mechanisms.

**Pros:** psychologically clean; zero legacy; no conflicting instructions.

**Cons:** the same objection ADR-008 raised against a rewrite, one level up. The ADRs,
retrospectives, and 15 session logs stop being live context and become a disconnected
archive. The concrete failure: a settled decision gets re-proposed months later because
the record that rejected it is no longer loaded. **The onion regenerates in a new
location.** Also splits the Kanban board and ID namespace across two repos.

### Option C: Build fresh in a workspace, in this repo (chosen)

Author the new framework at `workspaces/framework/` — a clean-slate build with no
inherited structure — while this repo's existing layout is left **untouched**. History,
ADRs, and the Kanban board stay connected and live. This repo becomes the first honest
dogfood of the multi-workspace model.

**Pros:** clean-slate authoring *and* connected history. Zero migration churn — nothing
moves. The transition boundary becomes **positional**: within
`workspaces/framework/`, that directory is the sole authority. The framework's own
repo is the first real multi-workspace case.

**Cons:** two framework versions coexist during the build, so command namespacing must
be handled deliberately (see *Consequences*). Requires an explicit graduation step, or
the workspace becomes permanent scaffolding.

---

## Decision

**Chosen: Option C — build the new framework fresh, in `workspaces/framework/`,
inside this repo.**

Five sub-decisions travel with it.

### D1. The term is `workspace`

`workspace` replaces **stream**, **engagement**, and every alternate considered in the
2026-07-16 brainstorm (§Streams): tracks, initiatives, programs, deliverables,
activities, portfolio, domains, practice-areas, areas, jobs, work-streams.

`jobs/` was considered on the field evidence — BD independently invented `Jobs/` for
this exact concept — and rejected: it fits BD, which is only SOWs, but not Honda, which
has `src/`, `operations/`, and a nested mini-project alongside its SOW work. The
container name must fit the widest case.

A **workspace** is a bounded body of work whose granularity the user chooses — an SOW, a
deliverable, a phase, an application, a knowledge base, or an operations area.

### D2. Everything is a workspace; the root owns only the spine

The repo root holds `.claude/`, `kanban/`, `history/`, `workspaces/`, `framework.yaml`,
`CLAUDE.md` — and nothing else that constitutes work. Honda's root-level `dist/ installers/
manifests/ scripts/ wrappers/` (the original prototype tool) become either their own
repo or a workspace like any other. There is no privileged root-level project.

This resolves the chameleon problem: the repo has no type of its own, only a spine and
a set of typed workspaces.

**Nesting is flat.** Honda's `hpc-2019-upgrade/` becomes `workspaces/hpc-2019-upgrade/`
— a peer, not a child, because it is a mini-project in its own right. Folder-level
nesting is where structures historically rot; the customer/parent relationship is
carried as a field on the work item, not as a directory depth.

**Retrospectives (and all history) follow the same rule: one timeline at the spine,
scope declared in the document.** Retrospectives live in `history/retrospectives/`;
each declares its scope via a `Workspace:` field — one workspace, several, or
account-wide. An account-level evaluation is a retro whose scope is "all," reading
across workspace-labeled work items and session history — possible precisely because
the timeline is never split into per-workspace folders. Scope by declaration, not by
location.

### D3. Authored vs. generated — only `.claude/` ships

- **Authored and shipped:** `.claude/` — commands, scripts, hooks, skills, templates,
  the framework contract. This is the deliverable.
- **Generated:** `kanban/`, `history/`, `workspaces/` are created by the commands
  (`/fw-init`, `/fw-new-workspace`) and are never packaged or migrated. This repo
  generates its own, as proof the commands work.
- **Third category, resolved (Open Questions #1):** the surviving standalone docs —
  `security-policy.md` (1,028 lines), `testing-strategy.md` (948),
  `code-quality-standards.md` (829), `troubleshooting-guide.md` (733),
  `architecture-guide.md` (574) — end as repo-wide **skills** under
  `.claude/skills/`, which brings them inside "only `.claude/` ships" with no
  exception. During conversion they stage in `workspaces/framework/standards/`
  under a one-home-at-all-times move rule.

The dogfooding gain is mechanical, not symbolic: `templates/starter/Setup-Framework.ps1`
can rot today because it is never executed. `/fw-init` cannot rot if this repo's own
structure comes from it. That converts an untested code path into a
continuously-exercised one — directly the BUG-170 class.

**The framework IS the plugin** (settled 2026-08-18). With structure generated and
standards as skills, there is nothing left for an archive to carry: distribution is a
marketplace install, upgrade is a plugin update, and the framework's version is the
plugin's version. At graduation the archive channel retires entirely — no zip, no
build-archive script successor, no `templates/starter/` (`/fw-init` is the starter).
Two consequences accepted deliberately: **Claude Code becomes a hard dependency**
(the AI-less fallback retires with the archive), and the workspace is understood as
the plugin's source tree plus build-time staging.

### D4. The workspace floor is a document-only workspace (no source tree required)

BD sets the floor. `/fw-new-workspace` must stand up a workspace that has no source
tree. The **common floor** across Honda and BD is small: meetings, research/reference,
deliverables, contacts, and an SOW/legal home. `src/`, `tests/`, `poc/` are a workspace
**type** layered on top, not part of the floor.

**Git is required at the repo root** (decided 2026-08-18). `.claude/scripts/fw-move.sh`
opens with `git rev-parse --show-toplevel` and exits if it fails; git operations are
built into the Kanban commands by design, and `git mv` is what preserves item history
across transitions. Rather than build a non-git mode, **BD becomes a git repo** as part
of its migration. The floor is therefore *no source tree required*, not *no git
required* — which is the constraint BD actually exercises. Its binary-heavy content
(`.docx`, signed PDFs, `.afdesign`) is committed as opaque blobs; "history" for those
artifacts means *when it changed and why*, recorded in work items and session history,
not a readable diff.

### D5. The old board stays authoritative until graduation

During the build there would otherwise be two Kanban boards — `project-hub/work/` (old,
live, holding real work) and `kanban/` (new) — one shared ID namespace, and two `fw-move`
implementations disagreeing about the path.

**`project-hub/work/` remains the single authoritative board for all work, including
work on the framework workspace.** The generated `kanban/` is a **test fixture** during
development: created by `/fw-init` to prove the command works, populated only with
throwaway items, never real ones. This is consistent with D3 — `kanban/` is generated
output, and generating a disposable one is precisely its purpose.

The crossover is a **single atomic moment**, not a period of ambiguity: at graduation,
the deletion commit also performs `git mv project-hub/work/* kanban/`. Until then there
is one board, one ID namespace, one WIP limit, and no ambiguity about which command to
run.

Rejected alternatives: *migrate the board on day one* (runs the new board with commands
that do not exist yet) and *two boards in parallel* (splits the WIP view and invites ID
collisions — the worst of the three).

---

## Relationship to ADR-005

ADR-005's **model is upheld**: one repo per customer, shared context stored once,
bounded bodies of work as folders, one Kanban board and one ID namespace at the root.
Per the immutable-ADR discipline logged in the onion retrospective, ADR-005 is not
edited; this ADR supersedes it and the truth is the chain.

What changes:

| ADR-005 | ADR-009 |
|---|---|
| The container is a **stream** | The container is a **workspace** (D1) |
| Gated behind a new `engagement` project type | Universal; every project has `workspaces/`. The type becomes redundant (D2) |
| `streams/` sits beside `project-hub/` | Root holds only the spine; all work is in a workspace (D2) |
| Structure shipped in an archive + setup script | Structure is generated by commands; only `.claude/` ships (D3) |
| Assumes a git repo with a source tree | Git still required; floor supports document-only workspaces with no source tree (D4) |

FEAT-165 (`engagement` project type, completed 2026-07-02) is **superseded in effect**.
The schema enum value, its `framework-roles.yaml` `project_type_defaults` entry, and the
docs updated by that item are not carried into the new build. FEAT-163 and FEAT-164
remain valid work but are rewritten against `workspace` vocabulary.

---

## Consequences

### Positive

- ✅ **Zero migration churn.** Nothing in this repo moves. The old structure is left
  intact and working while the new one is authored beside it.
- ✅ **The conflicting-instructions problem becomes a boundary, not a rule.** Within
  `workspaces/framework/`, that directory and its `CLAUDE.md` are the sole
  authority. Positional, and therefore script-checkable — the same reason `.claude/`
  works as a boundary today.
- ✅ **History stays live.** ADR-005/006/007/008, the retrospectives, and the session
  logs remain loaded context, not a disconnected archive.
- ✅ **Upgrade collisions disappear** for consuming projects: an upgrade replaces
  behavior only and can never collide with a user's content.
- ✅ **The framework repo becomes the first multi-workspace case**, dogfooding the model
  that Honda and BD need.

### Negative

- ⚠️ **Two framework versions coexist during the build.** The old root `.claude/`
  commands stay in daily use to manage the board while the new ones are authored. They
  cannot both own the `/fw-*` namespace at the root. Mitigation: build the new plugin
  under the workspace and install it from the local marketplace
  (`tools/Publish-ToLocalMarketplace.ps1`) under a distinct name until it fully
  replaces the old one.
- ⚠️ **Requires an explicit graduation step**, or the workspace becomes permanent
  scaffolding.
- ⚠️ **~4,000 lines of standards must be converted to skills** — staged through the
  interim `workspaces/framework/standards/` folder under the
  one-home-at-all-times rule (Open Questions #1).

### Accepted Risks

- **Copying carries the duplication across the boundary.** "Pull in what we need" must
  mean *almost nothing*. Mitigation: only `fw-move.sh` (a proven mechanism) and the
  genuine standalone docs are candidates. Everything else is re-derived or dropped.
  Anything copied must be justified in writing at the time.
- **The new build becomes its own onion.** Mitigation: it is bounded by the graduation
  criteria below; ADR-006/007/008 are inputs, not open questions.
- **Client pressure pulls focus before graduation.** Accepted deliberately — the
  intended sequence has the new commands built *against* BD, so client work is the
  build's driver rather than its casualty.

---

## Graduation Criteria

`workspaces/framework/` stops being a workspace and becomes the product when:

- [ ] `/fw-init` stands up a complete repo spine from nothing.
- [ ] `/fw-new-workspace` stands up both a source-bearing workspace (Honda shape) and a
      document-only one (BD shape).
- [ ] The Kanban engine (`fw-move.sh` equivalent) runs against the generated structure.
- [ ] The plugin builds and installs from the local marketplace and passes
      built-artifact verification (TECH-188's standing check).
- [ ] Boston Dynamics is migrated onto it — as a git repo, per D4 — and is the working
      system for that client.

At graduation, one commit does all of the following:

- `git mv project-hub/work/* kanban/` — the board crossover (D5), and the rest of
  `project-hub/` to `history/`. (The exact landing spot for `research/` and the ADRs —
  the mind-graph's "items needing a home" note — is decided as part of this step; the
  ADRs must remain live session-start context per Decision Driver 2.)
- Deletes `framework/`, `plugins/`, `tools/`, and `templates/`.
- Promotes `workspaces/framework/` to the product.

A deletion and a rename, not a migration.

---

## Sequencing

1. **BD first, not Honda.** BD is not a git repo, has no framework state to preserve,
   and is the harder floor test. If the commands can stand up BD from nothing, Honda
   becomes a `git mv` exercise against proven commands. Building against Honda first
   means migrating by hand and only then discovering what the command should have done.
2. **Honda second** — the depth test (nested mini-project, root-level orphan product).
3. **Toyota third** — expected to land between the two; a confirmation, not a new shape.
4. **Graduation**, then this repo's deletion commit.

**On ADR-008's "coupling first, streams after":** that sequencing was written to prevent
building streams *on the un-consolidated base*, which would give the onion a new axis.
Building fresh in a workspace satisfies the intent by a different route — the new build
inherits none of the coupling, so there is no un-consolidated base to grow along. The
consolidation work items (TECH-185/186/187/188) are **re-scoped, not cancelled**:
TECH-187's restatement audit still determines which of `framework/docs/`'s 8,246 lines
survive into the new build, and TECH-188's built-artifact verification becomes a
graduation criterion.

---

## Open Questions

1. ~~**Where do the surviving standalone docs live?**~~ **Settled 2026-08-18:**
   standards-as-skills is the end state; a workspace-local `standards/` folder is the
   interim that buys time to build them — under a **one-home-at-all-times** rule so
   DRY / Single-Source is never violated during the transition:
   - **Interim:** the surviving docs are **moved** (`git mv`, never copied) into
     `workspaces/framework/standards/` as raw material for the TECH-187
     restatement audit. Deliberately inside the workspace, not at repo base — the
     folder is build scaffolding, not a shipped or repo-wide surface.
   - **End state:** each standard is converted into a repo-wide **skill** under
     `.claude/skills/<name>/` — SKILL.md carries the decision rules (under ~500
     lines per Anthropic's spec), longer reference material sits beside it in the
     skill folder and loads only on use, and the description routes when it fires
     ("writing code that handles user input", "planning tests"). SKILL.md is plain
     markdown, so the skill *is* the human-readable standard — one home. Tailoring
     is fork-and-own: the plugin ships the baseline; a project needing a different
     standard copies it into its own `.claude/skills/` and owns it from then on.
   - **The DRY mechanics:** conversion is also a move — when a standard becomes a
     skill, its file leaves `standards/` in the same commit. At every moment each
     standard has exactly one home. `standards/` drains as skills are built; once
     empty, it is deleted. It never ships and never appears in a consuming repo.
   D3 is unblocked: the standards end as `.claude/` content, so "only `.claude/`
   ships" holds with no exception.
2. ~~**What carries workspace identity on a work item?**~~ **Settled 2026-08-18:** a
   distinct **`Workspace:`** field. `Workspace:` and `Theme:` are orthogonal
   dimensions — multiple applications (workspaces) can serve the same project theme,
   so collapsing them loses an axis. `Theme:` keeps its *stable category* meaning.
   Work-item templates gain the field; FEAT-163 is unblocked and proceeds in
   `workspace` vocabulary.
3. ~~**Does the Kanban engine require git?**~~ **Settled 2026-08-18 (D4):** yes. Git
   operations are built into the Kanban commands by design; no non-git mode will be
   built. BD becomes a git repo as part of its migration.
4. **What is BD's `.gitignore` and repo hygiene policy?** Direction set 2026-08-18:
   every customer repo is **private**; installers and secrets are ignored from day
   one (`GlobalProtect64.msi`, `.rdp` connection files, recovery keys — vault
   pointers only, per ADR-005); the ignore list is expected to grow over time.
   Mechanism follows D3: `/fw-init` generates the seed `.gitignore`, so enforcement
   exists at creation rather than after the first bad commit. Remaining detail —
   reconciling `src.orig` / `src.orig - Copy` and sorting existing content — lands
   in BD's migration work item.
5. ~~**Do workspaces have types?**~~ **Settled 2026-08-18 (open to challenge):** yes —
   **application, knowledgebase, sow, operations** — and the difference lives **only
   in the initial scaffolding** `/fw-new-workspace` lays down. Type is never a
   runtime branching mechanism: FEAT-165's audit measured what every type-branching
   point costs, and workspace types must not recreate that surface. Notes carried
   with the decision: *library* and *toolkit* fold into *application* (the
   2026-07-16 brainstorm itself noted they are the same from a project perspective),
   and the PARA lesson from the outside-ideas survey shapes the scaffolds — sow and
   application are Projects (they end; scaffold `deliverables/`), knowledgebase and
   operations are Areas (ongoing; scaffold intake/reference instead).
6. ~~**Numbered kanban folders?**~~ **Settled 2026-08-18: rejected.**
   `01_backlog`-style prefixes bake ordering into paths every script and doc must
   know, and break on inserting `blocked`. Sequence belongs in the transition matrix
   the move engine owns.

---

## Alignment with Anthropic Guidance (verified 2026-08-18)

Checked against the current official Claude Code best-practices documentation, since
the platform changed substantially over the past year (Agent Skills became an open
standard in Dec 2025; plugins are now the standard distribution unit).

**Confirmed — the model matches current guidance:**
- *"Unlike CLAUDE.md instructions which are advisory, hooks are deterministic and
  guarantee the action happens"* — ADR-008's Root-2 cure is now the platform's own
  framing. The docs even advise converting prose rules into hooks.
- Plugins bundle skills, hooks, subagents, and MCP into one installable unit — D3's
  "only `.claude/` ships" is the platform's native distribution model.
- CLAUDE.md: keep it short, prune ruthlessly — *"bloated CLAUDE.md files cause Claude
  to ignore your actual instructions"* — matches ADR-007's ≤150-line contract.
- *"Give Claude a check it can run"* — the graduation criteria and the TECH-188/189
  verification pattern.
- Push deterministic work into scripts — `fw-move.sh` as the move engine.

**Revised by the past year — inputs for framework-next:**
- *"For domain knowledge or workflows that are only relevant sometimes, use skills
  instead"* — skills' progressive disclosure (description routes; body loads on
  demand; reference files load only during execution) natively does what the old
  CLAUDE.md "AI Reading Protocol" did with push-prose, and what the `sources:`
  index-and-load model does by hand. `framework.yaml` remains the machine-readable
  config and release index; topic-routing for the AI increasingly belongs in skill
  descriptions. Feeds Open Questions #1.
- `disable-model-invocation: true` marks side-effect workflows as user-triggered
  only — fits `/fw-move` and `/fw-release`.
- Stop hooks can gate a turn on a failing check — a platform-native home for the
  done-gate and the drift guard.

---

## Validation

**How we verify correctness:**
- BD stands up from nothing via the new commands, with no hand-editing.
- Honda migrates with its nested mini-project flattened to a peer workspace and its
  root-level product relocated, with no orphan left at the root.
- The built plugin — not the source repo — passes verification (TECH-188).

**Success criteria:**
- ✅ A workspace can be created that contains no source tree at all.
- ✅ One Kanban board and one ID namespace serve all workspaces in a repo — and exactly
      one board is authoritative at any moment during the build (D5).
- ✅ No structure documentation exists that a command does not generate.
- ✅ Nothing outside `.claude/` is hand-authored structure (script-assertable — the
  TECH-189 drift guard pointed at a new invariant).

---

## References

- [ADR-005 — Multi-SOW Single-Customer Repo Model](005-multi-sow-customer-repo-model.md) (superseded by this ADR)
- [ADR-008 — Consolidate, Don't Rewrite](008-consolidate-not-rewrite.md)
- [ADR-006 — Work Item Type Taxonomy](006-work-item-type-taxonomy.md)
- [ADR-007 — AI Collaboration Contract and CLAUDE.md](007-ai-collaboration-contract-and-claude-md.md)
- [The Onion Retrospective](../../retrospectives/2026-07-22-the-onion-retrospective.md)
- [Gary's Thoughts — 2026-07-16](../../retrospectives/2026-07-16-garys-thoughts.md) (§Streams, §Structure Thoughts)
- `project-hub/retrospectives/FrameworkPlanning-FolderStructure-Proposed.png` — the 2026-08-18 mind-graph
- Field evidence inspected 2026-08-18: `SpearIT/Projects/HPC/HPCJobQueuePrototype`,
  `SpearIT/Clients Current/Boston Dynamics`
- FEAT-163 (workspace-aware reporting), FEAT-164 (workspace content structure),
  FEAT-165 (`engagement` type — superseded in effect)

---

**Change Log:**
- 2026-08-18: Initial decision (Proposed)
- 2026-08-18: D4 settled (git required); D5 added (board crossover at graduation).
  Open-question review with Gary: `Workspace:` field settled, workspace types settled
  (4, scaffolding-only), kanban numbering rejected, BD hygiene direction set.
  Anthropic best-practices alignment verified; OQ1 revised toward standards-as-skills.
- 2026-08-18: OQ1 settled — skills as end state, interim staging in
  `workspaces/framework/standards/` under one-home-at-all-times. No open
  question now blocks any decision; the ADR is ready for Accepted.
- 2026-08-18: Review pass (D4 heading fixed, `workspaces/` added to D2 spine,
  research/ADR landing noted in graduation, retrospectives scope-by-declaration added
  to D2). **Accepted by Gary.**
- 2026-08-18: Workspace renamed `framework-next` → `framework` and the dev plugin
  named `spearit-framework-dev` (relative names rot — Gary; path references in this
  document updated throughout, including prior change-log entries). "The framework IS
  the plugin" identity added to D3: archive channel retires at graduation; Claude
  Code becomes a hard dependency. BUG-181 re-scoped under this ADR (the composer
  becomes `/fw-init`; old-pipeline mechanisms will not be built).
