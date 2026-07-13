# Session History: 2026-07-13

**Date:** 2026-07-13
**Participants:** Gary Elliott, Claude Code
**Session Focus:** Response-style guidelines → uncovered the CLAUDE.md contract-delivery problem → ADR-007

---

## Summary

Started as a small housekeeping request — "give me guidelines to make your responses less verbose" — and
the question *"which CLAUDE.md does this go in?"* exposed that the framework has **no propagation rule
for `CLAUDE.md` at all**. A derived project never receives the AI collaboration contract, and the file
that was supposed to carry it turned out to be ~95% duplicate and materially stale. Drafted **ADR-007**
to settle what `CLAUDE.md` is and how it reaches each channel; filed **BUG-181** as the bug record.

**Nothing was implemented.** FEAT-175 (the planned work) was never started — this detour turned out to
be the more important thing.

---

## The Journey (how we got here)

This session is worth reading as a chain, because each step was only visible from the one before it.

**1. "Be less verbose."** Gary noted that detailed responses are taxing over the course of a day, and
asked for guidelines. Agreed on: bottom line up front, ≤5 lines default, no headers/tables unless asked,
recommend-don't-survey, and an escape hatch ("detail"/"explain"/"walk me through" → go long).

**2. "Save it to both — memory and the repo."** Written to memory (`response-brevity.md`, all projects
on this machine) and to `/CLAUDE.md` as a new `## Response Style` section.

**3. "How different are the two CLAUDE.md files?"** — the question that cracked it open. Turned out
there are **three** (root 126, `framework/` 501, `templates/starter/` 82), and they are not copies that
drifted — they have different *roles*, and the starter one is **missing the contract entirely**.

**4. "Shouldn't the distributed CLAUDE.md have its own framework.yaml reference?"** It does, but a
*weaker* one — starter's bootstrap says "check project configuration" where root's says "check
`roles.default` for your starting role." **A derived project never learns that `framework.yaml` drives
role selection at all.**

**5. "Looks like we exposed another bug?"** Yes. Filed BUG-181: the starter template never delivers the
collaboration contract. Proposed fix at the time: *delegate by reference* — add a pointer to
`framework/CLAUDE.md`.

**6. "How does starter inherit? Are we copying it in the build script?"** — Gary caught an unverified
assertion. Checked: `Build-FrameworkArchive.ps1` **Step 5.5** already copies `framework/CLAUDE.md` into
every archive, with a drift-guard forbidding a checked-in duplicate. So the contract **is already
physically present** in every derived project — the root file just never points at it. *A missing
pointer, not a missing file.* The fix got smaller.

**7. "Map out build time vs. runtime."** Verified end to end. `Setup-Framework.ps1` renames and promotes
nothing; it only substitutes `{{PLACEHOLDER}}` tokens. So the derived project ends up with an 82-line
auto-loaded root `CLAUDE.md` and a 501-line `framework/CLAUDE.md` that nothing loads and nothing links
to.

**8. "Then we have 2 issues?"** Gary named the real DRY tension — **root/CLAUDE.md ↔
starter/CLAUDE.md** — and I had been staring past it at `framework/CLAUDE.md`. Then the pivotal
question: **"PERHAPS framework/CLAUDE.md was not a good idea in hindsight? Is adding a link getting too
clever?"**

That reframed everything. `framework/CLAUDE.md` is a `CLAUDE.md` that **Claude never auto-loads**. The
name is a decoy. Adding a link would have been patching around a file that should not exist.

**9. "Is there any reason we can't copy root/CLAUDE.md straight to the archive?"** No — ~60% of it is
repo navigation that would be *wrong* in a derived project.

**10. "Why are there 501 lines?"** The audit (below) answered it, and the answer changed the ADR.

**11. "The pointers to the SoT should already be in framework.yaml."** Correct — and the **starter's
`framework.yaml` is more correct than the repo's** (see Bugs Found).

**12. "What if we mark BOTH regions?"** Gary's refinement to D4 — see Decisions.

---

## The Audit (the finding that changed the answer)

Ran a section-by-section audit of `framework/CLAUDE.md` (501 lines) against every file it links to.

| Category | Lines | % |
|---|---|---|
| **Genuinely unique** (exists nowhere else in the repo) | **~23** | **4.6%** |
| Restated (condensed duplicate of a guide that already owns it) | ~410 | 82% |
| Structural (headings, rules, blanks, link index) | ~68 | 13.4% |
| Repo-only (framework-source-specific) | **0** | 0% |

