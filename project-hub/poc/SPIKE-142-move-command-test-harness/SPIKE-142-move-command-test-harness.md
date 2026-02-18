# SPIKE-142: Move Command Test Harness

**Status:** Active
**Created:** 2026-02-18
**Related Work:** FEAT-141 (Move Command Batch Support), BUG-140 (Child Item Detection)

---

## Purpose

Reusable test harness for validating `move` command bash script logic. Kept as a live spike rather than archived because the move command may evolve and having a ready test harness has ongoing value.

---

## What It Tests

11 scenarios covering all standard and edge cases for the move command:

| # | Scenario | Test Items |
|---|----------|------------|
| 1 | Single item, full ID | `FEAT-201` |
| 2 | Single item, numeric ID only | `202` |
| 3 | Batch, full IDs | `FEAT-203, BUG-204` |
| 4 | Batch, numeric IDs | `205, 206` |
| 5 | Batch, mixed | `FEAT-207, 208` |
| 6 | Parent + children auto-follow | `FEAT-209` (+ `.1/.2/.3`) |
| 7 | Already in target → skip | `FEAT-211` (starts in `todo/`) |
| 8 | Missing ID in batch → skip, continue | `FEAT-201, FEAT-999` |
| 9 | Substring collision (`201` ≠ `2010`) | `FEAT-201` vs `FEAT-2010` |
| 10 | Any file extension (`.md` + `.txt`) | `FEAT-210` |
| 11 | Blocked transition (`done` → `todo`) | `FEAT-212` (starts in `done/`) |

---

## Files

| File | Purpose |
|------|---------|
| `poc-move.sh` | The bash script under test — mirrors logic in `plugins/*/commands/move.md` |
| `Create-PocTestItems.ps1` | Creates 200-block dummy work items in correct starting positions |
| `Reset-PocTests.ps1` | Resets all items to starting positions between runs |
| `Run-PocMove.ps1` | Runs all 11 test scenarios end-to-end |
| `Cleanup-PocTests.ps1` | Removes all test files and POC scripts (self-deletes) |

---

## Usage

**Full automated run:**
```powershell
powershell -ExecutionPolicy Bypass -File project-hub/poc/SPIKE-142-move-command-test-harness/Run-PocMove.ps1
```

**Step by step (for targeted testing):**
```powershell
# 1. Create test items
powershell -ExecutionPolicy Bypass -File project-hub/poc/SPIKE-142-move-command-test-harness/Create-PocTestItems.ps1

# 2. Run individual scenarios
bash project-hub/poc/SPIKE-142-move-command-test-harness/poc-move.sh FEAT-201 todo
bash project-hub/poc/SPIKE-142-move-command-test-harness/poc-move.sh "205, 206" todo
bash project-hub/poc/SPIKE-142-move-command-test-harness/poc-move.sh FEAT-209 todo

# 3. Reset between runs
powershell -ExecutionPolicy Bypass -File project-hub/poc/SPIKE-142-move-command-test-harness/Reset-PocTests.ps1

# 4. Clean up when done
powershell -ExecutionPolicy Bypass -File project-hub/poc/SPIKE-142-move-command-test-harness/Cleanup-PocTests.ps1
```

---

## Key Findings (from FEAT-141 session, 2026-02-18)

**Problem 1 — CWD not guaranteed:**
- Original scripts used relative paths (`find project-hub/work`) with no guarantee of CWD
- Silent failure: `find` returned nothing, script exited 0 with no output
- Fix: `git rev-parse --show-toplevel` + `cd` at script start

**Problem 2 — Type prefix included in match:**
- Original: `iname "${ITEM_ID}-*.md"` kept `FEAT-`, `BUG-` as part of the pattern
- Meant bare numeric input (`202`) couldn't match `FEAT-202-...md`
- Fix: strip type prefix with `sed 's/^[A-Za-z]*[-_]*//'`; match on numeric ID only

**Problem 3 — `set -e` + `pipefail` killed script on empty grep:**
- `grep` exits 1 when no match found
- With `pipefail`, any `find | grep` that finds nothing would abort the whole script
- Fix: `|| true` on all `find | grep` pipelines

**Problem 4 — Only `.md` files matched:**
- Original: `find -iname "*.md"` excluded supporting files (`.txt`, etc.)
- Fix: `find` with no name filter, piped through `grep` for ID anchoring

**Regex pattern (final):**
```bash
# Parent match (not children):
grep -iE "[-]${numeric_id}([-.]|$)"   # ID preceded by -, followed by -, ., or end
grep -ivE "[-]${numeric_id}[.][0-9]"  # exclude .1 .2 .3 suffixes

# Children only:
grep -iE "[-]${numeric_id}[.][0-9]"
```

---

## Sync Note

If `plugins/*/commands/move.md` script logic changes, update `poc-move.sh` to match so tests remain valid.

---

**Last Updated:** 2026-02-18
