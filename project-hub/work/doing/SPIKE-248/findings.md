# SPIKE-248 Findings

**Started:** 2026-09-28 · **Scope:** the new build (`workspaces/framework/`) plus the root
`CLAUDE.md`. Old `.claude/` parts are included only where they are meant to carry over.

Verdicts: **keep** · **mechanize** (prose → hook/script) · **skill** (move to an on-demand
skill) · **user** (move to user level) · **delete**. The native-overlap sources are in the
"Native overlap" section below.

---

## 1. Inventory — the new build (what ships)

| Item | Lines | Verdict | Reason |
|---|---|---|---|
| `commands/fw-move.md` + `scripts/fw-move.sh` | 102 + 688 | keep | The engine decides facts; the command carries only judgment (the pre-implementation review, the refusal etiquette). This is ADR-008's pattern, working: UAT-37..57 pass. |
| `commands/fw-move-ops.md` | 88 | keep | Same engine, operations namespace. |
| `commands/fw-new.md` + `scripts/fw-new.sh`, `fw-next-id.sh` | 102 + 263 | keep | The create gate: id assignment and filename shape are facts in the script. |
| `commands/fw-new-ops-record.md`, `fw-new-workspace.md`, `fw-new-kb-domain.md`, `fw-contacts.md` + scripts | ~250 + ~700 | keep | Script-backed create gates; nothing native does this. |
| `skills/fw-checkbox-states` | 196 | keep | A convention loaded on demand, which is what skills are for. |
| `skills/fw-troubleshoot` | 103 | keep | A judgment loop. Its value is still unproven by real use (TASK-205). |
| `hooks/refresh-contacts.sh` (PostToolUse + SessionStart) | 61 | keep | Already the native mechanism. |
| `tools/pre-commit`, `install-git-hooks.sh` | 46 | keep | Backstop for edits made outside Claude, which no Claude hook can see (UAT-31). |
| `templates/records/*` (4) | 215 | keep | The structure the gates fill. |
| `templates/queues/kanban/` (9 folders) | 60 | keep, no change | The state set was decided in TASK-242 (created 2026-09-22, completed 2026-09-23). The spike's "question the ceremony" hypothesis is already answered; re-opening it now would be relitigating. |
| `templates/queues/operations/`, `templates/workspaces/*` | — | keep | Generated structure, per ADR-009 D3. |
| `CLAUDE.md` (workspace, 38 lines) | 38 | keep (dev-only) | The build's authority boundary. It does not ship, and TECH-188's file list must exclude it. |
| **Missing: the contract has no way to reach a consuming repo** | — | **mechanize** | See finding F1. |

**Prompting style.** No `CRITICAL`, no `YOU`, and no persona framing in the new build's
commands or skills (grep, 2026-09-28). The hypothesis "drop the 2025 shouting" only applies
to the old root `.claude/commands/`, which graduation deletes. There is nothing to do.

## 2. Inventory — the root `CLAUDE.md` (134 lines)

| Section | Verdict | Reason |
|---|---|---|
| Bootstrap 1, "ask what kind of work" | delete | The user almost always says. It is a question that costs a turn. |
| Bootstrap 2, read `framework.yaml` / `roles.default` | keep the pointer; delete the role | `sources:` is a real index. "Adopt senior-architect" is persona framing that changes nothing verifiable. |
| Bootstrap 3, report `doing/` | mechanize | A SessionStart hook prints the WIP state. The hook type already runs in this build (contacts). |
| Bootstrap 4, `git mv` only | mechanize | A PreToolUse hook denies `mv`/`Move-Item`/`cp` on the board path. |
| Epistemic Standards | keep | Durable, and cannot be mechanized. |
| Response Style | user | See finding F3. |
| Implementation Rule | keep, plus a partial mechanism | See finding F2. |
| Single-Source Rule | keep | Durable. |
| Onboarding / This Repository | delete, becoming a pointer | `README.md` already carries it. |
| ADR-009 workspace exception | keep | Load-bearing: it routes authority inside `workspaces/framework/`. |

## 3. Findings

