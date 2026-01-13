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

Location: `thoughts/framework/`

### Process Documentation

Location: `thoughts/framework/process/`

- **[kanban-workflow.md](thoughts/framework/process/kanban-workflow.md)** - File-based kanban workflow for work items
- **[version-control-workflow.md](thoughts/framework/process/version-control-workflow.md)** - Git workflow and release process
- **[documentation-standards.md](thoughts/framework/process/documentation-standards.md)** - Documentation formatting standards

### Templates

Location: `thoughts/framework/templates/`

**Work Item Templates:**
- **[FEATURE-TEMPLATE.md](thoughts/framework/templates/FEATURE-TEMPLATE.md)** - Feature planning template
- **[BUGFIX-TEMPLATE.md](thoughts/framework/templates/BUGFIX-TEMPLATE.md)** - Bug fix documentation template
- **[BLOCKER-TEMPLATE.md](thoughts/framework/templates/BLOCKER-TEMPLATE.md)** - Blocker documentation template
- **[SPIKE-TEMPLATE.md](thoughts/framework/templates/SPIKE-TEMPLATE.md)** - Research/investigation template

**Architecture Decision Records:**
- **[ADR-MAJOR-TEMPLATE.md](thoughts/framework/templates/ADR-MAJOR-TEMPLATE.md)** - Major decision template
- **[ADR-MINOR-TEMPLATE.md](thoughts/framework/templates/ADR-MINOR-TEMPLATE.md)** - Minor decision template

### Patterns

Location: `thoughts/framework/patterns/`

- **[powershell-modules.md](thoughts/framework/patterns/powershell-modules.md)** - PowerShell module patterns (if applicable)
- **[config-management.md](thoughts/framework/patterns/config-management.md)** - Configuration patterns (if applicable)
- **[cmd-wrappers.md](thoughts/framework/patterns/cmd-wrappers.md)** - CMD wrapper patterns (if applicable)

### Framework Evolution

- **[FRAMEWORK-CHANGELOG.md](thoughts/framework/FRAMEWORK-CHANGELOG.md)** - Process/framework evolution tracking

---

## Project Documentation

Location: `thoughts/project/`

### Planning

Location: `thoughts/project/planning/`

- **[roadmap.md](thoughts/project/planning/roadmap.md)** - High-level vision and version goals
- **[backlog/](thoughts/project/planning/backlog/)** - Future work items (not yet committed)
  - `feature-NNN-*.md` - Feature plans
  - `bugfix-NNN-*.md` - Bug fix plans
  - `spike-*.md` - Investigation plans

### Active Work (Kanban)

Location: `thoughts/project/work/`

- **[todo/](thoughts/project/work/todo/)** - Committed next work (max 10 items)
- **[doing/](thoughts/project/work/doing/)** - Active work (WIP limit: 1)
- **[done/](thoughts/project/work/done/)** - Completed work ready for release

### Reference Documentation

Location: `thoughts/project/reference/`

**Core References:**
- **[system-architecture.md](thoughts/project/reference/system-architecture.md)** - Canonical architecture reference
- **[coding-standards.md](thoughts/project/reference/coding-standards.md)** - Code quality and style standards
- **[security-policy.md](thoughts/project/reference/security-policy.md)** - Security approach and guidelines
- **[terminology-standards.md](thoughts/project/reference/terminology-standards.md)** - Standard terminology

**Additional References:**
- [Add project-specific reference docs as created]

### Research

Location: `thoughts/project/research/`

**Architecture Decision Records:**
- **[adr/](thoughts/project/research/adr/)** - Architecture decision records
  - `001-decision-title.md`
  - `002-another-decision.md`

