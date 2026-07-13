# ADR-007: The AI Collaboration Contract — What CLAUDE.md Is, and How It Reaches Each Channel

**Status:** Proposed
**Date:** 2026-07-13
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
| **The three checkpoints** (Step 4 / 7.5 / 8.5) | → `workflow-guide.md` (which already owns Step 7.5 and is where the workflow lives). Contract carries the one-line Core Rule + a pointer. **Fix the step numbers** — they currently reference a nonexistent 11-step workflow. |
| **Claude Code Permissions** | → `docs/collaboration/security-policy.md` (or a `docs/ref/` page). **Rewrite it — it is currently false.** |
| **Everything else (~490 lines)** | → **deleted.** Already owned by `docs/collaboration/` and `docs/ref/`. |

**Rationale:** a `CLAUDE.md` Claude never loads is a misleading filename on a duplicate document. Adding
a link from the root file to it would be patching around a file that should not exist.

**Also on the table (see Open Questions):** `framework/CLAUDE-QUICK-REFERENCE.md` (334 lines) is the
*fourth* copy and duplicates most of the fifth. Retiring it is very likely correct and should be decided
here rather than left to rot.

#### D2a — The root cause: this repo is ONE project, not three

`framework/CLAUDE.md` did not appear by accident. It was licensed by a framing in the **repo's own root
`CLAUDE.md`**: the section *"Which Project Are You Working On?"* (`CLAUDE.md:62`), which asks the AI to
decide whether it is working on *the framework*, *template packages*, or *build tooling* — and then
routes it to `framework/CLAUDE.md` for the first.

**If there are three projects, each may have its own `CLAUDE.md`. There are not.** The repo *is* the
project — `framework.yaml` says so (`project.name: "SpearIT Project Framework"`, one entry). `framework/`,
`templates/`, and `tools/` are **subdirectories of one project**, not peer projects. The sub-project
framing is what created a second contract, and the second contract is what rotted.

**Therefore:** the repo's root `CLAUDE.md` drops *"Which Project Are You Working On?"* and its
sub-project routing. What survives is ~15 lines of *"`framework/` is the product, `templates/` packages
it, `tools/` builds it"* — and that is a **README concern, not a contract concern.** Verify it is not
already in `README.md` before restating it (per D3: there are no summary layers).

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
**explicitly partitioned into two marked regions** — one owned by the framework, one owned by the user.
Every line in the file has an owner.

```markdown
# Claude Context: {{PROJECT_NAME}}

<!-- ─────────────────────────────────────────────────────────────────────
     BEGIN FRAMEWORK CONTRACT — v{{FRAMEWORK_VERSION}}
     Derived from the framework. DO NOT EDIT — this region is replaced on
     framework upgrade. Put your own instructions in the USER INSTRUCTIONS
     region below; the framework never touches it.
     ───────────────────────────────────────────────────────────────────── -->

... the universal contract, authored once ...

<!-- END FRAMEWORK CONTRACT -->


<!-- ─────────────────────────────────────────────────────────────────────
     BEGIN USER INSTRUCTIONS
     This region is YOURS. The framework will never modify or overwrite it.
     Add your project's conventions, standards, preferences, and any
     standing instructions for the AI.
     ───────────────────────────────────────────────────────────────────── -->

<!-- Your project's conventions and standing instructions go here. -->

<!-- END USER INSTRUCTIONS -->
```

**Mark BOTH regions, not just the contract.** With only the framework region marked, everything outside
it is "not-contract" *by default* — an edit above the block, or a section the framework later wants to
own, lands in undefined territory and the upgrade tool has to guess. Two explicit regions make the file
a **partition**: `[framework][user]`, no ambiguity, nothing to infer.

It also inverts the message in the way we want. `DO NOT EDIT` alone reads as a fence; `BEGIN USER
INSTRUCTIONS` reads as an **invitation** — *this is yours, put your things here.* A user with nowhere
obvious to write will edit the contract block. Give them somewhere obvious.

**The user region ships non-empty.** It carries a placeholder comment from birth, not two bare
delimiters — an empty marked region reads like scaffolding to be deleted.

**And it buys a humane upgrade failure mode.** If re-derivation finds the framework region was edited,
it need not choose between silently overwriting (unacceptable) and refusing (useless): it can **relocate
the user's edits into the USER INSTRUCTIONS region and tell them it did.** That is only possible because
there is somewhere to move them *to*. (See Open Question 1.)

**The decomposition (this is the whole decision):**

| Layer | Universal? | Authored where | How it reaches a channel |
|---|---|---|---|
| **Contract** | Yes — identical in every channel | **Once**, in a fragment (e.g. `framework/docs/ref/ai-contract.md` — *not* named `CLAUDE.md`) | **Derived** into the guarded region |
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

#### The payoff nobody asked for: upgradeable contracts

Because the region is delimited and the shell is untouched, **a framework upgrade can re-derive the
contract block in place** without clobbering the user's notes.

**Nothing in the framework can do this today.** An upgrade currently cannot touch a derived project's
`CLAUDE.md` at all — which is precisely why derived projects would rot even if we shipped the contract
correctly once. Region-derivation is what makes the contract a *living* dependency rather than a
one-time stamp.

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

