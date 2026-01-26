# [Project Name] - Documentation Index

**Last Updated:** YYYY-MM-DD
**Purpose:** Complete navigation guide to all project documentation

---

## Quick Links

| Document | Purpose | Audience |
|----------|---------|----------|
| [README.md](README.md) | Project overview and quick start | All users |
| [PROJECT-STATUS.md](PROJECT-STATUS.md) | Current version and implementation status | All users |
| [CHANGELOG.md](CHANGELOG.md) | Version history | All users |
| [CLAUDE.md](CLAUDE.md) | AI assistant instructions and conventions | Developers + AI |

---

## Root Documentation

### Essential Documents

- **[README.md](README.md)** - Project overview, quick start, basic usage
- **[PROJECT-STATUS.md](PROJECT-STATUS.md)** - Current version, feature status, pending work
- **[CHANGELOG.md](CHANGELOG.md)** - Version history following Keep a Changelog format
- **[CLAUDE.md](CLAUDE.md)** - Project-specific AI assistant instructions
- **[INDEX.md](INDEX.md)** - This file (documentation index)

### Configuration

- **[CONFIG-README.md](CONFIG-README.md)** - Configuration system documentation (if applicable)
- **[.gitignore](.gitignore)** - Git ignore patterns
- **[LICENSE](LICENSE)** - Project license (if applicable)

### Contributing (if open source)

- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines
- **[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)** - Community standards

---

## Framework Documentation

Location: `project-hub/framework/`

### Process Documentation

Location: `project-hub/framework/process/`

- **[workflow-guide.md](project-hub/framework/collaboration/workflow-guide.md)** - Work item lifecycle and workflow
- **[version-control-workflow.md](project-hub/framework/process/version-control-workflow.md)** - Git workflow and release process
- **[documentation-standards.md](project-hub/framework/process/documentation-standards.md)** - Documentation formatting standards

### Templates

Location: `project-hub/framework/templates/`

**Work Item Templates:**
- **[FEATURE-TEMPLATE.md](project-hub/framework/templates/FEATURE-TEMPLATE.md)** - Feature planning template
- **[BUGFIX-TEMPLATE.md](project-hub/framework/templates/BUGFIX-TEMPLATE.md)** - Bug fix documentation template
- **[BLOCKER-TEMPLATE.md](project-hub/framework/templates/BLOCKER-TEMPLATE.md)** - Blocker documentation template
- **[SPIKE-TEMPLATE.md](project-hub/framework/templates/SPIKE-TEMPLATE.md)** - Research/investigation template

**Architecture Decision Records:**
- **[ADR-MAJOR-TEMPLATE.md](project-hub/framework/templates/ADR-MAJOR-TEMPLATE.md)** - Major decision template
- **[ADR-MINOR-TEMPLATE.md](project-hub/framework/templates/ADR-MINOR-TEMPLATE.md)** - Minor decision template

### Patterns

Location: `project-hub/framework/patterns/`

- **[powershell-modules.md](project-hub/framework/patterns/powershell-modules.md)** - PowerShell module patterns (if applicable)
- **[config-management.md](project-hub/framework/patterns/config-management.md)** - Configuration patterns (if applicable)
- **[cmd-wrappers.md](project-hub/framework/patterns/cmd-wrappers.md)** - CMD wrapper patterns (if applicable)

### Framework Evolution

- **[FRAMEWORK-CHANGELOG.md](project-hub/framework/FRAMEWORK-CHANGELOG.md)** - Process/framework evolution tracking

---

## Project Documentation

Location: `project-hub/`

### Planning

- **[roadmap.md](project-hub/roadmap.md)** - High-level vision and version goals

### Active Work (Kanban)

Location: `project-hub/work/`

- **[backlog/](project-hub/work/backlog/)** - Future work items (not yet committed)
  - `feature-NNN-*.md` - Feature plans
  - `bugfix-NNN-*.md` - Bug fix plans
  - `spike-*.md` - Investigation plans
- **[todo/](project-hub/work/todo/)** - Committed next work (max 10 items)
- **[doing/](project-hub/work/doing/)** - Active work (WIP limit: 1)
- **[done/](project-hub/work/done/)** - Completed work ready for release

### Reference Documentation

Location: `project-hub/external-references/`

**Core References:**
- **[system-architecture.md](project-hub/external-references/system-architecture.md)** - Canonical architecture reference
- **[coding-standards.md](project-hub/external-references/coding-standards.md)** - Code quality and style standards
- **[security-policy.md](project-hub/external-references/security-policy.md)** - Security approach and guidelines
- **[terminology-standards.md](project-hub/external-references/terminology-standards.md)** - Standard terminology

**Additional References:**
- [Add project-specific reference docs as created]

### Research

Location: `project-hub/research/`

**Architecture Decision Records:**
- **[adr/](project-hub/research/adr/)** - Architecture decision records
  - `001-decision-title.md`
  - `002-another-decision.md`