**F1 — The new build has no channel for its contract.** ADR-007 delivered the contract by
writing it into each generated project's `CLAUDE.md`. The new build has no `/fw-init` yet (a
graduation criterion) and ships no `CLAUDE.md` content. So the Implementation Rule, the
Epistemic Standards and the Single-Source Rule reach this repo only through its hand-written
root `CLAUDE.md`, and a client repo not at all. This is BUG-181's subject, in the new build's
terms. *Candidate mechanism: a SessionStart hook in the plugin that emits the contract from
one file inside the plugin, so every repo with the plugin enabled gets it and there is
nothing to compose or drift. Depends on native-overlap question 1–2.*

**F2 — The Implementation Rule can be partly enforced.** A PreToolUse hook on Edit/Write that
warns when a source path changes while `doing/` is empty catches the most common failure,
starting work with no card. It cannot judge whether an edit belongs to the card, so the rule
stays in the contract too. *(Opinion; needs a trial.)*

**F3 — Response Style exists in three copies, and none of them is user level.**
- the root `CLAUDE.md`: the current "optimize for skippability" text;
- `.claude/framework-contract.md`: the old "5 lines or fewer" text, drifted;
- this project's auto-memory `response-brevity.md`.

There is no `~/.claude/CLAUDE.md` and no output style (checked 2026-09-28). The auto-memory
directory is per-project, so today the preference does not follow Gary into client repos at
all. Recommendation: one home at user level, deleted from the other two.

**F4 — `framework-contract.md` has no composer.** ADR-007 D2/D4 planned a build step that
composes `CLAUDE.md` from `.claude/framework-contract.md`. No script reads the file (grep of
`*.ps1`, `*.sh`, `*.md`, `*.yaml`, 2026-09-28). The only readers are prose comments telling a
human to reconcile by hand. So it is a hand copy that has already drifted, which is the
failure ADR-008 names. *Leaning: delete it. In the new build the contract's single home is a
file inside the plugin (F1), and the root `CLAUDE.md` becomes repo-specific content only.*

## 4. Native overlap (verified against current docs, 2026-09-28)

These were first gathered by a docs-research subagent. The load-bearing claims were then
re-read directly from the pages cited. The subagent was wrong twice: the skill field is
`disable-model-invocation`, not `shouldAutoInvoke`, and there *is* size guidance for skills.
Both are corrected below.

