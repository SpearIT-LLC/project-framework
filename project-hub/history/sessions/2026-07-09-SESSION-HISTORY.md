# Session History: 2026-07-09

**Date:** 2026-07-09
**Participants:** Gary Elliott, Claude Code
**Session Focus:** FEAT-175 pre-implementation review — /fw-new deterministic create gate

---

## Summary

Ran the pre-implementation review gate on FEAT-175 and, through it, corrected a false premise about
plugin architecture, tested the proposed type-matching rule against real-world data, and split the
item into a shippable core plus three follow-ups. **No code was written** — the item remains in
`todo/`. The session's throughline: *verify the constraint before designing around it.*

---

## Work Completed

### FEAT-175: /fw-new Deterministic Create Gate (planning only)

- **Pre-implementation review completed** (checklist step 1 marked `[x]`)
- Scope **narrowed to the full framework**; plugin work split out
- Education surfaces **folded in** per Gary's "add feature X, add documentation for X" ruling
- Type-gate behavior, next-ID strategy, and rejection-message design settled and written into the item

### Filed: SPIKE-178, FEAT-179, FEAT-180

Three new items in `backlog/` (see Files Created).

---

## Decisions Made

### 1. Plugins already ship executable bash — the "prose-only plugin" premise was false

**Gary's recollection (start of session):** an earlier discussion had decided plugins ship no scripts,
because "a random developer loading the plugin is going to feel less comfortable if they know there
are scripts built-in," while the Full Framework freely uses packaged scripts.

**Searched the repo. No such decision exists.** The opposite is documented:
- `plugins/spearit-framework/commands/move.md:45` — "Then execute this bash script" + ~100 lines of
  `#!/usr/bin/env bash`
- Same in `backlog.md:41`, `kanban-state.md:33`, and the light edition's `move.md`

**The real recorded constraint is cache isolation, not script avoidance** (ADR-006:83–85): the plugin
ships via marketplace cache and forbids reading the consuming repo's `.claude/`. Every "self-contained"
citation in the repo means *no external path dependencies* — never *no code*.

**Why this mattered:** it inverted the design. The channel difference is **inline-embedded vs.
shared-file**, not scripts-vs-AI. And it surfaced a third option nobody had considered — a plugin
calling a script it ships *itself* — which is why SPIKE-178 exists.

**Rationale for recording this:** a design was nearly built on a remembered constraint that the record
contradicts. The lesson generalizes.

### 2. Type gate is STRICT in the script; leniency lives in the AI layer

**Gary proposed** fuzzy prefix matching (`FEAT*` → `FEAT`) as a nice-to-have for first-time users
coming from other trackers' terminology — self-documenting behavior.

**Tested it against real data** (see Research below): 74 literal type-name strings from Jira, Jira
Service Management, GitHub, Azure DevOps (Agile/Scrum/CMMI/Basic), GitLab, Linear, Redmine, Shortcut,
Conventional Commits, and SAFe.

**Result: zero false positives.** The rule correctly resolves all 9 spelling variants of our own types
(`FEATURE`→`FEAT`, `BUGFIX`→`BUG`, `TECHDEBT`→`TECH`, `TECHNICAL DEBT`→`TECH`) — reproducing ADR-006
D2's hand-maintained alias map *for free, with nothing to maintain.*

**But it cannot reach the ~15 strings a real user actually types:** `story`, `enhancement`,
`improvement`, `defect`, `fix`, `incident`, `chore`, `refactor`, `docs`, `perf`, `research`. Those
need a *semantic* mapping, not a spelling one.

**Decision:**
- `fw-new.sh` is **strict** — accepts only SoT members, no alias/fuzzy logic.
- The AI layer does **both** prefix-normalization (mechanical) and semantic suggestion (judgment).
- Both produce a *suggestion the user confirms*; the corrected type re-enters through the gate.
- **No durable alias table.** It would be a fourth copy of the type vocabulary — the exact
  fragmentation ADR-006 exists to prevent. The AI reasons from the SoT plus the guide's "why 5"
  rationale.

**Why strict-in-script:** prefix-match is safe against today's 5 types by *property of the current
list*, not of the rule. A future type that prefixes another makes it silently pick wrong, and whoever
adds a line to a `.txt` has no reason to think about prefix collisions. A create gate bakes its answer
into a filename that lives forever. Mirrors `fw-move.sh`: hard block in the script, interactive
recovery in the command.

### 3. Education is the first line of defense; the gate is the backstop

