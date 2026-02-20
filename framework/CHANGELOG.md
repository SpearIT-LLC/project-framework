# Changelog - SpearIT Project Framework

All notable changes to the SpearIT Project Framework will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

**Project:** SpearIT Project Framework
**Maintainer:** Gary Elliott (gary.elliott@spearit.solutions)
**Organization:** SpearIT, LLC

---

## [Unreleased]

### Added

None

### Changed

None

### Removed

None

### Fixed

None

---

## [5.2.0] - 2026-02-19

### Added

- **FEAT-143: External Dependency Tracking — Blocked/ Workflow**
  - New `project-hub/work/blocked/` folder state for work blocked on external parties
  - Transition rules and metadata schema for blocked items
  - Updated `fw-move` and `fw-status` commands to support blocked state
  - Starter template updated to include `blocked/` scaffold

- **FEAT-141: Move Command — Batch Item Support**
  - Batch move via comma-separated IDs (e.g., `fw-move 140,141 done`)
  - Supports full IDs, bare numbers, and mixed formats
  - Per-item error handling; WIP limit checked once for the batch
  - Backwards compatible with single-item usage

### Changed

- **CHORE-147: Distribution Path Restructuring**
  - Build-FrameworkArchive.ps1 output path updated to `distrib/framework/`
  - `.gitignore` updated; ZIPs now committed as downloadable release artifacts
  - Process doc path references updated to match new structure

- **CHORE-146: fw-session-history Command Sync**
  - Aligned local `fw-session-history` command with plugin version (Senior Technical Writer mindset, directory fallback)

### Removed

None

### Fixed

- **BUG-140: Move Command — Child Item Detection**
  - Fixed inverted grep filter that caused items with dotted IDs (e.g., FEAT-127.4) to fail detection
  - Fix applied to both plugin move commands and fw-move

---

## [5.1.0] - 2026-02-06

### Added

- **FEAT-005: ZIP Distribution Package**
  - Automated ZIP distribution package creation (Build-FrameworkArchive.ps1)
  - Framework-as-dependency distribution model
  - Version tracking in distribution packages (.framework-version)
  - Self-contained distribution with framework and starter template

- **FEAT-006: Interactive Setup Script**
  - Setup-Framework.ps1 - Interactive framework setup script (PowerShell 7+)
  - Automated project initialization with customization
  - Project type selection from framework-schema.yaml
  - Author metadata prompts with git config fallback
  - Transparent display of git config file path when reading author info
  - Edge case enhancements tracked in FEAT-112

### Changed

None

### Removed

None

### Fixed

- **BUG-109: Starter Template project-hub Location**
  - Starter template now has project-hub at repository root
  - Was incorrectly located in framework/project-hub/ from incomplete DECISION-037 migration
  - New projects created with Setup-Framework.ps1 now have correct structure
  - Aligns with DECISION-037 architectural decision
- Build script folder copy operations creating nested folder structures
  - Fixed PowerShell Copy-Item behavior causing framework/docs/docs/ instead of framework/docs/
  - Setup-Framework.ps1 can now find framework-schema.yaml at correct path
  - Affects framework/docs/, framework/templates/, framework/tools/ in distribution archive
- Build script now correctly checks for unreleased items in project-hub/work/done/ (BUG-108)
  - Was checking old location (framework/project-hub/) after DECISION-037 move
- Updated ROADMAP.md to reference correct future location for FEAT-093 (BUG-108)
- Updated claude-hooks-research.md example to use correct project-hub path (BUG-108)
- Removed leftover framework/project-hub/ directory from incomplete DECISION-037 cleanup (BUG-108)

---

## [5.0.0] - 2026-02-05

### BREAKING CHANGES

#### project-hub/ Moved to Repository Root

**Change:** `framework/project-hub/` → `project-hub/`

**Rationale:**
- Separates framework (product) from project management (meta-context)
- Clarifies that project-hub is for the repository, not part of framework package
- Establishes pattern: user projects should have project-hub/ at root
- Improves repository navigation and structure clarity

**Migration for existing users:**

1. Move your project-hub directory:
   ```bash
   git mv framework/project-hub project-hub
   ```

2. Update skill files in `.claude/commands/`:
   - Find: `framework/project-hub/`
   - Replace: `project-hub/`

3. Update any custom scripts/tools that reference the old path

4. Update `CLAUDE.md` structure diagram if present

**Impact:** All skills, documentation, and tools now reference `project-hub/` directly.

**Related:** DECISION-037

---

## [4.1.0] - 2026-02-05

### Added
- **FEAT-088: Framework Glossary**
  - Created GLOSSARY.md in framework/docs/ref/ defining framework terminology
  - 30 terms defined with cross-references to detailed documentation
  - Linked from QUICK-START.md Section 11 (Getting Help)
  - Added to framework/INDEX.md reference documentation section
  - Synced to templates/starter/ for distribution
  - Single source of truth for term definitions

- **FEAT-091: Feature Roadmap Framework**
  - Created /fw-roadmap command for AI-guided strategic planning
  - Interactive questionnaire system for capturing project goals and constraints
  - Automated roadmap generation with themed work items
  - Integration with backlog for roadmap-to-work-item flow

- **FEAT-095: AI Roadmap Questionnaire**
  - Comprehensive questionnaire template for roadmap planning sessions
  - Sections: project goals, constraints, priorities, user needs, technical considerations
  - Captures context for AI-assisted planning
  - Integrated with /fw-roadmap command

