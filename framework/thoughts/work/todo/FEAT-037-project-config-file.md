# FEAT-037: Project Configuration File

**ID:** FEAT-037
**Type:** Feature
**Priority:** High
**Status:** Todo
**Created:** 2026-01-08
**Updated:** 2026-01-14
**Related:** FEAT-006 (setup script)

---

## Summary

Create a lightweight `framework.yaml` configuration file that provides project context to AI assistants and tooling.

**Approach:** Start with MVP (project metadata only), validate it works, then extend with workflow and policy sections.

---

## Problem Statement

**Issue identified during:** TECH-043 categorization discussion

Currently, projects using this framework face challenges:

1. **Context Ambiguity:** AI must infer project type from file structure
2. **Repeated Context:** Project context explained in multiple places (CLAUDE.md, README.md)
3. **No Machine-Readable Config:** Tooling can't programmatically understand project type

**Who is affected?**
- AI assistants (need context to interpret correctly)
- Tooling/automation (need machine-readable config)
- Setup scripts (need to generate project-specific configuration)

---

## Design Decisions

| Question | Decision | Date |
|----------|----------|------|
| Format | YAML (human-readable, supports comments) | 2026-01-08 |
| Location | Project root (`framework.yaml`) | 2026-01-08 |
| Field naming | Nested (`project.type` not `projectType`) | 2026-01-14 |
| Policy organization | Flat list (simple first) | 2026-01-14 |
| MVP scope | Project metadata only | 2026-01-14 |
| INDEX.md relationship | Separate concerns (independent files) | 2026-01-14 |
| Multi-project support | **Removed** - single-project only | 2026-01-14 |

---

## MVP Schema

```yaml
# framework.yaml
# Project configuration for AI assistants and tooling

project:
  name: "My Project"
  type: application  # framework | application | library | tool
  deliverable: code  # code | documentation | hybrid
```

**That's it for MVP.** Three fields under `project:`.

### Field Definitions

| Field | Required | Values | Description |
|-------|----------|--------|-------------|
| `project.name` | Yes | string | Human-readable project name |
| `project.type` | Yes | `framework`, `application`, `library`, `tool` | What kind of project |
| `project.deliverable` | Yes | `code`, `documentation`, `hybrid` | Primary output type |

### Project Types

- **framework** - Process/methodology documentation (like this framework)
- **application** - Standalone software application
- **library** - Reusable code package
- **tool** - Utility script or CLI tool

### Deliverable Types

- **code** - Primary output is source code
- **documentation** - Primary output is documentation
- **hybrid** - Both code and documentation are primary outputs

---

## Future Enhancements (Post-MVP)

Once MVP is validated, add these sections:

### Workflow Section
```yaml
workflow:
  workPath: thoughts/work/
  wipLimits:
    doing: 1
    todo: 10
```

### Policies Section
```yaml
policies:
  workflow: framework/docs/process/workflow-guide.md
  codingStandards: docs/coding-standards.md
```

### Categories Section (if needed)
```yaml
categories:
  TECH: "Technical debt and refactoring"  # Interpretation for this project type
```

**Note:** These are documented for future reference. Do not implement until MVP is validated.

---

## Implementation Plan

### Phase 1: MVP Implementation

1. Create `framework.yaml` for this framework project
2. Create example `framework.yaml` for templates
3. Test AI reads and uses the config correctly
4. Document in CLAUDE.md that AI should read config

### Phase 2: Validation & Schema

1. Create JSON Schema for validation
2. Add schema reference to YAML files
3. Test validation works

### Phase 3: Setup Script Integration (FEAT-006)

1. Update FEAT-006 to generate `framework.yaml`
2. Setup script asks for project name, type, deliverable
3. Setup script writes config with user values

---

## Relationship to FEAT-006 (Setup Script)

**FEAT-037** defines WHAT `framework.yaml` looks like.
**FEAT-006** implements HOW it gets created.

The setup script (FEAT-006) will:
- Ask user for project name, type, deliverable
- Generate `framework.yaml` with user-provided values
- Handle path resolution for policy references (future)

Templates should include a placeholder `framework.yaml` that the setup script customizes, OR the setup script generates it fresh.

---

## Example Configurations

### This Framework Project
```yaml
# framework.yaml
project:
  name: "SpearIT Project Framework"
  type: framework
  deliverable: documentation
```

