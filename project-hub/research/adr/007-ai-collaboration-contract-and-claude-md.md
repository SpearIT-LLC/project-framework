# ADR-007: The AI Collaboration Contract — What CLAUDE.md Is, and How It Reaches Each Channel

**Status:** Accepted
**Date:** 2026-07-13
**Accepted:** 2026-07-15
**Deciders:** Gary Elliott, Claude Code
**Impact:** Major
**Scope:** Every `CLAUDE.md` in the framework and its distribution channels — what the file is for, what
it may contain, where its content is authored, and how each channel receives it. Also settles the fate
of `framework/CLAUDE.md` and `framework/CLAUDE-QUICK-REFERENCE.md`.
**Supersedes:** None. Extends the derivation principle established in **ADR-006** to a second artifact.

---

## Context and Problem Statement

**`CLAUDE.md` is the only file Claude Code auto-loads.** Everything else — guides, references, templates
— is read on demand, and only if something points at it. That makes `CLAUDE.md` the framework's one
guaranteed channel to the AI, and therefore the place its guarantees must actually live.

Today the framework has **three** files named `CLAUDE.md` and a fourth that behaves like one:

| File | Lines | Auto-loaded? | Ships to derived projects? |
|---|---|---|---|
| `/CLAUDE.md` (repo root) | 126 | **Yes** (in this repo) | No — repo-only |
| `framework/CLAUDE.md` | 501 | **No** | Yes — `Build-FrameworkArchive.ps1` Step 5.5 |
| `templates/starter/CLAUDE.md` | 82 | **Yes** (in a derived project) | Yes — becomes the derived project's root `CLAUDE.md` |
| `framework/CLAUDE-QUICK-REFERENCE.md` | 334 | No | Yes (via `framework/docs/`… — verify) |

### The three problems, verified 2026-07-13

**1. The contract does not reach derived projects.**
`Build-FrameworkArchive.ps1` ships **both** `templates/starter/CLAUDE.md` → archive root `CLAUDE.md`
(Step 1, incidental — swept up by the recursive starter copy) **and** `framework/CLAUDE.md` →
`framework/CLAUDE.md` (Step 5.5, deliberate, hard-errors if missing). `Setup-Framework.ps1` renames
nothing; it only substitutes `{{PLACEHOLDER}}` tokens.

So a derived project ships an 82-line root `CLAUDE.md` (auto-loaded) and a 501-line
`framework/CLAUDE.md` (never loaded, and **never linked to from the root file**). The AI in a derived
project therefore never receives: role wiring, the ADR-001 checkpoint policy, the AI Reading Protocol,
the `/fw-*` command list, or the full Epistemic Standards.

**2. `framework/CLAUDE.md` is a `CLAUDE.md` that Claude never loads.** The name is a decoy. It looks
like it will be picked up; it never is. It is a documentation file wearing a reserved filename.

**3. It is 95% duplicate.** A section-by-section audit against every file it links to (2026-07-13):

| Category | Lines | % |
|---|---|---|
| **Genuinely unique** (exists nowhere else in the repo) | **~23** | **4.6%** |
| Restated (condensed duplicate of a guide that owns the content) | ~410 | 82% |
| Structural (headings, rules, blank, link index) | ~68 | 13.4% |

And it is not the *fourth* copy — it is the **fifth**:
`workflow-guide.md` → `collaboration/README.md` → `architecture-guide.md` →
`CLAUDE-QUICK-REFERENCE.md` (334 lines, same folder) → `CLAUDE.md`.

Accounting for `CLAUDE-QUICK-REFERENCE.md`, which carries the checkpoints, the ADR decision tree, the
reading-protocol tree, the `divide()` fail-fast example, the SQL-injection example, the coverage
targets, and a **verbatim** copy of the Top-5 Emergency Reference — the genuinely-unique residue of
`framework/CLAUDE.md` falls to **~8 lines**.

### The drift this produced (all verified 2026-07-13)

Restatement is not free. Every one of these is a live defect in `framework/CLAUDE.md`:

- **Command list is 6 stale.** Lists 5 commands; `.claude/commands/` has **11**. Omits `/fw-next-id`,
  `/fw-release`, `/fw-roadmap`, `/fw-session-history`, `/fw-swarm`, `/fw-topic-index`.
  `docs/ref/framework-commands.md` has all 11 and is correct.
- **ADR template paths do not exist** (`:353-354`) — `templates/ADR-MAJOR-TEMPLATE.md`. Actual:
  `framework/templates/decisions/`.
- **Circular dangling reference.** `:215` cites a *"complete 11-step workflow"* in `workflow-guide.md`.
  **workflow-guide.md has no 11-step workflow** (it has 5 phases). Conversely `workflow-guide.md:212`,
  `:1760`, `:2246`, `:2290` all cite *"CLAUDE.md Step 9"* — **which does not exist either.** Two
  documents pointing at steps in each other that neither contains.
- **The permissions section is materially wrong** (`:430-446`). Claims the project allows only
  read-only operations (`Read`, `Glob`, `Grep`, `ls`, `cat`, `pwd`, `git status`). The actual
  `.claude/settings.local.json` allows **`Edit`, `Write`, and unrestricted `Bash`** with
  `"defaultMode": "dontAsk"`, plus a deny-list CLAUDE.md never mentions. It describes a security
  posture the project does not have.
- **The folder tree is wrong in ~8 ways** (`:34-61`) vs. `docs/PROJECT-STRUCTURE.md` — omits
  `framework.yaml`, `src/`, `tests/`, `work/blocked/`, `poc/`, `history/spikes/`; shows `process/`,
  `templates/`, `patterns/` at project root; shows `history/releases/` without the required
  `{product}/` level.
- **Self-referential dead link** (`:216`) — a "Full Details" bullet pointing at the same file, 25 lines
  up. A broken link patched with prose.
- **The framework's own size guidance contradicts itself in three places** —
  `collaboration/README.md:309` says CLAUDE.md is ~400–500 lines; `CLAUDE-QUICK-REFERENCE.md:196` says
  ~600 and calls itself "<200 lines" while being **334**.

**Bonus, found while verifying:** `framework.yaml:79` (repo root) sets
`project-structure: framework/docs/PROJECT-STRUCTURE-STANDARD.md` — **that file does not exist.** The
file is `PROJECT-STRUCTURE.md`. `/fw-topic-index` reads this block, so the repo's topic index currently
points at a missing file. **`templates/starter/framework.yaml` has it right.** The distribution's
config is more correct than the framework's own.

### The routing layer already exists

`framework.yaml` already ships a **`sources:` index** — 25 topic→file pointers — plus `policies:` and
`roles:`. `templates/starter/framework.yaml` carries the full set. **The machine-readable map from
"topic" to "source of truth" is solved and shipping.** Nothing in `CLAUDE.md` needs to restate a guide;
it needs to point at `framework.yaml`, which points at the guide.

### The question

**What is `CLAUDE.md` for, what may it contain, and how does each channel get it?**

