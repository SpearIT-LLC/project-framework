# Session History: 2026-01-27

**Date:** 2026-01-27
**Participants:** Gary Elliott, Claude Code
**Session Focus:** TECH-081 setup improvements, research insights analysis, FEAT-091 roadmap implementation
**Role:** developer.iterate

---

## Summary

Completed TECH-081 setup process improvements, analyzed research insights from misc-thoughts-and-planning.md, created four new feature work items (FEAT-088 through FEAT-091), and implemented FEAT-091 (Project Roadmap Structure). The session progressed from documentation improvements to strategic planning infrastructure, establishing a roadmap system for the framework project and all future user projects.

---

## Work Completed

### TECH-081: Implement Setup Process Suggestions

**Workflow:** backlog → todo → doing → done

Improved new project setup experience based on FEAT-025 testing feedback:

1. **NEW-PROJECT-CHECKLIST.md - "After Setup" section**
   - Replaced "First Work Item" with comprehensive "After Setup" section
   - Added "Option A: Ask the AI" with example prompt for Claude Code users
   - Added "Option B: Manual Creation" with clear step-by-step instructions
   - Explained WHY work items matter (prevents scope creep, clear completion criteria)

2. **NEW-PROJECT-CHECKLIST.md - Phase 2: LICENSE guidance**
   - Added optional LICENSE file step with common options (MIT, Apache 2.0, GPL)
   - Included link to https://choosealicense.com/ for guidance

3. **NEW-PROJECT-CHECKLIST.md - Phase 3.5: Remote Setup**
   - Added new optional section for GitHub/GitLab remote setup
   - Included commands for adding remote, pushing code and tags
   - Positioned after git initialization for logical flow

4. **Setup-Project.ps1 - Output update**
   - Changed "Next steps" to reference NEW-PROJECT-CHECKLIST.md as single source of truth
   - Listed key topics: first work item, GitHub setup, LICENSE
   - Followed DRY principle - script references documentation rather than duplicating

### TECH-087: Project Type Selection - Created

Created new work item for enhancing Setup-Project.ps1 to:
- Read valid project types from framework-schema.yaml
- Present numbered options with descriptions during setup
- Validate selection and auto-populate framework.yaml
- Maintain schema as single source of truth for valid values

---

## Session 2: Research Insights Analysis and Feature Planning

### misc-thoughts-and-planning.md Review

Analyzed framework research notes to identify best ideas for implementation:

**Best Ideas (to implement):**
- Glossary in QUICK-START.md
- Project patterns (per project type)
- Coding strategy progression (MVP → Tests → Refactor → Security → Performance)
- Feature roadmap for strategic planning

**Ideas to Avoid:**
- GitHub/Jira functional integration (complexity trap)
- Multi-AI model optimization (already model-agnostic)
- Visual roadmap diagrams (maintenance burden)

**Ideas Needing Refinement:**
- framework.yaml workflow.tracking setting
- CLAUDE.md minimum viable block (merged into TECH-061)

### New Feature Work Items Created

1. **FEAT-088: Framework Glossary**
   - Create GLOSSARY.md in framework/docs/ref/
   - Define framework-specific terminology
   - Enable TECH-061 cleanup by becoming term authority

2. **FEAT-089: Project Type Patterns**
   - Document architecture patterns for each project type
   - 2-3 key patterns per type (framework, application, library, toolbox)
   - Complement FEAT-052 (workflow phases)

3. **FEAT-090: Coding Strategy Patterns**
   - Document MVP → Tests → Refactor → Security → Performance progression
   - Include when to skip phases
   - Prevent premature optimization and reckless shipping

4. **FEAT-091: Project Roadmap Structure**
   - Create roadmap system for strategic direction
   - Enable FEAT-015 (Executive Summary) to measure progress
   - Moved to todo, then to doing for implementation

### TECH-061 Enhancements

Updated TECH-061 (CLAUDE.md Duplication Review) with:
- Scope clarification (merged FEAT-092 minimum viable block audit)
- Related research references
- Category examples (bootstrap-critical vs reference vs redundant)
- Success criteria (quantitative and qualitative)
- Synergy with FEAT-088 (glossary)

---

## Session 3: FEAT-091 Implementation - Project Roadmap Structure

### Implementation Decisions

**Location Discussion:**
- Initial confusion about root vs framework/ vs docs/ locations
- **Resolution:** Consistent path for all projects: `docs/project/ROADMAP.md`
- Framework source: `docs/project/ROADMAP.md` (at repo root)
- User projects: `docs/project/ROADMAP.md` (at their repo root)
- **Key insight:** `framework/` is like `src/` - it's the packaged content

**Roadmap Structure:**
- Theme-based organization (not time-based quarters)
- Themes organize related initiatives
- Work items optionally reference themes via metadata
- Roadmap provides strategic "why" that backlog lacks

**Theme Metadata:**
- Added optional `**Theme:**` field to all 5 work item templates
- Themes defined in roadmap (organic, not master list)
- Enables linking work items to strategic initiatives

### Files Created

- `docs/project/ROADMAP.md` - Framework's actual roadmap with Q1/Q2 themes
- `framework/templates/planning/ROADMAP-TEMPLATE.md` - Template for users
- `templates/starter/docs/project/ROADMAP.md` - Starter with placeholders

### Documentation Updated

**workflow-guide.md:**
- Added comprehensive "Project Roadmap" section
- Roadmap vs backlog distinction
- Theme-based organization guidance
- Best practices and anti-patterns

**PROJECT-STRUCTURE-STANDARD.md:**
- Added `docs/project/` to optional subfolders

