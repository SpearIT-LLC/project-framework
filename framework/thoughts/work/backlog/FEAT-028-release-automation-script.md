# Feature: Release Automation Script

**ID:** 028
**Type:** Feature (Tooling)
**Version Impact:** MINOR
**Status:** Backlog
**Created:** 2026-01-08
**Priority:** Medium
**Related:** FEAT-019 (release checklist template), ADR-003 (archival process)

---

## Summary

Create a release automation script (`framework/tools/release.sh`) that automates and enforces the release archival process, preventing common mistakes like copying instead of moving files.

---

## Problem Statement

**What problem does this solve?**

During v3.0.0 release, files were copied (cp) instead of moved (git mv) from done/ to releases/, creating duplicates and violating the archival policy (ADR-003). While this was caught and fixed, it demonstrates that manual processes are error-prone.

**Root cause:** Manual execution of multi-step process with critical commands that must be exact.

**Who is affected?**
- AI assistants performing releases (error-prone on exact commands)
- Solo developers managing releases (easy to forget verification step)
- Anyone following the workflow who might use wrong command

**Current workaround:**
- Manual execution with explicit commands in CLAUDE.md
- Verification step to check done/ is empty
- Common mistakes documented in ADR-003

---

## Requirements

### Functional Requirements

- [ ] Script: `framework/tools/release.sh`
- [ ] Input: Version number (e.g., `v3.0.0`)
- [ ] Validates input format (vX.Y.Z)
- [ ] Creates release folder if it doesn't exist
- [ ] Moves (git mv) ALL files from done/ to releases/vX.Y.Z/
- [ ] Verifies done/ is empty after move
- [ ] Outputs clear success/failure messages
- [ ] Exits with error code if validation fails
- [ ] Handles edge cases (no files in done/, folder already exists)

### Non-Functional Requirements

- [ ] Idempotent - safe to run multiple times
- [ ] Clear error messages
- [ ] Works on Linux, macOS, Windows (Git Bash)
- [ ] No external dependencies beyond git and bash

---

## Design

### Script Interface

```bash
Usage: ./tools/release.sh <version>

Example:
  ./tools/release.sh v3.0.0

Options:
  -h, --help     Show this help message
  -n, --dry-run  Show what would be done without executing
```

### Script Logic

```bash
#!/bin/bash
# framework/tools/release.sh
# Automates release archival process per ADR-003

set -e  # Exit on error

VERSION=$1

# Validate input
if [ -z "$VERSION" ]; then
    echo "ERROR: Version required"
    echo "Usage: ./tools/release.sh v3.0.0"
    exit 1
fi

# Validate version format
if [[ ! $VERSION =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "ERROR: Invalid version format. Use vX.Y.Z (e.g., v3.0.0)"
    exit 1
fi

# Define paths
RELEASE_DIR="framework/thoughts/history/releases/$VERSION"
DONE_DIR="framework/thoughts/work/done"

# Check if files exist in done/
FILE_COUNT=$(ls "$DONE_DIR"/*.md 2>/dev/null | wc -l)
if [ $FILE_COUNT -eq 0 ]; then
    echo "WARNING: No work items found in $DONE_DIR/"
    echo "Nothing to archive."
    exit 0
fi

echo "Found $FILE_COUNT work item(s) in done/"

# Create release folder
mkdir -p "$RELEASE_DIR"
echo "Created $RELEASE_DIR/"

# Move files (using git mv)
echo "Moving work items to release folder..."
git mv "$DONE_DIR"/*.md "$RELEASE_DIR/" 2>/dev/null || {
    echo "ERROR: Failed to move files. Check git status."
    exit 1
}

# Verify done/ is empty
REMAINING=$(ls "$DONE_DIR"/*.md 2>/dev/null | wc -l)
if [ $REMAINING -gt 0 ]; then
    echo "ERROR: $REMAINING file(s) still in done/"
    echo "Archival incomplete. Please investigate."
    exit 1
fi

echo "✓ Moved $FILE_COUNT file(s) to $RELEASE_DIR/"
echo "✓ Verified done/ is empty"
echo ""
echo "Next steps:"
echo "  1. Review changes: git status"
echo "  2. Commit: git commit -m \"chore: Archive $VERSION work items\""
echo "  3. Push: git push origin main"
```

### Alternative: PowerShell Version

For Windows users without Git Bash, also provide `release.ps1`:

```powershell
# framework/tools/release.ps1
param(
    [Parameter(Mandatory=$true)]
    [string]$Version
)

# Validate version format
if ($Version -notmatch '^v\d+\.\d+\.\d+$') {
    Write-Error "Invalid version format. Use vX.Y.Z (e.g., v3.0.0)"
    exit 1
}

# Define paths
$releaseDir = "framework/thoughts/history/releases/$Version"
$doneDir = "framework/thoughts/work/done"

# Check for files
$files = Get-ChildItem "$doneDir/*.md" -ErrorAction SilentlyContinue
if (-not $files) {
    Write-Warning "No work items found in $doneDir/"
    exit 0
}

Write-Host "Found $($files.Count) work item(s) in done/"

# Create release folder
New-Item -ItemType Directory -Force -Path $releaseDir | Out-Null
Write-Host "Created $releaseDir/"

# Move files (using git mv)
$files | ForEach-Object {
    git mv $_.FullName "$releaseDir/" 2>&1 | Out-Null
}

# Verify done/ is empty
$remaining = Get-ChildItem "$doneDir/*.md" -ErrorAction SilentlyContinue
if ($remaining) {
    Write-Error "$($remaining.Count) file(s) still in done/"
    exit 1
}

Write-Host "✓ Moved $($files.Count) file(s) to $releaseDir/" -ForegroundColor Green
Write-Host "✓ Verified done/ is empty" -ForegroundColor Green
```

---

## Benefits

1. **Prevents copy/move mistake:** Script only uses `git mv`, can't accidentally copy
2. **Automatic verification:** Always checks done/ is empty
3. **Consistent results:** Same outcome regardless of who runs it (human or AI)
4. **Error detection:** Fails fast with clear messages
5. **Reduces cognitive load:** One command instead of multi-step manual process
6. **Saves AI tokens:** Single script call vs reading/interpreting multi-step instructions
   - Manual process: ~500-1000 tokens (read docs, execute commands, verify)
   - Script: ~50-100 tokens (call script, check output)
   - 10x token reduction per release
7. **Idempotent:** Safe to run multiple times
8. **Documentation as code:** Script is living documentation of process

---

## Implementation Checklist

- [ ] Create framework/tools/ directory
- [ ] Write release.sh (bash version)
- [ ] Write release.ps1 (PowerShell version)
- [ ] Make executable: `chmod +x framework/tools/release.sh`
- [ ] Test on actual release
- [ ] Update CLAUDE.md Step 9 to reference script
- [ ] Update workflow-guide.md to mention script option
- [ ] Update ADR-003 to mention script prevents common mistakes
- [ ] Add to INDEX.md under tools section
- [ ] Document in tools/README.md

---

## Testing Plan

### Test Cases

1. **Happy path:** Files in done/, valid version → success
2. **No files:** Empty done/ → warning, exit 0
3. **Invalid version:** `v3.0` or `3.0.0` → error
4. **Missing version:** No argument → usage message
5. **Existing folder:** Release folder exists → works (idempotent)
6. **Git failure:** Simulated git error → clean failure message

### Success Criteria

- [ ] All test cases pass
- [ ] done/ is always empty after successful run
- [ ] Clear error messages for all failure modes
- [ ] Works on Linux, macOS, Windows (Git Bash)
- [ ] Dry-run mode shows what would happen

---

## Documentation Updates

- [ ] framework/tools/README.md - Document all tools
- [ ] CLAUDE.md Step 9 - "Or use: `./tools/release.sh vX.Y.Z`"
- [ ] workflow-guide.md - Add script as option
- [ ] ADR-003 - Note script prevents Mistake 1 and 2
- [ ] INDEX.md - Add tools/ section

---

## Future Enhancements

Once this proves useful:
- Integrate with FEAT-019 release checklist
- Add `--full` flag to run entire release process
- Auto-detect version from work item Version Impact
- Validate PROJECT-STATUS.md and CHANGELOG.md updated
- Dry-run mode improvements

---

## Related Work

**FEAT-019:** Release Checklist Template
- This script could be step 7 of that checklist
- Or could replace manual checklist with automation

**ADR-003:** Work Item Lifecycle and Archival Process
- This implements the archival process in code
- Prevents all common mistakes documented in ADR-003

---

## Notes

**Why script vs just better documentation?**

Documentation helps, but scripts *enforce*. You can't accidentally use the wrong command if the script only provides the right one.

**Why not full release automation?**

Start simple. Archival is error-prone and mechanical - perfect for automation. Full release has decision points (version calculation, changelog content) that benefit from human/AI review.

**Lessons from v3.0.0:**

Explicit commands in docs helped, but I still used `cp` instead of `git mv`. Script would have prevented this entirely.

**Token Usage Statistics:**

Baseline measurements for manual release process:

- **v3.0.1 Release (2026-01-11):** 62.8k tokens consumed
  - System prompt: 3.2k
  - System tools: 16.0k
  - Memory files: 882
  - Messages: 42.8k (68% of total usage)
  - Process: Read work item, calculate version, update 3 files (CHANGELOG, PROJECT-STATUS, work item), move files, commit, tag, archive
  - Time: Full release workflow with documentation reading and verification

This establishes the baseline for comparison once the script is implemented. Expected reduction: 5-10x fewer tokens for the archival portion of the release process.

---

**Created:** 2026-01-08
**Source:** v3.0.0 release mistake (copied instead of moved files)