This is the same question **DECISION-162** asks about command tiers, **TECH-169** asks about `/fw-move`
copies, and **SPIKE-178/FEAT-179** ask about the plugin engine. Four open items circling one unstated
rule. This ADR states it.

---

## Decision Drivers

- **CLAUDE.md is the only auto-loaded file.** A rule not in it (or not reachable from it) is a rule the
  AI does not have.
- **ADR-006's lesson, generalized:** restating content in N places produces N disagreeing copies. The
  fix is one authored source + derivation, never hand-sync.
- **The framework's own established pattern:** `Build-FrameworkArchive.ps1` already does
  canonical-source + copy-fresh + drift-guard for commands (Step 1.5), scripts (1.6), and the type SoT
  (1.6b). `CLAUDE.md` is the one artifact that opted out — and it is the one that rotted.
- **Dogfooding.** Whatever binds a derived project must bind this repo. A rule kept only in the user's
  `~/.claude/` or only in the repo root is a dogfooding violation.
- **Auto-loaded context is expensive.** Every line of `CLAUDE.md` is paid on every session, in every
  project, forever. 501 lines of restatement is a tax with no return.

---

## Decisions

### D1 — `CLAUDE.md` is a *contract*, not a *manual*

**Decided.** `CLAUDE.md` contains **only** what satisfies at least one of:

1. **A binding rule that exists nowhere else** (delete the file → the rule is lost), or
2. **A bootstrap instruction** — what to read, when, and in what order, and
3. **Project identity** — name, description, and what this specific project is.

It contains **no** restatement of a guide. No code-quality principles, no SQL-injection example, no
coverage targets, no folder tree, no command syntax. Those have owners; `CLAUDE.md` routes to them via
`framework.yaml`'s `sources:` index.

**Size target: ≤150 lines.** Not a style preference — auto-loaded context is paid every session.

### D2 — Retire `framework/CLAUDE.md`

**Decided.** The file is deleted. Its ~8 genuinely-unique lines are relocated:

| Content | Destination |
|---|---|
| **"Resume work" rule** — *"ALWAYS read `work/doing/` … NEVER suggest next actions without verifying current work state"* | → the contract (`CLAUDE.md`). Genuinely unique; genuinely load-bearing. |
| ~~**The three checkpoints** (Step 4 / 7.5 / 8.5)~~ | **Row void — see D7.** There is no set of three. One rule goes to the contract; the other two are already enforced by `/fw-move` and go nowhere. **Do not relocate them to `workflow-guide.md`** — doing so would ship Rule 1 to a file the AI never loads, i.e. re-commit BUG-181. |
| **Claude Code Permissions** | → `docs/collaboration/security-policy.md` (or a `docs/ref/` page). **Rewrite it — it is currently false.** |
| **`:7` — "Projects are encouraged to author their own `CLAUDE-QUICK-REFERENCE.md`"** | → **deleted, and contradicted.** This is the line that *actively recommends the duplication this ADR exists to end.* It is not content to relocate; it is a policy to reverse. See D6. |
| **"Pre-commit hook validates work items in `done/`"** | → **deleted. It is false** (verified 2026-07-14): `.git/hooks/` contains only samples. `Validate-WorkItems.ps1` exists but nothing invokes it. The `settings.json` hook is a `PreToolUse` hook, unrelated. **Eighth drift defect.** |
| **Everything else (~490 lines)** | → **deleted.** Already owned by `docs/collaboration/` and `docs/ref/`. |

> **⚠️ Do not treat this table as a licence to delete.** The audit behind it was a single pass across
> ~2,000 lines of comparison. It is reliable about the *shape* of the finding (overwhelmingly duplicate)
> but the claim *"everything else is safely deleteable"* is a summary judgment. **Before deleting any
> section, re-verify that its content actually exists in the file that supposedly owns it** — section by
> section, against the real file, at deletion time. The audit tells you where to look; it does not
> authorize the `rm`. A single unique rule that exists only here, deleted, is not noticed until the
> behavior it prevented happens.

**Rationale:** a `CLAUDE.md` Claude never loads is a misleading filename on a duplicate document. Adding
a link from the root file to it would be patching around a file that should not exist.

**Also on the table (see Open Questions):** `framework/CLAUDE-QUICK-REFERENCE.md` (334 lines) is the
*fourth* copy and duplicates most of the fifth. Retiring it is very likely correct and should be decided
here rather than left to rot.

#### D2a — The root cause: subdirectories were mistaken for sub-projects

`framework/CLAUDE.md` did not appear by accident. It was licensed by a framing in the **repo's own root
`CLAUDE.md`**: the section *"Which Project Are You Working On?"* (`CLAUDE.md:62`), which asks the AI to
decide whether it is working on *the framework*, *template packages*, or *build tooling* — and then
routes it to `framework/CLAUDE.md` for the first. **Three "projects" → licence for three contracts.**

**First, what the three products are NOT.** `framework.yaml` does list three products under `release:`
— framework, plugin-full, plugin-light, each with its own `PROJECT-STATUS.md`, `CHANGELOG.md`, and
build script. But these are **distribution channels, not sub-projects**: a consuming project picks
**one** (design intent, confirmed 2026-07-13 — full framework *or* plugin-full *or* plugin-light;
combining them is theoretically possible but was never the model). Three ways of shipping **one**
project.

**And `framework/` / `templates/` / `tools/` are not even those three.** The root `CLAUDE.md`'s question
does not route by *channel* — it routes by **source subdirectory**. Those are the parts of one codebase:
`framework/` is the product, `templates/` packages it, `tools/` builds it. **Nobody "works on" `tools/`
as a project.** The framing miscategorizes directory structure as project structure — and then hands one
of those directories its own collaboration contract.

**Therefore:** the repo's root `CLAUDE.md` drops *"Which Project Are You Working On?"* and its
sub-project routing. What survives is ~15 lines of orientation — *"`framework/` is the product,
`templates/` packages it, `tools/` builds it"* — and that is a **README concern, not a contract
concern.** Verify it is not already in `README.md` before restating it (per D3: there are no summary
layers).

This is what makes the repo's root `CLAUDE.md` genuine dogfooding: **the same contract block a derived
project gets, wrapped in a 15-line shell instead of a 20-line one.**

### D3 — Route through `framework.yaml`, do not restate

**Decided.** `framework.yaml`'s `sources:` block is the topic→SoT index and it already ships complete in
the starter. The contract's job is to say *"read `framework.yaml`; it tells you where everything is,"*
plus name the handful of always-relevant entries (`policies.onTransition`, `roles.default`). It never
inlines what a `sources:` entry points at.

**Corollary:** adding a rule to the framework means adding it to the guide that owns it and — if it is
binding on the AI at all times — to the contract. Never to a summary in between. **There are no summary
layers.**

### D4 — How each channel's root `CLAUDE.md` is produced: **derive the region, not the file**

**Decided (2026-07-13 discussion).** Every root `CLAUDE.md` is **contract + shell**, and the file is
**explicitly partitioned into two marked regions** — one owned by the framework, one owned by the
project. Every line in the file has an owner.

