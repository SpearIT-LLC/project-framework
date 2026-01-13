# Framework Upgrade Path

**Version:** 1.0.0
**Last Updated:** 2025-12-19

---

## Overview

Projects evolve. What starts as a simple script can grow into a maintained tool or full application. This document guides you through upgrading your project framework as complexity increases.

**Key Principle:** Upgrade when the current framework level becomes constraining, not before.

---

## When to Upgrade

### Signs You've Outgrown Your Current Level

#### Minimal → Light

**Upgrade triggers:**
- Script now has 2-3+ files
- You've made 3+ versions/updates worth tracking
- Someone else needs to use or maintain it
- You need to document decisions made
- Handoff to future-you or colleague expected
- Script became more complex than anticipated

**Don't upgrade if:**
- Still single file < 500 lines
- No version history needed
- Personal use only, no handoff expected

#### Light → Standard

**Upgrade triggers:**
- 10+ files in project
- Multiple distinct features/work items
- Team collaboration needed (2+ developers)
- Formal releases with changelogs required
- Architecture decisions need documentation (ADRs)
- Planning and roadmap becoming necessary
- Kanban workflow would help manage work

**Don't upgrade if:**
- Still < 10 files
- Single developer, simple coordination
- Linear development, no complex planning needed

---

## Upgrade Process

### Minimal → Light Upgrade

**What you're adding:**
- PROJECT-STATUS.md - Version tracking
- CHANGELOG.md - Change history
- thoughts/project/history/ - Decision documentation
- thoughts/project/research/justification.md - Why this tool exists
- Optional CLAUDE.md - Project-specific guidance

**Step-by-step:**

1. **Backup current files**
   ```bash
   mkdir upgrade-backup-$(date +%Y%m%d)
   cp README.md upgrade-backup-$(date +%Y%m%d)/
   ```

2. **Copy Light framework template**
   ```bash
   # From project-framework-template/light/
   cp README.md README-light-template.md
   cp PROJECT-STATUS.md .
   cp CHANGELOG.md .
   cp -r thoughts/ .
   ```

3. **Merge README content**
   - Open your current README.md
   - Open README-light-template.md
   - Copy your "Why This Script Exists" section to new README structure
   - Add installation, usage sections from template
   - Delete README-light-template.md when done

4. **Initialize PROJECT-STATUS.md**
   - Set current version (determine from git tags or choose v1.0.0)
   - Document current implementation status
   - List completed features

5. **Initialize CHANGELOG.md**
   - Review git history if available
   - Document recent changes
   - Create [Unreleased] section for future work

6. **Create justification document**
   - Create `thoughts/project/research/justification.md`
   - Document why tool exists (move from README if present)
   - List alternatives considered
   - Explain decision to build custom

7. **Commit upgrade**
   ```bash
   git add .
   git commit -m "Framework: Upgrade from Minimal to Light

   - Added PROJECT-STATUS.md for version tracking
   - Added CHANGELOG.md with history
   - Added thoughts/project/ structure for decisions
   - Created research justification document"

   git tag -a v1.1.0 -m "Framework upgrade to Light"
   ```

8. **Cleanup**
   ```bash
   rm -rf upgrade-backup-$(date +%Y%m%d)
   ```

---

### Light → Standard Upgrade

**What you're adding:**
- Full thoughts/ framework structure
- Kanban workflow (todo/doing/done)
- Planning and roadmap capability
- Full research templates
- Project-specific CLAUDE.md
- INDEX.md for documentation navigation
- Complete framework patterns and templates

**Step-by-step:**

1. **Backup current project**
   ```bash
   git checkout -b framework-upgrade-standard
   mkdir upgrade-backup-$(date +%Y%m%d)
   cp -r * upgrade-backup-$(date +%Y%m%d)/
   ```

2. **Copy Standard framework template**
   ```bash
   # Copy from project-framework-template/standard/
   # Be careful not to overwrite existing files
   cp -n INDEX.md .
   cp -n CLAUDE.md CLAUDE-template.md
   cp -r thoughts/framework/ thoughts/
   cp -r thoughts/project/planning/ thoughts/project/
   cp -r thoughts/project/work/ thoughts/project/
   cp -r thoughts/project/reference/ thoughts/project/
   ```

