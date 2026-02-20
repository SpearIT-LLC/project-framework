# Run-PocMove.ps1 - Full test suite for poc-move.sh
# Run from repo root: powershell -ExecutionPolicy Bypass -File project-hub/poc/SPIKE-142-move-command-test-harness/Run-PocMove.ps1
#
# Creates test items, runs all 11 scenarios, then shows cleanup instructions.

$REPO = "C:\Users\gelliott\OneDrive\Documents\SpearIT\Projects\project-framework"
$BASH = "C:\Users\gelliott\AppData\Local\Programs\Git\bin\bash.exe"
$SPIKE = "project-hub/poc/SPIKE-142-move-command-test-harness"

Set-Location $REPO

function Invoke-Bash([string]$cmd) {
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $BASH
    $pinfo.Arguments = "-c `"$cmd`""
    $pinfo.RedirectStandardOutput = $true
    $pinfo.RedirectStandardError = $true
    $pinfo.UseShellExecute = $false
    $pinfo.WorkingDirectory = $REPO
    $p = [System.Diagnostics.Process]::Start($pinfo)
    $out = $p.StandardOutput.ReadToEnd()
    $err = $p.StandardError.ReadToEnd()
    $p.WaitForExit()
    if ($out) { Write-Host $out.TrimEnd() }
    if ($err) { Write-Host "STDERR: $($err.TrimEnd())" -ForegroundColor Yellow }
    return $p.ExitCode
}

function Run-Test([string]$label, [string]$bashArgs) {
    Write-Host ""
    Write-Host "TEST: $label" -ForegroundColor Cyan
    Write-Host "CMD:  bash $SPIKE/poc-move.sh $bashArgs" -ForegroundColor DarkGray
    $exit = Invoke-Bash "bash $SPIKE/poc-move.sh $bashArgs"
    if ($exit -ne 0) { Write-Host "(exit: $exit)" -ForegroundColor Red }
}

# --- Setup ---
Write-Host "=== SETUP: Creating test items ===" -ForegroundColor Green
& powershell -ExecutionPolicy Bypass -File "$REPO\project-hub\poc\SPIKE-142-move-command-test-harness\Create-PocTestItems.ps1"

Write-Host ""
Write-Host "=== POC MOVE TEST RUN ===" -ForegroundColor Green

Run-Test "1.  Single full ID (FEAT-901 -> todo)"               "FEAT-901 todo"
Run-Test "2.  Single numeric ID (902 -> todo)"                 "902 todo"
Run-Test "3.  Batch full IDs (FEAT-903 + BUG-904 -> todo)"     "'FEAT-903, BUG-904' todo"
Run-Test "4.  Batch numeric IDs (905, 906 -> todo)"            "'905, 906' todo"
Run-Test "5.  Batch mixed (FEAT-907 + 908 -> todo)"            "'FEAT-907, 908' todo"
Run-Test "6.  Parent + children (FEAT-909 -> todo)"            "FEAT-909 todo"
Run-Test "7.  Already in target (FEAT-911 -> skip)"            "FEAT-911 todo"
Run-Test "8.  Missing ID in batch (FEAT-901 + FEAT-999)"       "'FEAT-901, FEAT-999' todo"
Run-Test "9.  Substring collision (901 must not match 9010)"   "901 todo"
Run-Test "10. Any extension (FEAT-910: .md + .txt)"            "FEAT-910 todo"
Run-Test "11. Blocked transition (FEAT-912 done -> todo)"      "FEAT-912 todo"

Write-Host ""
Write-Host "=== DONE ===" -ForegroundColor Green
Write-Host ""
Write-Host "To reset and run again:"
Write-Host "  powershell -ExecutionPolicy Bypass -File project-hub/poc/SPIKE-142-move-command-test-harness/Reset-PocTests.ps1"
