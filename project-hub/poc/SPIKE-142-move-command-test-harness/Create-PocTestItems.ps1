# Create-PocTestItems.ps1 - Create 900-block dummy work items for poc-move.sh testing
# IDs 900-999 are reserved for framework test fixtures (not used by real work items)
# Run from repo root: powershell -ExecutionPolicy Bypass -File project-hub/poc/SPIKE-142-move-command-test-harness/Create-PocTestItems.ps1

$REPO = "C:\Users\gelliott\OneDrive\Documents\SpearIT\Projects\project-framework"
$WORK = "$REPO\project-hub\work"

$items = @(
    # [destination, filename]

    # Standard cases — start in backlog
    @("backlog", "FEAT-901-test-single-full-id.md"),
    @("backlog", "FEAT-902-test-single-numeric-id.md"),
    @("backlog", "FEAT-903-test-batch-full-id-a.md"),
    @("backlog", "BUG-904-test-batch-full-id-b.md"),
    @("backlog", "FEAT-905-test-batch-numeric-a.md"),
    @("backlog", "TECH-906-test-batch-numeric-b.md"),
    @("backlog", "FEAT-907-test-batch-mixed-full.md"),
    @("backlog", "TECH-908-test-batch-mixed-numeric.md"),

    # Parent + children
    @("backlog", "FEAT-909-test-parent.md"),
    @("backlog", "FEAT-909.1-test-child-one.md"),
    @("backlog", "FEAT-909.2-test-child-two.md"),
    @("backlog", "FEAT-909.3-test-child-three.md"),

    # Multi-extension (both files should move together)
    @("backlog", "FEAT-910-test-any-extension.md"),
    @("backlog", "FEAT-910-test-any-extension.txt"),

    # Already in target — stays in todo
    @("todo",    "FEAT-911-test-already-in-todo.md"),

    # Blocked transition — starts in done
    @("done",    "FEAT-912-test-in-done.md"),

    # Substring collision trap — 901 must NOT match this
    @("backlog", "FEAT-9010-test-substring-trap.md")
)

foreach ($item in $items) {
    $folder = $item[0]
    $name   = $item[1]
    $path   = "$WORK\$folder\$name"
    New-Item -ItemType File -Path $path -Force | Out-Null
    Write-Host "Created: $folder/$name"
}

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
