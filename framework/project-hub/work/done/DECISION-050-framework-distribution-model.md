# DECISION-050: Framework Distribution Model (Framework-as-Dependency)

**ID:** DECISION-050
**Type:** Decision
**Priority:** High
**Version Impact:** None
**Created:** 2026-01-12

---

## Context

**Problem:** How should user projects relate to the framework? Should they reference a shared framework (monorepo), or should each project have its own framework copy (framework-as-dependency)?

**Discovery:** During DECISION-036 discussion about template access, we realized the question is much broader than just templates. It applies to the entire framework: templates, process docs, collaboration guides, patterns, etc.

**Current Reality:**
- Framework lives in `framework/` folder
- Projects reference `../framework/` for templates and guidance
- No clear mechanism for framework updates
- Projects are tightly coupled to framework location
- Framework modifications require careful coordination

**Key Insight:** This is a **dependency management problem**, not just a template access problem.

---

## The Framework-as-Dependency Model

Treat the framework like a package dependency (npm, pip, gem):
- Each project gets its own `framework/` copy
- User can update: `Update-Framework.ps1 -Version latest`
- User can customize: Modify local copy, accept ownership
- User can lock version: Stay on known-good version
- Projects are self-contained and portable

**Structure:**
```
my-project/
├── framework/              # Local copy, versioned
│   ├── templates/
│   ├── process/
│   ├── collaboration/
│   ├── patterns/
│   ├── docs/
│   └── .framework-version  # Tracks: v3.0.0
├── src/
├── docs/
└── project-hub/
```

---

## Core Questions from Discussion

### 1. Search Order / Override Strategy

**Question:** If both project-local AND framework files exist, which takes precedence?

**Example:**
- `my-project/framework/templates/FEATURE-TEMPLATE.md` (customized)
- `framework/templates/work-items/FEATURE-TEMPLATE.md` (canonical)

**Options:**
- **A) Project-first (LIFO)** - Check project copy, it overrides framework
  - Standard pattern (CSS, PATH, npm)
  - "Project customizations win"

- **B) Framework-first (FIFO)** - Framework is canonical
  - Unusual pattern
  - "Framework is always source of truth"

**Decision needed:** Which search order? (Recommend: Project-first)

---

### 2. Partial Overrides / Version Drift

**Question:** What happens when user customizes one framework file but wants updates for others?

**Scenarios:**

**Scenario A: User customizes template**
- Copies `FEATURE-TEMPLATE.md` to add custom fields
- Framework updates `FEATURE-TEMPLATE.md` to add new sections
- How does user get improvements without losing customizations?

**Scenario B: User doesn't modify anything**
- Has clean framework copy at v2.5.0
- Framework releases v3.0.0 with improvements
- Should update cleanly (no conflicts)

**Options:**

**Option 1: Accept ownership tradeoff** (simplest)
- If you modify a framework file, you own it
- Document modification with comment: `<!-- Customized from v2.5.0 on 2026-01-12 -->`
- User manually reviews framework updates
- **Pros:** Simple, clear ownership
- **Cons:** Manual merge burden

**Option 2: Version tracking with warnings**
- Track framework version: `.framework-version` file
- Compare against source repository
- Warn: "Framework v3.0.0 available (you have v2.5.0)"
- Still manual merge, but informed
- **Pros:** Visibility into drift
- **Cons:** Requires version infrastructure

**Option 3: File-level checksums**
- Track which files are modified: `.framework-manifest`
- Update script: "3 files modified locally, 12 can auto-update, 2 have conflicts"
- Three-way merge for conflicts
- **Pros:** Smart updates possible
- **Cons:** Complex implementation

**Option 4: Don't copy, extend via config**
- Project has `framework-overrides.yaml`
- Doesn't copy files, just declares overrides
- Always references canonical framework
- **Pros:** No drift, always current
- **Cons:** Complex, limited customization

**Decision needed:** Which override model? (Recommend: Start with Option 1, evolve to Option 2)

---

### 3. Framework Freeze / Export for Archival

**Question:** When a project reaches v1.0 and is "done," should we freeze/bundle the framework for archival?

**Use Case:**
- Project ships v1.0 in 2026
- Framework continues evolving
- Years later, want complete snapshot of project AS IT WAS
- Need to know exact framework version and state

**Options:**

**Option A: Git history is sufficient**
- Project commit abc123 used framework at commit def456
- Git provides complete history
- No special archival needed
- **Pros:** Simple, git does the work
- **Cons:** Assumes git history preserved

