# Feature: Guided Purpose Intake for `/fw-new-workspace` — Mini-Swarm Without the Ceremony

**ID:** FEAT-191
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-08-18
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Replace the single "What is this workspace for, in a sentence or two?" question in
`/fw-new-workspace` (step 2, the judgment step) with a short guided intake — a few targeted
questions that seed the workspace README with something actually useful. Swarm-style elicitation,
but 3–4 questions instead of a facilitated session.

Gary, 2026-08-18, on first real use of the command: *"your question might need more depth. More
like a mini swarm but without all the ceremony."*

---

## Problem Statement

**What is the current state?** (verified 2026-08-18)

- `workspaces/framework/commands/fw-new-workspace.md` step 2 asks one open question and writes the
  answer into the README's `**Purpose:**` line. That is the entire captured context for a new
  workspace.
- For a real workspace (an application, a client SOW), one sentence undersells the moment: workspace
  creation is exactly when the human has the context in their head, and the command captures almost
  none of it.

**What is the desired state?**

- `/fw-new-workspace` runs a short, type-aware intake after scaffolding — on the order of: who is it
  for, what does done look like, key constraints, first deliverable.
- Answers land in the generated `README.md` in a small structured block, not just one line.
- The ceremony stays low: a handful of questions, skippable (a placeholder workspace shouldn't
  require a interrogation — "test placeholder" remains a valid one-line answer).

---

## Scope

**In scope:**
- The intake question set, per workspace type (`application`, `sow`, `knowledgebase`, `operations`
  likely want different questions).
- README template additions to hold the answers (template content lives with the script/templates in
  `workspaces/framework/`, per the Single-Source Rule).
- A fast path: user can decline depth and give a one-liner.

**Out of scope:**
- Changing the folder scaffold or `scripts/fw-new-workspace.sh` structure authority (ADR-009 D3
  stands — the script remains the one home for structure).
- Full `/fw-swarm` facilitation; this is explicitly the no-ceremony version.

---

## Acceptance Criteria

- [ ] Intake questions defined per workspace type (or one set with type-aware phrasing)
- [ ] Generated README carries the structured answers, not only a one-line purpose
- [ ] One-liner fast path preserved for placeholder/test workspaces
- [ ] Folder structure authority unchanged: script remains the sole home (ADR-009 D3)
- [ ] Verified against the built plugin, not the source tree

---

## Documentation

- [ ] `fw-new-workspace.md` command doc reflects the intake flow (it is the flow's one home)
- [ ] CHANGELOG entry in the framework workspace

---

## Related

- **FEAT-164** — implemented `/fw-new-workspace`; this deepens its step 2.
- **ADR-009 D3** — workspaces are stood up by command, not improvisation; unchanged here.
- **`/fw-swarm`** — the full-ceremony ancestor of this intake's style.
