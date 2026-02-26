# Create-PocTestItems.ps1 - Create 900-block dummy work items for poc-move.sh testing
# IDs 900-999 are reserved for framework test fixtures (not used by real work items)
# Run from repo root: powershell -ExecutionPolicy Bypass -File project-hub/poc/SPIKE-142-move-command-test-harness/Create-PocTestItems.ps1

$REPO = "C:\Users\gelliott\OneDrive\Documents\SpearIT\Projects\project-framework"
$WORK = "$REPO\project-hub\work"

$items = @(
    # [destination, filename, id, title, type, priority]

    # Standard cases — start in backlog
    @("backlog", "FEAT-901-test-single-full-id.md",    "FEAT-901",   "Test Single Full ID",       "Feature", "Medium"),
    @("backlog", "FEAT-902-test-single-numeric-id.md", "FEAT-902",   "Test Single Numeric ID",    "Feature", "Medium"),
    @("backlog", "FEAT-903-test-batch-full-id-a.md",   "FEAT-903",   "Test Batch Full ID A",      "Feature", "Medium"),
    @("backlog", "BUG-904-test-batch-full-id-b.md",    "BUG-904",    "Test Batch Full ID B",      "Bug",     "High"),
    @("backlog", "FEAT-905-test-batch-numeric-a.md",   "FEAT-905",   "Test Batch Numeric A",      "Feature", "Medium"),
    @("backlog", "TECH-906-test-batch-numeric-b.md",   "TECH-906",   "Test Batch Numeric B",      "Tech",    "Low"),
    @("backlog", "FEAT-907-test-batch-mixed-full.md",  "FEAT-907",   "Test Batch Mixed Full",     "Feature", "Medium"),
    @("backlog", "TECH-908-test-batch-mixed-numeric.md","TECH-908",  "Test Batch Mixed Numeric",  "Tech",    "Low"),

    # Parent + children
    @("backlog", "FEAT-909-test-parent.md",            "FEAT-909",   "Test Parent",               "Feature", "Medium"),
    @("backlog", "FEAT-909.1-test-child-one.md",       "FEAT-909.1", "Test Child One",            "Feature", "Medium"),
    @("backlog", "FEAT-909.2-test-child-two.md",       "FEAT-909.2", "Test Child Two",            "Feature", "Medium"),
    @("backlog", "FEAT-909.3-test-child-three.md",     "FEAT-909.3", "Test Child Three",          "Feature", "Medium"),

    # Multi-extension (both files should move together)
    @("backlog", "FEAT-910-test-any-extension.md",     "FEAT-910",   "Test Any Extension",        "Feature", "Low"),
    @("backlog", "FEAT-910-test-any-extension.txt",    "FEAT-910",   "Test Any Extension",        "Feature", "Low"),

    # Already in target — stays in todo
    @("todo",    "FEAT-911-test-already-in-todo.md",   "FEAT-911",   "Test Already In Todo",      "Feature", "Medium"),

    # Blocked transition — starts in done
    @("done",    "FEAT-912-test-in-done.md",           "FEAT-912",   "Test In Done",              "Feature", "Medium"),

    # Substring collision trap — 901 must NOT match this
    @("backlog", "FEAT-9010-test-substring-trap.md",   "FEAT-9010",  "Test Substring Trap",       "Feature", "Low")
)

foreach ($item in $items) {
    $folder   = $item[0]
    $name     = $item[1]
    $id       = $item[2]
    $title    = $item[3]
    $type     = $item[4]
    $priority = $item[5]
    $path     = "$WORK\$folder\$name"

    $content = @"
# $($type): $title

**ID:** $id
**Type:** $type
**Priority:** $priority
**Status:** $($folder.Substring(0,1).ToUpper() + $folder.Substring(1))
**Created:** 2026-02-25

---

Test fixture — reserved ID block 900-999.
"@

    Set-Content -Path $path -Value $content -Force
    Write-Host "Created: $folder/$name"
}

# --- Policy check fixtures (custom content — not suitable for generic loop) ---

# FEAT-913: Dependency not in done/ — blocks → doing
Set-Content -Path "$WORK\todo\FEAT-913-test-dep-not-done.md" -Value @"
# Feature: Test Dependency Not Done

**ID:** FEAT-913
**Type:** Feature
**Priority:** Medium
**Status:** Todo
**Created:** 2026-02-25
**Depends On:** FEAT-999

---

Test fixture — dependency check. FEAT-999 does not exist in done/.
Moving → doing should be blocked by the script.
"@ -Force
Write-Host "Created: todo/FEAT-913-test-dep-not-done.md"

# FEAT-914: Unchecked acceptance criteria — blocks → done
Set-Content -Path "$WORK\todo\FEAT-914-test-unchecked-criteria.md" -Value @"
# Feature: Test Unchecked Criteria

**ID:** FEAT-914
**Type:** Feature
**Priority:** Medium
**Status:** Todo
**Created:** 2026-02-25

---

Test fixture — unchecked criteria block. Moving → done should be blocked by the script.

## Acceptance Criteria

- [x] First criterion (done)
- [ ] Second criterion (not done)
- [ ] Third criterion (not done)
"@ -Force
Write-Host "Created: todo/FEAT-914-test-unchecked-criteria.md"

# FEAT-915: Readiness markers — blocks → todo without --force, warns with --force
Set-Content -Path "$WORK\backlog\FEAT-915-test-readiness-markers.md" -Value @"
# Feature: Test Readiness Markers

**ID:** FEAT-915
**Type:** Feature
**Priority:** Medium
**Status:** Backlog
**Created:** 2026-02-25

---

Test fixture — readiness markers. Moving → todo should block without --force and warn with --force.

## Notes

TODO: decide the implementation approach
TBD: confirm scope with stakeholder

## Options

Option A: Use approach X
Option B: Use approach Y
"@ -Force
Write-Host "Created: backlog/FEAT-915-test-readiness-markers.md"

# FEAT-916: All criteria checked — allows → done
Set-Content -Path "$WORK\todo\FEAT-916-test-all-criteria-checked.md" -Value @"
# Feature: Test All Criteria Checked

**ID:** FEAT-916
**Type:** Feature
**Priority:** Medium
**Status:** Todo
**Created:** 2026-02-25

---

Test fixture — all criteria checked. Moving → done should be allowed.

## Acceptance Criteria

- [x] First criterion
- [x] Second criterion
- [x] Third criterion
"@ -Force
Write-Host "Created: todo/FEAT-916-test-all-criteria-checked.md"

Write-Host ""
Write-Host "Staging all test files for git mv to work..."
& git -C $REPO add "project-hub/work/" 2>&1
Write-Host "Done. Test files are staged and ready."
Write-Host ""
Write-Host "Run tests with:"
Write-Host "  powershell -ExecutionPolicy Bypass -File project-hub/poc/SPIKE-142-move-command-test-harness/Run-PocMove.ps1"
Write-Host ""
Write-Host "Reset between full runs with:"
Write-Host "  powershell -ExecutionPolicy Bypass -File project-hub/poc/SPIKE-142-move-command-test-harness/Reset-PocTests.ps1"