- **TECH-061: Framework Commands Reference**
  - Created framework-commands.md in framework/docs/ref/
  - Comprehensive documentation for all /fw-* commands
  - Added to framework/INDEX.md reference documentation section

- **TECH-081: Setup Suggestions and Onboarding Improvements**
  - Enhanced new project onboarding experience
  - Added setup guidance and best practices
  - Improved template documentation

- **TECH-087: Project Type Selection Guidance**
  - Added documentation for selecting appropriate project type
  - Guidance for software vs documentation projects
  - Framework adaptation strategies

- **TECH-094: Workflow Enforcement System**
  - **Three-Layer Enforcement Architecture**
    - Layer 1: Enhanced /fw-move with embedded checklists and mechanical precondition validation
    - Layer 2: Implementation Checklist with step-by-step execution protocol in templates
    - Layer 3: Pre-commit hook validating work items before commits (Claude Code hook)
  - **Pre-Commit Hook** (`.claude/hooks/Validate-WorkItems.ps1`)
    - Validates work items in done/ have Completed date and all criteria checked
    - Only validates staged files (not entire done/ folder)
    - Respects --no-verify for emergency bypasses
    - Catches issues after "## Acceptance Criteria" heading only (ignores Requirements section)
  - **Enhanced /fw-move Skill**
    - Embedded transition checklists directly in command (no references)
    - Verifies preconditions before executing git mv (dependencies, WIP limits)
    - Blocks transitions when requirements not met, offers to fix issues
    - Added "During Implementation" checklist enforcement protocol
  - **Template Enhancements**
    - Added Implementation Checklist with enforcement comment to all work item templates
    - 5 mandatory rules: strict order, immediate marking, stop at each step, re-read file, use TodoWrite
    - User override phrases ("continue to completion", "skip to step N")
  - **Documentation**
    - Added "Workflow Enforcement" section to workflow-guide.md with architecture, behavior, limitations
    - Updated CLAUDE.md Framework Commands section noting enforcement
    - All enforcement layers documented with examples and philosophy
  - **Known Limitation:** Enforcement only applies when Claude performs operations (see TECH-096)
  - **Origin:** FEAT-091 was committed with incomplete metadata - root cause was advisory-only checklists

- **DECISION-105: Retire Multi-Level Framework Concept**
  - Decided to retire "Minimal/Light/Standard" framework levels
  - Unified positioning: "file-based workflow and AI collaboration partner"
  - Rationale: levels caused confusion, didn't match actual usage patterns
  - Implementation via TECH-106

### Changed
- **TECH-106: Remove Multi-Level Framework References**
  - Unified framework positioning following DECISION-105
  - Updated all user-facing documentation with new positioning: "file-based workflow and AI collaboration partner for solo developers and small teams"
  - Removed obsolete "Minimal/Light/Standard" framework levels concept from active documentation
  - Removed "choose your framework level" instructions
  - Updated 15+ files: README.md, QUICK-START.md, CLAUDE.md, INDEX.md, workflow-guide.md, architecture-guide.md, PROJECT-STRUCTURE.md, REPOSITORY-STRUCTURE.md, GLOSSARY.md, templates
  - Historical files preserved unchanged (project-hub/history/)

- **TECH-061: CLAUDE.md Cleanup and Streamlining**
  - Reduced framework/CLAUDE.md from 728 to 500 lines (31% reduction)
  - Added glossary reference at top - establishes GLOSSARY.md as term authority
  - Distilled Checkpoint Policy from 79 to 30 lines - core rule now prominent
  - Externalized Framework Commands to framework-commands.md (130 line savings)
  - Removed outdated "Project Classification & Framework Selection" section (50 line savings)
  - Improved focus on bootstrap-critical vs. reference content
  - All detailed content preserved in appropriate reference locations

### Removed
- **TECH-085: Remove examples/ folder**
  - `examples/hello-world/` folder removed - redundant with framework-as-dependency model
  - Starter template (`templates/starter/`) now serves as the reference
  - Updated documentation references (CLAUDE.md, README.md, QUICK-START.md, etc.)

### Fixed
- **TECH-086: Align POC folder location with ADR-004**
  - Moved `poc/` from project root to `project-hub/poc/` per ADR-004 decision
  - Updated PROJECT-STRUCTURE.md, distribution-build-checklist.md
  - Updated Build-FrameworkArchive.ps1 output text
  - Moved starter template poc folder to correct location

- **TECH-108: Fix Status Field Contradiction**
  - Removed redundant "Status: Done" field requirement from all enforcement layers
  - Aligned with Kanban principle: folder location IS the status
  - Updated workflow-guide.md, fw-move.md, and pre-commit hook
  - Completed date remains (tracks when work finished)
  - Eliminates contradiction between documentation and enforcement

---

## [4.0.0] - 2026-01-26