```markdown
# Claude Context: {{PROJECT_NAME}}

<!-- ─────────────────────────────────────────────────────────────────────
     BEGIN FRAMEWORK CONTRACT — v{{FRAMEWORK_VERSION}}
     Derived from the framework. DO NOT EDIT — this region is replaced on
     framework upgrade. Put your own instructions in the PROJECT INSTRUCTIONS
     region below; the framework never touches it.
     ───────────────────────────────────────────────────────────────────── -->

... the universal contract, authored once ...

<!-- END FRAMEWORK CONTRACT -->


<!-- ─────────────────────────────────────────────────────────────────────
     BEGIN PROJECT INSTRUCTIONS
     This region is YOURS. The framework will never modify or overwrite it.
     Add your project's conventions, standards, preferences, and any
     standing instructions for the AI.
     ───────────────────────────────────────────────────────────────────── -->

<!-- Your project's conventions and standing instructions go here. -->

<!-- END PROJECT INSTRUCTIONS -->
```

#### Why `PROJECT INSTRUCTIONS`, not `USER INSTRUCTIONS` (2026-07-14)

**`USER INSTRUCTIONS` is ambiguous, and the wrong reading is the likelier one.** It parses two ways:

1. *"Instructions **for** the user"* — as in "user guide," "user documentation."
2. *"The user's instructions **to** Claude."*

In a file titled *Claude Context*, "user" reads most naturally as the **audience** of the instructions,
not their **author** — so a newcomer lands on (1), which is exactly backwards. The label must name the
**owner**, since ownership is the whole point of the partition.

`PROJECT INSTRUCTIONS` fixes it:
- It **cannot** be read as "instructions for the project" — the entire file is already about this
  project, so the only sensible reading is *the project's own instructions to the AI.*
- It **parallels the other region correctly**: `FRAMEWORK CONTRACT` vs. `PROJECT INSTRUCTIONS` —
  framework-owned vs. project-owned. Both labels name *whose* they are.
- It is **already the term in use**: `templates/starter/CLAUDE.md` ends with `## Project-Specific
  Notes` — *"[Add coding standards, architecture decisions, and conventions specific to this
  project]"*. Same region, different name.
- It **survives the team case.** "User instructions" invites *which user?*; "project instructions"
  does not.

Rejected: `YOUR INSTRUCTIONS` (second-person in a file read by both a human and an AI — "your" is
ambiguous about whom it addresses, which relocates the problem rather than solving it);
`INSTRUCTIONS FOR CLAUDE` (unambiguous, but odd inside a file that is *entirely* instructions for
Claude, and it does not parallel `FRAMEWORK CONTRACT`).

