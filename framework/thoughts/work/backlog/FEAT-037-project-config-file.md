# FEAT-037: Project Configuration File

**ID:** FEAT-037
**Type:** Feature
**Priority:** High
**Status:** Backlog
**Created:** 2026-01-08
**Related:** TECH-043, FEAT-031

---

## Summary

Create a lightweight project configuration file that provides contextual parameters and policy references to guide AI assistants and tooling, serving as a master index for project-specific policy decisions.

**Key Insight:** Framework projects (deliverable = documentation) and code projects (deliverable = code) need different interpretations of the same workflow. A config file can provide this context without repeating it everywhere.

---

## Problem Statement

**Issue identified during:** TECH-043 categorization discussion

Currently, projects using this framework face several challenges:

1. **Context Ambiguity:** AI must infer project type and interpret work item categories accordingly
2. **Policy Confusion:** Framework policies (for documentation projects) might not apply to code projects
3. **Repeated Context:** Project context must be explained in multiple places (CLAUDE.md, README.md, work items)
4. **Override Difficulty:** Users can't easily override framework policies for their specific project needs
5. **No Master Index:** Policy locations are documented in INDEX.md, but not machine-readable

**Specific example:**
- In framework project: TECH = process improvements (not "debt")
- In code project: TECH = technical debt/refactoring
- Same category, different meaning based on context

**Who is affected?**
- AI assistants (need context to interpret correctly)
- Contributors (need to understand project type)
- Tooling/automation (need machine-readable config)
- Users adopting framework (need to customize policies)

---

## Requirements

### Functional Requirements

- [ ] Define minimal set of configuration parameters
- [ ] Support project type identification (framework, application, library, tool)
- [ ] Specify primary deliverable (code, documentation, hybrid)
- [ ] Point to authoritative policy documents (SSoT references)
- [ ] Allow policy overrides for user projects
- [ ] Provide category interpretation guidance
- [ ] Remain machine-readable (JSON, YAML, or TOML)
- [ ] Stay minimal (not a replacement for documentation)

### Non-Functional Requirements

- [ ] Small file size (< 100 lines for typical project)
- [ ] Human-readable format
- [ ] Easy to override in derived projects
- [ ] Compatible with version control
- [ ] No build/compilation required
- [ ] Self-documenting with comments

---

## Design

### Core Concept: Master Policy Index

The config file serves as the **machine-readable master index** for:
1. Project context (type, deliverable)
2. Policy locations (SSoT references)
3. Interpretation guidelines (category meanings)
4. Workflow customization (which policies apply)

**Relationship to other work:**
- INDEX.md (FEAT-031) = Human-readable documentation index
- project-config = Machine-readable policy index + context

---

## Proposed Structure

### Option 1: Minimal YAML

```yaml
# project-config.yaml
# Project context and policy references for AI assistants and tooling

project:
  name: "Standard Project Framework"
  type: framework  # framework | application | library | tool
  deliverable: documentation  # code | documentation | hybrid

# Master policy index - points to source-of-truth documents
policies:
  workflow: framework/process/workflow-guide.md
  dryPrinciples: framework/collaboration/documentation-dry-principles.md
  workItemTemplates: framework/templates/work-items/
  codingStandards: null  # Not applicable for documentation project

# Work item category interpretation for this project type
categories:
  FEAT: "New framework content, capabilities, or documentation"
  TECH: "Process, tooling, and infrastructure improvements (not debt)"
  BUGFIX: "Corrections to existing framework content"
  DECISION: "Architectural or policy decisions requiring documentation"
  SPIKE: "Research and investigation"

# Workflow configuration
workflow:
  workPath: framework/thoughts/work/
  useStandardWorkflow: true
  customSteps: null  # Override workflow steps if needed
```

### Option 2: JSON with Comments

```json
{
  "$schema": "./project-config-schema.json",
  "project": {
    "name": "Standard Project Framework",
    "type": "framework",
    "deliverable": "documentation"
  },
  "policies": {
    "_comment": "Master index - points to source-of-truth documents",
    "workflow": "framework/process/workflow-guide.md",
    "dryPrinciples": "framework/collaboration/documentation-dry-principles.md",
    "workItemTemplates": "framework/templates/work-items/"
  },
  "categories": {
    "_comment": "How to interpret work item types in this project",
    "FEAT": "New framework content, capabilities, or documentation",
    "TECH": "Process, tooling, and infrastructure improvements"
  },
  "workflow": {
    "workPath": "framework/thoughts/work/",
    "standard": true
  }
}
```