**Option B: Version tracking in config**
- `project-config.yaml` tracks: `frameworkVersion: "v3.0.0"`
- Can reconstruct from framework releases
- **Pros:** Lightweight metadata
- **Cons:** Assumes framework releases are preserved

**Option C: Framework export/freeze command**
```powershell
Export-ProjectSnapshot -IncludeFramework
# Creates: project-v1.0.0-snapshot.zip
# Contains: Complete project + framework state
```
- **Pros:** True self-contained archive
- **Cons:** Requires tooling, storage overhead

**Decision needed:** Archival strategy? (Recommend: Option B for now, Option C if needed)

---

## Options for Framework Distribution Model

### Option 1: Framework-as-Dependency (Proposed)

**Each project gets its own framework copy:**

```
project-foo/
├── framework/              # Local copy
│   └── .framework-version  # v3.0.0
├── src/
└── project-hub/

project-bar/
├── framework/              # Separate copy
│   └── .framework-version  # v2.8.0 (older, locked)
├── src/
└── project-hub/
```

**Update mechanism:**
```powershell
# Update to latest
./Update-Framework.ps1 -Version latest

# Update to specific version
./Update-Framework.ps1 -Version v3.0.0

# Check for updates
./Update-Framework.ps1 -Check
# Output: "Framework v3.0.0 available (you have v2.5.0)"
```

**Pros:**
- ✅ Self-contained - No external dependencies
- ✅ Offline capable - Everything in project
- ✅ Customizable - User owns their copy
- ✅ Upgradeable - Can update when ready
- ✅ Stable - Project controls update timing
- ✅ Portable - Zip and go anywhere
- ✅ Simple mental model - "My project has its framework"
- ✅ Version lock - Can stay on known-good version

**Cons:**
- ❌ Duplication - Each project has framework copy
- ❌ Merge conflicts - Customized files need manual merge
- ❌ Storage overhead - Framework duplicated per project
- ❌ Update complexity - Requires merge strategy

**Implementation:**
1. Template packages include `framework/` folder
2. `.framework-version` file tracks version
3. `Update-Framework.ps1` script handles updates
4. Documentation on customization ownership

---

### Option 2: Shared Framework (Current Monorepo)

**All projects reference single framework:**

```
monorepo/
├── framework/          # THE framework
├── project-foo/        # References ../framework/
└── project-bar/        # References ../framework/
```

**Pros:**
- ✅ DRY - Single source of truth
- ✅ Always current - All projects use same version
- ✅ Easy updates - Update once, all benefit
- ✅ Less storage - No duplication

**Cons:**
- ❌ Tight coupling - Projects depend on framework location
- ❌ Not self-contained - Can't move project alone
- ❌ Update coordination - All projects affected by changes
- ❌ Customization hard - Can't easily customize per-project
- ❌ Not portable - Must maintain monorepo structure

---

### Option 3: Hybrid - Copy + Reference

**Projects start with framework copy, can opt to reference shared:**

```
project-foo/
├── framework/          # Local copy (default)
└── .use-shared         # Flag: use ../framework-shared/ instead
```

**Pros:**
- ✅ Flexibility - User chooses model per project
- ✅ Migration path - Can switch between models

**Cons:**
- ❌ Complexity - Two models to support
- ❌ Confusion - Which model am I using?
- ❌ Tooling complexity - Must handle both cases

---

### Option 4: Framework-as-Package (External Distribution)

**Framework hosted separately, installed like dependency:**

```powershell
# Install framework
Install-Framework -Source https://github.com/spearit/framework -Version v3.0.0

# Creates:
my-project/
└── .framework/         # Installed like node_modules
```

**Pros:**
- ✅ True package management
- ✅ Central distribution point
- ✅ Version management built-in

**Cons:**
- ❌ Requires external hosting
- ❌ Internet dependency (for updates)
- ❌ Complex for simple use case
- ❌ Overkill for solo developer

---

## Implications for Current Monorepo

If we adopt **Option 1 (Framework-as-Dependency)**, the current monorepo structure changes:

**Current:**
```
project-framework/
├── framework/              # THE canonical framework
├── examples/hello-world/    # References ../framework/
└── templates/      # Templates for new projects
```

