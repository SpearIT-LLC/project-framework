# Tech Debt: Consolidate AI sections from CLAUDE.md into workflow-guide.md

**ID:** TECH-067
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-01-21

---

## Summary

Move AI-specific sections (Reading Protocol, Workflow Checkpoint Policy) from `framework/CLAUDE.md` into `framework/docs/collaboration/workflow-guide.md` to consolidate documentation and eliminate redundancy.

---

## Problem Statement

**What is the current state?**

AI collaboration rules are split between two locations:
- `framework/CLAUDE.md` - Contains AI Reading Protocol, AI Roles, AI Workflow Checkpoint Policy (ADR-001)
- `framework/docs/collaboration/workflow-guide.md` - Contains AI Roles and Workflow section, references CLAUDE.md for checkpoint policy

The `framework.yaml` sources point to `framework/CLAUDE.md` for AI-specific content:
```yaml
ai-reading-protocol: framework/CLAUDE.md#ai-reading-protocol
ai-checkpoint-policy: framework/CLAUDE.md#ai-workflow-checkpoint-policy-critical---adr-001
```

**Why is this a problem?**

1. **DRY violation** - AI role info appears in both files
2. **Template confusion** - `templates/standard/framework/` included CLAUDE.md which duplicated root CLAUDE.md purpose
3. **Broken references** - Deleted redundant CLAUDE.md from template, now `workflow-guide.md` line 456 points to non-existent file
4. **Source inconsistency** - Root `framework.yaml` points to CLAUDE.md, template `framework.yaml` points to workflow-guide.md

**What is the desired state?**

Single source of truth for AI collaboration rules in `workflow-guide.md`:
- AI Reading Protocol section
- AI Workflow Checkpoint Policy (11-step workflow with 3 approval checkpoints)
- AI Roles and Workflow section (already exists)

Root CLAUDE.md becomes purely navigation/bootstrap, pointing to workflow-guide.md for details.

---

## Proposed Solution

1. **Add AI sections to workflow-guide.md:**
   - Add "AI Reading Protocol" section (decision tree for which docs to read)
   - Add "AI Workflow Checkpoint Policy" section (11-step workflow, 3 checkpoints)
   - Update existing "AI Roles and Workflow" section references

2. **Update framework/CLAUDE.md:**
   - Remove detailed AI sections
   - Add references to workflow-guide.md sections

3. **Update root framework.yaml sources:**
   - Change `ai-reading-protocol` to point to workflow-guide.md
   - Change `ai-checkpoint-policy` to point to workflow-guide.md

4. **Update cross-references:**
   - Fix workflow-guide.md line 456 to reference correct section
   - Update any other docs that reference CLAUDE.md AI sections

**Files Affected:**
- `framework/docs/collaboration/workflow-guide.md` - Add AI sections
- `framework/CLAUDE.md` - Remove AI sections, add references
- `framework.yaml` - Update sources
- Various docs with cross-references

---

## Acceptance Criteria

- [ ] AI Reading Protocol section exists in workflow-guide.md
- [ ] AI Workflow Checkpoint Policy section exists in workflow-guide.md
- [ ] Root framework.yaml sources point to workflow-guide.md for AI content
- [ ] framework/CLAUDE.md references workflow-guide.md for AI details
- [ ] No broken cross-references in framework docs
- [ ] Template framework.yaml matches pattern (already done)

---

## Notes

- Discovered during FEAT-025 (Manual Setup Process Validation)
- Template's `framework.yaml` already updated to point to workflow-guide.md
- Template's `framework/CLAUDE.md` and `CLAUDE-QUICK-REFERENCE.md` already deleted

---

## Related

- FEAT-025: Manual Setup Process Validation (discovered this issue)
- ADR-001: AI Workflow Checkpoint Policy

---

**Last Updated:** 2026-01-21