**Spikes/Investigations:**
- [Spike findings that haven't been archived yet]

### History

Location: `project-hub/history/`

**Session Histories:**
- **[YYYY-MM-DD-SESSION-HISTORY.md](project-hub/history/)** - Daily session activity logs

**Releases:**
- **[releases/](project-hub/history/releases/)** - Archived work items by version
  - `v1.0.0/` - Version 1.0.0 work items
  - `v1.1.0/` - Version 1.1.0 work items

**Spikes:**
- **[spikes/](project-hub/history/spikes/)** - Completed research/investigations
  - `spike-description-YYYY-MM-DD.md`

### Retrospectives

Location: `project-hub/retrospectives/`

- **[YYYY-MM-DD-retrospective.md](project-hub/retrospectives/)** - Project retrospectives
  - What went well
  - What didn't go well
  - Process improvements
  - Key learnings

### Archive

Location: `project-hub/history/archive/`

- **[Cancelled/outdated/superseded items](project-hub/history/archive/)** - Historical reference

---

## User Documentation

Location: `docs/` (if separate from root)

- **[getting-started.md](docs/getting-started.md)** - Detailed setup guide
- **[user-guide.md](docs/user-guide.md)** - Complete feature documentation
- **[api-reference.md](docs/api-reference.md)** - API documentation (if applicable)
- **[faq.md](docs/faq.md)** - Frequently asked questions
- **[troubleshooting.md](docs/troubleshooting.md)** - Common issues and solutions

---

## Testing Documentation

Location: `docs/testing/` or `tests/docs/`

- **[test-strategy.md](docs/testing/test-strategy.md)** - Overall testing approach
- **[test-plan.md](docs/testing/test-plan.md)** - Test coverage and scenarios
- **[manual-test-cases.md](docs/testing/manual-test-cases.md)** - Manual testing procedures

---

## Source Code Documentation

### Main Source

Location: `src/` (or language-specific structure)

- [Code should include inline documentation following coding-standards.md]

### Tests

Location: `tests/`

- [Test files should include descriptive comments]

---

## Configuration Documentation

- **[CONFIG-README.md](CONFIG-README.md)** - Configuration system overview
- **[config.shared.json](config.shared.json)** - Shared configuration (if applicable)
- **[.env.example](.env.example)** - Environment variable template (if applicable)

---

## Navigation by Audience

### For New Users
1. [README.md](README.md) - Start here
2. [docs/getting-started.md](docs/getting-started.md) - Setup guide
3. [docs/user-guide.md](docs/user-guide.md) - Learn features

### For Developers
1. [CLAUDE.md](CLAUDE.md) - Project conventions
2. [project-hub/external-references/system-architecture.md](project-hub/external-references/system-architecture.md) - Architecture
3. [project-hub/external-references/coding-standards.md](project-hub/external-references/coding-standards.md) - Code standards
4. [project-hub/framework/collaboration/workflow-guide.md](project-hub/framework/collaboration/workflow-guide.md) - Workflow
5. [PROJECT-STATUS.md](PROJECT-STATUS.md) - Current status

### For Contributors
1. [CONTRIBUTING.md](CONTRIBUTING.md) - How to contribute
2. [project-hub/framework/process/version-control-workflow.md](project-hub/framework/process/version-control-workflow.md) - Git workflow
3. [CHANGELOG.md](CHANGELOG.md) - Version history

### For AI Assistants (Claude)
1. [CLAUDE.md](CLAUDE.md) - Primary instructions
2. [../CLAUDE.md](../CLAUDE.md) - Generic framework (if exists)
3. [project-hub/framework/](project-hub/framework/) - All framework docs
4. [project-hub/external-references/](project-hub/external-references/) - Project references

---

## Document Types by Purpose

### Status & Planning
- PROJECT-STATUS.md - Current state
- roadmap.md - Future vision
- planning/backlog/* - Planned work
- work/todo/* - Committed work

### Process & Standards
- CLAUDE.md - Project conventions
- project-hub/framework/process/* - Workflows
- reference/coding-standards.md - Code quality

### History & Learning
- CHANGELOG.md - What changed
- history/* - Session logs and releases
- retrospectives/* - Lessons learned
- research/adr/* - Architecture decisions

### Reference & Help
- README.md - Overview
- docs/* - User guides
- reference/* - Technical references
- troubleshooting.md - Problem solving

---

## Search Tips

**Find by work item ID:**
```bash
grep -r "FEAT-002" project-hub/
```

**Find all ADRs:**
```bash
ls project-hub/research/adr/
```

**Find recent session histories:**
```bash
ls -t project-hub/history/sessions/*SESSION-HISTORY.md | head -5
```

**Find all TODOs in code:**
```bash
grep -r "TODO" src/
```

---

## Maintenance

**This index should be updated when:**
- New major documents are created
- Document locations change
- New document categories emerge
- Quarterly review

**Last Review:** YYYY-MM-DD
**Next Review:** YYYY-MM-DD (quarterly or after major milestone)

---

## Related Resources

- [Keep a Changelog](https://keepachangelog.com/) - CHANGELOG format
- [Semantic Versioning](https://semver.org/) - Versioning scheme
- [Markdown Guide](https://www.markdownguide.org/) - Markdown syntax

---

**Last Updated:** YYYY-MM-DD