| Framework part | Native feature | Overlap | Verdict | Source |
|---|---|---|---|---|
| Contract in `CLAUDE.md` (ADR-007 channel) | Plugins cannot ship a `CLAUDE.md`. A plugin's **SessionStart hook** stdout or `additionalContext` is added to Claude's context, capped at **10,000 characters** per string. Matchers: `startup`, `resume`, `clear`, `compact`, `fork`. Plugin hooks merge with user and project hooks when the plugin is enabled. | Replaces the channel | **mechanize** (D1) | code.claude.com/docs/en/hooks: SessionStart; "Hook output" cap; hook locations |
| Bootstrap 4, `git mv` only | **PreToolUse** hook returns `permissionDecision: "deny"` with a `permissionDecisionReason`: "blocks the tool call, and shows Claude the reason". Input includes `tool_input.command` and `tool_input.file_path`. | Full | **mechanize** (D4) | docs/en/hooks: PreToolUse decision control |
| Instructions in general | Memory docs: `CLAUDE.md` is "context, not enforced configuration. To block an action regardless of what Claude decides, use a PreToolUse hook." | Confirms ADR-008 | — | docs/en/memory: "CLAUDE.md vs auto memory" |
| Response Style | `~/.claude/CLAUDE.md` = "Personal preferences for all projects", and `~/.claude/rules/*.md` "apply to every project on your machine". Auto memory is "per repository", so it does not travel. | Full | **user** (D3) | docs/en/memory: scope table; "User-level rules"; "Storage location" |
| Root `CLAUDE.md` size | Target under 200 lines; "Longer files … reduce adherence." Block-level HTML comments are stripped before injection. Project-root `CLAUDE.md` is re-injected after `/compact`. | Guidance | keep slim (D2) | docs/en/memory: "Write effective instructions"; "How CLAUDE.md files load"; "Instructions seem lost after /compact" |
| Drift / stale-instruction checks (TECH-189 in part; this spike's manual audit) | **`/doctor prompt-audit`** reads the `CLAUDE.md` files and the rules, skills, commands and output styles under `.claude/` and `~/.claude/`, and flags "instructions written for older models, references to files or commands that don't exist, and files that contradict each other". It proposes edits and changes nothing until asked. Requires v2.1.283+. | Partial | **adopt as a check** (D7) | docs/en/memory: "Write effective instructions" |
| Plugin `commands/*.md` | "Custom commands have been merged into skills… Your existing `.claude/commands/` files keep working." Skills add a folder for supporting files and invocation control (`disable-model-invocation: true` means only the user can invoke it). "Keep `SKILL.md` under 500 lines." | Format only | keep now; convert later (D8) | docs/en/skills: note at top; frontmatter reference; tip |
| `→ doing` pre-implementation review | Plan mode is a **permission mode** (read and propose, no edits), set by `--permission-mode plan` or `permissions.defaultMode`. It holds no card and leaves no record. | None | keep | docs/en/permission-modes: modes table ("Claude Code blocks edits until you approve a plan"); starting-mode table (re-read 2026-09-28) |
| The board (`project-hub/work/`, `kanban/`) | Task/todo tools track steps **within** a session and don't persist to the repo. | None | keep | docs/en/agent-sdk/todo-tracking (re-read 2026-09-28): a within-session list surfaced as tool calls; the page says nothing about persistence, and on current models the tools are off by default ("Newer models track multi-step work without a written todo list"). "Doesn't persist to the repo" is inference: nothing in it writes there. |
| Self-hosted marketplace (TECH-188) | A marketplace is a repo with `.claude-plugin/marketplace.json`, added with `/plugin marketplace add owner/repo`. A project's settings can declare `extraKnownMarketplaces` and `enabledPlugins`; a `git-subdir` source takes `path` and `ref`. | Confirms TECH-188's recommendation | — | docs/en/plugin-marketplaces (re-read 2026-09-28: marketplace.json location, `claude plugin marketplace add <owner>/<repo>`, `git-subdir` with `path`; `ref`/`sha` pinning is on the marketplace-reference page). `extraKnownMarketplaces` and `enabledPlugins` are both **objects** (settings-reference, re-read 2026-09-28; the subagent said array, which was wrong). Check the exact entry shape at TECH-188. |

## 5. Decisions (proposed; awaiting Gary)

**D1 — The contract ships in the plugin, through a SessionStart hook.** One file inside the
plugin (e.g. `workspaces/framework/contract.md`) holds the rules every repo needs: the
Implementation Rule, the Epistemic Standards and the Single-Source Rule. A plugin hook emits
it on `startup|resume|clear|compact`. Every repo that has the plugin enabled gets it. There is
nothing to compose and nothing to drift. This replaces ADR-007's delivery channel (the premise
the spike was asked to re-examine), so it needs an **ADR-007 amendment**. It also resolves
BUG-181 for the new build. Constraint: the file must stay under 10,000 characters. Today's
`framework-contract.md` is 85 lines, so it fits.

**D2 — The root `CLAUDE.md` becomes repo-specific only; the slim draft is revised.** Once D1
lands, the contract reaches this repo through the plugin, so the root `CLAUDE.md` must *not*
restate it, or there would be two copies again. The target is the repo identity, the
`framework.yaml` pointer and the ADR-009 workspace exception: about 15 lines. The slim draft
(47 lines) is **revised, not accepted**: it keeps the Implementation Rule, Epistemic and
Single-Source sections, which move to D1's file instead. Test with fresh sessions per the
card's method *after* D1 exists; testing earlier would test the wrong shape.

**D3 — Response Style moves to user level.** One file: `~/.claude/rules/response-style.md`
(or `~/.claude/CLAUDE.md`). It is removed from the root `CLAUDE.md` and
`framework-contract.md`, and the project auto-memory entry is replaced with a pointer. This
is Gary's personal configuration, outside the repo, so Gary writes or approves it. It is
independent of everything else and can happen now.