**REPOSITORY-STRUCTURE.md:**
- Clarified framework-as-dependency model
- Removed obsolete multi-project language
- Added docs/project/ to both source and user project structures

**Work Item Templates:**
- All 5 templates (FEATURE, TECHDEBT, BUG, SPIKE, DECISION) now have optional Theme field

### Framework Roadmap Themes

**Q1 2026 - Current Focus:**
- Distribution & Setup Excellence (DECISION-050, TECH-081, TECH-087)

**Q2 2026 - Next Phase:**
- AI Integration & Clarity (TECH-061, FEAT-088, FEAT-059)
- Developer Guidance & Patterns (FEAT-089, FEAT-090, FEAT-052)
- Quality & Release Automation (FEAT-007, FEAT-028, FEAT-051)

**Future Considerations:**
- Visual Communication (FEAT-034, FEAT-004)
- Workflow Enhancements (FEAT-030, FEAT-021, FEAT-024)

### Sprint Discussion and FEAT-092

User suggested sprint-based roadmap instead of quarterly themes:
- Sprint cadence more realistic than quarters
- Collaborative planning ceremonies
- Needs further design work

**FEAT-092 Created: Optional Sprint Support**
- Sprint configuration in framework.yaml
- Optional sprint metadata in work items
- fw-sprint-planning and fw-retrospective skills
- Roadmap as sprint single source of truth
- Design questions documented for future work

---

## Decisions Made

1. **Scope separation:**
   - Keep TECH-081 focused on documentation improvements
   - Create separate TECH-087 for project type selection feature
   - Rationale: TECH-081 already in progress, type selection is distinct feature

2. **DRY principle for setup guidance:**
   - NEW-PROJECT-CHECKLIST.md is single source of truth for setup steps
   - Setup-Project.ps1 output references the checklist rather than duplicating
   - User experience tradeoff accepted (not ideal but works for now)
   - Rationale: Avoids duplicate maintenance, ensures consistency

3. **Project type definitions:**
   - Confirmed framework-schema.yaml defines 4 valid types:
     - framework: Process/methodology documentation
     - application: Standalone software application
     - library: Reusable code package
     - toolbox: Collection of utility scripts
   - Schema is authoritative source for validation

---

## Discussion Topics

### UX Analysis
- Identified gap: users wouldn't know to ask AI or what to ask
- Solution: Added explicit "Option A: Ask the AI" with example prompt
- Trade-off: Script referencing checklist vs duplicating content

### DRY vs User Experience
- Question: How to keep script and docs in sync without duplication?
- Resolution: Documentation as SsoT, script as pointer
- Accepted limitation for now with plan to revisit UX

---

## Files Modified

**Session 1 (TECH-081):**
- `templates/NEW-PROJECT-CHECKLIST.md` - Added 3 improvements
- `templates/starter/Setup-Project.ps1` - Updated output

**Session 2 (Research & Planning):**
- `framework/project-hub/work/backlog/TECH-061-claude-md-duplication-review.md` - Added notes and success criteria

**Session 3 (FEAT-091):**
- `framework/docs/collaboration/workflow-guide.md` - Added "Project Roadmap" section
- `framework/docs/PROJECT-STRUCTURE-STANDARD.md` - Added docs/project/ folder
- `framework/docs/REPOSITORY-STRUCTURE.md` - Clarified framework-as-dependency model
- All 5 work item templates - Added optional Theme field

## Files Created

**Session 1:**
- `framework/project-hub/work/backlog/TECH-087-project-type-selection.md`

**Session 2:**
- `framework/project-hub/work/backlog/FEAT-088-glossary.md`
- `framework/project-hub/work/backlog/FEAT-089-project-patterns.md`
- `framework/project-hub/work/backlog/FEAT-090-coding-patterns.md`

**Session 3:**
- `docs/project/ROADMAP.md` - Framework's roadmap
- `framework/templates/planning/ROADMAP-TEMPLATE.md` - Template for users
- `templates/starter/docs/project/ROADMAP.md` - Starter template
- `framework/project-hub/work/backlog/FEAT-092-sprint-support.md`

## Files Moved

**Session 1:**
- `TECH-081` → backlog → todo → doing → done

**Session 2:**
- `FEAT-091` → backlog → todo

**Session 3:**
- `FEAT-091` → todo → doing → done

---

## Current State

### In done/ (awaiting release)
- TECH-084: Rename thoughts/ to project-hub/
- TECH-085: Remove examples/ folder
- TECH-086: Align POC folder location with ADR-004
- TECH-081: Setup process improvements
- FEAT-091: Project Roadmap Structure
- DECISION-050: Framework Distribution Model (+ 2 supporting docs)

### In doing/
- (empty)

### In backlog/
- TECH-087: Add project type selection to setup
- FEAT-088: Framework Glossary
- FEAT-089: Project Type Patterns
- FEAT-090: Coding Strategy Patterns
- FEAT-092: Optional Sprint Support

---

## Commits

**Session 1:**
- `de0bb6f` - feat: Create TECH-087 for project type selection in setup
- `618b62c` - feat(TECH-081): Improve setup process with AI guidance and documentation
- `0527f25` - chore: Complete TECH-081, update session history

**Session 2:**
- `731d2bb` - feat: Create four new feature work items from research insights

**Session 3:**
- `ebd12d6` - feat(FEAT-091): Implement project roadmap structure

---

## Next Steps

- 6 work items ready for release in done/
- 5 new features in backlog ready for prioritization
- FEAT-092 (Sprint Support) needs further design discussion
- Roadmap provides strategic framework for future work

---

**Last Updated:** 2026-01-27