**The label must stand alone.** The body text already disambiguates (*"standing instructions for the
AI"*), but the label is what appears in the file outline, in a diff, and in a `grep`. It has to be
right without its explanation.

**Mark BOTH regions, not just the contract.** With only the framework region marked, everything outside
it is "not-contract" *by default* — an edit above the block, or a section the framework later wants to
own, lands in undefined territory and the upgrade tool has to guess. Two explicit regions make the file
a **partition**: `[framework][project]`, no ambiguity, nothing to infer.

It also inverts the message in the way we want. `DO NOT EDIT` alone reads as a fence; `BEGIN PROJECT
INSTRUCTIONS` reads as an **invitation** — *this is yours, put your things here.* A user with nowhere
obvious to write will edit the contract block. Give them somewhere obvious.

**The project region ships non-empty.** It carries a placeholder comment from birth, not two bare
delimiters — an empty marked region reads like scaffolding to be deleted.

**And it buys a humane upgrade failure mode.** If re-derivation finds the framework region was edited,
it need not choose between silently overwriting (unacceptable) and refusing (useless): it can **relocate
the user's edits into the PROJECT INSTRUCTIONS region and tell them it did.** That is only possible
because there is somewhere to move them *to*. (See Open Question 1.)

**The decomposition (this is the whole decision):**

| Layer | Universal? | Authored where | How it reaches a channel |
|---|---|---|---|
| **Contract** | Yes — identical in every channel | **Once**, in `.claude/framework-contract.md` (OQ2, resolved — *not* named `CLAUDE.md`; sits with the other build-input assets) | **Derived** into the guarded region |
| **Shell** | No — per-channel, **shares nothing** | Each channel authors its own | Hand-authored, stays hand-authored |

The shells genuinely have **nothing in common** — this repo's is repo layout; a derived project's is
identity + notes. They are not variants of one thing; they are two different things. So the *only*
question D4 ever had was: **is the contract pasted into both, or derived into both?** Framed that way it
answers itself. This is not "generate CLAUDE.md." It is **"stop pasting the contract twice"** — one
concat in a build script that already runs three copy-fresh-from-canonical steps.

#### Why a guarded *region*, not a guarded *file*

A derived project's `CLAUDE.md` **must remain user-editable.** Users will and should add their own
conventions and preferences. A wholly generated file with a "do not edit" banner would fight the user —
it is the wrong artifact to lock.

So the guard scopes to the contract block. Editing `CLAUDE.md` is **not** a mistake; editing **inside
the contract block** is — in every channel, this repo included.

#### The payoff it *enables* — upgradeable contracts (enabled, not promised)

Because the region is delimited and the shell is untouched, a framework upgrade **could** re-derive the
contract block in place without clobbering the user's notes. **Nothing in the framework can do this
today** — an upgrade cannot touch a derived project's `CLAUDE.md` at all, which is why derived projects
would rot even if we shipped the contract correctly once.

**⚠️ Scope discipline — D4 does not decide this.** D4 decides **build-time composition** (author once,
concatenate into each channel). That stands on its own: it kills the duplicate contract, and it is worth
doing even if in-place upgrade never ships.

**In-place upgrade is a separate decision that D4 makes *possible*, not one it makes.** It depends
entirely on Open Question 1 — *how does re-derivation detect that a user edited the framework region?* —
which is **unanswered**. An upgrade that silently overwrites a user's edit is unacceptable; an upgrade
that refuses is useless; the two-region partition suggests a third way (relocate the edits into PROJECT
INSTRUCTIONS and report it), but the **detection** mechanism is still undesigned.

**So: the markers ship with D4. The upgrade tooling does not.** Do not build the upgrade path until OQ1
is settled. Claiming the benefit before designing the mechanism is how the last five copies of this
contract got made.

#### Two-stage substitution (constraint)

`Setup-Framework.ps1` already substitutes `{{PROJECT_NAME}}` / `{{PROJECT_DESCRIPTION}}` / `{{DATE}}`
across all `*.md`. D4 must respect that seam:

- **Build** composes `contract + shell` → the channel's `CLAUDE.md`. *Universal.*
- **Setup** fills identity placeholders. *Per-project.*

**Therefore: the contract fragment contains ZERO placeholders.** Only the shell does. This is the line
that keeps the two stages from bleeding into each other.

#### Keep the composer stupid

Steps 1.5/1.6/1.6b copy artifacts the framework *uses at runtime* — inert until invoked. `CLAUDE.md` is
different: **it governs the AI that runs the build.** If the composer is wrong, the thing that would
catch it is operating under the wrong contract.

So the composer must be **literal concatenation of two files.** No templating logic, no conditionals, no
section selection. The moment it gets clever it becomes unauditable by the AI it governs.

#### Options considered

**Option A — Two hand-authored files** (the status quo). Every universal rule written twice; drifts.
**This is what produced this ADR.** Rejected.

**Option C — `/fw-init` composes it at project birth** (AI command). Rejected as the *primary*
mechanism: **bootstrap paradox** — `CLAUDE.md` is what tells Claude how to behave, so generating it runs
*ungoverned*, before the contract is loaded. It is probabilistic where ADR-006 D6 says be deterministic
(the same reasoning FEAT-175 used to make `fw-new.sh` strict), and it trades a build-time hard error for
"hopefully the user ran the command." `Setup-Framework.ps1` is already deterministic and already runs.

**Option C survives as a separate feature, not a replacement.** The AI-judgment gap it targets is
real and derivation does not cover it: *what kind of project is this? which optional sections apply?
what belongs in Project-Specific Notes?* That composes **the shell**, never the contract. → file as a
FEAT (see Open Questions).

### D5 — Response Style belongs in the contract

**Decided.** The bottom-line-up-front response guidance added 2026-07-13 is a
**universal binding rule on AI behavior** — exactly D1's criterion (1). It therefore lives in the
contract and reaches every channel by D4's composition mechanism.

It is **not** a personal preference to be kept in the user's `~/.claude/` or in this repo's root file
only. Keeping it there while claiming "the framework ships its contract to every project" is the
dogfooding violation in miniature — the same one this ADR exists to fix.

### D6 — Retire `CLAUDE-QUICK-REFERENCE.md`. Onboarding is a command, not a document.

**Decided 2026-07-14.** The file is deleted, the recommendation at `framework/CLAUDE.md:7` is deleted
with it, and **no replacement document is authored.**

**The goal was real; the artifact was the wrong shape for it.** The stated intent — a low-friction way
in for someone new, human or AI — is worth keeping. But a *document* has to guess the reader's level,
so it either overwhelms or under-serves. `CLAUDE-QUICK-REFERENCE.md` guessed wrong in both directions:
334 lines while declaring itself *"<200"* (`:196`), and it **does not ship** — the build copies
`framework/docs/`, `templates/`, `tools/`, and `framework/CLAUDE.md` **by name**, and this file is in
none of them. **The onboarding aid never reached a single newcomer.** It only ever helped someone
already inside the framework's source repo. It was also the fourth copy of the contract.

**And the recommendation was worse than the file.** `framework/CLAUDE.md:7` told every project to author
its own `CLAUDE-QUICK-REFERENCE.md` — **a summary layer D3 forbids, of a file the framework does not
ship them.** That line is not content to relocate; it is a policy to reverse.

**The goal transfers to `/fw-tour` — FEAT-115, already filed** (2026-02-06, `backlog/`). And note where
FEAT-115 *came from*: it was filed **because ad-hoc AI tours failed.** FEAT-011 validation feedback
(hello-father project): *"Tour of the framework was a bit too verbose but it was thorough."* So *"just
ask the AI"* was tried, and FEAT-115 is the bug report. What a tour command adds is not content — it is
**scope control** (quick / detailed / by-topic), which is exactly what a document cannot offer and a
prompt can.

**Why this is the right shape, and the general principle it exposes:** a tour command **reads live
state** — `framework.yaml`, the installed `.claude/commands/`, the user's actual `work/doing/`. It
therefore **cannot go stale.** That is precisely the property the retired file lacked, and it
generalizes:

> **Every framework artifact that has rotted is a document. Nothing that executes has rotted.**

Docs restate; commands derive. This is D3's rule (no summary layers) arriving at the same place from a
different direction, and it is the thread behind Open Question 7.

**`/fw-tour` does not block this ADR.** FEAT-115 stays in `backlog/` and is normal work. The contract
carries a one-line bootstrap pointer to it — legitimate under D1 criterion (2) — which is inert until
the command exists.

**`QUICK-START.md` survives, as the AI-less fallback only.** A human browsing the repo cold cannot run a
slash command, and `README.md` already points them at `QUICK-START.md` — the conventional chain, and it
already ships. Its job is **to hand off, not to be complete**: get the reader to the point where they can
ask the AI. It is **explicitly not a source of authority** — nothing may be true *because QUICK-START says
so* (D3 still binds). That constraint is what keeps it from becoming the fifth copy.

#### Evidence: the same rot, caught live while deciding this (2026-07-14)

Both `QUICK-START.md` files were audited during this decision. Every defect found was a **reference table
living in a tutorial** — restating content that has a real owner. This is D3's failure mode, observed:

| File | Defect | Owner it should have pointed at |
|---|---|---|
| `templates/starter/QUICK-START.md` | Commands table listed **5 of 11** | `/fw-help` (reads installed commands) |
| `templates/starter/QUICK-START.md` | Templates table omitted **TASK** | `.claude/scripts/work-item-types.txt` |
| `/QUICK-START.md` (root) | Commands table listed **9 of 11** | *(same)* |
| `/QUICK-START.md` (root) | Types table advertised retired **`DECISION`**, omitted **TASK** | *(same)* |
| `/QUICK-START.md` (root) | WIP limit given as **"1-2"** and **"max 2"** — actual is **1** | `doing/.limit` |
| `/QUICK-START.md` (root) | "Full Reference" → **`framework/CLAUDE.md`** | the file **D2 deletes** |

The root file's commands table carried the epitaph: *"**Note:** Keep this list updated as new commands
are added."* **It asked to be hand-synced. It was not.** That is the entire argument for D3 in one line.

**Fixed by deletion, not by update** (2026-07-14) — the tables are gone and replaced by pointers, so the
drift cannot recur. Two further stale copies were found downstream and corrected at the same time:
`workflow-guide.md:1116` (metadata example still said `Decision`, omitted `Task` — contradicting the
correct 5-type table 40 lines below it) and `GLOSSARY.md` (no `Task` entry; "Work Item" defined with the
retired set; ADRs located at a `project-hub/decisions/` that has never existed). **TECH-173 shipped
ADR-006's enforcement but did not complete its own "DRY every human-facing list" criterion** — these were
the residue.

### D7 — There are not three checkpoints. There is one rule, enforced at three surfaces.

**Decided 2026-07-14 (resolves OQ4).** The "three mandatory checkpoints (Step 4 / 7.5 / 8.5)" are a
**fiction invented by the summary layer.** They appear only in `framework/CLAUDE.md` and
`CLAUDE-QUICK-REFERENCE.md` — the two files this ADR retires. They were never written back to ADR-001
(which decided **one** checkpoint), never added to `workflow-guide.md` as a set, and their step numbers
point into **a workflow that has never existed in any file** (`workflow-guide.md` has 5 phases; ADR-001
has 8 steps; there is no 7.5 and no 9).

**The one rule:**

> **No code without an approved, ripe plan.**

It is enforced at three surfaces, and *only the first is prose*:

| | **Rule 1 — a plan exists, and it is where it belongs** | **Rule 2 — the plan is ripe** | **Rule 3 — the work is complete** |
|---|---|---|---|
| **Surface** | **The contract** (`CLAUDE.md`) | `/fw-move → doing` | `/fw-move → done` |
| **Mechanism** | Prose. **Unenforceable by construction.** | `check_readiness()` (greps TODO/TBD/DECIDE/Option A-B-C/placeholders, blocks unless `--force`) + dependency check (**never** `--force`-able) + `fw-move.md:96-103` forces the AI to review and **STOP** | `check_acceptance_criteria()` — every `- [ ]` must be `- [x]`. **Not `--force`-able.** |
| **Reliability** | Probabilistic. Occasionally fails. | Deterministic + forced review at a chokepoint. **Works.** | Deterministic. **Works.** |
| **Human approval is…** | …the thing the rule asks for | …implicit in typing `/fw-move <id> doing` | …**the act of typing `/fw-move <id> done`.** No further review step needed — or wanted. |
| **Contract carries** | **This rule, verbatim** | **Nothing** | **Nothing** |

**Rule 1 is the only true AI guard**, and the reason is structural: *`fw-move` cannot enforce a rule
against an AI that never calls `fw-move`.* An AI that implements an item straight out of `backlog/`
never triggers a transition, so no gate can intercept it. That failure is unreachable from the state
machine — which is exactly what makes the rule **contract material** rather than guide material.
**Relocating it to `workflow-guide.md` (as D2's original table proposed) would ship it to a file the AI
never auto-loads. That is BUG-181, re-committed.**

#### The rule's text changes

Today (root `CLAUDE.md:9`, `templates/starter/CLAUDE.md:8` — identical):

> *"**Before writing code:** State what you plan to do and wait for approval"*

**Replaced by:**

> **Implement only work in `doing/`.** Planning and refinement may happen in `backlog/`, `todo/`, or
> `doing/`. Implementation may not — move the item to `doing/` first (`/fw-move <id> doing`), which is
> what validates the plan is complete and current.

**Why the change (Gary, 2026-07-14).** The old wording buys *a plan*; it does not buy *a ripe plan*, and
it does not say **where** the plan must be. In practice Rule 1 has been **holding** — when the AI works
out of `backlog/`, there *is* a work item with an approach in it. The residual failure is subtler and
more dangerous: **the item was a seed, not a mature plan**, and by working out-of-band the AI **bypassed
the ripeness test entirely.** The old text is satisfiable by announcing a plan and coding immediately —
which is the observed failure. The new text makes the *folder* the gate, and the folder is a fact.

**And it routes Rule 1 into Rule 2 by construction:**

> Rule 1 says implementation requires `doing/`. Reaching `doing/` requires `/fw-move`. `/fw-move`
> enforces ripeness and forces the review. **Therefore: no implementation without a ripe, reviewed
> plan — and only the first link is prose.**

**The contract's whole job reduces to one thing: get the AI into the machine.** Everything downstream is
mechanized. This is why the contract can be ≤150 lines (D1) — *most rules do not belong in it.*

**Note the separation is on the verb, not the location.** Planning, refining, and researching a work item
in `backlog/` or `todo/` is **legal and normal** (this ADR was written that way). Only *implementing* is
gated.

#### What `/fw-move → doing` actually guarantees (stated honestly)

Not "the plan is mature." Precisely:

> A **deterministic** rejection of items with *declared* incompleteness (unresolved markers, unmet
> dependencies), plus a **behavioral** review that must surface *undeclared* incompleteness.

**Neither half is sufficient alone.** `grep` cannot see a confident-but-thin plan; the review cannot be
trusted to fire unless the transition forces it. **The mechanism's value is that it makes the review
unavoidable at the exact moment the plan is committed to.** The AI cannot arrive in `doing/` without
passing through it. Do not let a future reader believe the gate proves maturity — it proves the *absence
of declared* immaturity, and forces a human-plus-AI look at the rest.

#### Rule 3 gets no review step — deliberately

`fw-move.md`'s `→ done/` block is pure post-processing (stamp `Completed`, session history, commit,
volume nudge). **It has no "present the work for approval" step, and none should be added.** The
acceptance-criteria gate is a *better* completion test than a review prompt: checking off every `- [x]`
is an explicit, itemized assertion, and the script refuses the move until it is made. And **completion
already requires a human keystroke** — `/fw-move <id> done` does not happen unless the user types it.
There is no "AI accidentally completes an item" failure mode. **The approval is the command.**

**Not affected by TECH-177** (Obsidian checkbox states). That item makes the done-gate *smarter* —
`[/]` in-progress blocks, `[-]` cancelled passes — but it does not add a review step or move the gate.
It is the model working as intended: **the response to a gap in a mechanized rule is a better mechanism,
not a new paragraph.** (More evidence for OQ7.)

#### Consequences for the retiring files

- **ADR-001 is not rewritten.** It is the decision record for Rule 1 and stands as-is. Its
  "Implementation Details" section (an 8-step list to paste into `CLAUDE.md`) is historical, not
  binding.
- **`workflow-guide.md` keeps the pre-implementation review procedure** (`:2214-2290`) — it already
  owns it in full.
- **Fix the phantom pointers.** `workflow-guide.md:2246` and `:2290` cite *"CLAUDE.md Step 7.5"*;
  `:212` and `:1760` cite *"CLAUDE.md Step 9"*. **None of these exist.** Repoint to `fw-move.md` or
  inline the content.
- **The names "Step 4 / 7.5 / 8.5" are deleted.** Use: *the contract rule*, *the pre-implementation
  review*, *the done-gate*.

#### The unsolved problem, stated plainly

**Rule 1 is unenforced, and this ADR does not fix that.** Nothing in the framework can stop an AI from
editing `src/` while `doing/` is empty. The bootstrap block, `fw-move.md`, and `workflow-guide.md` are
all the *same* mechanism — telling the model, and hoping. **Layering a fourth restatement is the
strategy that has "mostly worked but occasionally not,"** and it is precisely the summary layer D3
forbids.

This is the framework's **founding constraint** — the eagerness problem it was built to solve (HPC
project, "ONE issue at a time," 2025-11-26, three weeks before the framework repo existed) — and its
longest-standing unsolved one: **a deterministic process driven by a probabilistic agent.**