### Breaking Changes
- **TECH-084: Rename thoughts/ to project-hub/**
  - All `thoughts/` folders renamed to `project-hub/` across framework
  - Clearer naming: "project-hub" indicates central place for project management
  - Affects: documentation, templates, PowerShell scripts, YAML files
  - PowerShell parameter renamed: `ThoughtsPath` → `ProjectHubPath`
  - **Migration:** Rename your `thoughts/` folder to `project-hub/`

- **Removed size-based templates** (minimal/, light/, standard/)
  - Superseded by single `starter/` template with framework-as-dependency model
  - Framework included directly in each project (self-contained, portable)

### Added
- **DECISION-050: Framework Distribution Model (Framework-as-Dependency)**
  - Each project gets its own `framework/` copy - self-contained and portable
  - `tools/Build-FrameworkArchive.ps1` - Creates distributable zip archive
  - `templates/starter/Setup-Project.ps1` - In-place project setup from archive
  - `templates/starter/` - Complete project scaffolding with framework included
  - `.framework-version` file tracks framework version in each project
  - Customization tagging standard (`<!-- CUSTOM: vX.Y.Z, DATE -->`)
  - Pre-build check warns about unreleased items in done/

- **FEAT-052: Task-Based Project Templates** (backlog)
  - Concept for future: workflow rigor based on project type, not size
  - Examples: Quick Script, Feature Enhancement, New Application, Research/Spike

### Changed
- Simplified `templates/` folder - now contains only `starter/` and setup guides
- Updated root CLAUDE.md with new template references
- Removed obsolete `templates/standard/` sync references from 11 backlog items

### Removed
- `templates/minimal/` - Use starter/ template instead
- `templates/light/` - Use starter/ template instead
- `templates/standard/` - Use starter/ template instead
- `templates/README-TEMPLATE-SELECTION.md` - No longer needed
- `templates/UPGRADE-PATH.md` - No longer needed
- `templates/STRUCTURE.md` - No longer needed

---

## [3.6.0] - 2026-01-26

### Added
- **FEAT-025: Manual Setup Process Validation**
  - Comprehensive testing of Standard template (18 work items, 6 releases in test project)
  - Created `distribution-build-checklist.md` for template package builds
  - Added `poc/` folder with README to Standard template (now required, not optional)
  - Updated NEW-PROJECT-CHECKLIST.md with tools, commands, troubleshooting sections
  - Documented 14 follow-on work items (TECH-068 to TECH-081) for discovered gaps

- **FEAT-031: Source-of-Truth Topic Registry**
  - Central registry tracking authoritative sources for framework topics
  - Prevents documentation drift and duplicate content

- **TECH-074: Include fw- Commands and Tools in Template**
  - Added `.claude/commands/` folder with all 8 fw- commands to Standard template
  - Added `framework/tools/` with 7 PowerShell scripts (.ps1, .psm1) to Standard template
  - New projects now have full workflow automation support out of the box

- **TECH-068: Document WIP Limit Flexibility**
  - Pause & Resume pattern (recommended default)
  - Temporary WIP Bump pattern with guardrails
  - Added WIP Limit Flexibility section to workflow-guide.md

- **TECH-069: Document Work Item Cancellation Process**
  - Cancellation vs deprioritization guidance
  - Required cancellation metadata (Status, Date, Reason)
  - Archive path: `history/archive/`

### Changed
- **TECH-036: Documentation DRY Audit and Remediation**
  - Audited framework documentation for duplicate content
  - Consolidated overlapping guidance

- **TECH-066: Migrate Existing Work Items to New Metadata Standard**
  - Updated existing work items to use standard 5 metadata fields
  - Consistent formatting across all work item types

- **TECH-075: Reconcile Spike Workflow vs Transition Matrix**
  - Consolidated spike workflow to use `poc/` folder consistently
  - Removed contradictory `backlog/` references for spikes

- **TECH-076: Consolidate Workflow Transition Checklists**
  - Unified enforcement prompts in workflow transitions
  - Clearer checklist formatting

- Updated PROJECT-STRUCTURE.md to include `poc/` as required folder
- Updated `.gitkeep` count from 6 to 7 (added `poc/.gitkeep`)

### Known Gaps (tracked in backlog)
- Session history template not yet created (TECH-072)
- External reference template not yet created (TECH-073)

---

## [3.5.0] - 2026-01-20

### Added
- **FEAT-022: Automated Session History Generation**
  - `/fw-session-history` slash command for capturing session work
  - Auto-update session history when moving items to done/
  - Auto-commit after done-transition
  - Standard session history format in `project-hub/history/sessions/`

- **FEAT-060: Framework Bootstrap Block**
  - Bootstrap block in root CLAUDE.md for session initialization
  - Numbered checklist format for AI assistants
  - Ensures consistent session startup behavior

- **FEAT-062: POC Folder and Spike Workflow**
  - `project-hub/poc/` folder for proof-of-concept experiments
  - Two spike workflow types: research (document-only) and POC (with artifacts)
  - Archive path: `history/spikes/` for completed spikes
  - Updated Get-WorkflowStatus.ps1 to show POC spikes section
  - Artifact retention policy in ADR-004

- **TECH-046: Work Item ID Discovery Policy**
  - Common ID namespace documented (all types share single counter)
  - `Get-NextWorkItemId` PowerShell function in FrameworkWorkflow.psm1
  - `Get-NextWorkItemId.ps1` standalone script
  - `/fw-next-id` slash command for AI assistants
  - Windows PowerShell 5.1 compatibility (not just pwsh)

### Changed
- **TECH-064: Standardize Work Item Metadata Fields**
  - 5 work item types: Feature, Bug, Tech Debt, Decision, Spike
  - Status determined by folder location, not metadata field
  - BUGFIX → BUG normalization in PowerShell tools
  - Updated workflow-guide.md with standard metadata fields section
  - Fixed single-item array bug in Get-WorkflowStatus.ps1

- **TECH-065: Simplify PROJECT-STATUS.md**
  - Reduced from 390 lines to 20 lines (95% reduction)
  - Ultra-minimal format: version, status, quick links, maintainer
  - README.md is authoritative for feature list (DRY principle)
  - CHANGELOG.md is authoritative for release history

### Documentation
- workflow-guide.md updated to v1.2.0 with:
  - POC spike workflow documentation
  - ID discovery section ("Finding Next Available ID")
  - Standard metadata fields section
  - Session history automation notes

### Notes
This release focuses on workflow automation and tooling improvements. The `/fw-*` command set is now more complete with session history and ID discovery capabilities.

---

## [3.4.0] - 2026-01-19

### Added
- **FEAT-018: Claude Command Framework (`/fw-*` commands)**
  - Standardized command structure for workflow operations
  - Command registry in CLAUDE.md with `/fw-` prefix convention
  - `/fw-help` - Discover available framework commands
  - `/fw-move` - Move work items with policy enforcement (validates transitions, uses git mv, checks WIP limits)
  - `/fw-status` - Show project status summary (version, workflow counts, items in progress)
  - `/fw-wip` - Check WIP limit status and current work items
  - `/fw-backlog` - Review and prioritize backlog items
  - PowerShell tooling: `Get-BacklogItems.ps1`, `Get-WorkflowStatus.ps1`, `Move-WorkItem.ps1`
  - Shared module infrastructure in `framework/tools/FrameworkLib/`

- **DOC-063: README Update in Release Process**
  - Added explicit README.md review step to release process
  - Ensures user-facing documentation reflects released capabilities

### Documentation
- Updated workflow-guide.md with README update step in release process
- Updated CLAUDE.md Step 9 with README check reference

### Notes
This release completes the Claude Command Framework (FEAT-018), providing standardized slash commands for framework operations. The framework now supports both AI-driven commands and PowerShell tooling for workflow automation.

---

## [3.3.0] - 2026-01-19

### Added
- **FEAT-037: Project Configuration File (framework.yaml)**
  - Machine-readable project configuration for AI assistants and tooling
  - Defines project metadata (name, type, deliverable)
  - References workflow policies and documentation
  - Enables consistent project context across sessions
  - Schema validation via `framework-schema.yaml`

- **FEAT-052: Framework YAML Validation Script**
  - PowerShell script to validate `framework.yaml` against schema
  - CI-friendly automation for configuration validation
  - Located at `framework/scripts/Validate-FrameworkYaml.ps1`

- **FEAT-059: Context-Aware AI Roles System**
  - 13 base roles organized into 6 families (Creation, Validation, Governance, Strategy, Operations, Perspective)
  - Role definitions file (`framework/docs/ref/framework-roles.yaml`)
  - Experience tiers (mid-level, senior) with distinct mindsets
  - `requires_context` field for roles needing domain clarification
  - `triggers` field for variant activation hints
  - Explicit role activation: "Adopt the scrum master role"
  - Default role configuration in `framework.yaml`
  - **Known limitation:** AI doesn't proactively ask about work context at session start

- **DOC-058: Workflow Transitions Documentation**
  - Comprehensive state transition rules in workflow-guide.md
  - Valid/invalid transition matrix with rationale
  - Per-transition checklists and procedures
  - Machine-readable policy reference via `framework.yaml`

- **New directory: `framework/docs/ref/`**
  - Reference material location for structured YAML definitions
  - Contains `framework-schema.yaml` and `framework-roles.yaml`

### Changed
- **TECH-056: Consolidate Workflow Documentation**
  - Deleted redundant `kanban-workflow.md` (content in workflow-guide.md)
  - Clarified relationship between workflow-guide.md and version-control-workflow.md
  - Reduced documentation duplication

- **TECH-043: DRY Documentation Principles**
  - Established single-source-of-truth policy for documentation
  - Documented information hierarchy and reference patterns
  - Guidelines for avoiding content duplication

### Documentation
- Updated README.md with framework.yaml and docs/ref/ in structure tree
- Added AI roles feature to AI Integration section
- Updated Framework Structure diagram

### Notes
This release contains 6 work items grouped together, establishing the foundation for AI-aware project configuration and role-based assistance.

---

## [3.2.0] - 2026-01-13

### Changed
- **REFACTOR-052: Adopt Industry-Standard Repository Structure**
  - Renamed `project-hello-world/` → `examples/hello-world/` (aligns with npm/pip/bundler conventions)
  - Renamed `project-templates/` → `templates/` (removes redundant prefix)
  - Updated terminology: "framework source repository" replaces "monorepo"
  - Updated all Tier 1 (critical navigation) and Tier 2 (active work items) documentation
  - Tier 3 work items (backlog/todo/done) will be updated incrementally as touched
  - See research: [project-hub/research/package-ecosystem-terminology-patterns.md](project-hub/research/package-ecosystem-terminology-patterns.md)
  - **Migration Note:** If referencing old paths in external docs, update to new structure

### Added
- **FEAT-039: Verify Hello-World Compliance**
  - Validated examples/hello-world/ against PROJECT-STRUCTURE.md
  - Comprehensive audit of all required files, folders, and structure
  - Validation report confirms 100% compliance with Standard Framework specification
  - Establishes hello-world as verified reference implementation
  - Informs FEAT-025 scope (Standard level validation already complete)

### Documentation
- **DOC-053: Document Claude Code Temporary File Configuration**
  - Added guidance about `tmpclaude-*` temporary files in NEW-PROJECT-CHECKLIST.md
  - Added troubleshooting section in collaboration/troubleshooting-guide.md
  - Documented `CLAUDE_CODE_TMPDIR` environment variable configuration option
  - Clarified .gitignore already prevents git tracking (added in REFACTOR-052)

### Notes
This release contains 3 work items grouped together: major refactoring (REFACTOR-052), validation work (FEAT-039), and user documentation (DOC-053).

---

## [3.1.0] - 2026-01-11

### Added
- **FEAT-032: Support Multiple Work Items Per Release**
  - Documented grouped release process in workflow-guide.md
  - Version bumping strategy for grouped releases (highest impact wins)
  - CHANGELOG format guidance for multiple items per release
  - Release folder structure examples and guidelines
  - Updated CLAUDE.md Step 9 with grouped release support
  - Both single and grouped release patterns now supported

### Changed
- **DECISION-042: Work Item ID Definition and Reference System**
  - Clarified ID as unique sequential counter (001, 002, 003...)
  - Type prefix (FEAT-, TECH-, etc.) is organizational metadata, not part of ID
  - Both reference forms valid: "042" (canonical) or "FEAT-042" (convenience)
  - Updated kanban-workflow.md with clear ID specification
  - Updated all work item templates to use canonical format (**ID:** NNN)
  - Existing work items remain valid (no retrospective changes)

### Fixed
- **FEAT-040: Framework Structure Compliance Fixes**
  - Fixed 4 issues in framework/ folder structure
  - Moved CLAUDE.md from docs/ to correct location (framework root)
  - Renamed collaboration/ to docs/collaboration/ per standard
  - Fixed process/ folder location (framework/docs/process/)
  - Ensured framework dogfoods own structure standard

### Notes
This release contains 3 work items grouped together.

---

## [3.0.1] - 2026-01-11

### Fixed
- **FEAT-038: Update All v3.0.0 Path References**
  - Updated 10 files with v3.0.0 structure path references
  - Process documentation: kanban-workflow.md, workflow-guide.md, troubleshooting-guide.md, architecture-guide.md
  - Templates: CLAUDE-TEMPLATE.md, INDEX-TEMPLATE.md, PROJECT-STATUS-TEMPLATE.md, README-TEMPLATE.md, PROJECT-DEFINITION-TEMPLATE.md
  - NEW-PROJECT-CHECKLIST.md updated to v3.0.0
  - All references changed: project-hub/project/planning/ → project-hub/work/
  - Fixed template package path: project-framework-template/ → templates/
  - Removed 4-level structure references (now 3-level)
  - Aligned all documentation with PROJECT-STRUCTURE.md

---

## [3.0.0] - 2026-01-08

### BREAKING CHANGES
- **FEAT-026: Framework Structure Migration**
  - Reorganized repository into multi-project structure
  - Framework content moved from root to `framework/` folder
  - Users must update all references to framework files
  - Project structure completely redesigned

### Added
- **Multi-Project Repository Structure**
  - Created `framework/` folder for framework project
  - Created `examples/hello-world/` reference implementation
  - Root-level `QUICK-START.md` for navigation
  - Root-level `CLAUDE.md` for repository navigation
- **Universal Structure Definitions**
  - `framework/docs/PROJECT-STRUCTURE.md` - Definitive project structure specification
  - `framework/docs/REPOSITORY-STRUCTURE.md` - Repository root structure specification
  - `framework/project-hub/research/README.md` - Research folder purpose documentation
- **Idea Collection Pattern**
  - Established pattern for idea collections in research/ folder
  - Documented lifecycle and workflow in FEAT-026-sub-item-strategy.md
  - Updated structure documentation to include idea collections

### Changed
- **Framework Dogfooding Complete**
  - Framework now fully applies its own Standard structure
  - All framework documentation in framework/
  - Framework uses its own templates, process, and workflow
- **Flattened Folder Structure**
  - Removed `project-hub/project/planning/` level
  - Moved `planning/backlog/` to `work/backlog/`
  - Reduced nesting from 4 levels to 3 levels maximum
- **Template Reorganization**
  - Categorized 19 templates into subfolders
  - Created: work-items/, decisions/, research/, documentation/, project/, wrappers/
  - Easier navigation and clearer organization
- **Collaboration Guides Location**
  - Moved from `project-hub/project/collaboration/` to `framework/collaboration/`
  - Now recognized as universal guides, not project-specific

### Fixed
- **P1 Critical Bugs (5 fixed)**
  - Root CLAUDE.md missing (created at repository root)
  - Invalid file path references throughout documentation
  - Framework structure didn't match project standard
  - Quick-start content separation unclear
  - Framework folder naming inconsistent
- **P2 High Priority Issues (6 fixed)**
  - Removed enterprise/large-team references (not applicable yet)
  - Removed fake/placeholder numbers from documentation
  - Cleaned up CLAUDE.md (removed stale references)
  - Aligned step counts across documentation (9 vs 11 steps)
  - Simplified workflow documentation (reduced duplication)
  - Fixed version references (removed outdated version numbers)

### Documentation
- Created comprehensive migration documentation in FEAT-026 work items
- Documented 14 major structure decisions in FEAT-026-universal-structure-decisions.md
- Created collision analysis and validation reports
- Established sub-item strategy for complex features
- Documented process improvements (co-location principle, idea collections)

### Migration Notes
- This is a BREAKING CHANGE - repository structure completely reorganized
- All paths to framework files have changed
- Users with existing projects are not affected (framework is copied, not referenced)
- This reorganization positions the framework for future growth and clarity

---

## [2.2.5] - 2026-01-01

### Fixed
- **BUGFIX-006: Stale Target Version Metadata in Work Item Templates**
  - Removed "Target Version" field from work item templates (FEATURE-TEMPLATE.md, BUGFIX-TEMPLATE.md)
  - Field became stale when items sat in backlog while other releases incremented version
  - Version now calculated at release time (Step 9) from PROJECT-STATUS.md + Version Impact
  - Eliminates confusion about version authority and stale metadata

### Added
- **Versioning & Releases Section** (workflow-guide.md lines 821-903)
  - Comprehensive 83-line section documenting version calculation process
  - Explicit formulas for PATCH, MINOR, MAJOR version increments
  - Step 9 version calculation process with 5 steps
  - Edge cases: multiple work items, user overrides, pre-release versions
  - Rationale for calculating at release time vs storing target version

### Changed
- **CLAUDE.md Step 9**: Added brief version calculation bullet
  - "Calculate next version: Read PROJECT-STATUS.md current version + work item Version Impact, calculate next version (PATCH increments patch, MINOR increments minor/resets patch, MAJOR increments major/resets minor+patch), confirm with user before proceeding"
- **CLAUDE.md Streamlined**: Removed redundant "Workflow Phases Quick Reference" section (17 lines)
  - Already detailed in workflow-guide.md "Development Workflow Phases" section
  - Keeps CLAUDE.md lean while maintaining functionality

---

## [2.2.4] - 2026-01-01

### Fixed
- **BUGFIX-005: Missing Pre-Implementation Review Checkpoint**
  - Added explicit Step 7.5 (Pre-Implementation Review) checkpoint between moving to doing/ and implementation
  - AI now reads complete work item, identifies open questions, and confirms approach before implementing
  - Prevents starting implementation with stale context or unresolved design decisions
  - Updated workflow from 10 steps to 11 steps

### Added
- **Pre-Implementation Review Guidance** (workflow-guide.md)
  - Comprehensive 77-line section on how to perform Step 7.5
  - Details on identifying open questions (TODO, TBD, Option A/B/C patterns)
  - Standard presentation format for confirming approach with user
  - Complements Step 8.5 (post-implementation review) for complete coverage
- **Universal Documentation Update Principle** (workflow-guide.md)
  - Establishes rule: Always update master documentation BEFORE derived summaries
  - Documents 4 common hierarchies: collaboration/* → CLAUDE.md, PROJECT-STATUS.md → README.md, ADRs → implementation docs, Templates → instances
  - Provides concrete examples and rationale
  - Applies universally across all framework documentation

### Changed
- CLAUDE.md: AI Workflow Checkpoint Policy updated with Step 7.5
- CLAUDE.md: "What NOT to Do" section now references all three checkpoints (Step 4, 7.5, 8.5)
- CLAUDE.md: "Rationale" section includes Step 7.5 benefits
- Step 8 now references "(as confirmed in Step 7.5)"
- Workflow now has three checkpoints providing complete coverage: before implementation (Step 4), before coding (Step 7.5), before release (Step 8.5)

---

## [2.2.3] - 2026-01-01

### Fixed
- **BUGFIX-002: Missing Review Step in AI Workflow Checkpoint Policy**
  - Added explicit Step 8.5 (Review & Approval) checkpoint between implementation and release
  - AI now presents completed work for user review before moving to done/
  - Prevents premature release of work without user approval
  - Updated workflow from 9 steps to 10 steps

### Changed
- CLAUDE.md: AI Workflow Checkpoint Policy updated with Step 8.5
- Step 9 now requires work to be "done, tested, AND APPROVED"
- Updated "What NOT to Do" section to reference both approval checkpoints (Step 4 and Step 8.5)
- Updated "Rationale" section to include review checkpoint benefits

---

## [2.2.2] - 2025-12-31

### Added
- **FEAT-023: Comprehensive Permission Patterns**
  - Configured `.claude/settings.local.json` with non-destructive operation permissions
  - Allows all read operations (Read, Glob, Grep, Task tools) without approval prompts
  - Allows safe Bash commands (ls, cat, pwd, git status)
  - Includes deny patterns for documentation purposes (.env, secrets/, credentials, etc.)
  - Demonstrates security-conscious permission configuration for AI assistants
  - Eliminates approval prompts for routine read operations
- **Security: .gitignore for Sensitive Files**
  - Created comprehensive .gitignore covering environment variables, secrets, credentials
  - Includes cloud provider configs (.aws/, .azure/, .gcloud/)
  - Covers IDE files, OS files, and temporary files
  - Primary security mechanism (deny rules are informational)
- **Documentation: Claude Code Permissions Section in CLAUDE.md**
  - Added "Claude Code Permissions" quick reference in Emergency Reference section
  - Documents allowed tools and security approach
  - Points to configuration location

---

## [2.2.1] - 2025-12-31

### Fixed
- **BUGFIX-001: Work Item Number Collision Risk**
  - AI numbering logic now scans ALL locations (backlog, todo, doing, done, releases/*/)
  - Previously only scanned backlog/, causing collision risk when items moved or archived
  - Prevents duplicate work item IDs across full lifecycle
  - Handles both uppercase (FEAT-) and lowercase (feature-) naming conventions

