# CLAUDE Quick Reference

**Purpose:** Critical rules and quick decision trees for AI assistants
**Full Documentation:** See [CLAUDE.md](CLAUDE.md) and [docs/collaboration/](docs/collaboration/)
**Last Updated:** 2025-12-22

---

## AI Workflow Checkpoint Policy (11 Steps)

**CRITICAL:** Follow this workflow for ALL feature requests

```
User Request → Backlog → [CHECKPOINT] → Todo → Doing → Done → Release
```

### The 11 Steps

1. **Listen** - Understand user requirement
2. **Research** - Quick check - does this exist already?
3. **Create Backlog** - Use template, place in `project-hub/work/backlog/`, status "Backlog"
4. **Present Plan** ⚠️ CHECKPOINT - Summarize approach, list files, ask "Should I proceed?"
5. **Wait for Approval** - User says yes → continue, no → stop
6. **Check WIP Limits** - Read `.limit` file, count doing/ items, must be under limit
7. **Move Through Workflow** - backlog → todo → doing (update status each time)
7.5. **Pre-Implementation Review** ⚠️ CHECKPOINT - Review work item, confirm approach before coding
8. **Implement** - Write code, tests, docs
8.5. **Review & Approval** ⚠️ CHECKPOINT - Present completed work for user review
9. **Complete & Release** - Atomic: update PROJECT-STATUS.md + CHANGELOG.md + move to done/ + commit + tag

**Reference:** [CLAUDE.md](CLAUDE.md) | [ADR-001](project-hub/research/adr/001-ai-workflow-checkpoint-policy.md)

---

## Critical Rules

### NEVER