### Typical User Application
```yaml
# framework.yaml
project:
  name: "My Web App"
  type: application
  deliverable: code
```

### Library/Package
```yaml
# framework.yaml
project:
  name: "my-utils"
  type: library
  deliverable: code
```

### CLI Tool
```yaml
# framework.yaml
project:
  name: "deploy-helper"
  type: tool
  deliverable: code
```

---

## CLAUDE.md Instruction Requirement

For AI to read `framework.yaml`, CLAUDE.md must contain an explicit instruction.

**Required instruction (add to CLAUDE.md):**
```markdown
## Project Configuration

Read `framework.yaml` at the project root for machine-readable project context:
- `project.name` - Project name
- `project.type` - framework | application | library | tool
- `project.deliverable` - code | documentation | hybrid

Use these values to understand project context rather than inferring from structure.
```

**Validation requirement for FEAT-006:**
- Setup script should either auto-update CLAUDE.md with this instruction, OR provide copy/paste instruction
- A `-check` flag (or separate validation script) should verify this instruction exists in CLAUDE.md
- Warn user if `framework.yaml` exists but CLAUDE.md doesn't reference it

---

## Test Plan

### Test Approach
Manual testing for MVP with explicitly defined expected results. Formal automated testing deferred to future work item.

### Prerequisites
1. `framework.yaml` created at project root
2. CLAUDE.md contains instruction to read config
3. Fresh Claude session (no prior context about project)

### Test Cases

| ID | Test | Setup | Prompt | Expected Result | Pass/Fail |
|----|------|-------|--------|-----------------|-----------|
| T1 | Reads project name | `name: "SpearIT Project Framework"` | "What is this project called?" | Response includes "SpearIT Project Framework" from config | |
| T2 | Reads project type | `type: framework` | "What type of project is this?" | Response identifies as "framework" type | |
| T3 | Reads deliverable | `deliverable: documentation` | "What is the primary deliverable?" | Response identifies "documentation" as deliverable | |
| T4 | Uses config over inference | `type: framework` (but has code files) | "Is this a code project?" | Response clarifies it's a documentation/framework project per config | |
| T5 | Missing config fallback | Delete `framework.yaml` | "What type of project is this?" | AI infers from structure, doesn't error | |

### Edge Case Tests

| ID | Test | Setup | Expected Result | Pass/Fail |
|----|------|-------|-----------------|-----------|
| E1 | Malformed YAML | Invalid syntax in `framework.yaml` | AI reports error, falls back to inference | |
| E2 | Missing required field | Remove `project.type` | AI uses available fields, notes missing data | |
| E3 | Invalid enum value | `type: banana` | AI notes invalid value, asks for clarification or falls back | |

### Test Execution
- [ ] T1: Project name -
- [ ] T2: Project type -
- [ ] T3: Deliverable -
- [ ] T4: Config over inference -
- [ ] T5: Missing config fallback -
- [ ] E1: Malformed YAML -
- [ ] E2: Missing required field -
- [ ] E3: Invalid enum value -

---

## Completion Criteria

### MVP (This Work Item)
- [ ] `framework.yaml` schema defined (done - see above)
- [ ] Config created for this framework project
- [ ] Config created for examples/hello-world (as demonstration)
- [ ] Example config added to templates
- [ ] AI successfully reads and uses config
- [ ] CLAUDE.md updated to reference config

### Future (Separate Work Items)
- [ ] JSON Schema for validation
- [ ] Workflow section added
- [ ] Policies section added
- [ ] FEAT-006 integration complete

---

## Success Metrics

- AI correctly identifies project type from config
- Config is simpler than current CLAUDE.md context sections
- Foundation established for future tooling integration

---

## Alternatives Considered

### Alternative 1: Extend CLAUDE.md with Frontmatter
```markdown
---
project:
  type: framework
---
```
**Rejected:** Mixes concerns, less machine-readable.

### Alternative 2: Multiple Config Files
**Rejected:** Single file is simpler.

### Alternative 3: Multi-Project Support
**Rejected (2026-01-14):** Over-engineering. Examples and templates are artifacts of the framework project, not separate projects. Single-project config is sufficient.

---

## References

- Related: FEAT-006 (setup script will generate config)
- Origin: Discussion during TECH-043 categorization review

---

**Last Updated:** 2026-01-14
