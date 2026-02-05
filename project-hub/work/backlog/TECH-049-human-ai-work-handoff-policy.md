# TECH-049: Human-AI Work Handoff Policy

**ID:** TECH-049
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-01-11

---

## Summary

Document best practices for handling work handoffs between human and AI when both are making concurrent or interleaved changes to the repository, particularly around git operations that require special handling.

---

## Problem Statement

**Issue discovered:** During session on 2026-01-11, human manually moved 3 work item files from backlog/ to todo/. AI was then asked to commit changes. The handoff exposed several issues:

1. **History loss:** Manual file copy (not git mv) lost file history
2. **Mixed staging:** AI initially staged human's changes with its own
3. **Recognition gap:** AI didn't immediately recognize the move pattern
4. **Guidance gap:** AI didn't proactively suggest better git approach

**Pattern:** Human does work → AI does work → Commit combines both
- Works for simple edits
- Breaks for git operations requiring special handling (moves, renames)
- Requires explicit coordination

**Who is affected:**
- Solo developers alternating between manual work and AI work
- Anyone using the framework's file-based workflow
- Git history quality and traceability

---

## Requirements

### Functional Requirements

- [ ] Define clear handoff protocol for mixed human/AI work
- [ ] Specify when AI should use `git mv` vs accepting manual moves
- [ ] Document how AI should recognize incomplete git operations
- [ ] Establish commit boundary rules (separate vs combined commits)
- [ ] Provide guidance for common scenarios

### Non-Functional Requirements

- [ ] Simple for users to understand
- [ ] Minimal overhead (not bureaucratic)
- [ ] Preserves git history when important
- [ ] Flexible for different workflow styles
- [ ] Works with framework's file-based approach

---

## Handoff Scenarios

### Scenario 1: Human Edits, AI Commits

**Example:** Human manually edits README.md, then asks AI to add a feature

**Current behavior:** AI commits both changes together
**Issue:** Works fine (no special git handling needed)
**Recommendation:** ✅ Continue current behavior

---

### Scenario 2: Human Moves Files (Manual Copy), AI Commits

**Example:** Human copies work items from backlog/ to todo/, then asks AI to create new work item

**Current behavior:**
- AI sees deletions + new untracked files
- Doesn't recognize as move
- Commits as delete + add (loses history)

**Issue:** ❌ Lost file history, messy git log

**Better approach:**
1. **AI recognizes pattern:** "I see you moved 3 files from backlog to todo"
2. **AI suggests fix:** "Want me to redo with `git mv` to preserve history?"
3. **AI executes:** Restore originals, remove copies, `git mv` properly
4. **AI commits:** Separate commit for moves (clean history)

---

### Scenario 3: Human Uses git mv, AI Commits

**Example:** Human runs `git mv backlog/FEAT-031.md todo/FEAT-031.md`, asks AI to commit

**Current behavior:** AI commits the staged rename
**Issue:** ✅ Works perfectly
**Recommendation:** Continue, but AI should recognize and praise proper git usage

---

### Scenario 4: Human Stages Changes, AI Stages More

**Example:** Human runs `git add file1.md`, then asks AI to create file2.md and commit both

**Current behavior:** AI stages file2.md and commits everything
**Issue:** Mostly fine, but no boundary check
**Recommendation:** AI should confirm: "I see file1.md already staged. Should I include that in the commit?"

---

### Scenario 5: Mixed Work Mid-Session

**Example:** AI creates work item, human manually moves another file, AI asked to commit

**Current behavior:** AI commits everything together
**Issue:** Unclear commit message (mixes unrelated work)
**Better approach:**
- AI detects mixed work types
- AI suggests separate commits
- "Your move + my new file, should I commit separately or together?"

---

## Proposed Policy

### General Principles

1. **Preserve git history** - Use `git mv` for moves/renames, not manual copy
2. **Recognize patterns** - AI should detect common git operations (moves, renames)
3. **Offer guidance** - AI should suggest better approaches when detected
4. **Confirm boundaries** - AI should clarify what's being committed when mixing work
5. **Separate concerns** - Different types of work should get separate commits when possible

### AI Responsibilities

**Before committing, AI should:**

1. **Check git status** - Understand what's staged/unstaged
2. **Identify work source** - Distinguish human changes from AI changes
3. **Recognize patterns:**
   - Deleted + untracked files in different folder = likely manual move
   - Already staged changes = human did work first
   - Renamed files = proper git mv (good!)
4. **Offer improvements:**
   - Suggest `git mv` if manual move detected
   - Propose separate commits if work types differ
5. **Ask for confirmation** if unclear about boundaries

### Human Responsibilities

**To make handoffs smooth:**

1. **Use `git mv` for moves/renames** (preserves history)
2. **Tell AI about your changes** if non-obvious ("I moved some files manually")
3. **Accept AI's suggestions** for improving git operations
4. **Be explicit about commit scope** ("commit only my changes" vs "commit everything")

