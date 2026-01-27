# Tech Debt: Implement Setup Process Suggestions

**ID:** TECH-081
**Type:** Tech Debt
**Priority:** Low
**Version Impact:** PATCH
**Created:** 2026-01-23

---

## Summary

Implement three suggestions from FEAT-025 testing to improve the new project setup experience.

---

## Problem Statement

**What is the current state?**

Testing identified three improvement opportunities:

1. **"What's Next" guidance is vague:**
   - Current: "Create a work item" with Copy-Item command
   - Users don't know what to put in the work item
   - No explanation of why they need one

2. **No GitHub setup step:**
   - Git initialized locally but no remote setup guidance
   - Users who want remote backups must figure it out themselves

3. **No LICENSE prompt:**
   - No guidance on adding a license file
   - Important for open-source or shared projects

**Why is this a problem?**

- New users may be confused about next steps
- Setup feels incomplete without remote backup
- License omission could cause legal issues later

**What is the desired state?**

- Clear guidance on first work item with purpose explanation
- Optional GitHub/remote setup step
- Optional license selection during setup

---

## Proposed Solution

### 1. Improve "What's Next" Section

Update NEW-PROJECT-CHECKLIST.md "First Work Item" section:

```markdown
## First Work Item

After setup, define what you're building:

**Option A: Ask the AI**
> "Create a work item for my first feature: [describe feature]"

**Option B: Manual Creation**
1. Copy template: `Copy-Item framework/templates/work-items/FEAT-NNN-template.md project-hub/work/backlog/FEAT-001-your-feature.md`
2. Edit the work item to describe:
   - What you're building
   - Why it's needed
   - Acceptance criteria

**Purpose:** Work items define scope BEFORE writing code. This prevents scope creep and provides clear completion criteria.
```

### 2. Add Optional GitHub Step

Add after "Phase 3: Git Setup" in NEW-PROJECT-CHECKLIST.md:

```markdown
### Phase 3.5: Remote Setup (Optional)

If you want to push to GitHub:

- [ ] Create repository on GitHub (do not initialize with README)
- [ ] Add remote:
  ```powershell
  git remote add origin https://github.com/username/repo-name.git
  ```
- [ ] Push with tags:
  ```powershell
  git push -u origin main
  git push --tags
  ```
```

### 3. Add Optional License Step

Add to "Phase 2: Configure Project":

```markdown
- [ ] **Add LICENSE file (optional)**
  - For open source: MIT, Apache 2.0, GPL
  - For proprietary: Add copyright notice or skip
  - Use https://choosealicense.com/ if unsure
```

### 4. Update Setup-Project.ps1 Output

Update script "Next steps" output to reference documentation (DRY principle):

```powershell
Write-Host "`nFor next steps, see:" -ForegroundColor Yellow
Write-Host "  NEW-PROJECT-CHECKLIST.md (After Setup section)" -ForegroundColor White
Write-Host "`nKey topics covered:" -ForegroundColor Cyan
Write-Host "  - Creating your first work item (AI or manual)" -ForegroundColor Gray
Write-Host "  - GitHub/remote setup (optional)" -ForegroundColor Gray
Write-Host "  - Adding a LICENSE file (optional)" -ForegroundColor Gray
```

**Files Affected:**
- `templates/NEW-PROJECT-CHECKLIST.md` - Add/improve three sections
- `templates/starter/Setup-Project.ps1` - Update "Next steps" output

---

## Acceptance Criteria

- [ ] "First Work Item" section explains purpose of work items
- [ ] "Ask the AI" option provided for creating first work item
- [ ] Optional GitHub/remote setup step added
- [ ] Optional LICENSE guidance added with choosealicense.com link
- [ ] Setup-Project.ps1 points to NEW-PROJECT-CHECKLIST.md as single source of truth

---

## Notes

These are quality-of-life improvements that make the framework more approachable for new users.

---

## Related

- FEAT-025: Manual Setup Validation (source of suggestions)
