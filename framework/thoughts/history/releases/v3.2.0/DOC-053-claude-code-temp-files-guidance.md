# DOC-053: Document Claude Code Temporary File Configuration

**ID:** 053
**Type:** Documentation
**Priority:** Low
**Status:** Backlog
**Created:** 2026-01-13
**Related:** REFACTOR-052 (temp file cleanup)

---

## Summary

Add user guidance about Claude Code's `tmpclaude-*` temporary files and configuration options to prevent working directory clutter.

**Context:** During REFACTOR-052, discovered Claude Code creates `tmpclaude-*` temporary files in the working directory. Added pattern to `.gitignore` to prevent git tracking, but users should know about the `CLAUDE_CODE_TMPDIR` environment variable for better control.

---

## Problem Statement

**Issue:** Claude Code (as of v2.1.5) creates temporary files named `tmpclaude-*` in the current working directory. Users may be confused by these files appearing in their project directories.

**Who is affected:**
- New users setting up projects with Claude Code
- Users encountering temp files and wondering what they are
- Users who prefer temp files in system temp directory instead of working directory

**Current state:**
- `.gitignore` pattern added (REFACTOR-052) - prevents git tracking ✅
- No user-facing documentation about this behavior ❌
- No guidance on `CLAUDE_CODE_TMPDIR` configuration option ❌

---

## Requirements

### Functional Requirements

**Documentation additions:**
- [ ] Add note to `templates/NEW-PROJECT-CHECKLIST.md` in Git Setup section
- [ ] Add section to `framework/docs/collaboration/troubleshooting-guide.md`
- [ ] Reference the Claude Code v2.1.5 feature that introduced this

**Content requirements:**
- [ ] Explain what `tmpclaude-*` files are (internal Claude Code temp files)
- [ ] Confirm `.gitignore` pattern already exists (added in REFACTOR-052)
- [ ] Document `CLAUDE_CODE_TMPDIR` environment variable option
- [ ] Provide example configuration for Windows/PowerShell users
- [ ] Keep tone informational, not alarming ("This is normal behavior")

### Non-Functional Requirements

- Clear, concise guidance (2-3 sentences + example)
- Optional/informational tone (not a critical issue)
- Cross-reference between docs for discoverability

---

## Design

### Location 1: templates/NEW-PROJECT-CHECKLIST.md

**Section:** After "Git Setup" sections (around line 90, 150, 290)

**Content:**
```markdown
**Note on Claude Code temp files:** Claude Code may create `tmpclaude-*` temporary files in your working directory. These are already in `.gitignore`, but if you prefer they not appear at all, set the `CLAUDE_CODE_TMPDIR` environment variable to your system temp directory:

```powershell
# Windows PowerShell (set permanently in environment variables)
$env:CLAUDE_CODE_TMPDIR = $env:TEMP
```

This is optional - the `.gitignore` pattern prevents them from being committed.
```

---

### Location 2: framework/docs/collaboration/troubleshooting-guide.md

**Section:** Add new section in "Common Framework Issues" (after line 182)

**Content:**
```markdown
### Issue: Claude Code Temporary Files in Working Directory

**Symptoms:**
- Files named `tmpclaude-*` appearing in project directory
- Files persist across sessions
- Clutter in file explorer/IDE

**Explanation:**
Claude Code (v2.1.5+) creates internal temporary files in the current working directory by default. This is normal behavior and these files are already ignored by git (`.gitignore` includes `tmpclaude-*` pattern).

**Solutions:**

**Option 1: Do Nothing (Recommended)**
- Files are already in `.gitignore` and won't be committed
- They don't affect project functionality
- Claude Code manages cleanup automatically

**Option 2: Change Temp Directory Location**
```powershell
# Set environment variable to use system temp directory
# Windows PowerShell (temporary - current session only)
$env:CLAUDE_CODE_TMPDIR = $env:TEMP

# Or set permanently in Windows Environment Variables:
# System Properties → Environment Variables → Add user variable
# Name: CLAUDE_CODE_TMPDIR
# Value: %TEMP%
```

**Prevention:**
- Set `CLAUDE_CODE_TMPDIR` environment variable before first use
- Include in team setup documentation if team-wide preference
- Not required - default behavior is acceptable for most users

**See also:** Claude Code release notes v2.1.5 - `CLAUDE_CODE_TMPDIR` feature
```

---

## Implementation Approach

### Phase 1: Update Documentation

**Step 1: Update NEW-PROJECT-CHECKLIST.md**
- [ ] Add note in Minimal Framework Setup → Git Setup (line ~88)
- [ ] Add note in Light Framework Setup → Git Setup (line ~142)
- [ ] Add note in Standard Framework Setup → Git Setup (line ~289)
- [ ] Keep consistent wording across all three locations

**Step 2: Update troubleshooting-guide.md**
- [ ] Add new section "Issue: Claude Code Temporary Files in Working Directory"
- [ ] Place after "Issue: Work Items in Wrong Folder" (line 182)
- [ ] Include explanation, solutions, and prevention guidance

**Step 3: Cross-reference**
- [ ] Ensure both docs mention each other if appropriate
- [ ] Keep DRY - detailed info in troubleshooting-guide.md, brief note in checklist

---

### Phase 2: Validation

**Verification checklist:**
- [ ] Content is clear and non-alarmist
- [ ] PowerShell examples are correct
- [ ] Cross-references work
- [ ] Placement feels natural in both documents
- [ ] Tone matches existing documentation style

---

## Success Metrics

**How do we know this work is complete?**

1. ✅ Both documents updated with temp file guidance
2. ✅ Users know this behavior is normal and expected
3. ✅ Users know how to configure alternative location if desired
4. ✅ Documentation mentions `.gitignore` already handles git tracking

**Validation:**
- Fresh reader can understand the issue and solution quickly
- Information is discoverable (checklist for new users, troubleshooting for existing)
- Tone is informational, not concerning

---

## Dependencies

**Requires:**
- `.gitignore` pattern already added ✅ (completed in REFACTOR-052)

**Blocks:**
- None (low priority documentation improvement)

---

## Notes

**Priority:** Low
- Not blocking any work
- Informational improvement only
- `.gitignore` already prevents main problem (git tracking)

**Why document this:**
- Professional appearance - users shouldn't be confused by framework behavior
- Demonstrates framework completeness
- Provides future users with context about temp files

**Related work:**
- REFACTOR-052 added `.gitignore` pattern for `tmpclaude-*`
- Three commits cleaned up temp files throughout repository

**Discovered During:** REFACTOR-052 continuation session (2026-01-13)

---

**Last Updated:** 2026-01-13