3. **Migrate existing content**
   - **history/** - Already exists from Light, keep as-is
   - **research/** - Move `justification.md` to research/, add other research docs as needed

4. **Create project-specific CLAUDE.md**
   - Copy CLAUDE-template.md to CLAUDE.md
   - Customize with project specifics:
     - What This System Is
     - Architecture overview
     - Coding standards
     - Common commands
     - Emergency reference
   - Delete CLAUDE-template.md

5. **Create INDEX.md**
   - List all documentation
   - Organize by category (Status, Planning, Reference, History)
   - Add links to key documents

6. **Initialize planning structure**
   - Create `thoughts/project/planning/roadmap.md`
   - Document high-level goals and version targets
   - Create initial backlog items if known

7. **Initialize kanban workflow**
   - Review current work items
   - Create feature docs in `thoughts/project/work/todo/`
   - Use FEATURE-TEMPLATE.md for structure
   - Set WIP limits in .limit files (default: doing=1, todo=10)

8. **Migrate decisions to ADRs (optional)**
   - Review history/ for significant decisions
   - Create ADRs in `thoughts/project/research/adr/` for major ones
   - Use ADR-MAJOR-TEMPLATE.md or ADR-MINOR-TEMPLATE.md

9. **Update documentation**
   - Enhance README with architecture section
   - Update PROJECT-STATUS to reflect new structure
   - Update CHANGELOG with framework upgrade entry

10. **Commit and merge upgrade**
    ```bash
    git add .
    git commit -m "Framework: Upgrade from Light to Standard

    - Added full thoughts/framework/ structure
    - Added kanban workflow (todo/doing/done)
    - Added planning/roadmap capability
    - Created project-specific CLAUDE.md
    - Created INDEX.md for navigation
    - Migrated work items to kanban structure"

    git checkout main
    git merge framework-upgrade-standard
    git tag -a v2.0.0 -m "Framework upgrade to Standard - breaking change to project structure"
    git branch -d framework-upgrade-standard
    ```

11. **Cleanup**
    ```bash
    rm -rf upgrade-backup-$(date +%Y%m%d)
    ```

---

## Downgrading (Rare)

**When to downgrade:**
- Project scope reduced significantly
- Overhead not justified by current needs
- Team size decreased

**Process:**
1. Archive unnecessary documentation to `thoughts/project/archive/`
2. Keep git history intact (don't delete, just stop using)
3. Simplify active documentation to lower framework level
4. Document downgrade decision in session history

**Note:** Downgrading is rare. Usually better to keep existing framework level and just not use all features.

---

## Upgrade Checklist Summary

### Minimal → Light
- [ ] Backup current files
- [ ] Add PROJECT-STATUS.md
- [ ] Add CHANGELOG.md
- [ ] Add thoughts/project/history/
- [ ] Create research/justification.md
- [ ] Commit and tag upgrade

### Light → Standard
- [ ] Backup current project
- [ ] Copy Standard framework templates
- [ ] Create project-specific CLAUDE.md
- [ ] Create INDEX.md
- [ ] Initialize planning structure (roadmap)
- [ ] Initialize kanban workflow (todo/doing/done)
- [ ] Migrate work items to kanban
- [ ] Migrate decisions to ADRs (optional)
- [ ] Update documentation
- [ ] Commit and tag upgrade (v2.0.0 - breaking structure change)

---

## Related Documents

- [NEW-PROJECT-CHECKLIST.md](NEW-PROJECT-CHECKLIST.md) - Initial setup for each framework level
- [CLAUDE.md](../CLAUDE.md) - Generic framework guidelines
- [version-control-workflow.md](../HPCJobQueuePrototype/thoughts/framework/process/version-control-workflow.md) - Release process

---

## Questions?

**How do I know if I'm at the right framework level?**
- If framework feels burdensome and you're skipping steps, you may be over-framed
- If you're inventing structure not in framework, you may need to upgrade
- If uncertain, stay at current level and reassess at next retrospective

**Can I mix framework levels?**
- Generally no - pick one level for consistency
- Exception: Can use parts of higher level (like ADRs) without full upgrade
- Document any deviations in CLAUDE.md

**What if I upgrade too early?**
- Not a disaster - you have more structure available
- Just don't use features you don't need yet
- Extra documentation is better than missing documentation

**What if I upgrade too late?**
- You may have invented ad-hoc structures outside framework
- Migrate your custom patterns into framework during upgrade
- Document in session history why upgrade was delayed

---

**Last Updated:** 2025-12-19
**Version:** 1.0.0