The check *"is `doing/` empty while I am about to edit code?"* is **mechanically decidable.** It cannot
live in a document — a document can only ask; something that *executes* would have to refuse.
**TECH-114 (`wip-enforcement-hook`, backlog)** is the only class of fix that could make Rule 1
deterministic. **ADR-007 does not depend on it and must not claim enforcement it does not have.**

---

## Consequences

**Positive**
- The contract reaches derived projects for the first time.
- **Contracts become upgrade*able*** — the delimited region is what a future upgrade would need in order
  to re-derive the contract without touching the user's notes. **This ADR ships the markers, not the
  upgrade tooling** (blocked on Open Question 1). Nothing in the framework can re-derive `CLAUDE.md`
  today, which is why derived projects would rot even if we shipped the contract correctly once.
- ~827 lines of duplicated documentation retired (501 + 334, less ~8 relocated).
- Eight verified drift defects are fixed by deletion rather than by maintenance.
- Auto-loaded context per session drops substantially, in every project, forever.
- **CLAUDE.md joins the derivation model the rest of the framework already uses.** TECH-169,
  DECISION-162, and FEAT-179 become instances of a stated rule instead of separate negotiations.

**Negative / risks**
- Deleting 835 lines will feel like losing something. It is not: the content is verified present in the
  guides. **The audit must be re-run at implementation time, per section, before each deletion** — do
  not trust this ADR's line counts as a licence to `rm`.
