# SPIKE-145: Script-Layer Policy POC

**Status:** Active
**Created:** 2026-02-26
**Related Work:** FEAT-145 (fw-move+ Script-Backed Move Command)

---

## Purpose

Evaluate moving policy enforcement from the AI layer into the bash script layer.

The hypothesis: pushing hard-block checks into the script yields faster execution on the happy path (no AI policy checks needed) while keeping the AI layer focused on interactive recovery and post-move actions.

---

## What It Tests

| Check | Current (move.sh) | POC (poc-move-policy.sh) |
|-------|-------------------|--------------------------|
| Transition matrix | AI layer blocks | **Script hard-blocks** |
| Dependency check | AI layer blocks | **Script hard-blocks** |
| Acceptance criteria | AI layer blocks | **Script hard-blocks** |
| WIP limit | Script warns | Script warns (unchanged) |
| Interactive recovery | AI layer | AI layer (unchanged) |
| Post-move actions | AI layer | AI layer (unchanged) |

---

## Files

| File | Purpose |
|------|---------|
| `poc-move-policy.sh` | Modified move.sh with policy checks as hard blocks |
| `SPIKE-145-script-policy.md` | This file |

The companion `fw-move-poc` command is at `.claude/commands/fw-move-poc.md`.

---

## Architecture Comparison

### Current (move.sh + fw-move)

```
fw-move (AI)
  ├── Check transition matrix        ← AI call
  ├── Check dependencies             ← AI call
  ├── Check acceptance criteria      ← AI call
  └── bash framework/scripts/move.sh ← script executes
        └── WIP warning only
```

### POC (poc-move-policy.sh + fw-move-poc)

```
fw-move-poc (AI)
  └── bash poc-move-policy.sh        ← script executes
        ├── Check transition matrix  ← script hard-block
        ├── Check dependencies       ← script hard-block
        ├── Check acceptance criteria← script hard-block
        ├── WIP warning
        └── Move files
  └── (AI handles recovery + post-move only)
```

---

## What We Lose

- **Interactive recovery on failure** — script exits 1 with a message; no "fix it for me?" offer
  - Example: script says "2 criteria unchecked"; user must fix manually and re-run
  - Current: AI offers to mark them complete inline
- This is a deliberate trade-off: faster happy path, more friction for incomplete items

---

## Test Scenarios

Use existing 900-block test items. Key scenarios for policy checks:

| Scenario | Command | Expected |
|----------|---------|----------|
| Invalid transition | `bash poc-move-policy.sh FEAT-912 todo` | ❌ blocks (done→todo) |
| Valid transition | `bash poc-move-policy.sh FEAT-901 todo` | ✅ moves |
| Dep not in done/ | `bash poc-move-policy.sh FEAT-913 doing` | ❌ blocks (FEAT-999 not in done/) |
| Unchecked criteria | `bash poc-move-policy.sh FEAT-914 done` | ❌ blocks (2 unchecked) |
| Readiness markers (blocked) | `bash poc-move-policy.sh FEAT-915 todo` | ❌ blocks (TODO/TBD/Option markers) |
| Readiness markers (--force) | `bash poc-move-policy.sh FEAT-915 todo --force` | ⚠️ warns, moves |
| All criteria checked | `bash poc-move-policy.sh FEAT-916 done` | ✅ moves |

---

## Usage

```bash
# Test invalid transition (done → todo should be blocked)
bash project-hub/poc/SPIKE-145-script-policy/poc-move-policy.sh FEAT-912 todo

# Test valid move
bash project-hub/poc/SPIKE-145-script-policy/poc-move-policy.sh FEAT-901 todo

# Via fw-move-poc command
/fw-move-poc FEAT-901 todo
```

---

**Last Updated:** 2026-02-26
