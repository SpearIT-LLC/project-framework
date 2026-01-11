# Troubleshooting Guide

**Audience:** All contributors (human and AI)
**Purpose:** Common issues, diagnostics, and solutions for the Project Framework
**Last Updated:** 2025-12-22

---

## Table of Contents

1. [Quick Diagnostics](#quick-diagnostics)
2. [Common Framework Issues](#common-framework-issues)
3. [Workflow Problems](#workflow-problems)
4. [Git Issues](#git-issues)
5. [Template Usage Errors](#template-usage-errors)
6. [Version Sync Issues](#version-sync-issues)
7. [AI Collaboration Issues](#ai-collaboration-issues)
8. [When Things Go Wrong](#when-things-go-wrong)

---

## Quick Diagnostics

### System Health Check

Run these commands to verify framework setup:

```bash
# Verify folder structure exists
ls thoughts/work/todo
ls thoughts/work/doing
ls thoughts/work/done
ls thoughts/framework/templates

# Check WIP limit configuration
cat thoughts/work/doing/.limit

# Count items in doing/ folder
ls thoughts/work/doing/*.md | wc -l

# Verify git repository
git status

# Check for uncommitted changes
git diff --stat

# View recent commits
git log --oneline -5

# Check current version
cat PROJECT-STATUS.md | grep "Current Version"
```

### Quick Diagnostic Questions

1. **Is your folder structure correct?** Check thoughts/ exists with project/ and framework/ subdirectories
2. **Are you violating WIP limits?** Count files in work/doing/, should be ≤ .limit value
3. **Is git clean?** Run `git status`, should see "nothing to commit, working tree clean" after releases
4. **Is version consistent?** PROJECT-STATUS.md, CHANGELOG.md, and latest git tag should match
5. **Are you in right framework level?** Check if project matches Minimal/Light/Standard criteria

---

## Common Framework Issues

### Issue: Folder Structure Missing or Incomplete

**Symptoms:**
- "No such file or directory" errors
- Templates not found
- Work items can't be created

**Diagnosis:**
```bash
# Check if thoughts/ folder exists
ls thoughts/

# Expected output:
# project/  framework/
```

**Solutions:**

**For New Projects:**
```bash
# Copy appropriate framework level
cp -r project-framework-template/standard /path/to/your-project

# Or create manually
mkdir -p thoughts/{work/{backlog,todo,doing,done},research,reference,retrospectives,history,archive,collaboration}
mkdir -p thoughts/framework/{templates,process,patterns,tools}
```

**For Existing Projects:**
- Check which framework level you're using
- Compare against template structure
- Create missing folders as needed

**Prevention:**
- Use NEW-PROJECT-CHECKLIST.md when setting up
- Run validation script (FEAT-007, when implemented)

---

### Issue: WIP Limit Violations

**Symptoms:**
- Too many features in progress simultaneously
- Difficulty completing tasks
- Context switching overhead

**Diagnosis:**
```bash
# Check WIP limit
cat thoughts/work/doing/.limit

# Count items in doing/
ls thoughts/work/doing/*.md | wc -l

# If count > limit, you're violating WIP
```

**Solutions:**

**Immediate Fix:**
```bash
# Complete and move items to done/
mv thoughts/work/doing/feature-ABC.md thoughts/work/done/

# Or move back to todo/ if not really started
mv thoughts/work/doing/feature-XYZ.md thoughts/work/todo/
```

**Long-term Fix:**
- Finish work before starting new work
- Move items sequentially through workflow
- Review WIP limit (is it too high? Default: 2)

**Prevention:**
- Check doing/ folder before moving items from todo/
- AI should verify WIP limit before starting work (ADR-001)
- Consider creating validation script (FEAT-007)

---

### Issue: Work Items in Wrong Folder

**Symptoms:**
- Items marked "Done" still in doing/
- Items being worked on still in backlog/
- Confusion about status

**Diagnosis:**
```bash
# List all work items with status
grep -r "Status:" thoughts/work/ thoughts/work/

# Compare folder location vs status field
```

**Solutions:**

**Fix Mismatched Status:**
```bash
# Move to correct folder based on actual status
mv thoughts/work/backlog/feature-123.md thoughts/work/doing/

# Update status field in document
# Edit file and change "Status: Backlog" to "Status: Doing"
```

**Establish Single Source of Truth:**
- Folder location = authoritative status
- Status field in document = secondary (for context)
- When mismatch: folder location wins

**Prevention:**
- Update status field when moving files
- Use git commits to track moves
- AI should update both folder and status field atomically

---

## Workflow Problems

### Issue: Bypassed AI Workflow Checkpoint (ADR-001 Violation)

**Symptoms:**
- Feature moved from backlog → doing without user approval
- AI implemented feature without asking "Should I proceed?"
- Work started without planning discussion

**Diagnosis:**
- Check git history for feature file creation
- Did feature go backlog → doing without approval commit?
- Was there explicit user approval message?

**Solutions:**

**Retroactive Fix:**
1. Document the violation in retrospective
2. If implementation is good, accept it but note the process gap
3. If implementation is wrong direction, revert and restart with approval

**Process Fix:**
- Review ADR-001 (thoughts/research/adr/001-ai-workflow-checkpoint-policy.md)
- Ensure AI reads and follows checkpoint policy
- Update CLAUDE.md if guidance unclear

**Prevention:**
- AI must ask "Should I proceed?" before moving backlog → todo/doing
- AI must present plan before implementation
- User approval required before starting work

---

### Issue: Forgot to Update Version on Release

**Symptoms:**
- Git tag created but PROJECT-STATUS.md still shows old version
- CHANGELOG.md missing section for new version
- Separate commits for implementation and version bump

**Diagnosis:**
```bash
# Check latest git tag
git describe --tags --abbrev=0

# Check PROJECT-STATUS.md version
grep "Current Version" PROJECT-STATUS.md

# They should match!
```

**Solutions:**

**Retroactive Fix:**
```bash
# Create new commit with version update
# Update PROJECT-STATUS.md to vX.Y.Z
# Update CHANGELOG.md with [X.Y.Z] section
git add PROJECT-STATUS.md CHANGELOG.md
git commit -m "Fix: Update version to vX.Y.Z (missed in release)"
git push
```

**Process Fix:**
- Follow atomic release process (CLAUDE.md step 9)
- Use release checklist (FEAT-019 when implemented)
- All version updates in single commit with implementation

**Prevention:**
- Read CLAUDE.md step 9 before every release
- Create pre-release checklist
- Validation script to check version consistency (FEAT-007)

---

### Issue: Work Items Not Archived After Release

**Symptoms:**
- work/done/ folder accumulating completed items
- No historical record in history/releases/
- Unclear what was in which release

**Diagnosis:**
```bash
# Check if done/ folder has old items
ls thoughts/work/done/

# Check if history/releases/vX.Y.Z/ exists
ls thoughts/history/releases/
```

**Solutions:**

**Retroactive Fix:**
```bash
# Create release folder
mkdir -p thoughts/history/releases/v2.1.0

# Move completed items to release
mv thoughts/work/done/*.md thoughts/history/releases/v2.1.0/

# Commit
git add thoughts/history/releases/v2.1.0/
git commit -m "Archive: Move v2.1.0 completed items to history"
```

**Prevention:**
- Include archival in release process
- Release checklist should have "Archive done/ items" step
- Automate with release script (future enhancement)

---

## Git Issues

### Issue: Merge Conflicts in Documentation Files

**Symptoms:**
- Git merge shows conflicts in CHANGELOG.md
- Conflicts in PROJECT-STATUS.md
- Conflicts in work item files

**Solutions:**

**CHANGELOG.md Conflicts:**
```bash
# Common pattern: Two branches added different entries

# Strategy: Keep both entries, sort chronologically
# 1. Accept both changes
# 2. Order by date (newest first)
# 3. Ensure proper markdown formatting

git add CHANGELOG.md
git commit -m "Merge: Resolve CHANGELOG.md conflict"
```

**PROJECT-STATUS.md Conflicts:**
```bash
# Strategy: Newer version wins
# 1. Choose higher version number
# 2. Combine status descriptions if needed
# 3. Use latest "Last Updated" date

git add PROJECT-STATUS.md
git commit -m "Merge: Resolve PROJECT-STATUS.md conflict (use vX.Y.Z)"
```

**Prevention:**
- Merge main/master into feature branches frequently
- Update PROJECT-STATUS.md only on main branch
- Coordinate CHANGELOG.md updates between team members

---

### Issue: Accidentally Committed to Wrong Branch

**Symptoms:**
- Committed feature work to main instead of feature branch
- Committed multiple features in single commit
- Mixed different work items in one commit

**Solutions:**

**If Not Yet Pushed:**
```bash
# Undo last commit, keep changes
git reset --soft HEAD~1

# Create correct branch
git checkout -b feature/correct-branch

# Commit on correct branch
git add .
git commit -m "Feature: Correct commit on correct branch"
```

**If Already Pushed:**
```bash
# Don't rewrite public history!
# Instead: Create fix commit or merge

# Option 1: Cherry-pick to correct branch
git checkout feature/correct-branch
git cherry-pick <commit-hash>
git push

# Option 2: Revert on main, commit on feature branch
git checkout main
git revert <commit-hash>
git push

git checkout feature/correct-branch
git cherry-pick <commit-hash>
git push
```

**Prevention:**
- Always check current branch before committing: `git branch`
- Use feature branches for all work
- Set up git hooks to prevent direct commits to main

---

### Issue: Lost Work Due to Git Mistakes

**Symptoms:**
- Accidentally deleted files with git reset
- Lost commits after git rebase
- Work disappeared after git clean

**Solutions:**

**Recovery Strategy:**
```bash
# Git keeps reflog of all operations
git reflog

# Find commit hash before mistake
# Example output:
# abc1234 HEAD@{0}: reset: moving to HEAD~1
# def5678 HEAD@{1}: commit: Feature work (THIS IS WHAT YOU WANT)

# Restore to that commit
git cherry-pick def5678

# Or reset to that point
git reset --hard def5678
```

**Prevention:**
- Commit frequently (work in progress commits are OK)
- Push to remote regularly
- Never use `git clean -fd` without checking `git clean -fdn` first (dry run)
- Never use `git reset --hard` without checking current status

---

## Template Usage Errors

### Issue: Modified Template Instead of Creating Instance

**Symptoms:**
- `FEATURE-TEMPLATE.md` contains actual feature content
- Template is no longer reusable
- Other features missing template sections

**Diagnosis:**
```bash
# Check if template has been modified
git log thoughts/framework/templates/FEATURE-TEMPLATE.md

# Should only have framework updates, not project-specific content
```

**Solutions:**

**Fix Modified Template:**
```bash
# Restore original template
git checkout HEAD~1 thoughts/framework/templates/FEATURE-TEMPLATE.md

# If you want to keep the content:
# 1. Copy current (wrong) content somewhere
# 2. Restore template
# 3. Create proper feature file from template
# 4. Paste content into feature file
```

**Correct Workflow:**
```bash
# CORRECT: Copy template to create instance
cp thoughts/framework/templates/FEATURE-TEMPLATE.md thoughts/work/backlog/feature-123-new-feature.md

# Edit the instance (feature-123-new-feature.md), NOT the template
```

**Prevention:**
- Never edit files in thoughts/framework/templates/ directly
- Always copy template to project location first
- Templates are read-only reference

---

### Issue: Missing Required Template Sections

**Symptoms:**
- Feature document incomplete
- Missing implementation steps
- No testing plan
- Unclear acceptance criteria

**Solutions:**

**Compare Against Template:**
```bash
# Diff your feature against template
diff thoughts/framework/templates/FEATURE-TEMPLATE.md thoughts/work/doing/feature-123.md

# Add missing sections
```

**Restore Deleted Sections:**
- If you deleted a section, decide if you need it
- If not needed: Add note "## [Section] - N/A for this feature"
- If needed: Copy from template and fill in

**Prevention:**
- Don't delete template sections, mark as "N/A" if not applicable
- Review template before submitting for approval
- Use template as checklist

---

## Version Sync Issues

### Issue: Version Mismatch Between Files

**Symptoms:**
- PROJECT-STATUS.md says v2.1.0
- Latest git tag is v2.0.0
- CHANGELOG.md has no [2.1.0] section

**Diagnosis:**
```bash
# Check all version indicators
echo "PROJECT-STATUS.md:"
grep "Current Version" PROJECT-STATUS.md

echo "Latest git tag:"
git describe --tags --abbrev=0

echo "CHANGELOG.md latest:"
grep "##" CHANGELOG.md | head -5
```

**Solutions:**

**Synchronize Versions:**
```bash
# Determine correct version (usually highest)
# Update all files to match

# Update PROJECT-STATUS.md
# Update CHANGELOG.md
# Create/update git tag

git add PROJECT-STATUS.md CHANGELOG.md
git commit -m "Fix: Synchronize version to vX.Y.Z"
git tag vX.Y.Z
git push --tags
```

**Prevention:**
- Atomic releases (update all version indicators in one commit)
- Follow release checklist
- Validation script (FEAT-007 when implemented)

---

## AI Collaboration Issues

### Issue: AI Not Following CLAUDE.md Guidelines

**Symptoms:**
- AI violates WIP limits
- AI skips approval checkpoints
- AI doesn't follow coding standards
- AI creates documentation in wrong location

**Solutions:**

**Immediate:**
1. Point AI to specific CLAUDE.md section being violated
2. Ask AI to re-read that section
3. Request correction

**Example:**
```
"You violated the AI Workflow Checkpoint Policy (ADR-001).
Please read the section in CLAUDE.md lines 435-561 and follow
the 9-step process before implementation."
```

**Long-term:**
- Review CLAUDE.md clarity - is guidance explicit enough?
- Add examples if principle-based guidance not working
- Create retrospective to document pattern
- Update CLAUDE.md with clearer instructions

**Prevention:**
- CLAUDE.md should be explicit, step-by-step
- Avoid implicit or principle-based guidance for AI
- Regular dogfooding to test AI guidance effectiveness

---

### Issue: AI Not Finding Collaboration Docs

**Symptoms:**
- AI asks questions answered in collaboration/ docs
- AI doesn't reference collaboration/ docs
- AI recreates content already in docs

**Solutions:**

**Immediate:**
```
"This is covered in collaboration/workflow-guide.md.
Please read that document first, then answer based on that guidance."
```

**Fix CLAUDE.md AI Reading Protocol:**
- Ensure AI Reading Protocol section exists
- Decision tree should be clear
- Examples of when to read what

**Prevention:**
- AI Reading Protocol in CLAUDE.md (FEAT-020)
- Train AI to check collaboration/ proactively
- Link from CLAUDE.md to specific collaboration docs

---

## When Things Go Wrong

### General Troubleshooting Process

1. **Stay Calm** - Most issues are recoverable
2. **Diagnose First** - Run diagnostics before making changes
3. **Git is Your Friend** - Check git log, git status, git reflog
4. **Document the Issue** - Create retrospective or update this guide
5. **Fix the Process** - Don't just fix instance, prevent recurrence

### Emergency Recovery Steps

**If Framework is Completely Broken:**

```bash
# 1. Check git status
git status

# 2. See what changed
git diff

# 3. If changes are bad, discard them
git reset --hard HEAD

# 4. If you need to go back further
git reflog
git reset --hard <previous-good-commit>

# 5. Restore from template if needed
cp -r /path/to/project-framework-template/standard/* .
```

**If Lost Work:**

```bash
# Check reflog
git reflog

# Find lost commit
git log --all --oneline | grep "your commit message"

# Restore
git cherry-pick <commit-hash>
```

**If Can't Figure It Out:**

1. Ask for help (team, community, documentation)
2. Document what you tried in troubleshooting guide
3. Create blocker document (BLOCKER-TEMPLATE.md)
4. Escalate if blocking progress

---

## Adding to This Guide

**When you encounter a new issue:**

1. **Document the Problem:**
   - Symptoms
   - How you diagnosed it
   - What you tried
   - What worked

2. **Add to This Guide:**
   - Create new section or expand existing
   - Include actual commands/examples
   - Link to related documentation

3. **Update CLAUDE.md if Needed:**
   - If issue reveals gap in AI guidance
   - Add to Emergency Reference section
   - Link to this guide

4. **Create Retrospective:**
   - Capture learning
   - Identify process improvements
   - Update templates/documentation

---

**Related Documentation:**
- [Workflow Guide](workflow-guide.md) - Complete workflow process
- [Architecture Guide](architecture-guide.md) - Framework design decisions
- [Code Quality Standards](code-quality-standards.md) - Implementation patterns

---

**Last Updated:** 2026-01-11
**Maintained By:** Framework Team
