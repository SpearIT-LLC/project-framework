# Feature: Setup Script Edge Cases and Polish

**ID:** FEAT-112
**Type:** Feature
**Priority:** Low
**Version Impact:** PATCH
**Created:** 2026-02-06
**Theme:** Distribution & Onboarding
**Sprint:** Polish (TBD)

---

## Summary

Handle edge cases and improve user experience for Setup-Framework.ps1 when git is not installed, users don't want version control, or prefer alternative VCS systems.

---

## Problem Statement

**What problem does this solve?**

The current Setup-Framework.ps1 makes assumptions about git availability and user preferences:
- Silent fallback when git not installed (no guidance)
- -NoGit flag not discoverable in interactive flow
- No consideration for users who prefer alternative VCS

**Who is affected?**

- New developers without git installed
- Users who don't want version control
- Users who prefer alternative VCS (SVN, Mercurial, etc.)

**Current workaround:**

Users discover behavior through trial and error.

---

## Requirements

### Functional Requirements

**Git Not Installed:**
- [ ] Detect if git is not available in PATH
- [ ] Provide helpful message: "Git not found. Download from https://git-scm.com/downloads"
- [ ] Warn: "Git initialization will be skipped. You can initialize later with 'git init'."
- [ ] Continue with setup (non-blocking)

**User Doesn't Want Version Control:**
- [ ] Make -NoGit more discoverable (mention in help text)
- [ ] Consider interactive prompt: "Initialize git repository? (Y/n)"
- [ ] Optional: Brief explanation of version control benefits for new users

**User Prefers Alternative VCS:**
- [ ] Document that only git is supported
- [ ] Consider: Is multi-VCS support worth the complexity?
- [ ] Decision: Git is industry standard - likely not worth supporting alternatives

### Non-Functional Requirements

- [ ] Clear, helpful error messages
- [ ] Non-blocking warnings (setup continues)
- [ ] Educational tone for new users
- [ ] Maintain script simplicity

---

## Design

### Git Detection Flow

```
1. Check if git is available: & git --version 2>$null
2. If not available:
   - Display: "Git not found on your system."
   - Display: "Download from: https://git-scm.com/downloads"
   - Display: "Git initialization will be skipped."
   - Display: "You can run 'git init' later in your project directory."
3. Continue with setup (non-blocking)
```

### Interactive Git Prompt (Optional Enhancement)

```
Current: Controlled by -NoGit parameter only
Proposed: Interactive prompt when git is available

"Initialize git repository? (Y/n)"
- Default: Yes (press Enter)
- No: Skip git initialization
- Brief help text: "Recommended for tracking changes and collaboration"
```

### Alternative VCS Consideration

**Analysis:**
- Git is the industry standard (>90% market share)
- Supporting multiple VCS adds significant complexity
- Diminishing returns for edge case support

**Recommendation:**
- Document that only git is supported
- Users who prefer alternatives can skip git init and set up manually
- Defer multi-VCS support unless strong user demand emerges

---

## Implementation Steps

- [ ] Add git availability detection
- [ ] Implement helpful messaging when git not found
- [ ] Add download link to git-scm.com
- [ ] Test behavior when git not in PATH
- [ ] Consider: Add interactive git prompt (vs. parameter-only)
- [ ] Update documentation with git requirements
- [ ] Document alternative VCS decision (why git-only)

---

## Success Criteria

- [ ] Users without git receive clear guidance
- [ ] Setup continues successfully without git (with warnings)
- [ ] Help text mentions git requirement and -NoGit option
- [ ] Documentation explains git-only decision

---

## Related Work Items

- **Prerequisite:** FEAT-006 - Interactive Setup Script (v4.1.0)
- **Context:** Edge cases identified during FEAT-006 review (2026-02-06)

---

## Notes

**Edge Cases Identified:**

1. **Git Not Installed** - Most important to address
2. **User Doesn't Want VCS** - Already handled by -NoGit, just needs better discoverability
3. **Alternative VCS** - Low priority, likely won't implement

**Recommended Approach:**
- Focus on helpful messaging when git not found
- Keep parameter-based control (-NoGit) for automation
- Document git-only decision clearly

**Priority Rationale:**
- Low priority - MVP functionality works
- Polish enhancement for better UX
- Non-blocking edge cases
