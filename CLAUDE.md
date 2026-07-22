# Claude Context: SpearIT Project Framework

<!-- ─────────────────────────────────────────────────────────────────────
     BEGIN FRAMEWORK CONTRACT
     This region is the framework's collaboration contract. It is AUTHORED to
     match .claude/framework-contract.md (the single source of truth) and
     VERIFIED against it by tools/Check-ContractDrift.ps1 (advisory). Unlike a
     derived project's CLAUDE.md, this repo's contract region is not build-
     composed — it is dogfooded by hand. Keep it byte-identical to the SoT;
     edit .claude/framework-contract.md first, then reconcile here.
     ───────────────────────────────────────────────────────────────────── -->

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

## The Single-Source Rule (ADR-008)

**One authored source per concept. Everything else is derived or a pointer — never a hand-kept copy.**
Duplication is not untidiness; it is a measurable tax that degrades the AI (stale copies mislead it) and
drifts silently until it surfaces as a bug. A rule written in prose does not prevent this — DRY held only
where it was *mechanical*.

So: content lives in exactly one home; other channels are composed from it at build, or point at it via
`framework.yaml`'s `sources:` index (pointers, never restatement). Invariants that must hold live behind a
command/script chokepoint, not a paragraph — an instruction the AI merely *reads* is not a guardrail.
Verify against the built artifact, not the source repo: a guarantee that works here but doesn't ship
hasn't shipped.

---

## Onboarding

**New here? Ask the AI for a tour of the framework.** It may be verbose and unstructured for now, but it
gives you somewhere to start. The sources of truth are indexed in `framework.yaml`; `README.md` and
`QUICK-START.md` are the AI-less fallback.

<!-- END FRAMEWORK CONTRACT -->


<!-- ─────────────────────────────────────────────────────────────────────
     BEGIN PROJECT INSTRUCTIONS
     This region is this repo's own. The framework never overwrites it.
     ───────────────────────────────────────────────────────────────────── -->

## This Repository

This is the **framework source repo** — one project, not several. Its parts: `framework/` is the product,
`templates/` packages it for distribution, `tools/` builds the archives, `plugins/` are the plugin
editions. See [README.md](README.md) for the full repository structure and
[framework.yaml](framework.yaml) for machine-readable configuration (schema:
[framework/docs/ref/framework-schema.yaml](framework/docs/ref/framework-schema.yaml)).

Work happens against these parts directly — "framework improvements" go in `framework/`, "template
updates" in `templates/`, "build tooling" in `tools/`. Nobody works on `tools/` (or any subdirectory) as
a separate project.

<!-- END PROJECT INSTRUCTIONS -->