**It is not the fourth copy — it is the fifth:**
`workflow-guide.md` → `collaboration/README.md` → `architecture-guide.md` →
**`CLAUDE-QUICK-REFERENCE.md` (334 lines, same folder — we did not know it existed)** → `CLAUDE.md`.

Accounting for `CLAUDE-QUICK-REFERENCE.md` — which carries the checkpoints, the ADR decision tree, the
reading-protocol tree, the `divide()` fail-fast example, the SQL-injection example, the coverage
targets, and a **verbatim** copy of the Top-5 Emergency Reference — the unique residue of
`framework/CLAUDE.md` falls to **~8 lines**.

**What would actually be lost if it were deleted:**
1. The "resume work" rule — *"ALWAYS read `work/doing/` … NEVER suggest next actions without verifying
   current work state."* Genuinely unique and genuinely load-bearing.
2. The three checkpoints as a set (Step 4 / 7.5 / 8.5) — but `CLAUDE-QUICK-REFERENCE.md` has them too.
3. The Claude Code Permissions section — the only orphan content, **and it is factually wrong.**

**Key insight:** the question was never *"how do we ship 501 lines to every project?"* It was **"why are
there 501 lines?"** — and the answer is that nobody should ship them at all.

---

## Decisions Made

### 1. Response style guidelines (adopted)

- Bottom line up front; **≤5 lines by default**
- No headers/tables unless asked — they pad length and turn an answer into a report
- Status/catch-up = **the delta only**; do not re-explain a work item's design
- **Recommend, don't survey** — one recommendation, one-line why
- **Escape hatch:** "detail" / "explain" / "walk me through" → go long. The only trigger.

**Rationale:** verbosity is a tax paid on every turn across a whole day. Gary would rather ask a
clarifying question than read reasoning he did not need. Depth is not lost — it is gated behind a word.

**Where it lives:** memory (`response-brevity.md`, all projects) **and** `/CLAUDE.md` (travels with the
repo). Per ADR-007 D5 it will move into the *contract* once the ADR is ratified.

### 2. ADR-007 — the AI collaboration contract (Proposed)

- **D1 — `CLAUDE.md` is a *contract*, not a *manual*.** Only: (a) binding rules that exist nowhere else,
  (b) bootstrap instructions, (c) project identity. **≤150 lines.** No restatement of any guide, ever.
  *Rationale: auto-loaded context is paid every session, in every project, forever.*
- **D2 — Retire `framework/CLAUDE.md`.** Relocate its ~8 unique lines; delete ~490.
  *Rationale: a `CLAUDE.md` that Claude never auto-loads is a misleading filename on a duplicate
  document that has already rotted.*
- **D2a — Root cause.** The repo's own *"Which Project Are You Working On?"* section is what **licensed**
  a second contract to exist: three projects → three CLAUDE.md files. **There is one project.**
  `framework/`, `templates/`, `tools/` are subdirectories, not peers. That section goes; what survives
  (~15 lines of repo orientation) is a **README concern, not a contract concern.**
- **D3 — Route through `framework.yaml`'s existing `sources:` index.** It already ships complete in the
  starter (25 topic→SoT pointers). **No summary layers.** Adding a rule means adding it to the guide
  that owns it, and — if binding at all times — to the contract. Never to a summary in between.
- **D4 — Derive the region, not the file.** *(See below — this is the decision that took the most work.)*
- **D5 — Response Style belongs in the contract.** It is a universal binding rule on AI behavior, so it
  is D1(a) by definition. Keeping it only in a personal `~/.claude/` or only in this repo's root file
  while claiming "the framework ships its contract to every project" **is the dogfooding violation this
  ADR exists to fix**, in miniature.

### 3. D4 — how the contract reaches each channel (the hard one)

**Evolution of this decision, in order:**

**First framing (rejected):** three options — (A) hand-author both files, (B) build-time generation,
(C) `/fw-init` AI command.

**`/fw-init` explored and rejected as the mechanism.** Gary raised it; it is a genuinely good idea
aimed at the wrong seam. Fatal objection: **bootstrap paradox** — `CLAUDE.md` is what tells Claude how
to behave, so an AI generating it runs *ungoverned*, before the contract is loaded. It is probabilistic
where ADR-006 D6 says be deterministic (the same reasoning FEAT-175 used to make `fw-new.sh` strict),
and it trades a build-time hard error for "hopefully the user ran the command."
**It survives as a separate FEAT** for composing *the shell* (project type, optional sections,
Project-Specific Notes) — never the contract.

