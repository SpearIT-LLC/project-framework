# Collaboration Documentation

**Purpose:** Universal collaboration guides for all contributors (human and AI)
**Last Updated:** 2025-12-22

---

## Quick Navigation

### For AI Assistants

**Read these docs proactively when:**

- **Starting any work** → [Workflow Guide](workflow-guide.md)
- **Writing code** → [Code Quality Standards](code-quality-standards.md)
- **Creating tests** → [Testing Strategy](testing-strategy.md)
- **Handling user input or security** → [Security Policy](security-policy.md)
- **Understanding the framework** → [Architecture Guide](architecture-guide.md)
- **Encountering problems** → [Troubleshooting Guide](troubleshooting-guide.md)

**Reading Protocol:**
1. **CLAUDE.md first** - Quick reference and critical rules
2. **Specific collaboration doc when needed** - Detailed guidance
3. **Templates for implementation** - Copy-paste starting points

### For Human Contributors

Browse the guides below based on what you need. Each guide is comprehensive and includes examples.

---

## Available Guides

### [Workflow Guide](workflow-guide.md)
**962 lines | Comprehensive workflow documentation**

**When to read:**
- Starting work on the project
- Creating features, ADRs, or work items
- Understanding development phases
- Learning git workflow
- Documenting work

**Contents:**
- Development Workflow Phases (Research → Define → Plan → Code → Release)
- Research Phase Guidelines
- Planning Guidelines
- Documentation Standards
- Session History
- Git Workflow (branches, commits, PRs)
- Architecture Decision Records (ADRs)
  - When to create
  - MAJOR vs MINOR template selection
  - Upgrading process
  - Lifecycle
- Collaboration Practices
- Communication Best Practices

---

### [Code Quality Standards](code-quality-standards.md)
**517 lines | Coding standards and best practices**

**When to read:**
- Before writing any code
- During code reviews
- When refactoring
- Setting up new project

**Contents:**
- Clean Code Principles (DRY, Single Responsibility, KISS)
- Code Organization (structure, module design)
- Naming Conventions (variables, functions, classes, files)
- Function Design (size, parameters, return values)
- Error Handling (fail fast, graceful degradation, logging)
- Comments and Documentation (when, how, quality)
- Code Review Standards (checklists, feedback)

**Key Examples:**
- DRY principle with before/after code
- Fail fast error handling patterns
- Naming conventions for different languages
- Function size and complexity guidelines

---

### [Testing Strategy](testing-strategy.md)
**639 lines | Comprehensive testing guidance**

**When to read:**
- Before writing tests
- Implementing new features (TDD)
- Fixing bugs
- Setting up test infrastructure

**Contents:**
- Testing Philosophy
- Test-Driven Development (TDD)
  - Red-Green-Refactor cycle
  - When to use TDD
  - Detailed example walkthrough
- Coverage Targets by component type
- Test Organization (file structure, naming)
- Test Types (Unit, Integration, E2E)
- Edge Case Testing
  - Empty/null inputs
  - Boundary values
  - Invalid states
  - Concurrency issues
  - Fail fast principle
- Test Quality Standards (FIRST principles)
- Testing Best Practices
  - AAA pattern
  - Mocking dependencies
  - Test data management
  - Setup and teardown
- Common Testing Patterns

**Key Examples:**
- Complete TDD cycle for calculateTotal function
- Edge case testing with code examples
- Mocking external dependencies
- Parameterized tests

---

### [Security Policy](security-policy.md)
**758 lines | Security best practices and vulnerability prevention**

**When to read:**
- Handling user input
- Implementing authentication
- Working with databases
- Creating APIs
- Before releasing to production

**Contents:**
- Security Philosophy (defense in depth, fail securely)
- Input Validation
  - Allowlist vs blocklist
  - Common validation patterns
  - File upload validation
  - Input sanitization
- Authentication & Authorization
  - Password hashing (bcrypt)
  - Password requirements
  - Account lockout
  - Rate limiting
  - Authorization checks
- Database Security
  - SQL injection prevention
  - Parameterized queries
  - Connection security
- XSS Prevention
  - Types of XSS
  - Output encoding
  - HTML sanitization
  - Content Security Policy
- CSRF Prevention
  - Token-based protection
  - SameSite cookies
- Dependency Management
- Secrets Management
- API Security
- Session Management
- OWASP Top 10 Checklist
- Security Testing

**Key Examples:**
- SQL injection attack scenarios with prevention
- XSS attack examples with fixes
- Password validation with strength requirements
- CSRF protection implementation

---

### [Architecture Guide](architecture-guide.md)
**548 lines | Framework architecture and design decisions**

**When to read:**
- Understanding the framework
- Choosing framework level for new project
- Contributing to framework
- Making architectural decisions

**Contents:**
- Framework Overview
  - What it is
  - Core problem solved
  - Core principles
- Multi-Level Design Philosophy
  - Minimal Framework (2 files, scripts)
  - Light Framework (7 files, small tools)
  - Standard Framework (50+ files, applications)
  - Selection matrix
- Folder Structure Architecture
  - thoughts/ folder concept
  - Separation: project/ vs framework/
  - Collaboration folder architecture
- File-Based Kanban Design
  - Why file-based
  - Workflow architecture
  - WIP limit enforcement
- Template System Architecture
  - Template philosophy
  - Template categories
  - Naming conventions
- Documentation Hierarchy
  - Core documentation files
  - Hierarchical documentation strategy
  - AI Reading Protocol