### Special Cases

**Work item moves (backlog → todo, todo → doing, etc.):**
- **Always use `git mv`** - These files have valuable history
- If human used manual copy, AI should offer to fix
- Separate commit from other work (clean kanban tracking)

**File renames:**
- **Always use `git mv`** - Critical for history tracking
- AI should detect and preserve renames

**Content edits:**
- Manual edits are fine, no special handling
- Can be combined with AI changes in same commit

---

## Implementation Approach

### Phase 1: Document in Collaboration Guide

**Add new section to ai-workflow.md (or similar):**

```markdown
## Human-AI Work Handoffs

When collaborating with AI on git repositories, follow these practices
for smooth handoffs:

### Moving or Renaming Files

❌ **Don't:** Manually copy files and delete originals
✅ **Do:** Use `git mv oldpath newpath` to preserve history

Example:
git mv project-hub/work/backlog/FEAT-031.md \
        project-hub/work/todo/FEAT-031.md

### Staging Work Before AI Session

If you've staged changes before asking AI to commit:
1. Tell the AI: "I've already staged file1.md"
2. AI will check and confirm what's being committed
3. Separate commits if mixing different work types

### When AI Detects Issues

If AI offers to redo a manual move with `git mv`:
- ✅ Accept - preserves file history
- History tracking is valuable for work items
- Takes only a moment to fix
```

### Phase 2: Update AI Instructions (CLAUDE.md)

**Add to framework/CLAUDE.md (git commit section):**

```markdown
### Handling Mixed Human/AI Work

Before committing, check git status and identify work sources:

1. **Detect manual file moves:**
   - Pattern: Deleted file + untracked file in different folder
   - Suggest: "Want me to redo with `git mv` to preserve history?"
   - Execute: Restore, remove copy, `git mv`, commit separately

2. **Confirm already-staged changes:**
   - Check: Are there staged changes you didn't make?
   - Ask: "I see file.md already staged. Include in commit?"

3. **Separate commit types:**
   - Work item moves → separate commit (kanban tracking)
   - New features → separate commit (clear history)
   - Don't mix unrelated work
```

### Phase 3: Create Examples

**Document common scenarios with examples:**
- Manual move detection and correction
- Confirming staged changes
- Separating mixed work types
- Praising proper git usage

---

## Success Metrics

**How do we know this policy works?**

1. ✅ AI consistently detects manual moves and offers to fix
2. ✅ File history preserved for work items (verified with `git log --follow`)
3. ✅ Commit messages clearly describe what changed
4. ✅ No lost history from manual copies
5. ✅ Smooth handoffs without confusion
6. ✅ Users understand when to use `git mv`

**Failure indicators:**
- Lost file history after moves
- Confused commit messages mixing unrelated work
- AI blindly commits without checking boundaries
- Users frustrated by handoff friction

---

## Open Questions

1. **Should AI always separate commits for different work types?**
   - Pro: Cleaner history
   - Con: More commits (might be annoying)
   - Recommendation: Offer choice, default to separate

2. **How proactive should AI be about fixing manual moves?**
   - Option A: Always offer to fix
   - Option B: Only fix if user agrees
   - Recommendation: Always offer, make it easy to accept

3. **Should this be a formal work item policy or informal best practice?**
   - Formal: More discoverable, official
   - Informal: More flexible, less intimidating
   - Recommendation: Start as best practice, formalize if needed

4. **Does this need tooling support?**
   - Helper script to detect and fix manual moves?
   - Pre-commit hook to warn about manual copies?
   - Recommendation: Documentation first, tooling if pain point

---

## Related Insights

**This connects to broader themes:**

1. **Manual-first philosophy** - Framework designed for manual work, but git has opinions
2. **History as documentation** - Work item history tells story of project evolution
3. **AI as collaborator** - Need explicit protocols for collaboration, not just commands
4. **Git as shared context** - Both human and AI operate through git's primitives

**Similar patterns to consider:**
- Merge conflict resolution
- Cherry-picking commits
- Interactive rebasing
- Branch management

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- **TECH-049: Human-AI Work Handoff Policy**
  - Documented best practices for mixed human/AI git operations
  - Added guidance for file moves and renames (use git mv)
  - Created examples for common handoff scenarios
  - Updated AI instructions to detect and improve manual moves
  - Established commit boundary protocols
```

---

## Notes

**Discovered During:** Manual file move test on 2026-01-11
- Human moved 3 work items from backlog to todo
- AI committed with lost history
- Identified need for handoff protocol

**Key Insight:**
Framework is file-based and manual-first, but git operations have "right ways" to preserve metadata. Need explicit protocol for when human and AI both touch files.

**Not just academic:**
This is a real pain point that affects git history quality and workflow smoothness. Worth documenting even if seems obvious to git experts.

---

**Last Updated:** 2026-01-11
