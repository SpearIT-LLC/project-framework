# Documentation Standards

**Project:** HPC Job Queue Prototype System
**Version:** 1.5.0
**Date:** 2025-11-14
**Last Updated:** 2025-11-18
**Status:** Active

## Document Purpose

This document defines standards for all documentation in the HPC Job Queue Prototype project, including versioning, Unicode usage, and maintenance guidelines.

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Version Tracking](#version-tracking)
- [Unicode Usage Policy](#unicode-usage-policy)
- [Naming Conventions](#naming-conventions)
- [PowerShell Version Policy](#powershell-version-policy)
- [Status Tracking](#status-tracking)
- [Documentation Maintenance](#documentation-maintenance)
- [Enforcement](#enforcement)
- [Version History](#version-history)

---

## Table of Contents Standard

### When to Include
Add a table of contents to documentation files that are:
- Longer than 200 lines
- Have 5 or more major sections
- Serve as reference documents

### Format
```markdown
## Table of Contents

- [Section 1](#section-1)
  - [Subsection 1.1](#subsection-11)
  - [Subsection 1.2](#subsection-12)
- [Section 2](#section-2)
- [Section 3](#section-3)
```

### Placement
- Place immediately after document purpose/metadata
- Before the first major content section
- Update when sections are added or renamed

### Documents Requiring TOC
- system-architecture.md
- coding-standards.md
- project-plan.md
- powershell-implementation.md
- DOCUMENTATION-STANDARDS.md (this file)

---

## Version Tracking

### Version Format
All documentation files use **Semantic Versioning**: `MAJOR.MINOR.PATCH`

- **MAJOR**: Significant restructuring or complete rewrites
- **MINOR**: New sections, substantial additions, architectural changes
- **PATCH**: Corrections, clarifications, minor updates

### Version Header Format
Every major documentation file must include:

```markdown
# Document Title

**Version:** X.Y.Z
**Date:** YYYY-MM-DD
**Status:** [Active | Draft | Deprecated | Archived]
**Last Updated:** YYYY-MM-DD

## Document Purpose
[Purpose statement]
```

### Version History
Maintain version history at the end of each document:

```markdown
## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2025-11-14 | Initial release | Gary Elliott |
| 1.1.0 | 2025-11-15 | Added section on X | Gary Elliott |
| 1.1.1 | 2025-11-16 | Fixed typo in Y | Gary Elliott |
```

### Documents Requiring Versioning
- system-architecture.md
- coding-standards.md
- project-decisions.md
- project-plan.md
- powershell-implementation.md
- terminology-standards.md
- document-hierarchy.md

### Documents NOT Requiring Versioning
- README.md files (status-based, not versioned)
- Research notes (historical, dated only)
- Meeting notes
- Temporary documents

---

## Unicode Usage Policy

### Documentation Files (.md)
**Unicode IS ALLOWED** in Markdown documentation for:
- Visual clarity in diagrams (→, ←, ✓, ✅, ❌, etc.)
- Box drawing characters (┌ ┐ └ ┘ ├ ┤ ─ │)
- Emphasis and lists (• ● ○)
- Symbols for status (✓ ✗ ⚠)

**Examples:**
```markdown
✅ Completed feature
⚠️ Warning: Check this
Project flow: Input → Process → Output

┌───────────────┐
│ Component A   │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ Component B   │
└───────────────┘
```

### Code Files (.ps1, .psm1, .cs, .cmd, .bat)
**Unicode IS PROHIBITED** in all code files:
- Use ASCII characters only (32-126)
- Comments must use ASCII
- String literals must use ASCII (or escape Unicode)
- No box-drawing or special symbols

**ASCII Alternatives for Code:**
```powershell
# GOOD: ASCII only
# Job flow: queue -> running -> completed
# Status: [OK] or [FAIL]

# BAD: Unicode symbols
# Job flow: queue → running → completed
# Status: ✓ or ✗
```

### Template Files (.template)
**Unicode IS PROHIBITED** - templates generate code, use ASCII only.

### JSON/XML Data Files
**UTF-8 encoding required**, Unicode allowed in:
- Display names and descriptions
- User-facing messages
- NOT in: property names, IDs, technical values

---

## Naming Conventions

### Template Files
**Standard:** snake_case with `.template` extension

**Correct:**
- `python_script.cmd.template`
- `powershell_task.ps1.template`
- `r_analysis.cmd.template`

**Incorrect:**
- `Python_Script.cmd.template` (PascalCase - deprecated)
- `PowerShell_Task.ps1.template` (PascalCase - deprecated)

### Job Executable Files
**Format:** `{job_id}_{job_name}.{ext}`

**Examples:**
- `job0001_preprocess_data.cmd`
- `job0042_simulate_scenario.ps1`
- `job0999_aggregate_results.cmd`

**Key Points:**
- Job ID: `job` + 4-digit zero-padded number (e.g., `job0001`)
- Underscore separates job ID from job name
- Job name: snake_case
- Extension: `.cmd` or `.ps1`

### PowerShell Scripts
**Format:** `Verb-Noun.ps1` (PascalCase with approved PowerShell verb)

**Examples:**
- `New-JobsFromManifest.ps1`
- `Start-JobScheduler.ps1`
- `Get-JobState.ps1`

### PowerShell Modules
**Format:** `ModuleName.psm1` (PascalCase)

**Examples:**
- `JobDependency.psm1`
- `JobExecution.psm1`
- `JobState.psm1`

### History Documents
**Format:** `{YYYY-MM-DD}-{DOCUMENT-DESCRIPTION}.md`

**Location:** `project-hub/history/`

**Examples:**
- `2025-11-17-SECURITY-REVIEW.md`
- `2025-11-18-USER-QUICK-START-CREATION.md`
- `2025-11-18-MULTI-NODE-COORDINATION-ADDED.md`

**Key Points:**
- Date format: ISO 8601 (YYYY-MM-DD)
- Description: UPPERCASE-WITH-HYPHENS (matches existing docs style)
- Always start with date for chronological sorting
- Use descriptive names that clearly indicate the change/event
- History documents capture point-in-time summaries of work completed

---

## PowerShell Version Policy

### Required Version
**PowerShell 5.1** (Windows PowerShell) is the **default and required version** for all code.

**Rationale:**
- Pre-installed on Windows 10/11/Server 2019
- Maximum compatibility
- No additional dependencies
- Standard for Windows environments

### PowerShell 7.4 Recommendation
**PowerShell 7.4** may be recommended if:

1. **Performance improvement of 20% or more** is measured and documented
2. **Documented in code header** with benchmark results
3. **Approved by project lead** before implementation

**Recommendation Process:**
1. Benchmark code in PowerShell 5.1 (baseline)
2. Benchmark same code in PowerShell 7.4
3. Document performance improvement (must be ≥20%)
4. Submit benchmark results for approval
5. If approved, add version check to code

**Example Justification:**
```powershell
<#
.NOTES
    PowerShell Version: 7.4+ RECOMMENDED
    Reason: Parallel processing provides 35% performance improvement
    Benchmark: 5.1 = 120s, 7.4 = 78s (35% faster)
    Approved: 2025-11-15 by Gary Elliott
#>
```

### Version Check Template
All scripts requiring PowerShell 7.4+ should include:

```powershell
#Requires -Version 7.4

# Or runtime check with helpful message
if ($PSVersionTable.PSVersion.Major -lt 7 -or
   ($PSVersionTable.PSVersion.Major -eq 7 -and $PSVersionTable.PSVersion.Minor -lt 4)) {
    Write-Error "This script requires PowerShell 7.4 or later for optimal performance."
    Write-Host "Download: https://github.com/PowerShell/PowerShell/releases"
    Write-Host "Current version: $($PSVersionTable.PSVersion)"
    exit 1
}
```

---

## Status Tracking

### Status Tracking System ✅ DEFINED

**Decision Date:** 2025-11-14
**Approved By:** Gary Elliott
**Updated:** 2025-12-18

**Approach:** Single source of truth with references

### Status Location and Convention

**Single Source of Truth:** [PROJECT-STATUS.md](../../PROJECT-STATUS.md)
- **THE ONLY PLACE** for current version and implementation status
- Component-level tracking (modules, scripts, steps)
- Release history and completion dates
- Maintained by project lead

**Other Documents Reference It:**
All other documents (README.md, CLAUDE.md, etc.) should reference PROJECT-STATUS.md instead of duplicating version information:

```markdown
**Current Version & Status:** See [PROJECT-STATUS.md](PROJECT-STATUS.md)
```

**Rationale:**
- Eliminates version number drift across documents
- Single update point during releases
- Always current, no stale status information
- Reduces release checklist complexity

**Document Headers (for document lifecycle only):**
- Indicates document validity, not project implementation progress
- Values: Draft | Active | Deprecated | Archived
- "Last Updated" field for document content changes only

### Status Values (Simple)
Implementation components use:
- **⬜ Not Started** - Pending implementation, no work begun
- **🔄 In Progress** - Active development underway
- **✅ Complete** - Tested and ready for use

### Update Responsibility
- **Project Lead** maintains PROJECT-STATUS.md
- **Developers** report completion of components/steps
- **Update Frequency:** Weekly or after major milestones

### Document Status Values
Document headers continue to use:
- **Draft** - Work in progress, not ready for use
- **Active** - Current, approved for use
- **Deprecated** - Superseded, kept for reference
- **Archived** - Historical, no longer relevant

---

## Documentation Maintenance

### Update Checklist
When updating documentation:
- [ ] Update version number (increment appropriately)
- [ ] Update "Last Updated" date
- [ ] Update "Date" if major version change
- [ ] Add entry to Version History table
- [ ] Check all cross-references still valid
- [ ] Verify no new redundancy introduced
- [ ] Update status if changed

### Review Schedule
- **Monthly**: Check for outdated information
- **Per Sprint**: Update implementation status
- **Per Release**: Version bump, archive old versions

### Redundancy Prevention
Before adding content, check:
1. Does this belong in the canonical location?
2. Can I reference instead of duplicate?
3. Is this information already documented?
4. Would a link be better than copying?

---

## Enforcement

### Code Reviews
All code reviews must verify:
- ASCII-only in code files
- Proper naming conventions
- PowerShell 5.1 compatibility (or documented exception)
- Version headers on documentation updates

### Automated Checks
Recommended git pre-commit hooks:
```bash
# Check for Unicode in .ps1 files
find . -name "*.ps1" -exec grep -P '[^\x00-\x7F]' {} +

# Check for PowerShell version requirements
find . -name "*.ps1" -exec grep -L "#Requires -Version" {} +

# Check template naming (warn on PascalCase)
find ./CreateJobs/templates -name "*[A-Z]*[A-Z]*.template"
```

---

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2025-11-14 | Initial documentation standards | Gary Elliott |
| 1.1.0 | 2025-11-14 | Added status tracking system (central file approach) | Gary Elliott |
| 1.2.0 | 2025-11-14 | Removed deprecated template migration section, updated PS policy to simple 20% rule | Gary Elliott |
| 1.3.0 | 2025-11-14 | Added table of contents standard for long reference documents | Gary Elliott |
| 1.4.0 | 2025-11-15 | Updated job ID format from 3-digit to 4-digit zero-padded numbers | Gary Elliott |
| 1.5.0 | 2025-11-18 | Added history document naming standard ({YYYY-MM-DD}-{DOCUMENT-DESCRIPTION}.md) | Gary Elliott |