**The decomposition that collapsed the problem:** the **shells share nothing.** This repo's shell is
repo layout; a derived project's is identity + notes. They are not variants of one thing — they are two
different things. So the only question D4 ever had was: *is the contract **pasted** into both, or
**derived** into both?* Framed that way it answers itself. **This is not "generate CLAUDE.md." It is
"stop pasting the contract twice"** — one concat in a build script that already runs three
copy-fresh-from-canonical steps (1.5 commands, 1.6 scripts, 1.6b type SoT).

**Gary's constraint that killed naive generation:** a derived project's `CLAUDE.md` **must stay
user-editable** — Project-Specific Notes, their conventions, their preferences. A wholly generated file
with a "do not edit" banner would *fight the user*. So the guard scopes to a **region**, not the file.

**Gary's refinement — mark BOTH regions:**

```markdown
<!-- BEGIN FRAMEWORK CONTRACT — derived. DO NOT EDIT; replaced on upgrade. -->
... the universal contract, authored once ...
<!-- END FRAMEWORK CONTRACT -->

<!-- BEGIN USER INSTRUCTIONS — this region is YOURS. Never touched. -->
<!-- Your project's conventions and standing instructions go here. -->
<!-- END USER INSTRUCTIONS -->
```

Three reasons this is strictly better than marking only the contract:
1. **It makes the file a partition.** Every line has an owner. With one region marked, everything
   outside it is "not-contract" *by default* — an edit above the block, or a section the framework later
   wants to own, lands in undefined territory and the upgrade tool has to guess.
2. **It inverts the message.** `DO NOT EDIT` alone reads as a fence; `BEGIN USER INSTRUCTIONS` reads as
   an **invitation**. A user with nowhere obvious to write *will* edit the contract block.
3. **It buys a humane upgrade failure mode.** If re-derivation finds the framework region was edited, it
   need not choose between silently overwriting (unacceptable) and refusing (useless) — it can
   **relocate the user's edits into USER INSTRUCTIONS and say so.** Only possible because there is
   somewhere to move them *to*.

**The sleeper payoff nobody asked for: upgradeable contracts.** Because the region is delimited and the
shell is untouched, a framework upgrade can **re-derive the contract in place** without clobbering the
user's notes. **Nothing in the framework can do this today** — which means derived projects would rot
*even if we shipped the contract correctly once*.

**Two supporting constraints:**
- **Zero placeholders in the contract fragment.** Build composes (`contract + shell`); Setup substitutes
  identity (`{{PROJECT_NAME}}`…). Only the shell carries placeholders. That is the line that keeps the
  two stages from bleeding.
- **Keep the composer stupid** — literal concatenation of two files. No templating, no conditionals.
  `CLAUDE.md` governs *the AI that runs the build*; the moment the composer gets clever it becomes
  unauditable by the thing it governs.

---

## Bugs Found (verified, not inferred)

All discovered while auditing. **None fixed this session.**

**In `framework/CLAUDE.md`** (all fixed *by deletion* under ADR-007 D2):
1. **Command list is 6 stale** — lists 5 commands; `.claude/commands/` has **11**. Omits `/fw-next-id`,
   `/fw-release`, `/fw-roadmap`, `/fw-session-history`, `/fw-swarm`, `/fw-topic-index`.
   `docs/ref/framework-commands.md` has all 11 and is correct.
2. **ADR template paths do not exist** (`:353-354`) — `templates/ADR-MAJOR-TEMPLATE.md`. Actual:
   `framework/templates/decisions/`.
3. **Circular dangling reference.** `:215` cites a *"complete 11-step workflow"* in `workflow-guide.md`
   — **which has no 11-step workflow** (it has 5 phases). Conversely `workflow-guide.md:212`, `:1760`,
   `:2246`, `:2290` all cite *"CLAUDE.md Step 9"* — **which does not exist either.** Two documents
   pointing at steps in each other that neither contains.
4. **The permissions section is materially wrong** (`:430-446`). Claims read-only-only (`Read`, `Glob`,
   `Grep`, `ls`, `cat`, `pwd`, `git status`). Actual `.claude/settings.local.json` allows **`Edit`,
   `Write`, unrestricted `Bash`** with `"defaultMode": "dontAsk"`, plus a deny-list it never mentions.
   **It describes a security posture the project does not have.**