**Gary:** "our first defense against the user entering invalid issue types is by education somehow —
fw-help, Setup-Framework, and in the response after someone enters an unsupported issue type. Perhaps
even explain a standard work item and sub-item to simulate a story with tasks."

**The story-with-tasks insight proved the sharpest.** A Jira user typing `story` isn't asking for a
synonym — they're asking *how do I model a story with tasks under it?* The framework already answers
this (`workflow-guide.md:994-1008`, hierarchical numbering, `FEAT-042` → `FEAT-042.1`, max depth 3),
and `fw-move.sh` already moves parent + children together. The rejection message now teaches the
structure rather than merely refusing.

### 4. Documentation ships with the feature (Gary overruled the AI's split proposal)

**Claude proposed** splitting education surfaces into a separate item to keep FEAT-175 small.

**Gary:** "My lean is the documentation belongs with the feature. Add feat X, add documentation for X.
That's something we haven't been real disciplined about but I think they should never ship separately."

**Accepted.** Education folded into FEAT-175. The AI had been optimizing for a small item and would
have shipped a gate whose only user-facing surface was a rejection message.

### 5. Documentation should be structurally enforced → FEAT-180

Gary's follow-on ("Perhaps documentation should be a mandatory question with every feature?") is a
change to *what a work item is*, so it was filed separately rather than smuggled into FEAT-175.

**Key finding: the enforcement is free.** `fw-move.sh:222-237` (`check_acceptance_criteria`) already
hard-blocks `→ done/` on any unchecked `[ ]` and is explicitly not `--force`-bypassable. Put a
documentation checkbox where that gate can see it, and docs become structurally required — zero new
machinery. This is the ADR-006 philosophy ("deterministic where a silent lapse is costly") applied to
documentation.

FEAT-175 **dogfoods it now**, carrying a `## Documentation` section before the rule exists.

### 6. Scope: full framework first; plugins follow

Gary: "Let's limit the scope to Full Framework and create followup work items for the plugins. So the
plugin work item(s) would cover the script(s) and templates."

Also confirmed: **`Setup-Framework.ps1` is in scope** — it ships only with the full framework and runs
once at project start (first contact with the taxonomy).

### 7. Deferred (recorded, not decided)

- **`fw-next-id.sh` / phasing out PowerShell.** Gary raised bash vs. C# vs. Python. Bash wins:
  **git is already a hard dependency** and ships bash on Windows, so it costs nothing new. Deferred to
  ADR-006 D7's "deterministic engine strategy" ADR. Noted that `FrameworkWorkflow.psm1:121` carries a
  **hardcoded fallback copy** of the accepted set that such a consolidation should delete.
