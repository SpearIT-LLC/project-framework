# Bug: [Brief Description]

**ID:** BUG-NNN
**Type:** Bug
**Priority:** [High | Medium | Low]
**Version Impact:** PATCH
**Created:** YYYY-MM-DD

<!-- Optional fields - uncomment if needed:
**Severity:** [Critical | High | Medium | Low]
**Assigned:** [Name]
**Depends On:** [ITEM-NNN, ITEM-NNN]
-->

---

## Summary

[1-2 sentence description of the bug and its impact]

---

## Bug Description

**What is happening (actual behavior)?**

[Detailed description of the incorrect behavior]

**What should happen (expected behavior)?**

[Detailed description of the correct behavior]

**Impact:**

[Who/what is affected by this bug? How severe is the impact?]

---

## Reproduction Steps

**Environment:**
- OS: [e.g., Windows 11]
- PowerShell Version: [e.g., 5.1]
- Configuration: [Any relevant config details]

**Steps to Reproduce:**

1. [Step 1 with specific details]
2. [Step 2 with specific details]
3. [Step 3 with specific details]
4. [Observe incorrect behavior]

**Reproducibility:** [Always | Sometimes | Rare]

**Sample Input/Data:**

```
[Example input that triggers the bug]
```

**Error Messages/Logs:**

```
[Copy of error messages or relevant log entries]
```

---

## Root Cause Analysis

**File(s) Affected:**
- `path/to/file.ps1` - [Line numbers if known]

**Root Cause:**

[Technical explanation of why the bug occurs]

**Why was this missed?**

[Was there a gap in testing? Design oversight? Edge case?]

---

## Fix Design

**Approach:**

[High-level description of how the bug will be fixed]

**Code Changes:**

**File:** `path/to/file.ps1`

**Before:**
```powershell
# Buggy code
[Original code that contains the bug]
```

**After:**
```powershell
# Fixed code
[Corrected code]
```

**Explanation:**
[Why this fix resolves the issue]

---

## Alternative Fixes Considered

**Option 1:** [Alternative fix]
- Pros: [Benefits]
- Cons: [Drawbacks]
- Decision: [Why not chosen]

---

## Testing

### Verification Steps

1. [Step-by-step instructions to verify the fix]
2. [Include expected results]
3. [Confirm bug no longer occurs]

### Regression Testing

- [ ] Original reproduction steps no longer trigger bug
- [ ] Related functionality still works correctly
- [ ] No new bugs introduced

### Test Cases Added

- [ ] Test case 1: [Description]
- [ ] Test case 2: [Description]

---

## Related Issues

**Related Bugs:**
- [Links to similar or related bugs]

**Prevents:**
- [Issues that this fix also resolves]

**May Cause:**
- [Potential side effects to watch for]

---

## Impact Assessment

**User Impact:**
- [How does this fix affect users?]

**Breaking Changes:**
- [Are there any breaking changes? Yes/No]
- [If yes, describe mitigation]

**Backward Compatibility:**
- [Is backward compatibility maintained? Yes/No]
- [If no, describe migration path]

---

## Security Implications

- [ ] No security impact
- [ ] Security vulnerability fixed (describe below)

[If security issue, provide details following security-policy.md]

---

## Documentation Updates

### Files to Update

- [ ] README.md - [If user-facing behavior changes]
- [ ] Known issues section - [Remove if this was documented]
- [ ] [Other relevant documentation]

---

## Implementation Checklist

- [ ] Root cause identified and documented
- [ ] Fix implemented following coding-standards.md
- [ ] ASCII-only characters in code (no Unicode)
- [ ] PowerShell 5.1 compatibility verified
- [ ] Original reproduction steps verified fixed
- [ ] Regression testing completed
- [ ] No new bugs introduced
- [ ] Code reviewed
- [ ] Documentation updated (if needed)
- [ ] CHANGELOG.md updated
- [ ] Version numbers bumped in affected files

---

## Deployment

**Urgency:** [Immediate | Next Release | When Convenient]

**Deployment Notes:**

[Any special considerations for deploying this fix]

**Rollback Plan:**

[How to revert this fix if it causes issues]

---

## Prevention

**How can we prevent this type of bug in the future?**

- [ ] Add automated test for this scenario
- [ ] Update coding guidelines
- [ ] Add validation/checks
- [ ] Improve error handling
- [ ] Update documentation

---

## Timeline

| Phase | Estimated Time | Actual Time | Status |
|-------|----------------|-------------|--------|
| Investigation | X hours | Y hours | [Complete/In Progress] |
| Fix Implementation | X hours | Y hours | [Complete/In Progress] |
| Testing | X hours | Y hours | [Complete/In Progress] |
| Documentation | X hours | Y hours | [Complete/In Progress] |
| **Total** | **XX hours** | **YY hours** | |

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Fixed
- [Brief description of bug fixed]
  - [Impact or affected component]
```

**Keep notes here during development, copy to CHANGELOG.md when releasing.**

---

## Notes

[Any additional context, workarounds, or observations]

---

## References

- [Link to error logs]
- [Link to related code]
- [Link to external resources]

---

**Last Updated:** [YYYY-MM-DD]
