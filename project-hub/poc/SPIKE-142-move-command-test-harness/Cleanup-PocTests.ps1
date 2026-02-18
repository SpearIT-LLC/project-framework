# Cleanup-PocTests.ps1 - Remove all 200-block test files
# NOTE: Does NOT delete the spike folder or scripts — those are kept for future use.
# Run from repo root: powershell -ExecutionPolicy Bypass -File project-hub/poc/SPIKE-142-move-command-test-harness/Cleanup-PocTests.ps1

$REPO = "C:\Users\gelliott\OneDrive\Documents\SpearIT\Projects\project-framework"
$WORK = "$REPO\project-hub\work"

# Unstage everything first so deletions are clean
& git -C $REPO restore --staged . 2>&1 | Out-Null

# Delete all 200-block test files from all work folders
foreach ($folder in @("backlog", "todo", "doing", "done", "archive")) {
    $path = "$WORK\$folder"
    if (Test-Path $path) {
        Get-ChildItem $path | Where-Object { $_.Name -match "^(FEAT|BUG|TECH)-2\d\d[-.]" } | ForEach-Object {
            Remove-Item $_.FullName -Force
            Write-Host "Deleted: $($_.Name)"
        }
    }
}

Write-Host ""
Write-Host "Done. Test files removed. Spike scripts retained for future use."