### Added
- **Work Item Numbering Documentation** (workflow-guide.md)
  - Comprehensive "Work Item Numbering" section with find command examples
  - Hierarchical numbering guidance (FEAT-020.1, FEAT-020.2)
  - Number exhaustion handling (999 → 1000)
  - When to use hierarchical vs. separate numbering

### Changed
- **CLAUDE.md AI Workflow Checkpoint Policy**
  - Step 3 now references workflow-guide.md for work item numbering
  - Keeps CLAUDE.md concise, delegates details to collaboration docs

---

## [2.2.0] - 2025-12-29

### Added
- **Test Type Taxonomy** (ADR-002)
  - Three-dimensional test classification system
  - Dimension 1: Test Subject (Process vs Implementation)
  - Dimension 2: Traditional Type (Functional/Non-Functional/QA)
  - Dimension 3: Automation Level (Automated/Manual/Hybrid)
  - AI guidance for detecting ambiguous test types
  - Supports all test scenarios (Performance, Security, UAT, Unit, Integration, E2E)
- **Testing Plan Template** (TESTING-PLAN-TEMPLATE.md)
  - Universal test plan template with test type taxonomy
  - Test type classification section referencing ADR-002
  - AI guidance notes for handling ambiguous tests
  - Complete test execution protocol