- **The region markers are themselves a new user-facing contract.** If a user edits inside the framework
  region, their change is at risk on upgrade. The delimiters must say so unmissably, the PROJECT
  INSTRUCTIONS region must be an obvious enough alternative that nobody *wants* to edit the other one,
  and re-derivation must detect a modified region rather than blindly overwrite it. *An upgrade that
  eats a user's work once will never be trusted again.*
- **`/init` collision — a tool, not a human, may rewrite the framework region** (added 2026-07-15).
  Claude Code ships a built-in `/init` whose job is *analyze the codebase and write `CLAUDE.md`.* A
  derived project's `CLAUDE.md` carries the framework region, and the user may run `/init` on it at any
  time — the two commands operate on the same file. **Documented behavior** (`code.claude.com/docs/en/memory`,
  HIGH confidence): *"if a `CLAUDE.md` already exists, `/init` suggests improvements rather than
  overwriting it."* So `/init` **updates in place; it does not regenerate** — the threat is **contamination
  of the framework region, not destruction of the file.** But *"suggests improvements"* ≠ *"preserves our
  delimited regions"*: `/init` has no knowledge of the markers, and an update pass could rewrite content
  *inside* the framework region. The `DO NOT EDIT` banner is the intended guard, but it is advisory to a
  *human*; its effect on a *model* rewriting the file is **unproven**. **Not bulletproof:** a confirmed
  overwrite bug exists (anthropics/claude-code#21795 — `/init` in `~/.claude` destroys the file without
  warning). That is the *user-level* case, so it misses the project-level framework region — but it proves
  the mechanism can fail hard. This risk **exists independently of whether `/fw-init` is ever built** (see
  OQ1, OQ5): the collision is between the framework region and a *built-in* command.
  **Observed live on this repo (2026-07-15):** `/init` was run against this repo's existing `CLAUDE.md`.
  It did **not** overwrite or edit the file — byte-identical before and after (md5 `fe69a147…`), confirming
  the *suggests-rather-than-overwrites* behavior empirically. **But the improvements it proposed would, if
  accepted, contaminate the region anyway:** it wanted to replace the heading + Bootstrap block with its
  own standard `# CLAUDE.md` prefix, and to inline a build/test command section — content the framework
  deliberately keeps *out* of `CLAUDE.md` and *in* `framework.yaml` (`release:*.build_script`,
  `sources.testing`). So the threat is not that `/init` writes uninvited; it is that **accepting `/init`'s
  suggestions is the edit**, and `/init` has no concept of the framework markers when it composes them.
  The `DO NOT EDIT` banner is the only thing standing between "suggests improvements" and a rewritten
  contract — and whether a model composing suggestions will honor a banner it can see is still unproven.
- **A partitioned file is harder to reason about than a file that is wholly one thing.** The cost is
  real; it is paid to keep the file user-editable, which is non-negotiable for a derived project. The
  two-region partition is the cheapest form of it — every line has exactly one owner, and both owners
  are named in the file.
- `docs/collaboration/README.md`, `architecture-guide.md`, and `workflow-guide.md` all reference
  `CLAUDE.md`'s structure (including its nonexistent Step 9). Those references must be fixed, not
  orphaned.
- **`framework.yaml:76` routes into the file D2 deletes** (verified 2026-07-14):
  `ai-checkpoint-policy: framework/CLAUDE.md#ai-workflow-checkpoint-policy-critical---adr-001`. The
  framework's own SoT index points at `framework/CLAUDE.md`. **Now that OQ4 (→ D7) is resolved, the
  target is known:** Rule 1 lives in the *contract*, and the contract is authored in
  `.claude/framework-contract.md` (OQ2) and delivered in each channel's `CLAUDE.md`. Repoint
  `ai-checkpoint-policy` at ADR-001 (the decision record for the rule) rather than at any `CLAUDE.md`
  copy — the policy's *authority* is ADR-001; `CLAUDE.md` is only its *delivery*. **D2 cannot be
  implemented without also fixing `framework.yaml`.**
- **Dropping "Which Project Are You Working On?" (D2a) changes how this repo is navigated.** Confirm the
  `framework/` `templates/` `tools/` orientation exists in `README.md` before deleting it from the
  contract.

---

## Open Questions

1. **How does re-derivation detect a modified contract region?** D4's upgrade path is the ADR's best
   payoff and its sharpest edge. Hash the region and compare against the shipped fragment? Silent
   overwrite is not acceptable. The two-region partition gives us the good answer — **relocate the
   user's edits into PROJECT INSTRUCTIONS and report it** — but the *detection* mechanism still needs
   choosing. *Highest-risk unknown; settle before implementation, not during.*
   - **Broader than first drafted (2026-07-14):** detection must cover a *tool* rewriting the file, not
     only a human editing text. The `/init` collision (see D4 Negative Consequences) is the concrete
     case — a built-in command performs an update pass with no knowledge of the markers. The requirement
     is therefore *"region contaminated, drifted, or gone,"* not merely *"region differs from a known
     prior version because a person typed in it."* A hash-compare handles both, but the recovery UX
     differs: a human edit relocates cleanly to PROJECT INSTRUCTIONS; a tool's contamination may have no
     clean seam and may need a full re-derive of the region.
   - **Candidate mechanism — `/fw-init` as the idempotent region-owner / repair command** (folds in OQ5).
     A command that **owns exactly one region and touches nothing else** is the natural repair for
     contamination: run `/init`, region drifts, run `/fw-init`, region is re-asserted clean. It is useful
     in *every* channel (archive-derived, plugin-only, brownfield, post-`/init` repair), is **not blocked
     on OQ7**, and is arguably part of OQ1's *answer* rather than a consumer of it. It does **not** replace
     the *detection* question — a repair command still needs to know the region was modified before it
     re-asserts — but it is a strong candidate for the *repair* half. See OQ5.
   - Sub-question: does the framework region carry a version stamp (`v1.4.0`) so an upgrade knows
     whether it is replacing an older contract or a tampered one? A stamp also makes the delimiter
     self-describing to a human reading the file cold — **and gives a repair command a cheap contamination
     check** (stamp present and region-hash matches that version → clean; else → repair).