- ❌ Implement features without user approval (violates ADR-001)
- ❌ Exceed WIP limits in work/doing/
- ❌ Skip the approval checkpoint
- ❌ Create items directly in work/doing/ (must go through backlog)
- ❌ Commit version separately from implementation (violates atomic release)
- ❌ Modify templates in templates/ (copy, don't edit)
- ❌ Store passwords in plain text
- ❌ Use eval() with user input
- ❌ Concatenate user input into SQL queries
- ❌ Skip input validation

### ALWAYS

- ✅ Ask "Should I proceed?" before implementing features
- ✅ Check WIP limits before moving items to doing/
- ✅ Update PROJECT-STATUS.md and CHANGELOG.md atomically with releases
- ✅ Read collaboration/ docs when need detailed guidance
- ✅ Use parameterized queries for database
- ✅ Validate all user input
- ✅ Hash passwords with bcrypt
- ✅ Follow fail-fast principle for error handling
- ✅ Write tests for new features and bug fixes
- ✅ Keep functions ≤ 50 lines

---

## Quick Decision Trees

### Should I Create an ADR?

```
Making decision between alternatives?
├─ YES → Create ADR
└─ NO → Just implement (or use code comment)

Which template?
├─ Affects 3+ files OR hard to change OR significant trade-offs → MAJOR
└─ Simple, 1-2 files, easy to change → MINOR

When in doubt: Start MINOR, upgrade to MAJOR if needed
```

**Location:** `project-hub/research/adr/NNN-decision-name.md`
**Templates:** [templates/](templates/)
**Full Guide:** [collaboration/workflow-guide.md](docs/collaboration/workflow-guide.md#architecture-decision-records-adrs)

---

### Is Release Ready?

```
Before creating release:
├─ All work/doing/ items complete? (moved to done/)
├─ Tests passing?
├─ Documentation updated?
├─ CHANGELOG.md has [Unreleased] content?
└─ Version number calculated (MAJOR.MINOR.PATCH)?

During release (atomic):
├─ Update PROJECT-STATUS.md (version, date, history)
├─ Update CHANGELOG.md ([Unreleased] → [vX.Y.Z])
├─ Move work items (doing/ → done/, update status)
├─ Commit all together
├─ Create annotated git tag (vX.Y.Z)
└─ Push with --tags

After release:
└─ Archive done/ items to history/releases/{product}/vX.Y.Z/
```

**Reference:** [CLAUDE.md step 9](CLAUDE.md) | [version-control-workflow.md](project-framework-template/standard/project-hub/framework/process/version-control-workflow.md)

---

### Which Collaboration Doc to Read?

```
Need workflow process? → collaboration/workflow-guide.md
Need coding standards? → collaboration/code-quality-standards.md
Need testing guidance? → collaboration/testing-strategy.md
Need security guidance? → collaboration/security-policy.md
Need framework understanding? → collaboration/architecture-guide.md
Have a problem? → collaboration/troubleshooting-guide.md
Not sure? → collaboration/README.md (navigation index)
```

**Strategy:** CLAUDE.md = quick reference, collaboration/ = full details

---

## Emergency Fixes

### Top 5 Common Issues

**1. WIP Limit Violation**
```bash
# Check limit
cat project-hub/work/doing/.limit

# Count items
ls project-hub/work/doing/*.md | wc -l

# Fix: Move items back to todo/ or complete to done/
mv project-hub/work/doing/extra-item.md project-hub/work/todo/
```

**2. Version Mismatch**
```bash
# Check version consistency
grep "Current Version" PROJECT-STATUS.md
git describe --tags --abbrev=0

# Should match! If not, update PROJECT-STATUS.md and commit
```

**3. Bypassed Approval Checkpoint (ADR-001)**
```
Symptom: Feature implemented without "Should I proceed?" approval

Fix:
1. Document violation in retrospective
2. If good: accept but note gap
3. If wrong: revert and restart with approval
4. Review ADR-001 to prevent recurrence
```

**4. Modified Template Instead of Instance**
```bash
# Check if template was modified
git log templates/FEATURE-TEMPLATE.md

# Fix: Restore template
git checkout HEAD~1 templates/FEATURE-TEMPLATE.md

# Correct workflow: COPY template to project location
cp templates/FEATURE-TEMPLATE.md project-hub/work/backlog/feature-123.md
```

**5. Forgot to Archive After Release**
```bash
# Create release archive (determine product: framework, plugin-light, plugin-full)
mkdir -p project-hub/history/releases/framework/v2.1.0

# Move completed items
mv project-hub/work/done/*.md project-hub/history/releases/framework/v2.1.0/

# Commit
git add project-hub/history/releases/framework/v2.1.0/
git commit -m "Archive: Move framework v2.1.0 items to history"
```

**Full Troubleshooting:** [collaboration/troubleshooting-guide.md](docs/collaboration/troubleshooting-guide.md)

---

## Key File Locations

### Documentation (Read These)
- `CLAUDE.md` - AI collaboration contract (detailed, ~600 lines)
- `CLAUDE-QUICK-REFERENCE.md` - This file (quick, <200 lines)
- `docs/collaboration/` - Detailed guides (~4,000 lines total)
- `templates/` - Copy-paste templates

### Work Tracking
- `project-hub/work/backlog/` - Future work (not approved)
- `project-hub/work/todo/` - Ready to start (approved, not started)
- `project-hub/work/doing/` - In progress (WIP limit enforced)
- `project-hub/work/done/` - Complete (awaiting release)
- `project-hub/history/releases/{product}/vX.Y.Z/` - Archived (released)

### Version Info (Single Source of Truth)
- `PROJECT-STATUS.md` - Current version and status
- `CHANGELOG.md` - Version history
- `git tags` - Release tags

---

## Framework Levels Quick Guide

| Level | Files | Use For |
|-------|-------|---------|
| **Minimal** | 2 | Scripts, throwaway, personal |
| **Light** | 7 | Tools, solo professional |
| **Standard** | 50+ | Applications, teams, AI collaboration |

**This project uses:** Standard Framework

---

## Quick Commands

### Check Status
```bash
# WIP limit compliance
cat project-hub/work/doing/.limit && ls project-hub/work/doing/*.md | wc -l

# Version consistency
grep "Current Version" PROJECT-STATUS.md && git describe --tags --abbrev=0

# Git status
git status
```

### Move Work Items
```bash
# Backlog → Todo (after user approval)
mv project-hub/work/backlog/feature-XXX.md project-hub/work/todo/

# Todo → Doing (check WIP limit first!)
mv project-hub/work/todo/feature-XXX.md project-hub/work/doing/

# Doing → Done (after completion)
mv project-hub/work/doing/feature-XXX.md project-hub/work/done/
```

### Create Work Items
```bash
# Copy template
cp templates/FEATURE-TEMPLATE.md project-hub/work/backlog/feature-XXX-description.md

# Edit the copy (NOT the template!)
```

---

## Testing Quick Reference

**TDD Cycle:** Red (failing test) → Green (passing test) → Refactor

**Coverage Targets:**
- Core logic: 90-100%
- Services: 80-90%
- UI: 60-80%
- Utils: 90-100%

**Edge Cases Always Test:**
- Empty/null/undefined inputs
- Boundary values (max/min)
- Invalid states
- Wrong types

**Fail Fast:**
```javascript
// Good: Validate at entry
function divide(a, b) {
  if (typeof a !== 'number' || typeof b !== 'number') {
    throw new TypeError('Both arguments must be numbers');
  }
  if (b === 0) throw new Error('Division by zero');
  return a / b;
}
```

---

## Security Quick Reference

**Input Validation:**
- Allowlist > Blocklist
- Validate length, type, format
- Sanitize before storage/display

**Passwords:**
- bcrypt with 12+ rounds (never plain text, MD5, or SHA without salt)
- Minimum 8 characters
- Require: upper, lower, number, special char

**Database:**
- Parameterized queries (NEVER concatenate user input)
- Use ORM when possible

**XSS Prevention:**
- Use `textContent` not `innerHTML`
- Sanitize HTML with DOMPurify
- Content Security Policy headers

**SQL Injection:**
```javascript
// ❌ BAD
const query = `SELECT * FROM users WHERE email = '${email}'`;

// ✅ GOOD
const query = 'SELECT * FROM users WHERE email = ?';
await db.query(query, [email]);
```

---

**For Complete Documentation:**
- **Detailed Reference:** [CLAUDE.md](CLAUDE.md)
- **Collaboration Guides:** [docs/collaboration/](docs/collaboration/)
- **Templates:** [templates/](templates/)

---

**Last Updated:** 2025-12-22