- AI Integration Architecture
  - CLAUDE.md as collaboration contract
  - AI Workflow Checkpoint Policy (ADR-001)
  - Session history architecture
- Design Decisions & Rationale
  - Folder-based kanban
  - Multi-level framework
  - Universal collaboration docs
  - Hierarchical documentation
  - WIP limits
  - Separation of concerns

**Key Insights:**
- Why framework scales from scripts to applications
- Rationale for file-based workflow
- How hierarchical documentation optimizes AI context
- Universal docs vs AI-specific docs decision

---

### [Troubleshooting Guide](troubleshooting-guide.md)
**547 lines | Common issues and solutions**

**When to read:**
- Something isn't working
- Framework setup problems
- Workflow violations
- Git issues
- Version sync problems

**Contents:**
- Quick Diagnostics (health check commands)
- Common Framework Issues
  - Folder structure problems
  - WIP limit violations
  - Work items in wrong folder
- Workflow Problems
  - ADR-001 violations
  - Forgot version update on release
  - Work items not archived
- Git Issues
  - Merge conflicts in docs
  - Wrong branch commits
  - Lost work recovery
- Template Usage Errors
  - Modified template instead of instance
  - Missing required sections
- Version Sync Issues
- AI Collaboration Issues
  - AI not following CLAUDE.md
  - AI not finding collaboration docs
- When Things Go Wrong
  - General troubleshooting process
  - Emergency recovery steps

**Key Resources:**
- Diagnostic bash commands
- Recovery procedures
- Prevention strategies

---

## Documentation Hierarchy

```
CLAUDE.md (Quick Reference)
    ↓ links to
collaboration/ (Detailed Guides) ← YOU ARE HERE
    ↓ links to
thoughts/framework/templates/ (Copy-paste Examples)
```

**Strategy:**
- **CLAUDE.md** - Concise, always-loaded reference (~400-500 lines)
- **collaboration/** - Comprehensive guides with examples (~3,500 lines total)
- **templates/** - Copy-paste starting points for work items

**Benefits:**
- AI doesn't load all details unless needed
- Humans can deep-dive into specific topics
- Single source of truth (no duplication)
- Scales as project grows

---

## Contributing to Collaboration Docs

### When to Update

**Add to existing guide when:**
- Found better way to do something
- Encountered edge case not documented
- Have clearer example
- Fixed common mistake

**Create new guide when:**
- Topic doesn't fit existing guides
- Specialized domain (performance, deployment, etc.)
- New framework feature requires guidance

### Update Process

1. **Make changes** to appropriate guide
2. **Update "Last Updated" date** in that guide
3. **Update this README** if adding new guide or major restructure
4. **Update CLAUDE.md** if quick reference section needs to change
5. **Test** - Can AI find and use the guidance?
6. **Commit** with clear message describing what changed

### Style Guidelines

**Consistency:**
- Use same headers structure (Table of Contents, sections, Related Documentation)
- Include code examples where helpful
- Provide both good and bad examples
- Link to related docs

**Audience:**
- Write for both humans and AI
- Be explicit, not implicit
- Use checklists and decision trees
- Include rationale, not just rules

**Quality:**
- Tested examples (code actually works)
- Clear explanations
- Searchable keywords
- Maintained over time

---

## Quick Reference: When to Read What

### AI Reading Decision Tree

```
Starting work?
├─ Need workflow process? → workflow-guide.md
├─ Need coding standards? → code-quality-standards.md
├─ Need to write tests? → testing-strategy.md
├─ Need security guidance? → security-policy.md
└─ Need to understand framework? → architecture-guide.md

Encountering problem?
└─ troubleshooting-guide.md

Making architectural decision?
├─ Need ADR guidance? → workflow-guide.md (ADR section)
└─ Need framework context? → architecture-guide.md

Reviewing code?
├─ code-quality-standards.md
├─ security-policy.md
└─ testing-strategy.md
```

### Human Learning Path

**New to Framework:**
1. Start with [Architecture Guide](architecture-guide.md) - understand the framework
2. Read [Workflow Guide](workflow-guide.md) - learn the process
3. Skim other guides - know what exists

**Contributing Code:**
1. [Code Quality Standards](code-quality-standards.md) - before writing
2. [Testing Strategy](testing-strategy.md) - while writing
3. [Security Policy](security-policy.md) - when handling input/auth/data

**Problem Solving:**
1. [Troubleshooting Guide](troubleshooting-guide.md) - first stop
2. Specific guide based on problem area
3. Create issue if not documented

---

## Document Statistics

| Guide | Lines | Focus |
|-------|-------|-------|
| Workflow Guide | 962 | Process, ADRs, Git, Documentation |
| Code Quality Standards | 517 | Clean code, naming, error handling |
| Testing Strategy | 639 | TDD, coverage, edge cases |
| Security Policy | 758 | Input validation, auth, vulnerabilities |
| Architecture Guide | 548 | Framework design, decisions |
| Troubleshooting Guide | 547 | Diagnostics, recovery, solutions |
| **Total** | **3,971 lines** | **Comprehensive collaboration documentation** |

---

**Related Documentation:**
- [CLAUDE.md](../../../CLAUDE.md) - AI collaboration contract and quick reference
- [thoughts/framework/templates/](../../framework/templates/) - Copy-paste templates
- [PROJECT-STATUS.md](../../../PROJECT-STATUS.md) - Current version and status

---

**Last Updated:** 2025-12-22
**Maintained By:** Framework Team
