<!-- DRAFT for SPIKE-248. Not applied. This is a proposed replacement for the root
     CLAUDE.md, about 40 lines instead of 134. Each removed section is listed at the end
     with where it goes. -->

# SpearIT Project Framework

This is the **framework source repo**. `workspaces/framework/` is the new build, and it
is the plugin (ADR-009). Everything else (`framework/`, `templates/`, `tools/`,
`plugins/`) is the old line. **Inside `workspaces/framework/`, that directory's own
`CLAUDE.md` is the sole authority.**

`framework.yaml` indexes every topic's source of truth under `sources:`. Look there
before asking where something is documented.

## The Implementation Rule (ADR-001 / ADR-007 D7)

**Implement only work that is in `doing/`.** Planning may happen anywhere. Before any
implementation, move the item with `/fw-move <id> doing`. That move runs the
pre-implementation review. A hook warns when source changes while `doing/` is empty. The
hook cannot judge whether an edit belongs to the card, so this rule still has to be
followed.

## Epistemic Standards

- **Verify before stating.** Read the file, run the command, check the source. If
  verification fails, say so. Never fall back to guessing without saying you did.
- **Label interpretation** ("I believe…", "My reading is…"). Never present inference as
  fact.

## One Source per Concept (ADR-008)

Content lives in one home. Every other copy is derived at build time or is a pointer.
Invariants live in scripts and hooks, not paragraphs. Verify against the built plugin,
not this source tree.

---
<!-- WHERE THE REMOVED SECTIONS GO (for the spike to confirm):
     - BOOTSTRAP 1 "ask what kind of work": dropped. The user almost always states it.
     - BOOTSTRAP 2 "read framework.yaml": kept as the pointer above.
     - BOOTSTRAP 3 "report doing/": a SessionStart hook that prints the WIP state.
     - BOOTSTRAP 4 "git mv only": a PreToolUse hook that blocks mv/Move-Item/cp on
       project-hub/work/.
     - Response Style: user-level (~/.claude memory or an output style). It describes
       Gary and applies in every repo.
     - Onboarding / "This Repository" detail: README.md, reached through framework.yaml.
     - .claude/framework-contract.md: either composed into this file with a drift check
       (TECH-189), or deleted. SPIKE-248 decides which. -->
