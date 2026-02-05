# FEAT-026-P2-TECH: Enterprise References to Remove

**Instructions:** Edit each file listed below to remove/replace Enterprise references.
**Goal:** Remove all Enterprise framework mentions - we only have Minimal, Light, Standard.
**Replacement pattern:** "Minimal, Light, Standard, Enterprise" → "Minimal, Light, Standard"

---

## User-Facing Documentation (HIGH PRIORITY)

### README.md
✅ **DONE** - Already cleaned up by Claude

### framework/CHANGELOG.md
- Line 241: `- **Multi-level framework system** - Minimal, Light, Standard, Enterprise`
  - **Action:** Remove ", Enterprise"
  - **DONE**

### framework/CLAUDE.md
- Line 26: `**Key Innovation:** Scales from single scripts to enterprise systems using a 3-dimension classification system.`
  - **Action:** Replace "enterprise systems" with "full applications"
  - **DONE**
- Line 319: `| System + Critical + Large Team | **Enterprise** (custom) |`
  - **Action:** Remove entire row OR change to just "Standard (recommend)"
  - **DONE**
- Line 343: `- Enterprise-ready documentation`
  - **Action:** Remove entire bullet OR change to "Production-ready documentation"
  - **DONE**

### framework/CLAUDE-QUICK-REFERENCE.md
- Line 221: `| **Enterprise** | Custom | Custom | Large systems, compliance |`
  - **Action:** Remove entire row
  - **DONE**

### framework/PROJECT-STATUS.md
- Line 15: `Multi-level framework system (Minimal/Light/Standard/Enterprise) is complete`
  - **Action:** Remove "/Enterprise"
  - **DONE**
- Line 33: `- ✅ Multi-level framework system (Minimal/Light/Standard/Enterprise) - Complete`
  - **Action:** Remove "/Enterprise"
  - **DONE**
- Line 70: `| Enterprise Framework | 📋 Planned | 0% | Future | Custom extensions only |`
  - **Action:** Remove entire row
  - **DONE**
- Lines 165-167: `### Enterprise Framework (Future)` section
  - **Action:** Remove entire section (3 lines)
  - **DONE**

### framework/INDEX.md
- Lines 206-209: `### Enterprise Framework (Custom)` section
  - **Action:** Remove entire section (4 lines)
  - **DONE**
- Line 226: `- Standard → Enterprise (custom)`
  - **Action:** Remove entire bullet
  - **DONE**

---

## Template Package Documentation (MEDIUM PRIORITY)

### project-templates/README-TEMPLATE-SELECTION.md
- Line 23: `| Large system, 50+ files | → **Standard** or **Enterprise** |`
  - **Action:** Change to just "**Standard**"
  - **DONE**
- Line 32: `| Critical production system | → **Standard** or **Enterprise** |`
  - **Action:** Change to just "**Standard**"
  - **DONE**
- Line 41: `| Large team (6+ people) | → **Enterprise** |`
  - **Action:** Change to "**Standard** (not recommended for large teams)"
  - **DONE**
- Line 55: `| System | Critical | Large Team | **Enterprise** |`
  - **Action:** Remove entire row
  - **DONE**
- Line 149: `- No enterprise-specific governance`
  - **Action:** Remove entire bullet (or change to "governance as needed")
  - **DONE**
- Lines 175-201: `### Enterprise Framework` section (entire section)
  - **Action:** Remove entire section (~27 lines)
  - **DONE**
- Line 222: `├─ Yes (6+ people) → ENTERPRISE`
  - **Action:** Change to "→ STANDARD (note: large teams may need custom extensions)"
  - **DONE**
- Line 230: Table header includes "Enterprise"
  - **Action:** Remove "Enterprise" column from table
  - **DONE**
- Line 273: `**Answer:** Start with **Standard**, plan for **Enterprise**`
  - **Action:** Change to "Start with **Standard**, extend as needed"
  - **DONE**
