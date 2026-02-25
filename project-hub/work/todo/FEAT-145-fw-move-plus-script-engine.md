# Feature: fw-move+ — Script-Backed Move Command with Batch & Child Support

**ID:** FEAT-145
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-02-19
**Theme:** Workflow / Performance

---

## Summary

Upgrade `fw-move` to use a promoted `move.sh` script as its execution engine, adding batch ID support, child item handling, any-extension support, and untracked file fallback — while preserving all existing AI-layer precondition checks and post-move actions.

---

## Problem Statement

**What problem does this solve?**

`fw-move` and the plugin `move` command have diverged. The plugin gained batch moves, child handling, bare numeric IDs, multi-extension support, and untracked file fallback. `fw-move` has none of these. Users working with `fw-move` get a slower, less capable experience.

Additionally, `fw-move` currently has Claude interpret and execute each file operation individually — which is slow and token-expensive. The SPIKE-142 POC demonstrated that a bash script engine cuts execution time significantly.

**Who is affected?**

All framework users using `fw-move` (non-plugin workflow).

---

## Proposed Design

### Two-Layer Architecture

**Script layer (`framework/scripts/move.sh`):**
Promoted and cleaned up from `poc-move.sh`. Handles all deterministic operations:
- Argument parsing (IDs, target folder)
- ID normalization and resolution (full ID, bare numeric, case-insensitive)
- File finding (parents, children, any extension)
- Transition rule enforcement
- Batch execution with per-item output
- Untracked file fallback (`mv` when `git mv` fails)

**AI layer (`fw-move` command):**
Thin wrapper around `move.sh`. Handles policy and judgment:
- Pre-move validation (Priority set? Dependencies met? Acceptance criteria?)
- Interactive recovery ("2 criteria unchecked — fix them?")
- Calls `bash framework/scripts/move.sh <ids> <target>`
- Post-move actions (pre-implementation review for `doing`, session history for `done`, metadata prompts for `archive`/`blocked`)

### New Capabilities (matching plugin)

- Batch: `/fw-move "FEAT-136, FEAT-137" todo`
- Bare numeric IDs: `/fw-move 136 todo`
- Mixed: `/fw-move "FEAT-136, 137" todo`
- Child items auto-move with parent
- Any file extension moves together
- Untracked files handled gracefully

### Preserved Capabilities (fw-move advantages)

- Full transition matrix enforcement (including `releases` target)
- Hard precondition checks before move
- Dependency validation (Depends On → must be in done/)
- Acceptance criteria verification before → done
- Metadata requirements for → blocked and → archive
- Post-move session history and commit prompts

---

## Affected Files

- `framework/scripts/move.sh` (new — promoted from POC)
- `.claude/commands/fw-move.md` (updated — calls script, adds batch syntax)
- `project-hub/poc/SPIKE-142-move-command-test-harness/` (reference source)

---

## Dependencies

**Informed by:**
- SPIKE-142 — Move command test harness (POC source)
- FEAT-141 — Plugin batch move support
- TECH-135 — Move command performance optimization

**Blocks:** Nothing

---

## Acceptance Criteria

- [ ] `move.sh` promoted to `framework/scripts/move.sh`, cleaned up from POC
- [ ] `fw-move` accepts batch ID syntax (comma/space separated, bare numeric, mixed)
- [ ] Child items auto-move when parent is moved
- [ ] Any file extension moves with parent
- [ ] Untracked files fall back to `mv` with `(untracked)` annotation
- [ ] All existing precondition checks preserved (Priority, Dependencies, Acceptance Criteria)
- [ ] All post-move actions preserved (review, session history, metadata prompts)
- [ ] Single-item syntax unchanged (backwards compatible)
- [ ] Full transition matrix enforced (including `releases`, `blocked`)
- [ ] Performance: batch of 5 items faster than current single-item fw-move

---

## Notes

**Why a shared script rather than shared command file?**
`fw-move` and the plugin commands serve different contexts. The AI-layer policy (preconditions, post-move actions) differs between them. A shared execution script keeps the fast/deterministic parts in one place without forcing the policy layers to merge.

**Script location:** `framework/scripts/` — keeps it alongside other framework tooling, separate from POC/test artifacts.

---

**Last Updated:** 2026-02-19
