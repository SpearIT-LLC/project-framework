# Tech Debt: Document Artifacts Pattern

**ID:** TECH-097
**Type:** Tech Debt
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-01-30

---

## Summary

The folder-follows-parent artifacts pattern was designed and implemented for TECH-094 test files, but is not yet documented in workflow-guide.md. Document this pattern so it can be used consistently for all work item associated files (tests, research, deliverables, temp files).

---

## Problem Statement

**What is the current state?**

The artifacts pattern exists in practice:
- TECH-094 test files moved to `done/TECH-094/` subfolder
- Pre-commit hook updated to skip artifact subfolders
- Session history documents the pattern design decisions
- But no guidance in workflow-guide.md

**Why is this a problem?**

- Pattern exists but isn't discoverable
- No guidance on when to create artifact folders
- No documentation of lifecycle rules
- fw-move doesn't explicitly handle artifact folders
- Risk of inconsistent usage

**What is the desired state?**

Clear documentation that:
- Explains the folder-follows-parent pattern
- Shows when to create `WORK-ID/` artifact folders
- Documents lifecycle rules (folders move/delete with parent)
- Updates fw-move to handle artifact folders
- Addresses edge cases and exceptions

---

## Proposed Solution

### 1. Document Pattern in workflow-guide.md

Add new "Work Item Artifacts" section covering:

**Pattern Overview:**
```
work/doing/
  TECH-094-fw-move-enforcement.md          # Work item
  TECH-094/                                 # Artifacts folder
    test-001-valid-item.md
    test-002-missing-status.md
    research-notes.md
    prototype-code.ps1
    diagram.png
```

**Key Principles:**
- Any file type (markdown, code, images, data, etc.)
- Folder name matches work item ID
- Folder follows parent everywhere (doing → done → releases → archive)
- Simple lifecycle (one git mv operation moves everything)

**When to Use:**
- Test artifacts for validation
- Work-in-progress drafts and notes
- Deliverable outputs (reports, diagrams)
- Prototypes and experiments
- Any supporting material for a work item

**Lifecycle Rules:**
- Create folder when needed (not every work item requires artifacts)
- Move folder with work item using `git mv WORK-ID* target/`
- Delete folder when deleting work item
- Archive folder with work item in releases/

**Exceptions:**
- Cross-cutting research → stays in `project-hub/research/`
- Stakeholder reports → may need `project-hub/reports/` (revisit with FEAT-015)
- Large files → defer guidance to future work item

### 2. Update fw-move Skill

Add artifact folder handling:
```bash
# Move work item file
git mv work/doing/TECH-094-*.md work/done/

# Move artifact folder if exists
if [ -d "work/doing/TECH-094" ]; then
  git mv work/doing/TECH-094/ work/done/
fi
```

Document in fw-move.md:
- Check for artifact folder after moving work item
- Move folder using same pattern
- Report to user if artifact folder moved

### 3. Update Pre-commit Hook Documentation

Document the hook behavior:
- Hook validates .md files directly in done/
- Hook skips files in done/WORK-ID/ subfolders
- Rationale: Artifacts aren't work items, can be any file type

### 4. Update Work Item Templates

Add optional "Artifacts" section to templates:
```markdown
## Artifacts

<!-- Optional: List any associated files in WORK-ID/ folder -->
- `test-001.md` - Valid work item test case
- `research-notes.md` - Investigation findings
- `prototype.ps1` - Experimental script
```

**Files Affected:**
- `framework/docs/collaboration/workflow-guide.md` - Add "Work Item Artifacts" section
- `.claude/commands/fw-move.md` - Add artifact folder handling
- `framework/templates/work-items/*.md` - Add optional Artifacts section
- `framework/CHANGELOG.md` - Document pattern addition

---

## Acceptance Criteria

- [ ] workflow-guide.md has "Work Item Artifacts" section
- [ ] Pattern overview, principles, and when-to-use documented
- [ ] Lifecycle rules clearly explained
- [ ] Exceptions documented (research, reports, large files)
- [ ] fw-move.md updated with artifact folder handling logic
- [ ] Pre-commit hook behavior documented
- [ ] Work item templates have optional Artifacts section
- [ ] CHANGELOG.md updated
- [ ] Examples reference TECH-094 as demonstration

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
<!-- User can say "continue to completion" to approve remaining steps at once. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED**
  - AI presents: Documentation structure, content outline, examples
  - User explicitly approves before proceeding

- [ ] Add "Work Item Artifacts" section to workflow-guide.md
- [ ] Update fw-move.md with artifact folder handling
- [ ] Document pre-commit hook behavior with artifacts
- [ ] Update work item templates with optional Artifacts section
- [ ] Update CHANGELOG.md
- [ ] Acceptance criteria verified

---

## Notes

**Pattern Origin:**
- Designed during 2026-01-30 session analyzing TECH-094 cleanup
- User insight: "What if all associated docs lived in a sub-folder and followed the parent?"
- Implemented immediately for TEST files cleanup
- Session history: `framework/project-hub/history/sessions/2026-01-30-SESSION-HISTORY.md`

**Current Implementation:**
- TECH-094 demonstrates pattern with 6 test files
- Pre-commit hook already skips artifact subfolders
- Pattern works but lacks documentation

**Edge Cases Deferred:**
- Large files handling (user prompt, configuration, .gitignore patterns)
- Stakeholder reports folder (revisit with FEAT-015)
- Binary artifact storage strategies

**Terminology:**
- "Artifacts" chosen for conciseness and industry familiarity
- Alternatives considered: associated files, supporting files, supplementary materials

---

## Related

- TECH-094: Workflow Enforcement System (demonstrates artifacts pattern)
- Session history: `framework/project-hub/history/sessions/2026-01-30-SESSION-HISTORY.md`
- Pre-commit hook: `.claude/hooks/Validate-WorkItems.ps1` (lines 50-53)
- FEAT-015: (Future) Stakeholder reports handling
- (Future work item): Large files and binary artifact strategies

---

**Last Updated:** 2026-01-30