---

## Addressing the Policy Confusion Problem

**The Challenge:** Will AI get confused referencing framework policies (designed for documentation projects) when working on code projects?

### Solution: Explicit Policy Scope in Config

Each project's config clarifies which policies apply:

**Framework project config:**
```yaml
project:
  type: framework
  deliverable: documentation

policies:
  workflow: framework/process/workflow-guide.md
  dryPrinciples: framework/collaboration/documentation-dry-principles.md
  # Applies to framework documentation

categories:
  TECH: "Process improvements, not code debt"
```

**User code project config:**
```yaml
project:
  type: application
  deliverable: code

policies:
  workflow: framework/process/workflow-guide.md  # Reuse framework workflow
  dryPrinciples: null  # DRY code principles, not doc principles
  codingStandards: docs/coding-standards.md  # Project-specific

categories:
  TECH: "Technical debt and code refactoring"
```

**Benefits:**
1. AI reads config first, understands context
2. Policies explicitly scoped to project type
3. User can override framework policies
4. Clear which interpretations apply

---

## Use Cases

### Use Case 1: AI Assistant Context

**Scenario:** Claude opens a project for the first time

**Current behavior:**
- Reads CLAUDE.md (if exists)
- Infers project type from file structure
- Guesses category interpretations

**With config:**
- Reads project-config.yaml first
- Knows project type explicitly
- Applies correct category interpretations
- References correct policy documents

---

### Use Case 2: User Overriding Framework Policy

**Scenario:** User wants different DRY principles for their code project

**Current approach:**
- User must understand framework structure
- Create their own policy document
- Update multiple references manually
- Risk confusion with framework policies

**With config:**
```yaml
project:
  type: application
  deliverable: code

policies:
  workflow: framework/process/workflow-guide.md  # Keep framework workflow
  dryPrinciples: docs/my-dry-principles.md  # Override with project-specific
  codingStandards: docs/coding-standards.md  # Add new policy
```

Clean, explicit, easy to understand.

---

### Use Case 3: Tooling and Automation

**Scenario:** Build script needs to know project structure

**Current approach:**
- Parse multiple markdown files
- Hard-code assumptions
- Break when structure changes

**With config:**
```javascript
const config = yaml.load('project-config.yaml');
const workPath = config.workflow.workPath;
const policies = config.policies;
// Machine-readable, stable interface
```

---

## Design Decisions Needed

### 1. Field Naming Conventions

**Question:** What naming style should we use?

**Options:**

**A. Nested Structure (Recommended)**
```yaml
project:
  name: "Framework Name"
  type: framework
  deliverable: documentation

policies:
  workflow: path/to/workflow.md
  dryPrinciples: path/to/dry.md
```
- Pros: Organized, scalable, clear grouping
- Cons: More verbose

**B. Flat Structure**
```yaml
projectName: "Framework Name"
projectType: framework
projectDeliverable: documentation
policyWorkflow: path/to/workflow.md
policyDryPrinciples: path/to/dry.md
```
- Pros: Simple, direct access
- Cons: Namespace pollution, less organized

**Recommendation:** Nested (Option A) - better organization as config grows

**Terminology alignment:**
- Match existing framework terms where possible
- Review framework/ documentation for established terminology
- Ensure names are intuitive for new users

---

### 2. Policy Categorization

**Question:** Should policies have formal categories?

**Current framework organization:**
```
framework/
├── process/          # Workflow, release procedures
├── collaboration/    # AI guides, team workflows
├── templates/        # Work items, documents
├── patterns/         # Reusable patterns
└── docs/            # Other documentation
```

**Config Option A: Flat Policy List**
```yaml
policies:
  workflow: framework/process/workflow-guide.md
  dryPrinciples: framework/collaboration/documentation-dry-principles.md
  featureTemplate: framework/templates/work-items/FEATURE-TEMPLATE.md
  releaseProcess: framework/process/release-process.md
```
- Pros: Simple, direct
- Cons: Could get long, no organization

**Config Option B: Categorized Policies**
```yaml
policies:
  process:
    workflow: framework/process/workflow-guide.md
    release: framework/process/release-process.md
  collaboration:
    dryPrinciples: framework/collaboration/documentation-dry-principles.md
    aiWorkflow: framework/collaboration/ai-workflow.md
  templates:
    workItems: framework/templates/work-items/
```
- Pros: Organized, mirrors framework structure
- Cons: More complex, requires formal categories

