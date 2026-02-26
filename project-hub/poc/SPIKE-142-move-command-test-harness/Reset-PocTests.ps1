# Reset-PocTests.ps1 - Reset 900-block test files to starting positions
# Removes all existing test files and recreates them from scratch.
# Run from repo root: powershell -ExecutionPolicy Bypass -File project-hub/poc/SPIKE-142-move-command-test-harness/Reset-PocTests.ps1

$HARNESS = "project-hub/poc/SPIKE-142-move-command-test-harness"

Write-Host "Cleaning up existing test files..."
powershell -ExecutionPolicy Bypass -File "$HARNESS/Cleanup-PocTests.ps1"

Write-Host ""
Write-Host "Recreating test files..."
powershell -ExecutionPolicy Bypass -File "$HARNESS/Create-PocTestItems.ps1"