**Decided (pending D4's mechanism).** The bottom-line-up-front response guidance added 2026-07-13 is a
**universal binding rule on AI behavior** — exactly D1's criterion (1). It therefore lives in the
contract and reaches every channel by whatever D4 settles.

It is **not** a personal preference to be kept in the user's `~/.claude/` or in this repo's root file
only. Keeping it there while claiming "the framework ships its contract to every project" is the
dogfooding violation in miniature — the same one this ADR exists to fix.

---

## Consequences

**Positive**
- The contract reaches derived projects for the first time.
- **Contracts become upgradeable.** The guarded region lets a framework upgrade re-derive the contract
  in place without touching the user's notes. Nothing in the framework can do this today — which means
  today's derived projects would rot even if we shipped the contract correctly once. This is the
  sleeper benefit of D4.
- ~800 lines of duplicated documentation retired (501 + 334, less ~8 relocated).
- Seven verified drift defects are fixed by deletion rather than by maintenance.
- Auto-loaded context per session drops substantially, in every project, forever.
- **CLAUDE.md joins the derivation model the rest of the framework already uses.** TECH-169,
  DECISION-162, and FEAT-179 become instances of a stated rule instead of separate negotiations.

**Negative / risks**
- Deleting 835 lines will feel like losing something. It is not: the content is verified present in the
  guides. **The audit must be re-run at implementation time, per section, before each deletion** — do
  not trust this ADR's line counts as a licence to `rm`.
- **The region markers are themselves a new user-facing contract.** If a user edits inside the framework
  region, their change is at risk on upgrade. The delimiters must say so unmissably, the USER
  INSTRUCTIONS region must be an obvious enough alternative that nobody *wants* to edit the other one,
  and re-derivation must detect a modified region rather than blindly overwrite it. *An upgrade that
  eats a user's work once will never be trusted again.*
- **A partitioned file is harder to reason about than a file that is wholly one thing.** The cost is
  real; it is paid to keep the file user-editable, which is non-negotiable for a derived project. The
  two-region partition is the cheapest form of it — every line has exactly one owner, and both owners
  are named in the file.
- `docs/collaboration/README.md`, `architecture-guide.md`, and `workflow-guide.md` all reference
  `CLAUDE.md`'s structure (including its nonexistent Step 9). Those references must be fixed, not
  orphaned.
- **Dropping "Which Project Are You Working On?" (D2a) changes how this repo is navigated.** Confirm the
  `framework/` `templates/` `tools/` orientation exists in `README.md` before deleting it from the
  contract.

---

## Open Questions

1. **How does re-derivation detect a user-edited contract block?** D4's upgrade path is the ADR's best
   payoff and its sharpest edge. Hash the region and compare against the shipped fragment? Silent
   overwrite is not acceptable. The two-region partition gives us the good answer — **relocate the
   user's edits into USER INSTRUCTIONS and report it** — but the *detection* mechanism still needs
   choosing. *Highest-risk unknown; settle before implementation, not during.*
   - Sub-question: does the framework region carry a version stamp (`v1.4.0`) so an upgrade knows
     whether it is replacing an older contract or a tampered one? A stamp also makes the delimiter
     self-describing to a human reading the file cold.
2. **Where does the contract fragment live?** `framework/docs/ref/ai-contract.md` is a placeholder name.
   It must **not** be named `CLAUDE.md` (that is the mistake D2 is undoing), and it must be excluded
   from the `framework/docs/` bulk copy (Step 3) or it will ship twice.
3. **`CLAUDE-QUICK-REFERENCE.md`** — retire it (it is the fourth copy), or keep it as a project-authored
   optional artifact? Note `framework/CLAUDE.md:7` actively *encourages* projects to write one — i.e.
   the framework currently recommends creating a duplicate. Verify whether it ships to derived projects.
4. **Where do the three checkpoints live** — `workflow-guide.md` alone, or ADR-001? ADR-001 documents
   only *one* checkpoint; the three-checkpoint set exists only in the two files being retired. Whoever
   owns it must also **fix the step numbering**, which points into a workflow that does not exist.
5. **Does `/fw-init` get filed as a FEAT?** D4 rejected it as the derivation mechanism, but the
   AI-judgment gap it targets is real: composing **the shell** (project type, optional sections,
   Project-Specific Notes) at project birth. It would never touch the contract.
6. **Does the plugin have a contract surface at all?** The plugins ship commands, not a `CLAUDE.md`.
   Confirm they are out of scope here — if they are, say so; if not, they are a fourth channel.

---

## Related

- **ADR-006** — established one-authored-source + per-channel derivation for the work-item type SoT.
  This ADR applies the same principle to the collaboration contract. **The precedent is the argument.**
- **ADR-001** — the checkpoint policy. Currently reaches no derived project.
- **BUG-181** — the presenting bug (starter `CLAUDE.md` does not deliver the contract). Becomes an
  *instance* of this ADR; re-scope it once D4 is settled.
- **DECISION-162 / TECH-169** — command-tier sync strategy and `/fw-move` copy reconciliation. Same
  unstated rule, different artifact. Feed this ADR's answer into them.
- **SPIKE-178 / FEAT-179** — plugin engine derivation. Same pattern.
- **FEAT-175** — `/fw-new` create gate. Its "strict script, lenient AI" split is the same
  deterministic-vs-probabilistic reasoning that argues against D4 Option C.
- **`documentation-dry-principles.md`** — the framework's own DRY doctrine, which `framework/CLAUDE.md`
  violates about as thoroughly as a single file can.

---

**Last Updated:** 2026-07-13
