# Reset-PocTests.ps1 - Reset 900-block test files to starting positions
# Run between full test suite runs.
# Run from repo root: powershell -ExecutionPolicy Bypass -File project-hub/poc/SPIKE-142-move-command-test-harness/Reset-PocTests.ps1

$REPO = "C:\Users\gelliott\OneDrive\Documents\SpearIT\Projects\project-framework"
$WORK = "$REPO\project-hub\work"

# Move all 900-block test files from any work folder back to backlog
foreach ($folder in @("backlog", "todo", "doing", "done", "archive")) {
    $path = "$WORK\$folder"
    if (Test-Path $path) {
        Get-ChildItem $path | Where-Object { $_.Name -match "^(FEAT|BUG|TECH)-9\d\d\d?[-.]" } | ForEach-Object {
            Move-Item $_.FullName "$WORK\backlog\$($_.Name)" -Force
            Write-Host "Reset: $($_.Name) -> backlog"
        }
    }
}

# FEAT-911 belongs in todo
$f911 = "$WORK\backlog\FEAT-911-test-already-in-todo.md"
if (Test-Path $f911) {
    Move-Item $f911 "$WORK\todo\" -Force
    Write-Host "Reset: FEAT-911 -> todo"
}

# FEAT-912 belongs in done
$f912 = "$WORK\backlog\FEAT-912-test-in-done.md"
if (Test-Path $f912) {
    Move-Item $f912 "$WORK\done\" -Force
    Write-Host "Reset: FEAT-912 -> done"
}

Write-Host ""
Write-Host "Re-staging files for git mv..."
& git -C $REPO add "project-hub/work/" 2>&1
Write-Host "Done. Ready for next test run."
