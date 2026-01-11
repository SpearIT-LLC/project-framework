# Kanban Workflow

**Version:** 1.0.0
**Created:** 2025-12-18
**Status:** Active Process Standard

---

## Overview

A simplified file-based kanban workflow designed for one-person teams. Work items flow through planning → backlog → todo → doing → done → release → archive.

**Core Principle:** ONE work item at a time, from planning to release.

---

## Folder Structure

```
thoughts/
├── roadmap.md                          # High-level vision with work item IDs
├── work/
│   ├── backlog/                        # NOT committed yet
│   │   ├── FEAT-NNN-description.md
│   │   ├── BUGFIX-NNN-description.md
│   │   └── SPIKE-description.md
│   ├── todo/                           # Committed next (max 10)
│   │   ├── .limit                      # Contains "10"
│   │   └── FEAT-NNN-description.md
│   ├── doing/                          # Active work (WIP limit: 1)
│   │   ├── .limit                      # Contains "1"
│   │   └── FEAT-NNN-description.md     # ONLY ONE
│   └── done/                           # Ready to release
│       └── FEAT-NNN-description.md     # Triggers release
│
└── history/
    ├── releases/
    │   ├── v1.0.0/
    │   ├── v1.1.0/
    │   └── v1.2.0/
    │       └── FEAT-NNN-description.md
    └── spikes/
        └── SPIKE-description-YYYY-MM-DD.md
```

---

## Work Item Lifecycle

### Standard Flow (Features/Bugfixes)

```
roadmap.md
    ↓ (detail the work)
work/backlog/FEAT-NNN-description.md
    ↓ (commit to next sprint)
work/todo/FEAT-NNN-description.md
    ↓ (ready to work, WIP limit allows)
work/doing/FEAT-NNN-description.md
    ↓ (implemented, tested, merged)
work/done/FEAT-NNN-description.md
    ↓ (TRIGGERS RELEASE PROCESS)
history/releases/vX.Y.Z/FEAT-NNN-description.md
```

### Spike Flow (Research/Investigation)

```
work/backlog/SPIKE-description.md
    ↓ (ready to investigate)
work/doing/SPIKE-description.md
    ↓ (findings documented)
history/spikes/SPIKE-description-YYYY-MM-DD.md
```

**Note:** Spikes do NOT trigger releases.

---

## Work Item Naming Convention

### Format

```
{type}-{id}-{short-description}.md
```