- Line 275: `- Add enterprise requirements incrementally`
  - **Action:** Remove bullet
  - **DONE**
- Line 313: `- **Standard → Enterprise:** When system requires governance`
  - **Action:** Remove entire bullet
  - **DONE**

### project-templates/NEW-PROJECT-CHECKLIST.md
- Line 10: `single scripts to enterprise systems`
  - **Action:** Change to "single scripts to full applications"
  - **DONE**
- Line 55: `| System + Critical + Large Team | **Enterprise** | [Enterprise Note](#enterprise-framework) |`
  - **Action:** Remove entire row
  - **DONE**
- Lines 312-327: `## Enterprise Framework` section (entire section)
  - **Action:** Remove entire section (~16 lines)
  - **DONE**

### project-templates/UPGRADE-PATH.md
- Line 51: `#### Standard → Enterprise`
  - **Action:** Remove entire section header
  - **DONE**
- Lines 242-263: `### Standard → Enterprise` section (entire section)
  - **Action:** Remove entire section (~22 lines)
  - **DONE**
- Lines 306-307: Checklist items for Enterprise
  - **Action:** Remove these checklist items
  - **DONE**

### project-templates/STRUCTURE.md
- Line 180: `| Enterprise | Custom | Custom | Days-weeks |`
  - **Action:** Remove entire row
  - **DONE**

### project-templates/README.md
- Line 11: `single scripts to enterprise systems`
  - **Action:** Change to "single scripts to full applications"
  - **DONE**
- Lines 41+: `### Enterprise Framework (Future)` section
  - **Action:** Remove entire section
  - **DONE**

---

## Framework Internal Documentation (LOW PRIORITY)

### framework/docs/collaboration/README.md
- Line 195: `- Enterprise Framework (custom, large systems)`
  - **Action:** Remove entire bullet
  - **DONE**
- Line 226: `- Why framework scales from scripts to enterprise`
  - **Action:** Change to "scripts to applications"
  - **DONE**

### framework/docs/collaboration/architecture-guide.md
- Line 28: `enterprise systems`
  - **Action:** Change to "full applications"
  - **DONE**
- Line 42: `Minimal (2 files) → Light (7 files) → Standard (50+ files) → Enterprise (custom)`
  - **Action:** Remove "→ Enterprise (custom)"
  - **DONE**
- Lines 146-152: `#### Enterprise Framework (Custom)` section
  - **Action:** Remove entire section (~7 lines)
  - **DONE**
- Lines 169-170: Table rows mentioning Enterprise
  - **Action:** Remove or modify rows
  - **DONE**

### framework/docs/collaboration/testing-strategy.md
- Line 932: `### Full/Enterprise Framework`
  - **Action:** Change to "### Standard Framework"
  - **DONE**

---

## Historical/Reference Files (SKIP - Don't edit these)

**Files in these categories should NOT be edited** (historical record):
- `framework/thoughts/history/` - All files (release archives, session history)
- `framework/thoughts/research/adr/` - All ADRs
- `framework/thoughts/work/backlog/feature-010-enterprise-framework-docs.md` - Keep as is (backlog item)
- `framework/thoughts/work/doing/FEAT-026-followup.md` - Keep as is (this work item)
- `framework/thoughts/work/doing/FEAT-026-P2-TECH-remove-enterprise.md` - Keep as is (this work item)
- `framework/thoughts/work/doing/FEAT-026-sub-item-strategy.md` - Keep as is (meta document)
- `framework/thoughts/work/doing/FEAT-026-future-enhancements.md` - Keep as is
- `framework/thoughts/work/todo/FEAT-025-brainstorming.md` - Keep as is

---

## Summary

**Total files to edit:** ~15 user-facing/template files
**Total references to remove/change:** ~60+ instances
**Strategy:** Complete removal (Option 1) - no "future planned" mentions

**When done:**
1. Save all edited files
2. Let Claude know you're done
3. Claude will verify changes and commit
