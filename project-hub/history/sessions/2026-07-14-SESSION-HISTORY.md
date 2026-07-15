# Session History: 2026-07-14

**Date:** 2026-07-14
**Participants:** Gary Elliott, Claude Code
**Session Focus:** ADR-007 — resolve OQ3 (onboarding) and OQ4 (checkpoints); D4 terminology fix

---

## Summary

Resolved two of ADR-007's open questions into new decisions (**D6**, **D7**) and corrected D4's region
label. Both resolutions overturned the draft's own proposals — OQ3's premise ("give onboarding to a
guide") and OQ4's premise ("where do the three checkpoints live") were each **false**, and finding out
why produced the ADR's central insight. Also fixed eight live drift defects across four files, on the
principle that fixing costs less than tracking.

**The through-line that emerged:** *the enforcement was already built; what was broken was the story
told about it.* Every framework artifact that has rotted is a **document**. Nothing that **executes**
has rotted. → filed as **OQ7**.

---

## Work Completed

### ADR-007: OQ3 → D6 — "Onboarding is a command, not a document"

**The draft proposed** retiring `CLAUDE-QUICK-REFERENCE.md` and giving the onboarding goal to
`docs/collaboration/README.md`.

**Gary pushed back on the premise, not the retirement:** *"the original idea behind the quick reference
was a place both human and AI could go for a 'tutorial'… I still think it's a good idea, even though we
didn't maintain it well. How can we get the same or similar benefit?"* — i.e. the goal is real; find it
a working home.

**The investigation, and three wrong turns before the right answer:**

1. **First proposal (wrong):** name `QUICK-START.md` the onboarding SoT — it already exists in both the
   repo root and the starter, and it already ships. **Problem:** two hand-authored copies of the same
   idea is exactly the duplication ADR-007 exists to end, and deriving a *tutorial* is forced (a
   tutorial is per-channel by nature).
2. **Second thought (also wrong):** *"would it be simpler to just ask the AI?"* (Gary). **Verified
   answer: no — that was already tried and it failed.** `FEAT-115` was filed 2026-02-06 *because of*
   FEAT-011 validation feedback on the hello-father project: *"Tour of the framework was a bit too
   verbose but it was thorough."* **Ad-hoc AI tours are the bug report, not the fix.** Asking works, but
   the answer is unbounded — nothing tells the AI how much is enough.
3. **The right answer:** `/fw-tour` (FEAT-115, already in `backlog/`, **postponed not abandoned**). What
   it adds over "just ask" is not content — it is **scope control** (quick / detailed / by-topic), which
   a document cannot give and a prompt can. And it **reads live state** (`framework.yaml`, installed
   commands, actual `work/doing/`), so **it cannot go stale.**

**Then Gary reframed the whole question and it collapsed:** *"the tour is helpful for new users but I'm
the primary user of the framework and it was built to help me service my clients."* → **Every artifact
under debate serves a newcomer who mostly doesn't exist yet. The thing that actually fails him every
session is that the contract doesn't reach client projects (BUG-181).** Onboarding is real but not on the
critical path.

**D6 as decided:** retire the artifact; delete the `framework/CLAUDE.md:7` line that *tells every project
to author its own* (a summary layer D3 forbids, of a file the framework doesn't even ship them); author
**no replacement**; goal transfers to FEAT-115, which **stays in backlog and does not block the ADR**.
`QUICK-START.md` survives as the AI-less fallback (README → QUICK-START is the conventional chain a cold
reader already knows), **explicitly non-authoritative** — nothing may be true *because QUICK-START says
so*.

**Two verified facts that decided it:**
- `CLAUDE-QUICK-REFERENCE.md` is **334 lines while declaring itself "<200"** at `:196`.
- **It does not ship.** `Build-FrameworkArchive.ps1` copies `framework/docs/`, `templates/`, `tools/`,
  and `framework/CLAUDE.md` **by name**. This file is in none of them. **The onboarding aid never
  reached a single newcomer.**

---

### ADR-007: OQ4 → D7 — "There are not three checkpoints"

**The draft asked:** *where do the three checkpoints (Step 4 / 7.5 / 8.5) live — `workflow-guide.md` or
ADR-001?* Gary: *"Let's review the checkpoints one by one."* Doing so **destroyed the premise.**

**Verified: the three-checkpoint set is a fiction invented by the summary layer.**
- **ADR-001 decided ONE checkpoint**, not three.
- The set of three appears **only** in `framework/CLAUDE.md` and `CLAUDE-QUICK-REFERENCE.md` — the two
  files being retired. It was never written back to ADR-001 and never adopted by `workflow-guide.md`.
- **The step numbers point into a workflow that has never existed in any file.** `workflow-guide.md` has
  **5 phases**; ADR-001's list has **8 steps**; there is no 7.5 and no 9. Yet `workflow-guide.md:212`,
  `:1760`, `:2246`, `:2290` all cite *"CLAUDE.md Step 7.5 / Step 9."*

#### Checkpoint 1 — the journey (two reversals)

**Claude's first take (wrong):** retire it — `fw-move.sh`'s transition matrix makes `backlog → doing`
impossible, so the pause is redundant.

**Gary supplied the history that killed that:** the eagerness problem is *why the framework exists*.
Traced to the origin project (`HPC/HPCJobQueuePrototype`) — *"ONE issue at a time"* was written into
`thoughts/plans/` on **2025-11-26, three weeks before the framework repo existed.** *"The SpearIT
Framework is a living project of its own. You might call it the Mother of SpearIT Projects."*

**Why Claude's reasoning was wrong:** *the matrix only governs an AI that calls `/fw-move`.* An eager AI
doesn't move an item and then code — **it skips the work item entirely.** That failure is *unreachable
from the state machine*. **The rule is unmechanizable by construction — which is precisely what makes it
contract material.**

**Then Gary corrected the correction:** *"rule 1 hasn't completely failed. Even though AI will sometimes
work on an item not in doing/, it does have a plan… My issue has more to do with is the plan **mature or
just a seed**."*

**That split one rule into two:**
- **Rule 1 = "a plan exists."** Holding. The bootstrap line works.
- **Rule 2 = "the plan is *ripe*."** A different claim — about the **state of the item**, not the AI's
  discipline. Unenforceable in prose; *mechanizable*.

**And it explained `fw-move.sh`'s design retroactively:** `check_readiness()` greps for
TODO/TBD/DECIDE/Option A-B-C/placeholders — **that is a machine test for "seed vs. mature plan."** The
dependency check (`Depends On:` must be in `done/`, **never** `--force`-able) is a machine test for
**currency**. The residual failure is not "AI codes planless" — it is **"working out-of-band bypasses the
ripeness test entirely."**

**The rule's text therefore changes.** Gary's phrasing, which is better than Claude's proposal (Claude's
would have banned the backlog refinement done all session, including this ADR):

> **"Implement only work in `doing/`."** Planning and refinement may happen in `backlog/`, `todo/`, or
> `doing/`. Implementation may not.

**The split is on the VERB, not the location.** And it routes Rule 1 into Rule 2 by construction:
*implementation requires `doing/` → reaching `doing/` requires `/fw-move` → `/fw-move` enforces ripeness
and forces the review.* **Only the first link is prose.**

#### Checkpoint 2 — delegated to the command, contract carries nothing

Gary: *"If checkpoint rule 2 is not stated as an AI guard but delegated to fw-move, are we saying rule 1
will become the AI guard?"* → **Yes — and Rule 1 always was the *only* AI guard.** Rule 2 isn't a weaker
version of it; it is the *in-workflow* enforcement, and it's reliable **because** it's mechanized.
Gary confirms: *"If I explicitly move an item with the fw-move command, I'm getting the behavior we
expect."*

**Stated honestly (this matters — a future reader must not over-trust it):** `/fw-move → doing`
guarantees *"a **deterministic** rejection of items with **declared** incompleteness, plus a
**behavioral** review that must surface **undeclared** incompleteness."* **Not** "the plan is mature."
`grep` cannot see a confident-but-thin plan. **The mechanism's value is that it makes the review
unavoidable at the moment the plan is committed to.**

#### Checkpoint 3 — never existed; do not create it

**Verified:** `fw-move.md`'s `→ done/` block is **pure post-processing** (stamp `Completed`, session
history, commit, volume nudge). **There is no "present the work for approval" step anywhere in any
executing surface.** "Checkpoint 3" lives only in the two retiring files.

