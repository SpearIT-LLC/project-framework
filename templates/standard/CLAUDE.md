# CLAUDE.md - [Project Name]

**Inherits:** [Generic framework guidelines](../CLAUDE.md)
**Document Version:** 1.0.0
**Last Updated:** YYYY-MM-DD
**Current Version & Status:** See [PROJECT-STATUS.md](PROJECT-STATUS.md) *(per framework standard)*
**Core Features:** [Status description]

---

> **Note:** This project follows the [Documentation Standards](../CLAUDE.md#documentation-standards) from the generic framework, including the convention that PROJECT-STATUS.md is the single source of truth for version and status information.

---

## Project Configuration

Read `framework.yaml` at the project root for machine-readable project context:
- `project.name` - Project name
- `project.type` - framework | application | library | tool
- `project.deliverable` - code | documentation | hybrid

Use these values to understand project context rather than inferring from structure.

---

## What This System Is

[2-3 paragraph description of what this project does and what problem it solves]

**Think of it as:** [Simple analogy that explains the project's purpose]

---

## What This System Is NOT

- ❌ [Common misconception 1]
- ❌ [Common misconception 2]
- ❌ [Common misconception 3]
- ❌ [What it explicitly doesn't do]

---

## Core Architecture Philosophy

### Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **[Technology Choice]** | [Selection] | [Why this was chosen] |
| **[Architectural Pattern]** | [Pattern used] | [Why this pattern] |
| **[Data Storage]** | [Approach] | [Why this approach] |
| **[Language]** | [Language + version] | [Why this language] |

---

## Project Structure

```
ProjectName/
├── src/                        # [Description]
├── tests/                      # [Description]
├── docs/                       # [Description]
├── config/                     # [Description]
│
├── CLAUDE.md                   # This file
├── README.md                   # Project overview
├── PROJECT-STATUS.md           # Single source of truth for status
├── CHANGELOG.md                # Version history
│
└── thoughts/                   # Project documentation and framework
    ├── project/                # Project-specific content
    │   ├── planning/           # Roadmap and backlog
    │   ├── work/               # Kanban workflow
    │   ├── reference/          # Current project docs
    │   ├── research/           # Project research (ADRs)
    │   ├── retrospectives/     # Project retrospectives
    │   └── history/            # Session history and releases
    └── framework/              # Reusable across projects
        ├── process/            # Workflow documentation
        ├── templates/          # Planning templates
        └── patterns/           # Implementation patterns
```

---

## Workflow: How It Works

### [Main Workflow Name]

**Step 1: [Step Name]**

[Description of step]

```[language]
# Example code or command
```

**Step 2: [Step Name]**

[Description of step]

```[language]
# Example code or command
```

**Step 3: [Step Name]**

[Description of step]

```[language]
# Example code or command
```

---

## Critical Files and Line References

### [Component 1]
**[path/to/file.ext](path/to/file.ext)**
- `FunctionName` - [Description of what it does]
- `AnotherFunction` - [Description]

### [Component 2]
**[path/to/file.ext](path/to/file.ext)**
- `FunctionName` - [Description of what it does]
- `AnotherFunction` - [Description]

---

## Coding Standards

### [Language] Requirements

**Version:** [Language version and rationale]

**File Structure:**
```[language]
# Standard file header template
# [Language-specific conventions]
```

### Naming Conventions

**[Language-specific]:**
- [Convention 1]: `ExampleName` ([Description])
- [Convention 2]: `example_name` ([Description])
- [Convention 3]: `exampleName` ([Description])

**Files:**
- [File type 1]: `example-name.ext` ([Convention])
- [File type 2]: `ExampleName.ext` ([Convention])

**[Data Format] Properties:**
- Use [convention]: `"property_name"`, `"another_property"`
- Timestamps: [Format, e.g., ISO 8601 UTC]

### Character Encoding

**[If relevant]**
- ✅ [Allowed characters]
- ❌ [Prohibited characters]
- ✅ [File encoding, e.g., UTF-8]

### Error Handling

**[Language-specific error handling patterns]**

```[language]
# Example error handling pattern
```

### Logging Standards

```[language]
# Log format example
# [YYYY-MM-DD HH:MM:SS] LEVEL | Message | key=value
```

**Levels:** [List logging levels used]

---

## Security Policy

### Trust Model

**Trusted:**
- [What is trusted]

**Untrusted (Requires Validation):**
- [What requires validation]

### Security Approach

[Description of security philosophy and implementation]

1. **[Security Area 1]**
   - [Approach]

2. **[Security Area 2]**
   - [Approach]

### Security Rationale

[Why this security approach is appropriate for this project]

---

## Common Development Tasks

### [Task 1: Common Operation]

```[language]
# Example command or code
```

### [Task 2: Another Operation]

```[language]
# Example command or code
```

### Debug [Common Issue]

1. **Check [location]:** [What to check]
2. **Read logs:** [Where logs are]
3. **Check [state]:** [How to verify]
4. **Review [artifact]:** [What to look at]

### Run Tests

```[language]
# Unit tests
[command]

# Integration tests
[command]

# All tests
[command]
```

---

## Known Issues and Gotchas

### [Issue 1: Description]

**Issue:** [Detailed description]
**Impact:** [Who/what is affected]
**Status:** [Status and tracking info]
**Workaround:** [If available]
**Fix:** [Plan for resolution]

---

## Configuration System

### Configuration Files

**[config file 1]** ([tracked/ignored in git])
```[format]
{
  "setting": "value"
}
```

**[config file 2]** ([tracked/ignored in git])
```[format]
{
  "setting": "value"
}
```

### Usage in Code

```[language]
# Example of loading and using configuration
```

---

## Documentation Standards

> **See [Framework Documentation Standards](../CLAUDE.md#documentation-standards)** for general guidelines on:
> - Session history format (daily YYYY-MM-DD-SESSION-HISTORY.md files)
> - Work item documentation templates (FEATURE, BUGFIX, BLOCKER, SPIKE)
> - Code documentation requirements
> - Work item location (`thoughts/project/work/` todo/doing/done folders)

### [Project]-Specific Documentation

**[Language] Code Documentation:**
- [Project-specific code doc requirements]

**[Component] Documentation:**
- [Component-specific doc requirements]

**Release Process:**
When features/bugfixes are complete, follow [version-control-workflow.md](thoughts/framework/process/version-control-workflow.md):
1. Keep CHANGELOG notes in work item doc during development
2. At release: Update PROJECT-STATUS.md and CHANGELOG.md together
3. Commit, tag, and push as single atomic operation

---

## Retrospective Insights

> **See [Framework: Project Retrospectives](../CLAUDE.md#project-retrospectives)** for retrospective structure and guidelines.

[If project has retrospectives, summarize key learnings here and link to full retrospectives]

---

## Commands for Development

```[language/bash]
# Navigate to project
cd /path/to/project

# [Common command 1]
[command]

# [Common command 2]
[command]

# [Common command 3]
[command]
```

---

## Future Roadmap

### v[Next Minor] Candidates
- [Feature/fix description]
- [Feature/fix description]

### v[Next Major] Features
- [Feature description]
- [Feature description]

### Future Enhancements
- [Enhancement description]
- [Enhancement description]

See [roadmap.md](thoughts/project/planning/roadmap.md) for complete roadmap.

---

## Working with Claude

> **See [Framework: Working with Claude](../CLAUDE.md#working-with-claude-ai-assistant)** for general AI collaboration guidelines.

### [Project]-Specific Insights

**What works well in this project:**
- [Project-specific collaboration pattern]
- [Project-specific approach]

**Lessons learned:**
- [Project-specific lesson]
- [Project-specific lesson]

---

## Emergency Reference

### System Not Working? Check These First

1. **[Most common failure mode]**
   - Check: [What to verify]
   - Fix: [How to resolve]

2. **[Configuration issue]**
   - Check: [Where to look]
   - Fix: [How to resolve]

3. **[Dependency issue]**
   - Check: [How to verify]
   - Fix: [How to resolve]

4. **[Log location]**
   - Location: [Where logs are]
   - Look for: [What to search for]

5. **[Common user error]**
   - Symptom: [How it presents]
   - Fix: [How to resolve]

### Quick Diagnostics

```[language/bash]
# Commands to check system state
[command]

# Commands to verify configuration
[command]

# Commands to view logs
[command]

# Commands to test key functionality
[command]
```

---

## Related Documents

**Project Status & History:**
- [CHANGELOG.md](CHANGELOG.md) - Version history following Keep a Changelog format
- [PROJECT-STATUS.md](PROJECT-STATUS.md) - Current implementation status and completion tracking
- [README.md](README.md) - Project overview and getting started guide

**Must Read:**
- [system-architecture.md](thoughts/project/reference/system-architecture.md) - Canonical architecture reference (if exists)
- [coding-standards.md](thoughts/project/reference/coding-standards.md) - Code quality standards (if exists)
- [version-control-workflow.md](thoughts/framework/process/version-control-workflow.md) - Git branching, releases, and CHANGELOG discipline

**Framework (Reusable):**
- [FRAMEWORK-CHANGELOG.md](thoughts/framework/FRAMEWORK-CHANGELOG.md) - Process evolution tracking
- [workflow-guide.md](thoughts/framework/collaboration/workflow-guide.md) - Work item lifecycle

---

## Version Control & Release Process

**All development follows a disciplined version control workflow documented in [version-control-workflow.md](thoughts/framework/process/version-control-workflow.md).**

### Key Principles

1. **ONE work item at a time** - Work on a single feature, bugfix, or blocker
2. **Plan first** - Create planning document before coding
3. **Branch per item** - Use `feature/`, `bugfix/`, or `hotfix/` branches
4. **CHANGELOG at release** - Keep notes in planning doc, update CHANGELOG when releasing
5. **Atomic releases** - CHANGELOG update, commit, tag, and push together

### Semantic Versioning

- **MAJOR (2.0.0)** - Breaking changes
- **MINOR (1.3.0)** - New features (backward-compatible)
- **PATCH (1.2.1)** - Bug fixes (backward-compatible)

See [version-control-workflow.md](thoughts/framework/process/version-control-workflow.md) for complete details.

---

## Contact

**Project Lead:** [Name]
**Email:** [email@example.com]
**Project Duration:** [Start date] - [End date or Ongoing]

---

**Last Updated:** YYYY-MM-DD
**Next Review:** [When to review this document]
