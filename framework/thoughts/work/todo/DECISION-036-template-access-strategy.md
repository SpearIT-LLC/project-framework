# DECISION-036: Template Access Strategy for User Projects

**Status:** Proposed
**Date:** 2026-01-10
**Deciders:** TBD
**Impact:** Minor
**Scope:** User project setup, template access workflow
**Supersedes:** None

---

## Context

**Problem:** Users creating new projects need access to framework templates (FEATURE-TEMPLATE.md, BUGFIX-TEMPLATE.md, ADR templates, etc.) to create work items, but the current structure doesn't clearly define how they access these templates.

**Current Reality:**
- Framework templates are in `framework/templates/` (organized by category)
- User projects DO NOT have `thoughts/framework/templates/` after setup
- NEW-PROJECT-CHECKLIST.md references template copying but paths are unclear/incorrect
- FEAT-025 discovered this as a critical validation issue

**Key Questions:**
1. How do users access framework templates when creating work items?
2. Should templates be copied to user projects during setup?
3. Should users reference framework templates externally?
4. What's the balance between self-containment and DRY?

**Use Cases:**
- User creates new feature work item, needs FEATURE-TEMPLATE.md
- User documents architectural decision, needs ADR-MAJOR-TEMPLATE.md
- User creates bugfix, needs BUGFIX-TEMPLATE.md
- User wants to update to newer template versions

**Constraints:**
- User projects should be self-contained (ideally)
- Template updates should be easy to propagate
- Setup process should be simple
- DRY principle favors single source of truth

---

## Options

### Option 1: Copy All Templates to User Projects

**Approach:**
- During setup, copy entire `framework/templates/` to user project
- Location: `templates/` at project root
- Users have local copy of all templates
- Users copy from local templates/ folder to create work items

**Structure:**
```
my-project/
├── templates/           # Copied from framework/templates/
│   ├── work-items/
│   │   ├── FEATURE-TEMPLATE.md
│   │   ├── BUGFIX-TEMPLATE.md
│   │   └── ...
│   ├── decisions/
│   │   ├── ADR-MAJOR-TEMPLATE.md
│   │   └── ADR-MINOR-TEMPLATE.md
│   └── documentation/
│       └── ...
└── thoughts/
    └── work/
        └── backlog/
            └── FEAT-001-new-feature.md  # Copied from templates/work-items/
```

**Pros:**
- ✅ Self-contained - Project has everything it needs
- ✅ Offline access - No external dependencies
- ✅ Familiar location - `templates/` is intuitive
- ✅ Simple for users - Just copy from local templates/

**Cons:**
- ❌ Duplication - Every project has template copies
- ❌ Version drift - Template updates don't reach existing projects
- ❌ Larger project size - Templates add ~50KB per project
- ❌ Outdated templates - Users may use old template versions
- ❌ Template management - Users must manually update templates

**Implementation:**
- Add `templates/` copy step to NEW-PROJECT-CHECKLIST.md
- Update template packages to include templates/ folder
- Document template usage in project CLAUDE.md

---

### Option 2: Reference Framework Templates Externally

**Approach:**
- User projects do NOT copy templates
- Users reference `../framework/templates/` (if monorepo) or keep separate framework reference
- Templates remain in framework project only
- Users copy from external framework location

**Structure:**
```
my-project/
├── thoughts/
│   └── work/
│       └── backlog/
│           └── FEAT-001-new-feature.md  # Copied from ../framework/templates/
└── [No templates/ folder]

# Users copy from:
# - Monorepo: ../framework/templates/work-items/FEATURE-TEMPLATE.md
# - Separate: /path/to/framework-reference/templates/work-items/FEATURE-TEMPLATE.md
```

**Pros:**
- ✅ Single source of truth - Templates in one place
- ✅ Easy updates - Update framework, all users benefit
- ✅ DRY - No duplication across projects
- ✅ Smaller project size - No template copies
- ✅ Always current - Users always use latest templates

**Cons:**
- ❌ External dependency - Requires framework reference
- ❌ Not self-contained - Projects depend on external files
- ❌ Path complexity - Users must know correct relative/absolute paths
- ❌ Monorepo assumption - Works best in monorepo structure
- ❌ Offline issues - Need framework reference available

**Implementation:**
- Document framework reference location in CLAUDE.md
- NEW-PROJECT-CHECKLIST.md explains how to access framework templates
- Users maintain framework reference copy separately (if not monorepo)

---

### Option 3: Minimal Template Set in User Projects

**Approach:**
- Copy only most common templates to user project
- Advanced/specialized templates referenced from framework
- Balance between self-containment and DRY

**Structure:**
```
my-project/
├── templates/           # Minimal set only
│   ├── FEATURE-TEMPLATE.md      # Common
│   ├── BUGFIX-TEMPLATE.md       # Common
│   └── ADR-MINOR-TEMPLATE.md    # Common
└── thoughts/
    └── work/

# Less common templates accessed from framework:
# - ADR-MAJOR-TEMPLATE.md (rare)
# - SPIKE-TEMPLATE.md (rare)
# - Code templates (rare)
```

**Pros:**
- ✅ Balanced - Most common needs met locally
- ✅ Smaller than Option 1 - Only ~5-10 templates
- ✅ Self-sufficient for common cases - 80/20 rule
- ✅ Less duplication - Only common templates duplicated
- ✅ Simpler than Option 2 - Don't need external reference for common tasks

**Cons:**
- ❌ Still some duplication - Common templates still copied
- ❌ Still some version drift - Common templates can be outdated
- ❌ Inconsistent - Some templates local, some external
- ❌ Users need to know which templates are where
- ❌ More complex setup - Need to decide which templates to copy