**And none should be added.** `check_acceptance_criteria()` blocks `→ done` on **any** unchecked `- [ ]`,
**not `--force`-able** — an itemized, explicit completion assertion, *better* than a review prompt. And
**completion already requires a human keystroke**: `/fw-move <id> done` doesn't happen unless Gary types
it. **The approval IS the command.**

#### The unsolved problem, recorded rather than papered over

**Rule 1 is unenforced, and ADR-007 does not fix that.** Nothing can stop an AI editing `src/` with an
empty `doing/`. Bootstrap block, `fw-move.md`, `workflow-guide.md` are all the **same** mechanism —
telling the model and hoping. **Layering a fourth restatement is the strategy that has "mostly worked but
occasionally not."** Gary: *"balancing AI innovation with a deterministic process… has been the biggest
challenge."*

The check *"is `doing/` empty while I'm about to edit code?"* is **mechanically decidable** — it just
can't live in a document. **TECH-114 (`wip-enforcement-hook`, backlog)** is the only class of fix.
**ADR-007 does not depend on it and must not claim enforcement it lacks.**

---

### ADR-007: D4 terminology — `USER INSTRUCTIONS` → `PROJECT INSTRUCTIONS`

Gary's sanity check: *"Is 'user instructions' the correct phrase? It could be interpreted 2 ways: (1)
insert instructions **for** the user here, (2) insert the user's instructions **for Claude** here."*