### Changed
- **CLAUDE.md AI Reading Protocol** enhanced
  - Added "Resuming work or checking status" guidance
  - AI must check work item completion status before suggesting next actions
  - Decision tree includes work-in-progress verification

### Fixed
- **Test 0.0 failure** - AI context awareness when resuming work
  - AI now reads work items in doing/ to verify completion status
  - Prevents suggesting actions without understanding current work state

### Testing
- **FEAT-020 Testing Complete** - 10/11 tests passed (90.9%)
  - Validated AI Reading Protocol effectiveness
  - Validated documentation hierarchy understanding
  - Validated complete workflow integration
  - Identified and fixed critical context awareness gap

---

## [2.1.0] - 2025-12-20

### Added
- **Framework Quick Reference Guide** (QUICK-REFERENCE.md)
  - Bare-bones, get-functional guide for rapid onboarding
  - Covers all framework levels with quick setup commands
  - Decision tree for framework selection (30 seconds)
  - Common operations cheat sheet
  - Templates quick reference
  - Essential links with time estimates
- **ADR-001: AI Workflow Checkpoint Policy**
  - Mandatory user approval checkpoint before feature implementation
  - Explicit workflow: User Request → Backlog → [CHECKPOINT] → Todo → Doing → Done
  - Prevents runaway AI implementation
  - 9-step process documented in CLAUDE.md