**Config Option C: Essential + Index Reference**
```yaml
policies:
  # Essential policies referenced frequently by AI/tooling
  workflow: framework/process/workflow-guide.md
  workItemTemplates: framework/templates/work-items/

  # Complete policy list in INDEX.md
  index: framework/INDEX.md
```
- Pros: Minimal config, points to complete list
- Cons: Machines must parse markdown for complete list

**Recommendation to Discuss:**
- Start with Option C (Essential + Index) for minimal config
- Can expand to Option B (Categorized) if needed
- Formal categories would require documentation of category system

**Action Items:**
1. Review existing framework docs for established policy categories
2. List "essential" policies that AI/tooling needs most
3. Decide if formal categorization adds enough value
4. Document category system if we implement it

---

## Implementation Approach

### Phase 1: Design and Prototype

1. Finalize field naming conventions (nested vs flat)
2. Decide policy organization (flat, categorized, or essential+index)
3. Define formal policy categories (if needed)
4. Create config structure and schema
5. Prototype for framework project
6. Prototype for sample code project (project-hello-world)
7. Test with AI to validate context improvement

### Phase 2: Integration

1. Add config file to framework root
2. Update CLAUDE.md to reference config
3. Update AI instructions to read config first
4. Document config format and usage

### Phase 3: Adoption

1. Add config to project-hello-world
2. Add to project templates (minimal, light, standard)
3. Create guide for customizing config
4. Update workflow documentation

---

## Config File Location

**Options:**

1. **Project root:** `project-config.yaml`
   - Pros: Easy to find, standard location
   - Cons: Adds clutter to root

2. **Framework folder:** `framework/project-config.yaml`
   - Pros: Keeps framework concerns together
   - Cons: Less discoverable

3. **Hidden dot-file:** `.project-config.yaml`
   - Pros: Keeps root clean
   - Cons: Harder to discover, less standard

**Decision:** Project root (`project-config.yaml`) ✓
- Standard location for config files
- Immediately visible to tools and AI
- Consistent with other projects (package.json, etc.)
- Decided: 2026-01-08

---

## Relationship to INDEX.md (FEAT-031)

**Key Question:** How do project-config.yaml and INDEX.md work together?

### Similarities (Overlap)
Both reference policy document locations:
- INDEX.md: Human-readable list for browsing
- project-config: Machine-readable references for tooling

### Differences (Complementary)
- **INDEX.md:** Complete documentation index, organized for humans
- **project-config:** Project context + essential policy pointers for machines

### Sync Strategy Options

**Option A: Independent (Allow Duplication)**
- Both maintain their own policy references
- Accept some duplication as acceptable
- Pros: Each optimized for its audience, no coupling
- Cons: Must update both when policies move

**Option B: Config References INDEX.md**
```yaml
policies:
  indexFile: framework/INDEX.md  # Master list
  workflow: framework/process/workflow-guide.md  # Essential policies only
```
- Config has minimal policies, points to INDEX.md for complete list
- Pros: Less duplication, single source for complete list
- Cons: Machines must parse markdown INDEX.md

**Option C: INDEX.md References Config**
```markdown
## Master Policy Index

See [project-config.yaml](../project-config.yaml) for machine-readable policy references.

Below is the human-organized documentation index...
```
- INDEX.md acknowledges config exists
- Both maintain their own structures
- Pros: Clear that both exist, minimal coupling
- Cons: Still duplication

**Option D: Separate Concerns Completely**
- project-config: Essential context + key policies only
- INDEX.md: Complete documentation navigation
- Overlap is minimal and acceptable
- Pros: Each serves its purpose well
- Cons: Some duplication inevitable

**Recommendation to Discuss:** Option D (Separate Concerns)
- Config focuses on context and interpretation guidance
- INDEX.md focuses on complete documentation organization
- Some policy references overlap but serve different purposes
- DRY principle applies within each, not across them

---

## Relationship to Other Work Items

**Complements:**
- **FEAT-031:** INDEX.md is human-readable index, config is machine-readable (see above)
- **TECH-043:** DRY principles can be referenced in config
- **TECH-036:** Config helps identify which policies to apply during refactoring

**Enables:**
- Clearer AI context and interpretation
- Easier policy customization for users
- Foundation for tooling/automation
- Multi-project monorepo support

---

## Questions to Resolve

1. **Format choice:** YAML vs. JSON vs. TOML?
   - ✓ **Decision:** YAML (human-readable, supports comments) - 2026-01-08