**Spikes/Investigations:**
- [Spike findings that haven't been archived yet]

### History

Location: `thoughts/project/history/`

**Session Histories:**
- **[YYYY-MM-DD-SESSION-HISTORY.md](thoughts/project/history/)** - Daily session activity logs

**Releases:**
- **[releases/](thoughts/project/history/releases/)** - Archived work items by version
  - `v1.0.0/` - Version 1.0.0 work items
  - `v1.1.0/` - Version 1.1.0 work items

**Spikes:**
- **[spikes/](thoughts/project/history/spikes/)** - Completed research/investigations
  - `spike-description-YYYY-MM-DD.md`

### Retrospectives

Location: `thoughts/project/retrospectives/`

- **[YYYY-MM-DD-retrospective.md](thoughts/project/retrospectives/)** - Project retrospectives
  - What went well
  - What didn't go well
  - Process improvements
  - Key learnings

### Archive

Location: `thoughts/project/archive/`

- **[Old or outdated documentation](thoughts/project/archive/)** - Superseded documents

---

## User Documentation

Location: `docs/user/` (if applicable to your project)

### Quick Start (First-Time Experience)
- **[user-quick-start.md](docs/user/user-quick-start.md)** - Bare minimum to run successfully (first time)
  - Human-friendly, easy to follow
  - Step-by-step with expected results
  - Common pitfalls highlighted

### Complete User Documentation
- **[user-guide.md](docs/user/user-guide.md)** - Complete feature documentation
- **[tutorials.md](docs/user/tutorials.md)** - Step-by-step tutorials for common tasks
- **[faq.md](docs/user/faq.md)** - Frequently asked questions
- **[troubleshooting.md](docs/user/troubleshooting.md)** - Common issues and solutions

---

## Administrator Documentation

Location: `docs/admin/` (if applicable to your project)

### Quick Start (First-Time Setup)
- **[admin-quick-start.md](docs/admin/admin-quick-start.md)** - Bare minimum to install/configure (first time)
  - Human-friendly, easy to follow
  - Initial setup and configuration
  - Verification steps

### Complete Administrator Documentation
- **[installation-guide.md](docs/admin/installation-guide.md)** - Detailed installation instructions
- **[configuration-guide.md](docs/admin/configuration-guide.md)** - All configuration options
- **[administration-guide.md](docs/admin/administration-guide.md)** - Day-to-day administration
- **[maintenance-guide.md](docs/admin/maintenance-guide.md)** - Maintenance and updates
- **[backup-recovery.md](docs/admin/backup-recovery.md)** - Backup and disaster recovery
- **[security-hardening.md](docs/admin/security-hardening.md)** - Security best practices
- **[troubleshooting.md](docs/admin/troubleshooting.md)** - Admin-level troubleshooting

---

## Developer/API Documentation

Location: `docs/developer/` (if applicable)

- **[getting-started.md](docs/developer/getting-started.md)** - Developer setup guide
- **[api-reference.md](docs/developer/api-reference.md)** - API documentation
- **[architecture.md](docs/developer/architecture.md)** - System architecture overview
- **[contributing.md](docs/developer/contributing.md)** - How to contribute code

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

### For New Users (First-Time)
1. **START HERE:** [docs/user/user-quick-start.md](docs/user/user-quick-start.md) - Get running in 5-10 minutes
2. [README.md](README.md) - Project overview
3. [docs/user/user-guide.md](docs/user/user-guide.md) - Complete feature documentation

### For New Administrators (First-Time Setup)
1. **START HERE:** [docs/admin/admin-quick-start.md](docs/admin/admin-quick-start.md) - Install and configure in 15-20 minutes
2. [docs/admin/installation-guide.md](docs/admin/installation-guide.md) - Detailed installation
3. [docs/admin/configuration-guide.md](docs/admin/configuration-guide.md) - All configuration options

### For Developers
1. [CLAUDE.md](CLAUDE.md) - Project conventions
2. [thoughts/project/reference/system-architecture.md](thoughts/project/reference/system-architecture.md) - Architecture
3. [thoughts/project/reference/coding-standards.md](thoughts/project/reference/coding-standards.md) - Code standards
4. [thoughts/framework/process/kanban-workflow.md](thoughts/framework/process/kanban-workflow.md) - Workflow
5. [PROJECT-STATUS.md](PROJECT-STATUS.md) - Current status

### For Contributors
1. [CONTRIBUTING.md](CONTRIBUTING.md) - How to contribute
2. [thoughts/framework/process/version-control-workflow.md](thoughts/framework/process/version-control-workflow.md) - Git workflow
3. [CHANGELOG.md](CHANGELOG.md) - Version history

### For AI Assistants (Claude)
1. [CLAUDE.md](CLAUDE.md) - Primary instructions
2. [../CLAUDE.md](../CLAUDE.md) - Generic framework (if exists)
3. [thoughts/framework/](thoughts/framework/) - All framework docs
4. [thoughts/project/reference/](thoughts/project/reference/) - Project references

---

## Document Types by Purpose

### Status & Planning
- PROJECT-STATUS.md - Current state
- roadmap.md - Future vision
- planning/backlog/* - Planned work
- work/todo/* - Committed work

### Process & Standards
- CLAUDE.md - Project conventions
- thoughts/framework/process/* - Workflows
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
grep -r "FEAT-002" thoughts/
```

**Find all ADRs:**
```bash
ls thoughts/project/research/adr/
```

**Find recent session histories:**
```bash
ls -t thoughts/project/history/*SESSION-HISTORY.md | head -5
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
