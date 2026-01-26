# Feature: POC Folder and Spike Workflow

**ID:** 062
**Type:** Feature
**Version Impact:** MINOR (adds new capability)
**Status:** Todo
**Created:** 2026-01-17
**Completed:** N/A
**Developer:** TBD

---

## Summary

Add `thoughts/poc/` folder for experiments and update the `developer.prototype` workflow to prompt for spike creation. This provides tracked experimentation without kanban workflow overhead.

---

## Problem Statement

**What problem does this solve?**

During FEAT-059 testing, the `developer.prototype` variant created code outside the formal workflow. This raised questions about:
- Whether POC/prototype work should be tracked
- Where experimental code artifacts should live
- How to preserve history of what was tried (successes and failures)

Currently, prototype work either:
1. Bypasses tracking entirely (lost history)
2. Gets forced into kanban workflow (unnecessary overhead)

**Who is affected?**

- AI assistants using `developer.prototype` variant
- Users doing rapid experimentation
- Future maintainers wanting to understand what was tried

**Current workaround (if any):**

Ad-hoc file placement or skipping tracking entirely.

---

## Requirements

### Functional Requirements

- [x] Create `thoughts/poc/` folder structure
- [x] Update `developer.prototype` variant to ask "Should I create a spike to track this experiment?"
- [x] Define spike-in-poc workflow (create, work, record findings, archive)
- [x] Support spike subfolders for multi-file artifacts (`poc/SPIKE-XXX-name/`)
- [x] No WIP limits on `poc/` folder
- [x] Entire spike folder archives to `history/spikes/SPIKE-XXX/` when complete
- [x] Document optional artifact cleanup after production implementation

### Non-Functional Requirements

- [x] Performance: N/A
- [x] Security: N/A
- [x] Compatibility: Existing spike flow (`backlog → doing → history/spikes`) still works
- [x] Documentation: Update workflow-guide.md, framework-roles.yaml

---

## Design

### Architecture Impact

**Files Modified:**
- `framework/docs/collaboration/workflow-guide.md` - Add poc/ section, update spike flow
- `framework/docs/ref/framework-roles.yaml` - Update developer.prototype variant
- `framework/docs/ref/framework-schema.yaml` - Add poc/ to valid structure (if documented)

**Files Added:**
- `framework/thoughts/poc/.gitkeep` - Create folder

**Folder Structure:**
```
thoughts/
├── work/           # Formal kanban workflow
├── research/       # Analysis, ADRs, landscape reviews
├── poc/            # Experiments and spikes (NEW)
│   ├── .gitkeep
│   └── SPIKE-XXX-description/   # Spike folder with artifacts
│       ├── SPIKE-XXX-description.md
│       └── [code artifacts]
└── history/
    └── spikes/
        └── SPIKE-XXX-description/  # Archived spike folder (entire folder, not just doc)
```

**Spike Lifecycle:**
1. Create spike folder in `poc/SPIKE-XXX-description/`
2. Add spike doc and code artifacts to folder
3. Work on spike (no WIP limits)
4. Record findings in spike doc
5. Archive entire folder to `history/spikes/SPIKE-XXX-description/`
6. After production implementation → optionally delete code artifacts, keep spike doc

### Implementation Approach

**Phase 1: Folder and Basic Docs**
1. Create `thoughts/poc/.gitkeep`
2. Update workflow-guide.md with poc/ section
3. Document the distinction: research/ (documentation) vs poc/ (code experiments)

**Phase 2: Role Integration**
1. Update `developer.prototype` variant in framework-roles.yaml
2. Add trigger behavior: "On prototype request, ask about spike creation"
3. Document the workflow in the variant's mindset

**Phase 3: Template (Optional)**
1. Create SPIKE-TEMPLATE.md if not already present
2. Ensure it captures: question, approach, findings, next steps

### Alternative Approaches Considered

See ADR-004 for full analysis. Options considered:
- `thoughts/work/poc/` - Rejected (POCs don't follow kanban)
- `src/poc/` - Rejected (mixes experimental with production)
- `thoughts/research/poc/` - Rejected (research is documentation, not code)

---

## Dependencies

**Requires:**
- ADR-004 (accepted) - Documents the decision

**Blocks:**
- None

**Related:**
- FEAT-059: Context-aware AI roles (testing revealed this need)
- TECH-055: Work item move validation (poc/ excluded from kanban validation)
- FEAT-018: Claude command framework (potential `/fw-spike` command)

---

## Testing Plan

### Manual Testing Steps

1. Create `thoughts/poc/` folder
2. Trigger `developer.prototype` variant with "let's prototype X"
3. Verify AI asks about spike creation
4. Create a spike with artifacts in subfolder
5. Complete spike and archive entire folder to `history/spikes/SPIKE-XXX/`
6. Verify no WIP limit errors for poc/
7. After "production" implementation, optionally delete code artifacts from archived spike

### Edge Cases

- [ ] Spike without code artifacts (just findings doc)
- [ ] Multiple concurrent spikes (no WIP limit)
- [ ] Spike that leads to formal work item (reference chain)

---

## Security Considerations

N/A - This is a folder structure and workflow feature, not code execution.

---

## Documentation Updates

### Files to Update

- [x] workflow-guide.md - Add poc/ folder section, update spike flow diagram
- [x] framework-roles.yaml - Update developer.prototype variant
- [ ] CLAUDE.md - Add brief reference to poc/ workflow (if appropriate)

### New Documentation Needed

- [x] Spike template (if not already present) - Updated existing SPIKE-TEMPLATE.md
- [ ] Example spike with findings

---

## Implementation Checklist

- [x] ADR-004 reviewed and accepted
- [x] `thoughts/poc/.gitkeep` created
- [x] workflow-guide.md updated with poc/ section
- [x] framework-roles.yaml developer.prototype updated
- [x] Manual testing completed
- [ ] CHANGELOG.md updated

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- `thoughts/poc/` folder for experiments and proof-of-concept work
  - Separate from formal kanban workflow (no WIP limits)
  - Supports spike documents with code artifact subfolders
  - Spikes archive to `history/spikes/` when complete
- Updated `developer.prototype` variant to prompt for spike creation
- ADR-004: POC folder decision documented
```

---

## Notes

This feature emerged from FEAT-059 testing when we observed the `developer.prototype` variant creating code without tracking. The discussion led to clarifying the distinction between:
- `research/` = understanding & analysis (documentation)
- `poc/` = proving & experimenting (code + spike docs)

The POC prototype script (`Move-WorkItem.ps1`) created during this session should be retroactively attached to a spike once this feature is implemented.

---

## References

- ADR-004: POC Folder for Experiments
- FEAT-059: Context-aware AI roles (source of requirement)
- Session discussion: 2026-01-17

---

**Last Updated:** 2026-01-17
