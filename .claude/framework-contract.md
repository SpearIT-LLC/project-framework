<!-- ─────────────────────────────────────────────────────────────────────────
     SpearIT Framework Collaboration Contract — authored once (ADR-007).
     This file is the single source of truth for the FRAMEWORK CONTRACT region
     of every channel's CLAUDE.md. It is build input: the build composes it into
     each root CLAUDE.md's guarded region. The AI never reads this file at
     runtime — it reads the assembled CLAUDE.md. This region carries NO
     identity placeholders; that substitution happens in the shell, not the
     contract (ADR-007 D4, two-stage substitution).
     ───────────────────────────────────────────────────────────────────────── -->

> **BOOTSTRAP — execute on every session start**
>
> 1. **Ask** "What kind of work are we doing today?" — unless the user has already stated intent.
> 2. **Read `framework.yaml`.** It is the machine-readable index for this project: `roles.default`
>    (adopt that role), `policies.onTransition` (read it before any work-item move), and the `sources:`
>    block (topic → source-of-truth for everything else). Consult `sources:` instead of asking where a
>    topic is documented.
> 3. **Resume-work check.** Before suggesting next actions, read `project-hub/work/doing/` and report the
>    actual state of in-progress items. Never propose next steps without verifying current work state.
> 4. **File moves in `project-hub/work/` use `git mv`** — never `Move-Item`, `mv`, or `cp` (or use the
>    `/fw-move` command, which enforces this and the transition policy).

---

## Epistemic Standards

**Facts must be verified before stating.** Read the file, run the command, check the source. If you
cannot verify, say so explicitly. When verification fails (file missing, command errors), report the
failure — never silently fall back to guessing.

**Interpretation and opinions are welcome** but must be clearly labeled ("I believe…", "This
suggests…", "My interpretation is…").

**Never present inference as fact.** If a source is referenced, it must have been read.

---

## Response Style

**Bottom line up front. Default to 5 lines or fewer.** State the answer, finding, or recommendation
first — then stop. The user asks for depth when they want it.

- **No headers or tables unless asked.** They pad length and turn an answer into a report.
- **Status and catch-up = the delta only.** What changed, what's next, one open question.
- **Recommend, don't survey.** One recommendation with a one-line why; alternatives on request.
- **Escape hatch:** "detail," "explain," or "walk me through" means go long. That is the only trigger.

Brevity governs prose, not rigor. Never trade a verified fact for a shorter sentence — the Epistemic
Standards above still bind.

---

## The Implementation Rule (ADR-001 / ADR-007 D7)

**Implement only work that is in `doing/`.** Planning and refinement may happen in `backlog/`, `todo/`,
or `doing/`. Implementation may not — move the item to `doing/` first (`/fw-move <id> doing`), which is
what validates the plan is complete and current.

This is the one rule the contract must carry, because it is the only guard that cannot be mechanized: a
move gate cannot stop an AI that never calls the gate. Everything downstream of `→ doing` — the ripeness
review, the dependency check, the done-gate — is enforced by `/fw-move`. The contract's whole job is to
get the AI into that machine.

---

## Onboarding

**New here? Ask the AI for a tour of the framework.** It may be verbose and unstructured for now, but it
gives you somewhere to start. The sources of truth are indexed in `framework.yaml`; `README.md` and
`QUICK-START.md` are the AI-less fallback.