2. ~~**Where does the contract fragment live?**~~ **RESOLVED 2026-07-15 → `.claude/framework-contract.md`.**

   **Decided: the fragment is `.claude/framework-contract.md`.** The two constraints are met, and the
   location joins the build pattern that already works.
   - **Not named `CLAUDE.md`** — the D2 mistake is undone.
   - **Not under `framework/docs/`** — so Step 3's recursive `docs/*` sweep (verified `:213-218`) cannot
     pick it up. No new exclusion logic is needed; the placeholder `framework/docs/ref/ai-contract.md`
     would have required *adding* a Step-3 exclusion, which this location avoids entirely.
   - **It sits with its build-siblings.** `.claude/` already holds the three assets the build copies
     fresh-from-canonical — `commands/*.md` (Step 1.5), `scripts/*.sh` (Step 1.6),
     `scripts/work-item-types.txt` (Step 1.6b). The contract fragment is the same *kind* of thing: an
     authored-once source the composer reads. Its natural home is beside them, not in the product docs.
   - **Name ↔ marker.** The folder supplies *"claude"* (it is `.claude/`); the file name supplies
     *"framework-contract"*, which matches the D4 region marker `BEGIN FRAMEWORK CONTRACT` word-for-word.
     Both words are present — one in the path, one in the name — with no stutter, and **D4's marker text
     needs no change.**

   **`framework.yaml` does NOT point at it** (decided in the same discussion). `sources:` indexes
   *runtime* SoTs the AI consults *while working*. The fragment is **build input**, consumed once at
   composition time; the AI never reads `framework-contract.md` at runtime — it reads the *assembled*
   `CLAUDE.md`. Indexing the fragment in `sources:` would resurrect the "is the contract in the fragment
   or in `CLAUDE.md`?" confusion. Answer: **authored in the fragment, delivered in `CLAUDE.md`, and the
   AI only ever sees the delivery** — exactly as `framework.yaml` does not point at
   `templates/starter/CLAUDE.md` today.

   **Is this duplication? No — derivation, provided the composed region is generated and guarded.** The
   contract text does exist in the fragment *and* in every built `CLAUDE.md` after a build — but they
   **cannot drift**, because the fragment is the only *authored* copy and the `CLAUDE.md` copies are
   *regenerated* on every build (like a compiler's object code, which nobody calls duplication). This is
   the same bet the build already makes three times (`work-item-types.txt`, `commands/`, `scripts/`), and
   the **drift-guard at `:113-132` is the proof it's not duplication** — it *hard-fails the build* if a
   copy of these appears in `templates/starter/`. The fragment model extends that same regime to
   `CLAUDE.md`'s contract region. **It does not add an editable copy; it removes one** — today
   `framework/CLAUDE.md` (501 lines) and `starter/CLAUDE.md` (82) are *both* hand-authored and *both*
   ship; the fragment collapses them to one authored source.
   - **Implementation note for D2/D4.** The composer step must **(a)** read `.claude/framework-contract.md`,
     **(b)** concatenate it into the guarded region of each channel's root `CLAUDE.md` (literal
     concatenation — D4 "keep the composer stupid"), and **(c)** be covered by a drift-guard extension so
     a hand-edited contract region in `templates/starter/CLAUDE.md` (or this repo's root) fails the build
     rather than shipping drift. Without (c), the construct *degrades to* duplication. The build already
     has the guard machinery (`:113-132`); this adds the `CLAUDE.md` contract region to what it watches.
3. ~~**`CLAUDE-QUICK-REFERENCE.md` — keep the goal, kill the copy?**~~ **RESOLVED 2026-07-14 → see D6.**
4. ~~**Where do the three checkpoints live** — `workflow-guide.md` alone, or ADR-001?~~ **RESOLVED
   2026-07-14 → see D7.** The premise was false: **there is no set of three.** One rule (contract), two
   mechanized enforcements (`/fw-move`). ADR-001 stands unrewritten.
5. **`/fw-init` — not a separate FEAT. Folds into OQ1 as the idempotent region-owner.** *(discussed at
   length 2026-07-14; resolved to a direction, not yet a FEAT)*

   The draft asked simply *"does `/fw-init` get filed as a FEAT?"* The discussion blew the question open:
   `/fw-init` denotes **at least four different commands**, and the name collides with the built-in `/init`.

   **The four readings, and why three collapse:**

   | Reading | Job | Status |
   |---|---|---|
   | **Shell composer** (D4 Option C) | fill per-project bits of `CLAUDE.md` at birth | **Redundant** — `Setup-Framework.ps1` already substitutes identity placeholders deterministically |
   | **Scaffolder** (plugin-only) | create `project-hub/`, `framework.yaml`, `.limit` | **Only meaningful if OQ7 → commands-only.** Today the distribution archive scaffolds; the command would be redundant-or-foundational depending on OQ7 — the signature of a decision not to make now |
   | **Brownfield adopter** | add the framework to a project that already has a `CLAUDE.md` and conventions | **Blocked on OQ1** — this is the hard case D4 did not solve |
   | **Idempotent region-owner / repair** | (re-)assert the framework region, non-destructively, in place | **The strongest reading** — see below |

   **The naming insight (Gary):** a user who knows `/init` — *analyze the codebase and write `CLAUDE.md`*
   — will expect `/fw-init` to **edit `CLAUDE.md`.** For the region-owner reading that expectation is
   *helpful*: it matches. For the scaffolder reading it is *misleading*: scaffolding directories is not
   what `/init` does.

   **Why the region-owner reading wins.** If `/init` **updates rather than replaces** (verified — see D4
   Negative Consequences), a `/fw-init` that owns exactly one region and touches nothing else is its
   natural companion: the repair for `/init` contamination, and equally the tool for archive-derived,
   plugin-only, and brownfield channels. It is **not blocked on OQ7**, and it is plausibly **part of
   OQ1's answer** (the *repair* half) rather than a consumer of it.

   **So `/fw-init` is not filed as a standalone FEAT here.** Its live reading folds into **OQ1** as a
   candidate mechanism for non-destructive region re-derivation. The other three readings are parked: the
   shell composer is redundant, the scaffolder waits on OQ7, the brownfield adopter waits on OQ1. If any
   is ever wanted, it is a *different* command with a *different* name — three jobs, three names, not one
   overloaded `/fw-init`. **Whether the region-owner ships as its own FEAT or as part of OQ1's upgrade
   tooling is deferred until OQ1's detection mechanism is chosen** — the repair command needs detection to
   exist first.

   **Bonus finding from running the live `/init` test (2026-07-15) — more OQ7 evidence.** `/init`'s
   suggested "improvements" included a **build/test command section for `CLAUDE.md`.** But those pointers
   *already exist and already derive from live config*: `framework.yaml` names every `build_script`
   per-channel (`release:*.build_script`) and a `sources.testing` SoT — and the Bootstrap block already
   routes the AI to `framework.yaml`. **There was no gap; `/init` wanted to restate in a document what the
   framework already indexes in config.** That is the document-vs-executable thread (OQ7) from a third
   direction: the reflex of a general tool is to *write pointers into prose*; the framework's design is to
   *derive them from a machine-readable index.* Recorded here, not filed — it is confirmation of D3/OQ7,
   not new work.
6. **Is a contract-less channel an acceptable product, or a gap?**

   **Verified 2026-07-13: the plugins have no contract surface.** Neither `plugins/spearit-framework/`
   nor `plugins/spearit-framework-light/` ships a `CLAUDE.md` — only `commands/`, `skills/`, `README.md`,
   `CHANGELOG.md`, `PROJECT-STATUS.md`. **A plugin user's AI receives no collaboration contract at all.**

   **This is by design, and the design has a cost.** The plugin's value proposition is *self-contained
   and lightweight* — no framework directory, no guides, no overhead. The yin/yang (stated design intent,
   2026-07-13): it trades **structure and nuance** for **weight**. And a project *picks one channel* —
   full framework **or** plugin-full **or** plugin-light — so a plugin user does not get the contract
   "from the framework side." There is no framework side.

   So the question is not *"how do we ship the contract to the plugins too?"* (that would make them the
   thing they exist not to be). It is:

   > **Is "no collaboration contract" an acceptable point on the lightness/structure curve — or is the
   > contract the one thing that must not be traded away?**

   Consider: ADR-001's checkpoints, the resume-work rule, and Response Style are *behavioral guarantees*.
   A plugin user gets `/fw-move`'s mechanical enforcement but none of the behavioral contract — arguably
   the more valuable half. A **minimal contract** (the ~8 unique rules, not the guides) might cost the
   plugin very little weight.

   **Not settled here.** But *"out of scope"* is the wrong answer, and stating it as one would bury a
   real product question. **Flag it; decide it deliberately** — possibly in its own ADR, since it is a
   question about what the plugin *is*, not about `CLAUDE.md`.

   **Update 2026-07-14 (see OQ7):** D6 supplies evidence on one side. `/fw-tour` — the onboarding
   surface — is a **command**, and commands are exactly what the plugins already ship. A plugin user
   could get the full onboarding experience *without* the framework's ~4,000 lines of guides. If the
   behavioral contract can likewise be delivered as commands, the lightness/structure trade OQ6 poses
   may be **a false choice.**

7. **Is the framework, long-term, just a collection of commands?** *(raised 2026-07-14; not answered
   here)*

   Every framework artifact that has rotted is a **document**: `framework/CLAUDE.md` (8 verified
   defects), `CLAUDE-QUICK-REFERENCE.md` (334 lines claiming <200, never shipped), both
   `QUICK-START.md` files, `workflow-guide.md`'s metadata example, `GLOSSARY.md`'s type list.
   **Nothing that executes has rotted** — `/fw-move`, `/fw-status`, `/fw-wip` read live state, so
   there is no copy to drift from.

   That is not a coincidence, and D3 ("no summary layers") is the same observation arriving from
   another direction: **documents restate; commands derive.** D6 is one step along this line — an
   onboarding *document* retired in favor of an onboarding *command*. **D7 is a second**: of the one
   rule's three enforcement surfaces, the two that *execute* work, and the one that is *prose* is the
   one that occasionally fails.

   **The sharper formulation (2026-07-14):** it is not merely that commands execute. **Commands own
   chokepoints, and documents do not.** `/fw-move` works because the AI cannot reach `doing/` without
   passing through it — a moment where a single well-targeted instruction lands with full context. The
   contract works, when it works, because session-start is the *only other* chokepoint in the system.
   **A rule is reliable in proportion to whether the AI must stop somewhere to obey it.**

   **Corollary, and this is the design lever:** every rule moved from the contract to a command
   converts a probabilistic guarantee into a deterministic one. **The contract is where rules go when
   they cannot be mechanized — it is a residue, not a home.** The smaller it gets, the more of the
   process is actually enforced.

   The question this raises is bigger than `CLAUDE.md` and should not be answered inside this ADR:
   **if the durable surface is executable, what is the guide layer for?** Note that answering it would
   also collapse **OQ6** — a commands-only framework and the plugins become the same product, and the
   lightness/structure trade-off disappears.

   **Flag only.** ADR-007 is a step in this direction, not a commitment to it. Worth its own ADR when
   the thread is pulled.

---

## Related

- **ADR-006** — established one-authored-source + per-channel derivation for the work-item type SoT.
  This ADR applies the same principle to the collaboration contract. **The precedent is the argument.**
- **ADR-001** — the checkpoint policy. **Decided ONE checkpoint, not three** (D7). Its Rule-1 text does
  reach derived projects (`starter/CLAUDE.md:8`) — it is the *only* part of the contract that does.
  **Not rewritten by this ADR**; it is the decision record for Rule 1.
- **TECH-114** — `wip-enforcement-hook` (backlog). **The only class of fix that could make Rule 1
  deterministic** — a hook observes the edit whether or not the AI cooperates. D7 depends on it for
  nothing; it is named so the unsolved problem has an address.
- **TECH-177** — Obsidian checkbox states. Refines the done-gate's semantics (`[/]` blocks, `[-]`
  passes). **Does not reopen D7** — the response to a gap in a mechanized rule is a better mechanism,
  not a new paragraph.