**New:**
```
project-framework/
├── framework/                      # SOURCE framework (for development)
├── examples/hello-world/
│   └── framework/                  # HAS ITS OWN COPY
│       └── .framework-version      # Tracks version
└── templates/
    └── standard/
        └── framework/              # Template includes framework copy
            └── .framework-version  # Set at template creation
```

**Changes:**
1. `examples/hello-world` gets its own `framework/` copy
2. Template packages include `framework/` folder
3. Source `framework/` becomes "upstream" for updates
4. Each project tracks its framework version

---

## Open Questions

### Q1: Version Tracking Mechanism

How do we track which framework version a project has?

**Options:**
- `.framework-version` file containing version string
- `framework/VERSION.md` markdown file
- In `project-config.yaml` (if FEAT-037 implemented)
- Git submodule (tracks commit hash)

**Recommendation:** `.framework-version` file (simple, clear)

### Q2: Update Mechanism - When to Build?

**MVP (now):**
- Manual instructions: "Copy framework/ from latest release"
- Document customization ownership

**v2 (later):**
- `Update-Framework.ps1` script
- Handles clean updates, warns on conflicts

**v3 (future):**
- Smart merge tool
- File checksums
- Conflict resolution UI

**Recommendation:** Start with MVP (documentation), build tooling if usage validates need

### Q3: Framework Exclusions

Should projects copy ENTIRE framework, or exclude certain parts?

**Exclude candidates:**
- `framework/project-hub/` - Framework's own work items
- `framework/project-hub/history/` - Framework's history
- Framework-specific work items (FEAT-026, etc.)

**Keep:**
- `framework/templates/` - Essential
- `framework/process/` - Essential
- `framework/collaboration/` - Essential
- `framework/patterns/` - Useful
- `framework/docs/` - Useful

**Recommendation:** Exclude `framework/project-hub/` (project-specific to framework development)

### Q4: Relationship to FEAT-037 (Project Config)

FEAT-037 proposes `project-config.yaml` for tracking project context. Should it also track framework version?

```yaml
# project-config.yaml
project:
  name: "My Application"
  type: application

framework:
  version: "3.0.0"
  source: "https://github.com/spearit/framework"
  lastUpdated: "2026-01-12"
  customizedFiles:
    - framework/templates/FEATURE-TEMPLATE.md
```

**Recommendation:** Yes, integrate with FEAT-037 if implemented

### Q5: Dogfooding - When to Apply?

Should we immediately refactor this monorepo to use the new model?

**Option A: Immediately**
- Give `examples/hello-world` its own framework copy
- Test the model on ourselves
- Discover issues early

**Option B: After FEAT-025 validation**
- Validate current structure first
- Then migrate to new model
- More stable transition

**Option C: For new projects only**
- Current projects stay as-is
- New projects use framework-as-dependency
- Gradual adoption

**Recommendation:** Option B (after FEAT-025 validation)

### Q6: Breaking Change Impact

This is a **MAJOR** architectural change. What's the migration path for existing projects?

**Migration strategy:**
1. Release framework v3.0.0 with current structure
2. Release v4.0.0 with framework-as-dependency model
3. Provide migration guide
4. Support both models during transition?

**Recommendation:** Treat as MAJOR version, provide migration guide

---

## Decision Criteria

When evaluating options, prioritize:

1. **Self-containment** - Can project work independently?
2. **Simplicity** - Easy for solo developer to understand?
3. **Update path** - Can user get improvements when ready?
4. **Customization** - Can user adapt to their needs?
5. **Portability** - Can project be moved/archived easily?
6. **DRY balance** - Avoid duplication where it matters
7. **Offline capability** - Works without internet?

---

## Recommended Decision

**Adopt Option 1: Framework-as-Dependency**

**Rationale:**
- Aligns with solo developer target audience (self-contained projects)
- Matches established patterns (npm, pip, gem dependency models)
- Solves template access problem (DECISION-036) as side effect
- Enables customization without coordination overhead
- Portable and archival-friendly
- Acceptable tradeoff: Duplication for simplicity

**Implementation path:**
1. Document ownership model (customize = own it)
2. Add `.framework-version` tracking
3. Update template packages to include framework/
4. Provide manual update instructions (MVP)
5. Build `Update-Framework.ps1` if usage validates need
6. Migrate examples/hello-world after FEAT-025 validation

**Start simple, evolve based on usage.**

---

## Impact Analysis

### Blocks
- **DECISION-036** - Template access strategy (resolved by this decision)