- **Type list embedded in `fw-new.sh` instead of a data file** (Gary's Q4). Rejected: PowerShell
  (`FrameworkWorkflow.psm1:94`) and 7 doc surfaces read the `.txt`. Embedding it in bash would force
  PowerShell to keep its hardcoded copy permanently — two authored sources, the exact root cause
  ADR-006 diagnosed. A data file is also readable by the future compiled CLI (D5's stated rationale).

---

## Research

### Industry issue-type vocabularies (deep-research workflow, 107 agents, 25 primary sources)

Harvested **74 distinct literal type-name strings** with citations to authoritative docs, to test the
fuzzy-matching rule empirically rather than by intuition.

**Notable:** the workflow's synthesis step returned a placeholder (`{"summary":"test","findings":[]}`)
— a harness bug, not a research failure. The 79 extracted claims and 24 adversarially-confirmed
verdicts were recovered from the run's `journal.jsonl`.

**One claim was refuted 3–0:** Microsoft Learn's CMMI page asserts "five primary work item types"
while its own table lists four, and the page is flagged `ai-usage: ai-assisted`. Not relevant to us,
but a clean demonstration of why adversarial verification exists.

### Verified facts that became acceptance criteria

- **Scan-boundary hazard is real, not theoretical.** A naive `TYPE-NNN` grep across `project-hub/`
  returns `202` — it matches `ROADMAP-2026-02-04.md` as `ROADMAP-202`. The canonical scoped scan
  (`work/`, `releases/`, `poc/`, `history/spikes/`) returns `178`. An unscoped `fw-new.sh` would
  silently burn 25 IDs on first run. Now an explicit AC with expected values.
- **Python is not installed on this machine.** Gary's instinct to avoid a Python dependency wasn't
  merely philosophical — it would break on his own dev box.
- **Plugin 3-template limit was never decided.** Traced to
  `FEAT-118-PLAN-template-extraction.md:19,31` (Feb 2026): the three templates that *happened to be
  inline* in `new.md` were extracted to files **for file-size reasons** ("~180 lines"). No document
  records a decision to cap plugin types at three, or any rationale for `CHORE`. The full plugin later
  copied the same three from light (`FEAT-127.1:129`). ADR-006 D3 says types are universal and
  non-tiered — so there is no principled basis for the difference.

---

## Bugs Discovered (filed, not fixed)

1. **Plugins offer 5 types but ship 3 templates.** `new.md:63` lists `FEAT, BUG, TECH, TASK, SPIKE`;
   `plugins/*/templates/` holds only `FEAT`, `BUG`, `CHORE`. A plugin user choosing `TECH`, `TASK`, or
   `SPIKE` has **no template to resolve** — the create flow's Step 5 fails. `CHORE` is a retired type
   that still ships a template and a worked example. → **FEAT-179**
2. **Full plugin's `new.md` is a stale copy of the light one** — self-names
   `/spearit-framework-light:new` throughout. → **FEAT-179**
3. **`/fw-help` omits `/fw-next-id` and `/fw-topic-index`**, while declaring itself "the **single
   source of truth** for all `/fw-*` command help" (`fw-help.md:50`). The framework demonstrating
   FEAT-180's problem on itself. → folded into **FEAT-175**

---

## Sequencing Risk Flagged

**TECH-176 vs. FEAT-175.** TECH-176 renames `FEATURE-TEMPLATE.md` → `FEAT-TEMPLATE.md` and
`TECHDEBT-TEMPLATE.md` → `TECH-TEMPLATE.md`. `fw-new.sh` resolves a template per type. Hard-code
either spelling and it breaks on one side of that rename. **Either land TECH-176 first, or have
`fw-new.sh` resolve template filenames without assuming the spelling.** Noted in both items; decide
before implementation, not during.

---

## Files Modified

- `project-hub/work/todo/FEAT-175-fw-new-deterministic-create-gate.md` — narrowed to full framework;
  added Type Gate Behavior, Next-ID Assignment, Cross-Channel Equivalence, and Documentation sections;
  rewrote ACs (split gate/education) and checklist; marked pre-implementation review `[x]`
- `project-hub/work/backlog/TECH-169-reconcile-move-command-copies.md` — recorded that option (a) is
  ruled out by cache isolation; noted the third option SPIKE-178 tests; re-pointed the pilot to
  FEAT-179; added cross-refs
- `project-hub/work/backlog/TECH-176-rename-work-item-templates-to-canonical-prefixes.md` — re-pointed
  plugin template trees from FEAT-175 → FEAT-179; added the FEAT-175 sequencing note

## Files Created

- `project-hub/work/backlog/SPIKE-178-plugin-script-invocation.md` — can a plugin invoke a script
  inside its own marketplace cache? Time-boxed; output is a decision. Blocks FEAT-179.
- `project-hub/work/backlog/FEAT-179-plugin-create-gate-parity.md` — plugin create-gate parity: derive
  engine + SoT + templates into both editions; fix the 3-template bug; retire `CHORE`.
  Depends on SPIKE-178, FEAT-175.
- `project-hub/work/backlog/FEAT-180-mandatory-documentation-section.md` — mandatory `## Documentation`
  section, enforced by the existing `→ done/` criteria gate. Has one open question (how to honestly
  decline documentation) that depends on TECH-177's `[-]` convention.

## Files Moved

- None.

---

## Current State

### In doing/
- Empty.

### In todo/
- **FEAT-175** — pre-implementation review **complete**; ready to move to `doing/` and build
- TECH-177, TECH-172, FEAT-092, FEAT-163, FEAT-164

### In backlog/ (new this session)
- **SPIKE-178** — blocks FEAT-179
- **FEAT-179** — blocked by SPIKE-178
- **FEAT-180** — has an open question dependent on TECH-177

### In done/ (awaiting release)
- BUG-167, BUG-170, FEAT-165, TECH-079, TECH-173 — 5 items, under the release-nudge threshold

---

## Resume Here Next Session

**FEAT-175 is planned and unblocked.** Its checklist step 1 (pre-implementation review) is `[x]`;
step 2 is "Build `fw-new.sh`: deterministic type gate (reads SoT, strict)."

**Decide before implementing:** the TECH-176 template-rename sequencing (above). It is the only
open risk in FEAT-175's path.

**Nothing was built this session.** All six changed files are work-item planning documents.

---

**Last Updated:** 2026-07-09