- **BUG-181** — the presenting bug (starter `CLAUDE.md` does not deliver the contract). Becomes an
  *instance* of this ADR; re-scope it against D4's composition mechanism at implementation time.
- **DECISION-162 / TECH-169** — command-tier sync strategy and `/fw-move` copy reconciliation. Same
  unstated rule, different artifact. Feed this ADR's answer into them.
- **SPIKE-178 / FEAT-179** — plugin engine derivation. Same pattern.
- **FEAT-175** — `/fw-new` create gate. Its "strict script, lenient AI" split is the same
  deterministic-vs-probabilistic reasoning that argues against D4 Option C.
- **FEAT-115** — `/fw-tour`. **D6 hands it the onboarding goal.** Filed 2026-02-06 *because ad-hoc AI
  tours were too verbose* (FEAT-011 validation) — which is why "just ask the AI" is not the answer on
  its own. Stays in `backlog/`; **does not block this ADR.**
- **FEAT-180** — mandatory `## Documentation` section on work items. The structural fix for the drift
  class D6 documents: no new machinery, since `fw-move.sh` already hard-blocks `→ done/` on an
  unchecked `[ ]`. Its premise was confirmed again by the six defects in the D6 evidence table.
- **TECH-173 / ADR-006** — shipped the type SoT and its enforcement, but **did not complete its own
  "DRY every human-facing list" criterion.** The residue (`workflow-guide.md:1116`, `GLOSSARY.md`) was
  found and fixed 2026-07-14 while deciding D6.
- **`documentation-dry-principles.md`** — the framework's own DRY doctrine, which `framework/CLAUDE.md`
  violates about as thoroughly as a single file can.

---

**Last Updated:** 2026-07-15 (Accepted)
