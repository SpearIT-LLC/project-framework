# Feature: Move Command - Batch Item Support

**ID:** FEAT-141
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-02-17
**Theme:** Workflow

**Depends On:** BUG-140 (Move Command - Child Item Detection)

---

## Summary

Extend the `move` command in both plugins to accept a list of work item IDs, moving all of them to the same target folder in a single command invocation.

---

## Problem Statement

**What problem does this solve?**

Moving multiple related items currently requires issuing one command per item. When pulling a set of backlog items into todo, or completing a batch of work at end of session, this is repetitive and slow.

**Who is affected?**

All plugin users, both light and full editions.

**Current workaround:**

Issue `/move` once per item.

---

## Proposed Syntax

```
/move "FEAT-136, FEAT-137, FEAT-138" todo
/move "136, 137, 138" todo          ← bare numbers, resolved by unique ID scan
/move "FEAT-136, 140, CHORE-133" todo  ← mixed full and bare IDs
```

---

## Parsing Rules

### Intent-First Parsing

Claude is parsing this, not a shell script. If intent is clear, execute it. Don't require perfect syntax.

**Target folder detection:**
- Last token is checked against valid folder names: `backlog`, `todo`, `doing`, `done`, `archive`
- If last token is a valid folder → it's the target, everything else is the item list
- If last token is NOT a valid folder → report error asking for a valid target

**Item list parsing:**
- Strip surrounding quotes (if any)
- Split on commas, spaces, or both
- Filter out any tokens that match valid folder names (handles misplaced target)
- Remaining tokens are resolved as IDs

**ID resolution:**
- Full ID (`FEAT-136`, `BUG-140`) → match directly, case insensitive
- Bare number (`136`, `140`) → scan all work folders, match file with that number regardless of type prefix
- If bare number matches zero files → report not found, skip
- If bare number matches more than one file → **data integrity error**, stop and report

### Forgiving Examples

| Input | Parsed as |
|---|---|
| `"FEAT-136, FEAT-137" todo` | items: FEAT-136, FEAT-137 · target: todo |
| `FEAT-136, FEAT-137 todo` | items: FEAT-136, FEAT-137 · target: todo |
| `FEAT-136 FEAT-137 todo` | items: FEAT-136, FEAT-137 · target: todo |
| `"136, 137, 138" todo` | items: 136→resolve, 137→resolve, 138→resolve · target: todo |
| `"FEAT-136, FEAT-137 todo"` | items: FEAT-136, FEAT-137 · target: todo (folder detected inside quotes) |

---

## Behavior

### Per-Item Processing

Each item in the list is processed independently using the same logic as single-item move:
- Transition rules apply per item (e.g., backlog → doing is still invalid)
- Parent + children move together (per BUG-140 fix)
- WIP limit checked once before batch, warned if exceeded

### Error Handling

| Situation | Behavior |
|---|---|
| Item not found | Report + skip, continue with rest |
| Duplicate ID (data integrity) | Stop entire batch, report which ID has duplicates, prompt user to fix |
| Invalid transition for one item | Report + skip that item, continue with rest |
| No valid target folder detected | Report error with valid folder names, stop |

### Output Format

```
Moving 3 items to todo/...

✅ FEAT-136-project-guidance-design-doc.md
✅ FEAT-137-plugin-project-guidance-commands.md
❌ FEAT-999 - not found (skipped)

📊 WIP: 4/10 items in todo/
```

---

## Requirements

### Functional Requirements

- [ ] Comma-separated list of IDs accepted as first argument
- [ ] Space-separated list of IDs accepted (no quotes required)
- [ ] Bare numeric IDs resolved by unique ID scan across all work folders
- [ ] Mixed full and bare IDs in same command work correctly
- [ ] Duplicate ID (data integrity error) stops batch and reports affected ID
- [ ] Not-found items skipped with report, rest of batch continues
- [ ] Invalid transition skipped with report, rest of batch continues
- [ ] WIP limit checked and warned before batch executes
- [ ] Output summarizes all moves: succeeded, skipped, failed

### Non-Functional Requirements

- [ ] Applied to both plugin editions (light and full)
- [ ] Single-item syntax continues to work unchanged (backwards compatible)
- [ ] Performance: batch of 10 items completes in < 30 seconds

---

## Affected Files

- `plugins/spearit-framework/commands/move.md`
- `plugins/spearit-framework-light/commands/move.md`

Both files need identical updates — batch logic is shared behavior.

---

## Dependencies

**Requires:**
- BUG-140 (Move Command - Child Item Detection) — batch move inherits the fixed find logic

**Blocks:** Nothing

**Related:**
- BUG-140 — fix that enables correct per-item resolution

---

## Acceptance Criteria

- [ ] `move "FEAT-136, FEAT-137" todo` moves both items
- [ ] `move FEAT-136 FEAT-137 todo` (no quotes) moves both items
- [ ] `move "136, 137" todo` resolves bare numbers and moves both items
- [ ] Duplicate ID detected → batch stops, clear error reported
- [ ] Not-found ID → skipped, rest of batch continues
- [ ] Invalid transition → that item skipped, rest of batch continues
- [ ] Single-item syntax still works unchanged
- [ ] Both plugins updated

---

## Notes

**Why depends on BUG-140?**
The batch implementation reuses the same find-and-move logic per item. Building batch on broken single-item logic would compound the bug. Fix the foundation first.

**Parsing philosophy:** Claude is the parser. Lean on intent recognition rather than strict syntax. If a human typed it and the meaning is clear, execute it.

---

**Last Updated:** 2026-02-17