### Affects
- **FEAT-025** - Manual setup validation (validates new distribution model)
- **FEAT-037** - Project config (can track framework version)
- **FEAT-005** - ZIP distribution (must include framework copy)
- **FEAT-006** - Interactive setup (must copy framework)

### Requires
- Documentation updates (NEW-PROJECT-CHECKLIST.md, CLAUDE.md)
- Template package restructuring
- Version tracking mechanism
- Update process documentation

---

## Success Metrics

- User can create self-contained project from template
- User can customize framework files without breaking updates
- User can update framework when desired
- Projects are portable (can be zipped and moved)
- Clear ownership model (framework vs project files)

---

## References

- **Origin:** DECISION-036 discussion (2026-01-12)
- **Related:** FEAT-037 (Project config file)
- **Related:** FEAT-025 (Setup validation)
- **Related:** DECISION-036 (Template access - blocked by this)

---

## Notes

**This is a paradigm shift** from "shared framework in monorepo" to "framework as dependency for each project."

**Key insight:** The framework is documentation and process, not code. Treating it like a package dependency gives users control over stability vs. updates.

**Complexity vs. Simplicity:** Start with simple documentation-based approach, build tooling only if needed.

**Dogfooding opportunity:** Applying this to examples/hello-world will validate the model.

---

## DECISION SUMMARY

**Decision:** Adopt Framework-as-Dependency Model (Option 1)

**Key Decisions Made:**

1. ✅ **Distribution Model:** Framework-as-dependency (each project gets own framework/ copy)
2. ✅ **Override Strategy:** Project-first (user customizations take precedence)
3. ✅ **Customization Ownership:** User owns customized files
4. ✅ **Customization Tagging:** Single keyword `CUSTOM` with version and date
   - Format: `<!-- CUSTOM: v{VERSION}, {DATE} -->`
   - File header required for any customized file
   - Section-level tags mark customized sections
5. ✅ **Version Tracking:** `.framework-version` file + `project-config.yaml` integration
6. ✅ **Framework Exclusions:** Exclude `framework/project-hub/` from user copies
7. ✅ **Update Strategy:** Manual (MVP), build tooling later if validated
8. ✅ **Implementation Timing:** After FEAT-025 validates current setup
9. ✅ **Archival Strategy:** Version tracking in config (sufficient)

**Customization Tagging Standard:**

```markdown
<!-- File header (required) -->
<!-- CUSTOM: v3.0.0, 2026-01-12 -->

# Feature: [Feature Name]
...

<!-- Section-level tag -->
## New Section
<!-- CUSTOM: v3.0.0, 2026-01-12 -->
[custom content]

<!-- Inline tag (with closing) -->
## Existing Section
- Original content
<!-- CUSTOM: v3.0.0, 2026-01-12 -->
- Custom addition
<!-- /CUSTOM -->
```

**Rationale:**
- Aligns with solo developer target audience (self-contained projects)
- Matches established dependency patterns (npm, pip, gem)
- Solves template access problem (DECISION-036) as natural consequence
- Enables customization without coordination overhead
- Projects are portable and archival-friendly
- Simple customization tagging (single keyword, minimal overhead)
- Acceptable tradeoff: duplication for simplicity

**Supporting Documents:**
- [Flow Diagrams](DECISION-050-framework-distribution-flow-diagram.md) - Visual explanation of model
- [Customization Example](DECISION-050-customization-example.md) - Tagging examples and options

**Implementation Status (v3.7.0):**

Core implementation completed:
- ✅ `tools/Build-FrameworkArchive.ps1` - Creates distributable zip with framework/
- ✅ `templates/starter/Setup-Project.ps1` - In-place setup from extracted archive
- ✅ `templates/starter/` - Full project scaffolding with framework/ included
- ✅ `.framework-version` tracking - Created by build script
- ✅ Framework exclusions - `framework/project-hub/` excluded from distribution
- ✅ Version auto-detection from PROJECT-STATUS.md
- ✅ Pre-build check for unreleased items in done/

**Follow-on work items:**
- **TECH-085: Remove examples/ folder** - No longer needed with new distribution model
- **FEAT-006: Interactive Setup Script** - Partial implementation, remaining items in backlog
- **FEAT-007: Framework Validation Script** - Includes `-Framework` mode for pre-release validation

**Deferred (build if validated by usage):**
- Update-Framework.ps1 script - MVP is manual update
- Framework Update Test Harness - Future tooling

---

**Last Updated:** 2026-01-26
**Status:** Done - Implementation complete