**D4 — The two mechanical bootstrap steps become hooks; the other two are deleted.**
- Step 3 (report `doing/`) becomes a SessionStart hook.
- Step 4 (`git mv` only) becomes a PreToolUse deny on `mv`/`Move-Item`/`cp` against the
  board path, with the reason naming `/fw-move`.
- Step 1 (ask the kind of work) and the `roles.default` persona are deleted.

Both hooks ship in the plugin against `kanban/`. Until the D5 crossover this repo's board is
`project-hub/work/`, so the hooks either take the board path from `workspace.yaml` or
`framework.yaml`, or a project-level interim hook covers it. That is decided on the card.

**D5 — `.claude/framework-contract.md` is deleted.** Its content *moves* into D1's plugin
file in the same commit (one home at all times). ADR-007's composer plan (D2/D4 there) is
withdrawn in the amendment. TECH-189's drift guard loses its main target and is re-scoped at
its own review, along with D7.

**D6 — The Implementation Rule stays in the contract, with an advisory hook trial.** A
PreToolUse hook on Edit/Write returns `ask` (not `deny`) when a non-board path changes while
`doing/` is empty. Advisory only, and fail-open. Trial it in this repo first.

**D7 — Adopt `/doctor prompt-audit` as the routine instruction check.** It natively covers
the "written for older models / dead reference / contradiction" part of this spike and part
of TECH-189. Gary runs it (it is a built-in command the AI cannot invoke here). The first run
should come after D1–D5 land, to confirm the result is clean.

**D8 — Commands stay commands for now.** Converting the 7 plugin commands to skills buys
`disable-model-invocation` and supporting-file folders, but the format is supported and
nothing is broken. File one low-priority card; don't do it before graduation.

**Settled, no change:** the board state set (TASK-242); plan mode and native tasks don't
replace the board or the `→ doing` review; the new build's prompting style is already clean.

**Q5, scope of change:**
- **Before graduation:** D1, D2, D4, D5 and D6. They are the contract channel, and
  graduation needs it.
- **Now, and independent:** D3.
- **After graduation:** D8. D7 comes after D1–D5.

**Follow-up artifacts, once approved:**
- an ADR-007 amendment (D1, D5);
- one card for the plugin contract hook plus the root `CLAUDE.md` rewrite (D1, D2, D5,
  which absorbs BUG-181's new-build scope);
- one card for the bootstrap hooks (D4, D6);
- one low-priority card for the command-to-skill conversion (D8);
- TECH-189 is re-scoped at its own review. D3 is Gary's to do.

## 6. Status of the decisions (2026-09-28, Gary)

| Decision | Status | Carried by |
|---|---|---|
| D1 contract via plugin hook | **Approved** (after the explanation that the hook is part of the plugin and runs every session; it is not an update prompt) | ADR-007 Amendment 1 (A1); BUG-181 re-scoped |
| D2 root `CLAUDE.md` repo-specific | **Approved** | A3; BUG-181 |
| D3 Response Style to user level | **Tabled** (Gary, 2026-09-28, after the D5 conflict was raised). **Open.** Gary asked how it works across machines. Answer given: a OneDrive file imported by a one-line `~/.claude/CLAUDE.md` on each machine. **Then found:** this reverses ADR-007 D5, which decided Response Style belongs *in the contract* and rejected `~/.claude/`. Under D1 the contract reaches every plugin repo on every machine, so keeping it in the contract solves the cross-machine problem too. Needs Gary's call. | Amendment 1 "under review" |
| D4 bootstrap hooks | **Approved** | A4; TECH-253 |
| D5 retire `framework-contract.md` | **Approved** | A2; BUG-181 |
| D6 advisory Implementation-Rule hook | **Tabled to 2026-09-29** ("feels awkward") | Amendment 1 "under review" |
| D7 `/doctor prompt-audit` | **Approved**, with a reminder | An acceptance criterion on BUG-181, so the done-gate enforces it |
| D8 commands stay commands | **Approved** | TECH-254 (Low) |