**Implementation:**
- Define "minimal template set" (5-10 most common)
- Copy minimal set during setup to `templates/`
- Document how to access framework for advanced templates
- Update NEW-PROJECT-CHECKLIST.md with minimal set

---

### Option 4: Online Template Repository

**Approach:**
- Templates available via public URL (GitHub, website)
- Users download templates as needed via curl/wget
- No local template copies
- Always fetches latest version

**Structure:**
```
my-project/
└── [No templates/ folder]

# Users fetch templates on demand:
# curl https://raw.githubusercontent.com/.../FEATURE-TEMPLATE.md > thoughts/work/todo/FEAT-001.md
```

**Pros:**
- ✅ Always current - Always fetch latest version
- ✅ No duplication - No copies anywhere
- ✅ Smallest project size - No template storage
- ✅ Easy updates - Just fetch new version
- ✅ Works for any project type - Not monorepo-dependent

**Cons:**
- ❌ Requires internet - Can't work offline
- ❌ Friction - Extra step to fetch template
- ❌ URL dependency - Relies on external service
- ❌ Version lock unclear - Hard to use specific template version
- ❌ Not beginner-friendly - More complex workflow

**Implementation:**
- Host templates on GitHub
- Provide template URL list in documentation
- Create helper scripts for template fetching
- Update NEW-PROJECT-CHECKLIST.md with fetch instructions

---

### Option 5: Hybrid - Copy + External Reference

**Approach:**
- Copy minimal set during setup
- Document framework reference for updates/advanced templates
- Users can refresh templates from framework when needed

**Structure:**
```
my-project/
├── templates/           # Initial copy from setup
│   ├── FEATURE-TEMPLATE.md
│   ├── BUGFIX-TEMPLATE.md
│   └── ...
└── thoughts/

# To update templates:
# cp ../framework/templates/work-items/FEATURE-TEMPLATE.md templates/
# Or keep using existing templates
```

**Pros:**
- ✅ Self-contained initially - Works out of the box
- ✅ Update path available - Can refresh when desired
- ✅ User choice - Use local or update as needed
- ✅ Familiar pattern - Like dependency management
- ✅ Offline capable - Local copies work offline

**Cons:**
- ❌ Still duplicates - Initial copies still exist
- ❌ Manual updates - Users must choose to update
- ❌ Version confusion - Local vs. framework versions
- ❌ Update friction - Extra step to stay current

**Implementation:**
- Copy templates during setup
- Document update procedure in CLAUDE.md
- Provide "refresh templates" instructions
- Optional: Script to refresh templates from framework

---

## Decision

**We choose [OPTION TBD]** because:
- [Reason 1]
- [Reason 2]
- [Reason 3]

**Implementation:** [To be determined after option selected]

**Rollout:**
- Update NEW-PROJECT-CHECKLIST.md with chosen approach
- Update template packages in `project-templates/`
- Update documentation (CLAUDE.md, collaboration guides)
- Implement for FEAT-025 validation

---

## Consequences

**Good:**
- [To be determined based on chosen option]

**Bad:**
- [To be determined based on chosen option]

**Neutral:**
- [To be determined based on chosen option]

**Revisit if:**
- Template management becomes problematic
- Users consistently struggle with template access
- Framework structure changes significantly
- Better solution emerges (e.g., template CLI tool)

---

## Evaluation Criteria

When choosing option, consider:

1. **User Experience:** How easy is it for new users to use templates?
2. **Self-Containment:** Can projects work without external dependencies?
3. **Update Path:** How easily can users get latest template versions?
4. **DRY Principle:** How much duplication exists?
5. **Offline Capability:** Can users work offline?
6. **Maintenance Burden:** How much ongoing work for framework maintainers?
7. **Beginner Friendliness:** Can novices understand the approach?

---

## Testing Plan

**Validation via FEAT-025:**
- Implement chosen option in template packages
- Test during FEAT-025 setup validation
- Document user experience
- Verify template access works as designed
- Collect feedback on friction points

**Success Metrics:**
- Users can create work items from templates without confusion
- Template access is documented clearly
- Setup process is straightforward
- Update path is clear (if applicable)

---

## Notes

**Priority:** P1 - Informs FEAT-025 and FEAT-038

This decision affects:
- FEAT-038 (Update NEW-PROJECT-CHECKLIST.md) - Template access instructions
- FEAT-025 (Manual Setup Validation) - Will test chosen approach
- All future user projects - Sets the pattern

**Discovered During:** FEAT-025 alignment analysis

**Critical Insight:** FEAT-025 discovered that documentation references `thoughts/framework/templates/` but this path doesn't exist in user projects. This is a fundamental template access issue that must be resolved.

**Recommendation Factors:**
- Consider that most users will likely be creating single-project repositories (not monorepos)
- Consider that the framework is intended for solo/small teams (not enterprise)
- Consider that offline capability may be important for some users
- Consider that version management might not be critical for templates (unlike dependencies)

**Follow-up Work:**
- Implement chosen option in template packages
- Update NEW-PROJECT-CHECKLIST.md
- Document in CLAUDE.md templates
- Test in FEAT-025

---

## References

- [FEAT-025-ALIGNMENT-ANALYSIS.md](FEAT-025-ALIGNMENT-ANALYSIS.md) - Discovered this issue
- [PROJECT-STRUCTURE-STANDARD.md](../../docs/PROJECT-STRUCTURE-STANDARD.md) - Project structure spec
- [NEW-PROJECT-CHECKLIST.md](../../../project-templates/NEW-PROJECT-CHECKLIST.md) - Will be updated based on decision

---

**Last Updated:** 2026-01-10
**Status:** Proposed - Awaiting decision and implementation