**Correct, and the wrong reading is the likelier one** — in a file titled *Claude Context*, "user" reads
as the **audience**, not the **author**. The label must name the **owner**, since ownership is the entire
point of the partition.

**`PROJECT INSTRUCTIONS`** — parallels `FRAMEWORK CONTRACT` (both name *whose* the region is), cannot be
misread ("instructions for the project" is nonsense in a file that *is* the project's), survives the team
case ("which user?"), and **is already the term in use**: `templates/starter/CLAUDE.md` ends with
`## Project-Specific Notes`.

Rejected: `YOUR INSTRUCTIONS` (second-person is ambiguous about *whom* it addresses — relocates the
problem); `INSTRUCTIONS FOR CLAUDE` (odd in a file that is entirely that, and doesn't parallel).

---

### Drift defects fixed live ("just fix it")

Gary: *"We're growing new issues faster than we can solve them… I vote for 'just fix it' on this one."*
Fixing cost less than filing. **Every defect was a reference table living in a tutorial — D3's failure
mode, observed.**

**`QUICK-START.md` (root, 221 lines) and `templates/starter/QUICK-START.md` (133) — different documents
that share a name, not copies:**

| Defect | Was | Fix |
|---|---|---|
| Commands table (starter) | 5 of 11 | **Deleted** → `/fw-help` + `framework-commands.md` |
| Commands table (root) | 9 of 11 | **Deleted** → same |
| Types/templates tables | omitted **TASK**; root also advertised **retired `DECISION`** | **Deleted** → `.claude/scripts/work-item-types.txt` (the real SoT) |
| WIP limit (root) | *"1-2"* and *"max 2"* in 3 places | **1** |
| "Full Reference" (root) | → `framework/CLAUDE.md` | → `framework-commands.md` (the file **D2 deletes**) |

**The root file's commands table carried its own epitaph:** *"**Note:** Keep this list updated as new
commands are added."* **It asked to be hand-synced. It was not.** That is the entire argument for D3 in
one line.

**Fixed by deletion, not update** — so the drift cannot recur.

**Two more found downstream while verifying the pointer targets** (Claude nearly routed three links into
a stale table):
- **`workflow-guide.md:1116`** — metadata example still read `Feature | Bug | Tech Debt | **Decision** |
  Spike`, **contradicting the correct 5-type table 40 lines below it** (`:1131`). → fixed to `Task`.
- **`GLOSSARY.md`** — no `### Task` entry (the other four types each had one); "Work Item" defined with
  the retired set; **ADRs located at `project-hub/decisions/`, a directory that has never existed** (real:
  `research/adr/`). → all three fixed.

**Root cause:** **TECH-173 shipped ADR-006's enforcement but did not complete its own acceptance
criterion — *"DRY every human-facing 'valid types' list to agree with it."*** These were the residue.

---

## Decisions Made

1. **D6 — Retire `CLAUDE-QUICK-REFERENCE.md`; onboarding is a command, not a document.**
   - Delete the artifact **and** the `framework/CLAUDE.md:7` recommendation that tells every project to
     author one. Author **no replacement**.
   - Goal → **FEAT-115 (`/fw-tour`)**, stays in `backlog/`, **does not block the ADR**.
   - `QUICK-START.md` survives as the AI-less handoff; **explicitly not a source of authority**.
   - **Rationale:** a document must guess the reader's level (334 lines vs. its own "<200" promise); a
     command **asks**, and reads live state so it **cannot go stale**. And ad-hoc AI tours were already
     tried — FEAT-115 *is* that bug report.

2. **D7 — There are not three checkpoints. One rule, three enforcement surfaces.**
   - *No code without an approved, ripe plan.*
   - **Rule 1 → contract.** Text changes to **"Implement only work in `doing/`"** (split on the verb —
     planning stays legal anywhere). **The only true AI guard**; the only one that is prose; the only one
     that occasionally fails.
   - **Rule 2 (`→ doing`) and Rule 3 (`→ done`) → already mechanized in `/fw-move`. Contract carries
     nothing for either.**
   - **Net footprint: one line in `CLAUDE.md`. Zero change to `fw-move`.**
   - **ADR-001 is NOT rewritten** — it is the decision record for Rule 1 and stands as-is.

3. **D4 label — `PROJECT INSTRUCTIONS`, not `USER INSTRUCTIONS`.** The label must name the **owner**;
   "user" reads as the audience. Parallels `FRAMEWORK CONTRACT`. Already the term in use
   (`## Project-Specific Notes`).

4. **D2's relocation table — one row VOIDED.** It sent "the three checkpoints" → `workflow-guide.md`.
   **That would ship Rule 1 to a file the AI never auto-loads — i.e. re-commit BUG-181.**

5. **Eighth drift defect recorded.** `framework/CLAUDE.md`'s claim that *"pre-commit hook validates work
   items in done/"* is **false** — `.git/hooks/` holds only samples; `Validate-WorkItems.ps1` exists but
   **nothing invokes it**; the `settings.json` hook is an unrelated `PreToolUse` hook.

6. **`framework.yaml:76` blocks D2.** It routes `ai-checkpoint-policy` → `framework/CLAUDE.md#...` — **the
   framework's own SoT index points into the file D2 deletes.** D2 cannot ship without fixing it.

7. **OQ7 filed (flag only, not answered):** *Is the framework, long-term, just a collection of commands?*
   **Every artifact that rotted is a document; nothing that executes has rotted.** Sharper formulation:
   **commands own chokepoints; documents do not.** Corollary — *every rule moved from the contract to a
   command converts a probabilistic guarantee into a deterministic one; the contract is a **residue**, not
   a home.* Answering it would also collapse **OQ6** (plugins and framework become the same product).

---

## OQ5 Discussion — `/fw-init` (Later, same day — NOT YET WRITTEN INTO THE ADR)

**Status at session close: mid-discussion. No ADR edits made for OQ5.** This section is the record of
where we got to; the resolution is deferred to next session.

The draft's OQ5 asked simply: *does `/fw-init` get filed as a FEAT?* The discussion blew that question
open — `/fw-init` turned out to denote **at least four different commands**, and the naming collides with
a Claude Code built-in.

**Gary's opening move — table it, pending OQ7:** *"fw-init might make sense in a plugin-command-only
environment to lay out the framework structure… but today the distribution archive does that for us."*
Correct: the shell-composer `/fw-init` the draft imagined is **redundant** — `Setup-Framework.ps1`
already substitutes identity placeholders deterministically. But a **scaffolder** `/fw-init` (create
`project-hub/`, `framework.yaml`, `.limit`) is only meaningful *if OQ7 goes commands-only* — today the
ZIP scaffolds. So the same command is redundant-or-foundational depending on OQ7. **That is the signature
of a decision that shouldn't be made now.**

**Gary added two more use cases:** *"fw-init as a possible upgrade path OR as a way to add framework
capability to an existing project."* **Both are brownfield** — writing into a project that already has a
`CLAUDE.md`, already has conventions. That is the hard case D4 did **not** solve, and it **is OQ1** (how
to re-derive the contract region without eating what's there).

**The naming insight (Gary):** *"Claude Code comes with its own `init` command… a user familiar with
`init` would expect similar behavior from `fw-init`."* This is the sharpest point in the thread.
`/init`'s known meaning is *analyze the codebase and write `CLAUDE.md`.* So `/fw-init` inherits an
expectation: **it edits `CLAUDE.md`.** For the "add the framework contract to the top of CLAUDE.md"
reading, that expectation is **helpful, not harmful** — it matches.

**Gary's killer question:** *"What happens if you run `init`, then `fw-init`, then sometime later run
`init` again?"*

**This forced an empirical test** (see below). Claude's initial answer — *"`/init` plausibly destroys
the contract region"* — was **asserted too strongly from inference.** Gary made a backup
(`CLAUDE copy.md`, verified byte-identical to the committed `CLAUDE.md`) and authorized a test.

**Test result (via claude-code-guide subagent, HIGH confidence, sourced from
`code.claude.com/docs/en/memory`):**

> *"If a CLAUDE.md already exists, `/init` suggests improvements rather than overwriting it."*

**So `/init` UPDATES in place; it does not regenerate.** Claude's destruction claim was **wrong** — the
documented behavior contradicts it. Caveats that keep it from being an all-clear:
- **"Suggests improvements" ≠ "preserves our delimited regions."** `/init` has no knowledge of the
  markers; an update pass could still rewrite content *inside* the framework region. Threat drops from
  **destruction** to **contamination** — which is what D4's `DO NOT EDIT` banner is for, but that banner
  is advisory to a *human* and its effect on a *model* rewriting the file is unproven.
- **A confirmed overwrite bug exists** (anthropics/claude-code#21795) — `/init` in `~/.claude` destroys
  the file without warning. That is the **user-level** case, not project-level, so it misses us — but it
  proves the mechanism isn't bulletproof.
- Claude explicitly **discounted the subagent's citation of ADR-007 back as "evidence"** — that is
  circular; the docs are the finding, our own ADR is not corroboration.

**Where this leaves the four readings of `/fw-init`:**

| Reading | Job | Status |
|---|---|---|
| Shell composer (draft's) | fill per-project bits of `CLAUDE.md` at birth | **Redundant** — `Setup-Framework.ps1` does it |
| Scaffolder (plugin-only) | create `project-hub/`, `framework.yaml`, `.limit` | **Only meaningful if OQ7 → commands-only** |
| Brownfield adopter | add framework to an existing project | **Blocked on OQ1** |
| Upgrader / **region-owner** | (re-)assert the framework region, idempotent, non-destructive | **The strongest reading** — see below |

**The emergent best reading — `/fw-init` as the idempotent region-owner.** If `/init` updates rather
than replaces, a `/fw-init` that **owns exactly one region and touches nothing else** is its natural
companion: run `/init`, region drifts/contaminates, run `/fw-init`, region is re-asserted clean. It is
**the repair command**, useful in *every* channel (archive-derived, plugin-only, brownfield, post-`/init`
repair), **not blocked on OQ7**, and arguably **part of OQ1's answer rather than a consumer of it.**

**Two things this discussion surfaced that DO need to reach the ADR next session:**
1. **The `/init` collision is a real D4 risk, independent of whether `/fw-init` ever exists.** Even with
   no `fw-init`: a derived project's `CLAUDE.md` has a framework region, the user runs `/init`, and an
   update pass may contaminate the region. **Belongs in D4's Negative Consequences** — recorded with the
   *documented* behavior (update-in-place), not as destruction.
2. **It reframes OQ1.** OQ1 assumes the only mutation is a *human editing text.* The `/init` case is a
   *tool rewriting the file.* Detection must cover "region contaminated / gone," not just "region
   differs." Broader requirement than OQ1 currently states.

**Not yet done (next session):** write the D4 risk, fold OQ5 into OQ1 (region-owner `/fw-init` as a
candidate mechanism, not a separate FEAT), and decide whether to run `/init` on this repo as a live test
(our `CLAUDE.md` has no markers yet, so it would show whether "suggests improvements" means *edits* vs.
*asks first* — but wouldn't test region-preservation until markers exist).

**Housekeeping:** `CLAUDE copy.md` is an untracked backup created this session. Delete it once the
`/init` question is closed, or leave it until then as the safety net (git also covers it — `CLAUDE.md` is
committed clean at `74442cd`).

---

## Files Modified

- `project-hub/research/adr/007-ai-collaboration-contract-and-claude-md.md` — **D6, D7 added**; D4 region
  label + rationale; D2 table row voided + 8th defect; `framework.yaml:76` added to blast radius; OQ3/OQ4
  struck as resolved; **OQ7 filed**; Related expanded (FEAT-115, FEAT-180, TECH-114, TECH-177, TECH-173)
- `QUICK-START.md` — commands + types tables **deleted** → pointers; retired `DECISION` type removed; WIP
  1-2 → **1** (×3); `framework/CLAUDE.md` link repointed
- `templates/starter/QUICK-START.md` — commands + templates tables **deleted** → pointers
- `framework/docs/collaboration/workflow-guide.md` — `:1116` metadata example `Decision` → **`Task`**
- `framework/docs/ref/GLOSSARY.md` — added `### Task`; "Work Item" definition → accepted 5-type set; ADR
  path `project-hub/decisions/` → **`project-hub/research/adr/`**

## Files Created

- `project-hub/history/sessions/2026-07-14-SESSION-HISTORY.md` — this file

## Files Moved

*(none)*

---

## Current State

### ADR-007 — **Status: Proposed** (not yet Accepted)

**Decided:** D1, D2, D2a, D3, D4, D5, **D6**, **D7**

**Open Questions remaining:**
- **OQ1** — how does re-derivation detect a user-edited contract region? *(Does NOT block acceptance —
  D4 ships the markers, not the upgrade tooling.)* **Now broader:** the `/init` case (a *tool* rewriting
  the file) means detection must cover "region contaminated," not just "human edited text."
- **OQ2** — where does the contract fragment live? (must not be named `CLAUDE.md`; must be excluded from
  the `framework/docs/` bulk copy)
- **OQ5** — `/fw-init`. **Discussed at length this session but NOT written into the ADR** (see the OQ5
  Discussion section above). Emerging answer: **not a FEAT to file — fold into OQ1 as the idempotent
  region-owner / repair command.** Resolution deferred to next session.
- **OQ6** — is a contract-less plugin channel acceptable, or a gap? **D6 supplies evidence it may be a
  false choice** — `/fw-tour` is a *command*, and commands are what plugins already ship.
- **OQ7** — is the framework just a collection of commands? *(flagged, deliberately unanswered)*

### In doing/
*(empty)*

### In todo/
FEAT-092, FEAT-163, FEAT-164, FEAT-175, TECH-172, TECH-177

### Notable backlog items touched by this session
- **FEAT-115** (`/fw-tour`) — **now carries D6's onboarding goal.** Postponed, not abandoned.
- **FEAT-180** (mandatory `## Documentation` section) — **premise confirmed twice today.** Needs no new
  machinery: `fw-move.sh` already hard-blocks `→ done/` on unchecked `[ ]`.
- **TECH-114** (`wip-enforcement-hook`) — **the only class of fix for Rule 1's unenforceability.**
- **BUG-181** — still parked in `backlog/`; becomes an instance of ADR-007 once D4 ships.

---

## Next Session

**Resume point:** finish the `/fw-init` discussion (Gary: *"Let's continue this discussion next
session."*). The investigation is done; the ADR edits are not.

1. **OQ5 → write it into the ADR.** Three concrete edits, all agreed in discussion, none yet made:
   - Add the **`/init` collision as a D4 Negative Consequence** — recorded with the *documented*
     behavior (`/init` updates in place, does not regenerate; contamination risk to the framework
     region, not destruction; ref bug anthropics/claude-code#21795 as the not-bulletproof caveat).
   - **Fold OQ5 into OQ1**: `/fw-init` as the idempotent, region-owning **repair command** — a candidate
     *mechanism* for OQ1, not a separate FEAT. Drop the shell-composer/scaffolder/adopter readings (or
     rename if ever wanted — three jobs, three names).
   - Note OQ1 is **broader than drafted**: detection must cover a *tool* rewriting the file, not only a
     human editing text.
2. **Optional live test:** run `/init` on this repo to see whether "suggests improvements" means *edits*
   vs. *asks first*. Backup `CLAUDE copy.md` is verified byte-identical; `CLAUDE.md` committed clean at
   `74442cd`; recovery = `git checkout CLAUDE.md`. (Won't test region-preservation — no markers yet.)
   Then **delete `CLAUDE copy.md`.**
3. **OQ2** — name and locate the contract fragment.
4. Then: **ratify ADR-007** (Proposed → Accepted). OQ1/OQ6/OQ7 may remain open — none block acceptance.

---

**Last Updated:** 2026-07-14