5. **Folder tree wrong in ~8 ways** (`:34-61`) vs. `docs/PROJECT-STRUCTURE.md`.
6. **Self-referential dead link** (`:216`) — a "Full Details" bullet pointing at the same file, 25 lines
   up. A broken link patched with prose.
7. **The framework's own size guidance contradicts itself in three places** —
   `collaboration/README.md:309` says ~400–500 lines; `CLAUDE-QUICK-REFERENCE.md:196` says ~600 and
   calls *itself* "<200 lines" while being **334**.

**Separable — needs its own item if ADR-007 does not sweep it up:**
8. **`framework.yaml:79` (repo root) points at `framework/docs/PROJECT-STRUCTURE-STANDARD.md` — which
   does not exist.** The file is `PROJECT-STRUCTURE.md`. `/fw-topic-index` reads that block, so **the
   repo's topic index currently resolves to a missing file.**
   **`templates/starter/framework.yaml` has it right.** The distribution's config is more correct than
   the framework's own — which is its own small indictment.

---

## Files Created

- `project-hub/research/adr/007-ai-collaboration-contract-and-claude-md.md` — **ADR-007** (Proposed).
  What `CLAUDE.md` is, and how the contract reaches each channel. D1–D5 + 6 open questions.
- `project-hub/work/backlog/BUG-181-starter-claude-md-missing-collaboration-contract.md` — the bug
  record. **Blocked on ADR-007's ratification.**
- `~/.claude/.../memory/response-brevity.md` — response-style preference (all projects, this machine).

## Files Modified

- `CLAUDE.md` — added `## Response Style` section (after Epistemic Standards). Per ADR-007 D5 this will
  **move into the contract** once the ADR is ratified — it is currently in the one place that cannot
  ship it.
- `~/.claude/.../memory/MEMORY.md` — added a Working Preferences index pointer.

## Files Moved

- None.

---

## Commits

- `92e8b61` — `docs: Draft ADR-007 (AI collaboration contract); file BUG-181; add Response Style`

---

## Current State

### In doing/
- Empty.

### In todo/
- **FEAT-175** — pre-implementation review complete; **still unblocked and untouched.** This session
  never reached it.
- TECH-177, TECH-172, FEAT-092, FEAT-163, FEAT-164

### In backlog/ (new this session)
- **BUG-181** — blocked on ADR-007

### ADRs
- **ADR-007** — **Proposed.** Needs ratification.

### In done/ (awaiting release)
- BUG-167, BUG-170, FEAT-165, TECH-079, TECH-173 — 5 items, under the release-nudge threshold.

---

## Resume Here Next Session

**Two live threads. Pick one deliberately — they are independent.**

**Thread A — ADR-007 (the new one).** It is **Proposed** and needs your ratification. D1–D3 and D5 are
settled in draft; D4 is settled in draft and is the substantive one. **The sharpest open question is #1:
how does re-derivation detect a user-edited contract region?** Silent overwrite is unacceptable — an
upgrade that eats a user's work once is never trusted again. The two-region partition gives us the good
*answer* (relocate the edits into USER INSTRUCTIONS and report it); the *detection* mechanism still needs
choosing. Settle it **before** implementation, not during.

Other open questions on the ADR: where the contract fragment lives (must **not** be named `CLAUDE.md`,
and must be excluded from the `framework/docs/` bulk copy or it ships twice); whether
`CLAUDE-QUICK-REFERENCE.md` is also retired; where the three checkpoints go; whether `/fw-init` is filed
as a FEAT; whether the plugins have a contract surface at all.

**Thread B — FEAT-175 (the planned work).** Untouched. Still says what it said at the end of
2026-07-09: checklist step 1 is `[x]`; **step 2 is "Build `fw-new.sh`: deterministic type gate."** Its
one open risk remains the **TECH-176 template-rename sequencing** — decide that before implementing.

**A caution on ADR-007's implementation:** it proposes deleting ~835 lines (501 + 334). The content is
verified present in the guides, but **re-run the audit per section before each deletion.** Do not treat
this session's line counts as a licence to `rm`.

**A note on how this session went.** The most valuable move was Gary asking *"was `framework/CLAUDE.md`
a good idea in hindsight?"* — a question about a **premise**, not about the fix under discussion. Two
proposed fixes (add a pointer; sync the files) were both wrong, and both would have *worked*, and both
would have entrenched the actual problem. Worth remembering next time a fix feels like it is getting
clever.

---

**Last Updated:** 2026-07-13