**Examples:**
- `FEAT-001-namespace-system.md`
- `FEAT-002-environment-validation.md`
- `BUGFIX-004-memory-export.md`
- `TECH-040-work-item-policy.md`
- `SPIKE-hpc-integration.md` (spikes don't need IDs)

### Type Prefixes

| Type | Prefix | Version Impact | Example |
|------|--------|----------------|---------|
| Feature | `FEAT-` | MINOR (1.1.0 → 1.2.0) | `FEAT-001-namespace.md` |
| Technical | `TECH-` | PATCH (1.1.0 → 1.1.1) | `TECH-040-work-item-policy.md` |
| Bugfix | `BUGFIX-` | PATCH (1.1.0 → 1.1.1) | `BUGFIX-004-memory-export.md` |
| Decision | `DECISION-` | Varies | `DECISION-042-id-definition.md` |
| Breaking Change | `BREAKING-` | MAJOR (1.1.0 → 2.0.0) | `BREAKING-001-api-redesign.md` |
| Spike | `SPIKE-` | No release | `SPIKE-hpc-integration.md` |

### Work Item IDs

**ID Definition:** Unique sequential counter across all work item types.

**Format:** `NNN` (001, 002, 003...)

**Assignment:**
- Start at 001
- Increment sequentially
- Shared across ALL types (FEAT, TECH, BUGFIX, DECISION, SPIKE, etc.)
- Each ID used exactly once per project

**Reference Forms:**
- **Canonical:** Counter only (042)
- **Convenience:** Type-prefixed (FEAT-042, TECH-040, BUGFIX-004)
- Both forms are valid and searchable

**Filename Convention:** `{TYPE}-{NNN}-{description}.md`
- Example: `FEAT-042-namespace-system.md`
- Type prefix organizes files by category
- Counter ensures global uniqueness

**Examples:**
- ID 026 → Filename: `FEAT-026-structure-migration.md`
- ID 040 → Filename: `TECH-040-work-item-policy.md`
- ID 042 → Filename: `DECISION-042-id-definition.md`

**Searching:**
```bash
# By ID (canonical)
grep -r "\b042\b" thoughts/

# By type-prefixed reference (convenience)
grep -r "FEAT-042" thoughts/

# By filename
ls thoughts/work/*/FEAT-042*
```

---

## WIP Limits

### Current Limits

| Folder | Limit | Enforcement |
|--------|-------|-------------|
| `work/todo/` | 10 items | Soft limit (review if exceeded) |
| `work/doing/` | 1 item | **Hard limit** (enforced) |
| `work/done/` | N/A | Cleared after each release |

### WIP Limit Files

**work/todo/.limit** contains `10`
**work/doing/.limit** contains `1`

### Enforcement

**Manual Check:**
```powershell
# Check doing/ limit
$doingLimit = [int](Get-Content "thoughts/work/doing/.limit")
$doingCount = (Get-ChildItem "thoughts/work/doing/*.md" -ErrorAction SilentlyContinue).Count

if ($doingCount -ge $doingLimit) {
    Write-Warning "WIP limit reached in doing/ ($doingCount/$doingLimit). Complete current work first."
}

# Check todo/ limit
$todoLimit = [int](Get-Content "thoughts/work/todo/.limit")
$todoCount = (Get-ChildItem "thoughts/work/todo/*.md" -ErrorAction SilentlyContinue).Count

if ($todoCount -ge $todoLimit) {
    Write-Warning "TODO limit reached ($todoCount/$todoLimit). Consider reviewing backlog priorities."
}
```

**Automated Helper:** (See `scripts/Test-WipLimit.ps1` - to be created)

---

## Roadmap Integration

### Roadmap Format

**thoughts/roadmap.md** tracks high-level version goals and references work items by ID:

```markdown
## v1.2.0 - Configuration Enhancements

**Status:** In Progress
**Target Date:** Q1 2025

**Planned Features:**
- [x] FEAT-001: Manifest defaults - RELEASED v1.1.0
- [ ] FEAT-002: Namespace system - In doing
- [ ] FEAT-003: Environment validation - In backlog

**Planned Bugfixes:**
- [ ] BUG-101: Memory export fix - In backlog
- [ ] BUG-102: Dependency circular detection - In todo

**Current Work:**
- 🔄 FEAT-002: Namespace system - In doing
```

### Loose Coupling

- Roadmap references work items by ID (FEAT-002), not file path
- Work items move between folders without breaking roadmap links
- Grep-friendly: `grep -r "FEAT-002"` finds all references

---

## State Transitions

### Moving Items Between Folders

**Backlog → Todo:**
```powershell
# When ready to commit to work
Move-Item "thoughts/work/backlog/FEAT-002-namespace.md" `
          "thoughts/work/todo/FEAT-002-namespace.md"

# Update roadmap.md: "In backlog" → "In todo"
```

**Todo → Doing:**
```powershell
# When ready to start work (check WIP limit first!)
Move-Item "thoughts/work/todo/FEAT-002-namespace.md" `
          "thoughts/work/doing/FEAT-002-namespace.md"

# Create git branch
git checkout -b feature/002-namespace

# Update roadmap.md: "In todo" → "In doing"
```

**Doing → Done:**
```powershell
# When implementation complete and tested
Move-Item "thoughts/work/doing/FEAT-002-namespace.md" `
          "thoughts/work/done/FEAT-002-namespace.md"

# This TRIGGERS the release process (see version-control-workflow.md)
```

**Done → History (Post-Release):**
```powershell
# After release is tagged and pushed
Move-Item "thoughts/work/done/FEAT-002-namespace.md" `
          "thoughts/history/releases/v1.2.0/FEAT-002-namespace.md"
```

---

## Release Trigger

### When Item Moves to done/

Moving a work item to `work/done/` signals it's ready for release. This triggers the release process:

1. **Pre-Release Checks**
   - All tests pass
   - Feature branch merged to main
   - Documentation updated

2. **Version Determination**
   - Read work item metadata for version impact (MAJOR/MINOR/PATCH)
   - Calculate new version number

3. **Release Execution**
   - Update PROJECT-STATUS.md
   - Update CHANGELOG.md
   - Git commit, tag, push

4. **Post-Release**
   - Archive work item to history/releases/vX.Y.Z/
   - Delete feature branch
   - Update roadmap if needed

**See:** [version-control-workflow.md](version-control-workflow.md) for complete release process.

---

## Work Item Templates

### Required Metadata

All work items (except spikes) must include this metadata header:

```markdown
# [Type]: [Title]

**ID:** 042
**Type:** Feature | Technical | Bugfix | Decision | Breaking Change
**Version Impact:** MAJOR | MINOR | PATCH
**Target Version:** v1.2.0
**Status:** Backlog | Todo | Doing | Done | Released

---

## Description
[What this work item accomplishes]

## Rationale
[Why this is needed]

## Implementation Notes
[Technical approach, decisions made]

## Testing
[How to verify this works]

## CHANGELOG Notes
[Keep notes here during development, copy to CHANGELOG.md at release]

---

**Created:** YYYY-MM-DD
**Last Updated:** YYYY-MM-DD
```

### Templates

- **Features:** Use [FEATURE-TEMPLATE.md](../templates/FEATURE-TEMPLATE.md)
- **Bugfixes:** Use [BUGFIX-TEMPLATE.md](../templates/BUGFIX-TEMPLATE.md)
- **Blockers:** Use [BLOCKER-TEMPLATE.md](../templates/BLOCKER-TEMPLATE.md)
- **Spikes:** Use [SPIKE-TEMPLATE.md](../templates/SPIKE-TEMPLATE.md)

---

## Best Practices

### Do's

✅ Keep WIP limit to 1 (review in retrospectives if needed)
✅ Move items to done/ immediately after testing
✅ Update roadmap.md when work items change status
✅ Keep CHANGELOG notes in work item docs during development
✅ Archive completed work to history/releases/vX.Y.Z/
✅ Use descriptive IDs and names for traceability

### Don'ts

❌ Don't exceed WIP limit (finish current work first)
❌ Don't skip metadata in work item templates
❌ Don't rename files when moving between folders (keeps ID consistent)
❌ Don't batch multiple items in done/ (one release per item)
❌ Don't create releases for spikes

---

## Retrospective Review

**Review After:** 5 releases or when workflow friction identified

**Review Questions:**
- Is WIP limit of 1 still appropriate?
- Is todo/ limit of 10 appropriate?
- Are we batching releases effectively?
- Should we adjust the process?

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-12-18 | Initial kanban workflow documented |

---

## Related Documents

- [version-control-workflow.md](version-control-workflow.md) - Release process
- [FEATURE-TEMPLATE.md](../templates/FEATURE-TEMPLATE.md) - Feature planning template
- [BUGFIX-TEMPLATE.md](../templates/BUGFIX-TEMPLATE.md) - Bugfix planning template
- [BLOCKER-TEMPLATE.md](../templates/BLOCKER-TEMPLATE.md) - Blocker documentation template
- [SPIKE-TEMPLATE.md](../templates/SPIKE-TEMPLATE.md) - Spike/investigation template

---

**Last Updated:** 2026-01-11
**Next Review:** After 5 releases or when process issues arise