2. **File location:** Root, framework folder, or hidden?
   - ✓ **Decision:** Project root (project-config.yaml) - 2026-01-08

3. **Relationship to INDEX.md:** How do they work together?
   - ❓ **Open:** Do they need to be kept in sync, or are they independent?
   - **Discussion:**
     - INDEX.md = Human-readable documentation index (for browsing)
     - project-config = Machine-readable policy index (for tooling/AI)
     - Overlap: Both reference policy locations
     - Question: Is duplication acceptable? Or should one reference the other?
     - Potential: Config could point to INDEX.md as the human-readable version?

4. **Field naming conventions:** What makes sense?
   - ❓ **Open:** Need to discuss and standardize field names
   - **Considerations:**
     - `project.type` vs `projectType` (nested vs flat)
     - `policies.workflow` vs `policies.workflowGuide` (brief vs descriptive)
     - `deliverable` vs `primaryArtifact` vs `output` (terminology)
     - Should match existing framework terminology where possible
   - **Action:** Review existing framework terminology and propose standard naming

5. **Policy categorization:** Do we need formal categories?
   - ❓ **Open:** Should policies have formal categories for referencing in config?
   - **Example current categories:**
     - Process (workflow, release)
     - Collaboration (AI guides, team guides)
     - Templates (work items, documents)
     - Patterns (code/doc patterns)
   - **Question:** Should config use these categories? Or just list individual policies?
   - **Benefit:** Formal categories enable `policies.process.workflow` structure
   - **Tradeoff:** More structure vs. simplicity

6. **Required vs. optional fields:** What's minimum viable config?
   - **Recommendation:** Only project.type and project.deliverable required
   - **Open:** Validate this is sufficient for AI context

7. **Schema validation:** Should we provide JSON schema?
   - **Recommendation:** Yes, but optional (helps tooling)
   - **Open:** When to implement (Phase 1 or later)?

8. **Backwards compatibility:** How to handle projects without config?
   - **Recommendation:** AI falls back to current behavior (infer from CLAUDE.md)
   - **Validation:** Ensure gradual adoption is possible

9. **Monorepo structure:** One config or multiple?
   - **Recommendation:** One per project (framework/, project-hello-world/, etc.)
   - **Open:** Should framework config be "inherited" by other projects?

---

## Completion Criteria

- [ ] Config file format and structure defined
- [ ] Schema documentation created
- [ ] Example configs created (framework, code project)
- [ ] Framework project config implemented
- [ ] CLAUDE.md updated to reference config
- [ ] AI workflow updated to read config first
- [ ] Usage guide documented
- [ ] Templates updated with config files
- [ ] Tested with AI assistant (confirms correct interpretation)

---

## Success Metrics

- AI correctly interprets project context from config
- Users can easily override framework policies
- Reduced ambiguity in category interpretation
- Foundation established for tooling integration
- Clear separation between framework and user project policies

---

## Alternatives Considered

### Alternative 1: Extend CLAUDE.md with Structured Frontmatter

```markdown
---
project:
  type: framework
  deliverable: documentation
policies:
  workflow: framework/process/workflow-guide.md
---

# Claude Context: Framework Project
...
```

**Pros:** No new file, markdown ecosystem
**Cons:** Less machine-readable, mixes concerns
**Decision:** Separate config file is cleaner

---

### Alternative 2: Multiple Small Config Files

- `.project-type` (just the type)
- `.policies` (policy references)
- `.workflow-config` (workflow settings)

**Pros:** Very modular
**Cons:** Too many files, harder to understand holistically
**Decision:** Single config file is simpler

---

### Alternative 3: Do Nothing (Status Quo)

**Pros:** No work required
**Cons:** Doesn't solve the problems identified
**Decision:** Config provides significant value, worth implementing

---

## References

- Related: TECH-043 (DRY principles - can be referenced in config)
- Related: FEAT-031 (INDEX.md registry - human-readable counterpart)
- Origin: Discussion during TECH-043 categorization review

---

## Notes

**Design Philosophy:**
- Keep minimal - only what provides context or points to policies
- Machine-readable first, human-readable second
- Support customization without complexity
- Serve as master policy index

**Future Possibilities:**
- Tooling that validates config
- Scripts that read config for automation
- IDE plugins that understand project context
- Config inheritance (project extends framework config)

**Critical Success Factor:**
- Must actually help AI understand context better
- Test with real AI interactions to validate

---

**Last Updated:** 2026-01-08