- **AI Workflow Checkpoint Policy** section in CLAUDE.md
  - Explicit step-by-step process for AI feature requests
  - Example interactions
  - "What NOT to Do" checklist
  - Enforces framework workflow compliance
- **Retrospective system** for dogfooding learnings
  - project-hub/project/retrospectives/ directory
  - 2025-12-20-workflow-enforcement-retrospective.md documenting FEAT-016 incident
- **Planned features** (documented in backlog, not implemented)
  - FEAT-017: Backlog Review Command (/backlog-review)
  - FEAT-018: Claude Command Framework

### Changed
- INDEX.md - Added quick reference to "Quick Links" section
- README.md - Added quick reference link in "Quick Start" section

### Process Improvements
- FEAT-016 moved to work/done/ (retroactive workflow compliance)
- Established pattern: "Fix the process, not just the instance"
- Dogfooding validation: Framework successfully using its own Standard level

---

## [2.0.0] - 2025-12-19

### Added
- **Dogfooding:** Framework now uses its own Standard framework for development
- PROJECT-STATUS.md for framework project (single source of truth for version)
- CHANGELOG.md for framework project version history
- INDEX.md for framework project documentation navigation
- project-hub/project/ structure for framework development (kanban workflow)
- project-hub/project/reference/version-strategy.md - Version strategy documentation
- project-framework-template/README.md - Package overview with migration notes

