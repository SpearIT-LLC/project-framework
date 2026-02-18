# Create-PocTestItems.ps1 - Create 200-block dummy work items for poc-move.sh testing
# Run from repo root: powershell -ExecutionPolicy Bypass -File project-hub/poc/SPIKE-142-move-command-test-harness/Create-PocTestItems.ps1

$REPO = "C:\Users\gelliott\OneDrive\Documents\SpearIT\Projects\project-framework"
$WORK = "$REPO\project-hub\work"

$items = @(
    # [destination, filename]

    # Standard cases — start in backlog
    @("backlog", "FEAT-201-test-single-full-id.md"),
    @("backlog", "FEAT-202-test-single-numeric-id.md"),
    @("backlog", "FEAT-203-test-batch-full-id-a.md"),
    @("backlog", "BUG-204-test-batch-full-id-b.md"),
    @("backlog", "FEAT-205-test-batch-numeric-a.md"),
    @("backlog", "TECH-206-test-batch-numeric-b.md"),
    @("backlog", "FEAT-207-test-batch-mixed-full.md"),
    @("backlog", "TECH-208-test-batch-mixed-numeric.md"),

    # Parent + children
    @("backlog", "FEAT-209-test-parent.md"),
    @("backlog", "FEAT-209.1-test-child-one.md"),
    @("backlog", "FEAT-209.2-test-child-two.md"),
    @("backlog", "FEAT-209.3-test-child-three.md"),

    # Multi-extension (both files should move together)
    @("backlog", "FEAT-210-test-any-extension.md"),
    @("backlog", "FEAT-210-test-any-extension.txt"),

    # Already in target — stays in todo
    @("todo",    "FEAT-211-test-already-in-todo.md"),

    # Blocked transition — starts in done
    @("done",    "FEAT-212-test-in-done.md"),

    # Substring collision trap — 201 must NOT match this
    @("backlog", "FEAT-2010-test-substring-trap.md")
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
