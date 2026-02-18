# Reset-PocTests.ps1 - Reset 200-block test files to starting positions
# Run between full test suite runs.
# Run from repo root: powershell -ExecutionPolicy Bypass -File project-hub/poc/SPIKE-142-move-command-test-harness/Reset-PocTests.ps1

$REPO = "C:\Users\gelliott\OneDrive\Documents\SpearIT\Projects\project-framework"
$WORK = "$REPO\project-hub\work"

# Move all 200-block test files from any work folder back to backlog
foreach ($folder in @("backlog", "todo", "doing", "done", "archive")) {
    $path = "$WORK\$folder"
    if (Test-Path $path) {
        Get-ChildItem $path | Where-Object { $_.Name -match "^(FEAT|BUG|TECH)-2\d\d[-.]" } | ForEach-Object {
            Move-Item $_.FullName "$WORK\backlog\$($_.Name)" -Force
            Write-Host "Reset: $($_.Name) -> backlog"
        }
    }
}

# FEAT-211 belongs in todo
$f211 = "$WORK\backlog\FEAT-211-test-already-in-todo.md"
if (Test-Path $f211) {
    Move-Item $f211 "$WORK\todo\" -Force
    Write-Host "Reset: FEAT-211 -> todo"
}

# FEAT-212 belongs in done
$f212 = "$WORK\backlog\FEAT-212-test-in-done.md"
if (Test-Path $f212) {
    Move-Item $f212 "$WORK\done\" -Force
    Write-Host "Reset: FEAT-212 -> done"
}

Write-Host ""
Write-Host "Re-staging files for git mv..."
& git -C $REPO add "project-hub/work/" 2>&1
Write-Host "Done. Ready for next test run."