### Changed
- **BREAKING:** Removed legacy root templates from project-framework-template/
  - Removed duplicate README.md, CLAUDE.md, PROJECT-STATUS.md, CHANGELOG.md, INDEX.md, project-hub/
  - Templates now exclusively in framework-level folders (minimal/, light/, standard/)
  - Guide documents remain at package root
- Updated README.md with comprehensive project overview
- Updated STRUCTURE.md to remove legacy template references

### Previous v2.0.0 Changes

### Added
- **Multi-level framework system** - Minimal, Light, Standard
- **Framework selection guide** (README-TEMPLATE-SELECTION.md) - 3-dimension classification
- **Setup checklists** (NEW-PROJECT-CHECKLIST.md) - All levels with phase-by-phase instructions
- **Upgrade paths** (UPGRADE-PATH.md) - Migration guides between framework levels
- **Structure documentation** (STRUCTURE.md) - Complete template structure reference
- **Research phase templates** (5 templates):
  - PROBLEM-STATEMENT-TEMPLATE.md
  - LANDSCAPE-ANALYSIS-TEMPLATE.md
  - FEASIBILITY-TEMPLATE.md
  - PROJECT-JUSTIFICATION-TEMPLATE.md
  - PROJECT-DEFINITION-TEMPLATE.md
- **Minimal framework template** - 2 files for single scripts
- **Light framework template** - 7 files for small tools
- **Standard framework template** - 50+ files for applications
- WIP limit configuration files (.limit) in kanban folders

### Changed
- **BREAKING:** Reorganized template structure into framework levels (minimal/, light/, standard/)
- **BREAKING:** Root-level templates marked as legacy (deprecated)
- NEW-PROJECT-CHECKLIST.md updated with Phase 0 (framework selection)
- NEW-PROJECT-CHECKLIST.md restructured by framework level
- Version numbering updated to v2.0.0 across core documents

### Fixed
- Template file naming consistency (removed TEMPLATE- prefix from wrappers)
- Documentation cross-references between templates

### Deprecated
- Root-level templates in project-framework-template/ (use level-specific folders instead)

---

## [1.0.0] - 2025-12-18

### Added
- Initial framework template package extracted from HPC Job Queue Prototype
- Core documentation templates:
  - README-TEMPLATE.md
  - PROJECT-STATUS-TEMPLATE.md
  - CHANGELOG-TEMPLATE.md
  - INDEX-TEMPLATE.md
  - CLAUDE-TEMPLATE.md
- Work item templates:
  - FEATURE-TEMPLATE.md
  - BUGFIX-TEMPLATE.md
  - BLOCKER-TEMPLATE.md
  - SPIKE-TEMPLATE.md
- Decision templates:
  - ADR-MAJOR-TEMPLATE.md
  - ADR-MINOR-TEMPLATE.md
- Quick start templates:
  - USER-QUICK-START-TEMPLATE.md
  - ADMIN-QUICK-START-TEMPLATE.md
- CMD wrapper templates (4 variants):
  - WRAPPER.cmd (basic)
  - WRAPPER-ENHANCED.cmd (recommended)
  - WRAPPER-PS7.cmd (PowerShell 7 preferred)
  - WRAPPER-ADMIN.cmd (administrator required)
- Process documentation:
  - kanban-workflow.md
  - version-control-workflow.md
  - documentation-standards.md
- Pattern documentation:
  - powershell-modules.md
  - config-management.md
  - cmd-wrappers.md
- Complete project-hub/ folder structure
- File-based kanban workflow (todo/doing/done)
- WIP limits (doing=1, todo=10)
- Generic CLAUDE.md for framework guidelines
- Project-specific CLAUDE.md template
- README.md for template package
- LICENSE file

### Documentation
- NEW-PROJECT-CHECKLIST.md for greenfield and existing project setup
- Template structure documentation
- Wrapper template README with usage examples

---

## [0.1.0] - 2025-11-25 (Approximate)

### Added
- Initial extraction of framework patterns from HPC project
- Basic template structure
- CMD wrapper patterns
- Process documentation drafts

### Notes
- This version represents the framework as it existed within HPC project before extraction
- Exact date approximate based on HPC project history

---

## Version Strategy

### Framework Versioning
- **Framework version** (this file): Tracks overall framework release version
- **Current framework version:** v2.0.0

### Template Versioning
- Individual templates may track their own versions for significant changes
- Templates inherit framework version unless independently versioned
- Document versions tracked in "Last Updated" field in each file

### Semantic Versioning
- **Major (X.0.0):** Breaking changes, incompatible structure changes
- **Minor (x.Y.0):** New features, templates, or levels added
- **Patch (x.y.Z):** Bug fixes, documentation improvements, clarifications

### Examples
- v1.0.0 → v2.0.0: Multi-level framework system (breaking structure change)
- v2.0.0 → v2.1.0: Added distribution packaging and setup scripts (new features)
- v2.1.0 → v2.1.1: Fixed typos in templates (patch)

---

## Migration Notes

### Upgrading from v1.0.0 to v2.0.0

**Breaking Changes:**
- Template files moved from root to framework-level folders (minimal/, light/, standard/)
- If you copied v1.0.0 templates, they still work but are considered legacy
- NEW-PROJECT-CHECKLIST.md has new Phase 0 for framework selection

**Migration Steps:**
1. If using old templates, continue using them (no forced migration)
2. For new projects, use appropriate framework level folder
3. For existing projects, follow "Existing Project Integration" in NEW-PROJECT-CHECKLIST.md
4. Review UPGRADE-PATH.md for guidance between framework levels

**Recommendation:**
- Existing projects: No immediate action required
- New projects: Use framework-level folders (minimal/, light/, standard/)

---

## Links

- [Framework Repository](https://github.com/SpearIT-LLC/project-framework) *(if applicable)*
- [Issue Tracker](https://github.com/SpearIT-LLC/project-framework/issues) *(if applicable)*
- [HPC Job Queue Prototype](../HPCJobQueuePrototype/) *(original source project)*

---

**Maintained by:** Gary Elliott (gary.elliott@spearit.solutions)
**Last Updated:** 2025-12-19
