# Architecture Guide

**Audience:** All contributors (human and AI)
**Purpose:** Understanding the Project Framework's architecture and design decisions
**Last Updated:** 2025-12-22

---

## Table of Contents

1. [Framework Overview](#framework-overview)
2. [Multi-Level Design Philosophy](#multi-level-design-philosophy)
3. [Folder Structure Architecture](#folder-structure-architecture)
4. [File-Based Kanban Design](#file-based-kanban-design)
5. [Template System Architecture](#template-system-architecture)
6. [Documentation Hierarchy](#documentation-hierarchy)
7. [AI Integration Architecture](#ai-integration-architecture)
8. [Design Decisions & Rationale](#design-decisions--rationale)

---

## Framework Overview

### What Is the Project Framework?

The **SpearIT Project Framework** is a comprehensive, multi-level project management framework designed to bring structure, consistency, and AI integration to software projects of any size.

**Key Innovation:** Scales from single scripts to full applications using a 3-dimension classification system that selects the appropriate framework level based on:
1. **Scope & Complexity** (Script → Tool → Application → System)
2. **Lifespan & Evolution** (Throwaway → Short-term → Maintained → Critical)
3. **Team & Collaboration** (Solo/Personal → Solo/Professional → Small Team → Large Team)

### Core Problem Solved

**Problem:** Most project frameworks are one-size-fits-all:
- Too heavyweight for simple scripts (discourage good practices)
- Too lightweight for complex projects (lead to chaos)
- No clear upgrade path as projects grow

**Solution:** Tiered framework with explicit upgrade paths:
```
Minimal (2 files) → Light (7 files) → Standard (50+ files)
```

### Core Principles

1. **Right-Sized Structure** - Never pay for more structure than you need
2. **Upgrade Path** - Start small, grow with your project
3. **Single Source of Truth** - No duplicated information
4. **File-Based Simplicity** - Folders and files, no databases or tools required
5. **AI-Native** - Designed for human-AI collaboration
6. **Dogfooding** - Framework uses itself (Standard level)

---

## Multi-Level Design Philosophy

### The Four Framework Levels

#### Minimal Framework (2 files)

**For:** Single scripts, throwaway projects, personal automation

**Structure:**
```
project/
├── README.md          # With embedded "Why This Exists" section
└── script.py          # Your code
```

**Philosophy:**
- Capture the "why" before it's forgotten
- Just enough to hand off to future-you
- No overhead, no ceremony

**When to Use:**
- One-time scripts
- Personal automation
- Proof-of-concepts you'll delete

#### Light Framework (7 files)

**For:** Small tools with medium lifespan, solo professional work

**Structure:**
```
project/
├── README.md
├── PROJECT-STATUS.md      # Version & status
├── CHANGELOG.md           # Version history
├── thoughts/
│   └── project/
│       └── history/       # Decision history
└── src/                   # Your code
```

**Philosophy:**
- Version tracking matters
- Future maintainers need context
- Decisions should be documented
- Still lightweight, no kanban overhead

**When to Use:**
- Tools you'll maintain for months/years
- Solo work that might be handed off
- Projects needing version control discipline

#### Standard Framework (50+ files)

**For:** Applications, small teams, ongoing maintenance

**Structure:**
```
project/
├── Core Documentation (README, STATUS, CHANGELOG, CLAUDE.md)
├── thoughts/
│   ├── project/
│   │   ├── work/          # Kanban workflow (todo/doing/done)
│   │   ├── planning/      # Backlog, roadmap
│   │   ├── research/      # Problem validation, ADRs
│   │   ├── reference/     # Current project docs
│   │   ├── retrospectives/
│   │   ├── history/       # Session history
│   │   └── archive/
│   └── framework/
│       ├── templates/     # 19 reusable templates
│       ├── process/       # Workflow documentation
│       └── patterns/      # Implementation patterns
└── src/                   # Your code
```

**Philosophy:**
- Workflow discipline prevents chaos
- WIP limits enforce focus
- Templates capture best practices
- Research phase prevents wheel reinvention
- AI integration is first-class
- Retrospectives drive improvement

**When to Use:**
- Multi-feature applications
- Small team collaboration (2-5 developers)
- Projects requiring formal planning
- AI-assisted development

### Selection Matrix

| Scope | Lifespan | Team Size | Framework Level |
|-------|----------|-----------|-----------------|
| Script | Throwaway/Short-term | Solo/Personal | **Minimal** |
| Script/Tool | Maintained | Solo/Professional | **Light** |
| Tool/Application | Maintained | Solo/Professional or Small Team | **Standard** |
| Application/System | Maintained/Critical | Small team | **Standard** |

---

## Folder Structure Architecture

### The `thoughts/` Folder Concept

**Why "thoughts"?**
- Project management is capturing and organizing thoughts
- Not code, not deliverables, but thinking artifacts
- Separates "how we work" from "what we deliver"

**Architecture:**
```
thoughts/
├── project/        # Project-specific content (unique per project)
│   ├── work/       # Current work (kanban)
│   ├── planning/   # Future work
│   ├── research/   # Past investigation
│   ├── reference/  # Living docs
│   ├── retrospectives/
│   ├── history/    # Session logs
│   ├── archive/    # Outdated docs
│   └── collaboration/  # Universal collaboration guides
└── framework/      # Reusable across projects
    ├── templates/  # Copy-paste starting points
    ├── process/    # How framework works
    ├── patterns/   # Implementation recipes
    └── tools/      # Scripts, utilities
```

### Separation: Project vs Framework

**Design Decision:** Separate project-specific content from reusable framework

**Benefits:**
- Framework can be updated independently
- Templates don't mix with work items
- Clear what to copy for new projects
- Enables framework reuse across projects

**Example:**
- `thoughts/project/work/doing/feature-020.md` - Specific to THIS project
- `thoughts/framework/templates/FEATURE-TEMPLATE.md` - Reusable for ANY project

### Collaboration Folder Architecture

**Purpose:** Universal collaboration documentation for humans and AI

**Location:** `thoughts/project/collaboration/`

**Contents:**
- `workflow-guide.md` - Complete workflow documentation
- `code-quality-standards.md` - Coding standards and best practices
- `testing-strategy.md` - Testing philosophy and patterns
- `security-policy.md` - Security requirements and examples
- `architecture-guide.md` - This document
- `troubleshooting-guide.md` - Common issues and solutions
- `README.md` - Navigation index

**Design Rationale:**
- **Universal, not AI-specific:** Humans and AI read same docs (single source of truth)
- **Detailed reference:** Comprehensive guidance that would bloat CLAUDE.md
- **Hierarchical documentation:** CLAUDE.md = quick reference, collaboration/ = full details
- **Scalable:** As project grows, add detail to collaboration docs, keep CLAUDE.md concise

---

## File-Based Kanban Design

### Why File-Based?

**Alternatives Considered:**
1. **Database-backed tools** (Jira, Trello, etc.)
2. **File-based kanban** (chosen)
3. **Plain text lists** (too unstructured)

**Why File-Based Won:**
- ✅ Lives with code (same repo)
- ✅ Version controlled (git tracks changes)
- ✅ Works offline
- ✅ AI can read/write directly
- ✅ No external dependencies
- ✅ Simple (just files and folders)
- ✅ Grep/search friendly

**Trade-offs Accepted:**
- ❌ No fancy UI (accepted - simplicity > features)
- ❌ Manual file moves (accepted - keeps it explicit)
- ❌ No automatic notifications (accepted - not needed for small teams)

### Kanban Workflow Architecture

```
planning/backlog/
    feature-001.md         # Future work
    feature-002.md
    ↓
    [User approval checkpoint - ADR-001]
    ↓
work/todo/
    feature-003.md         # Ready to start
    feature-004.md
    ↓
work/doing/
    feature-005.md         # In progress (WIP limit: 2)
    .limit                 # File containing WIP limit
    ↓
work/done/
    feature-006.md         # Complete, awaiting release
    feature-007.md
    ↓
    [Release to version]
    ↓
history/releases/vX.Y.Z/
    feature-006.md         # Archived with release
    feature-007.md
```

### WIP Limit Enforcement

**File:** `thoughts/project/work/doing/.limit`

**Content:** Single number (default: 2)

**Purpose:**
- Enforce focus (don't start too many things)
- Prevent context switching
- Encourage finishing over starting

**Implementation:**
- AI checks folder count before starting work
- Validation script can verify compliance
- Explicit limit file makes it visible

**Rationale:**
- Research shows WIP limits improve throughput
- Forces prioritization
- Reduces half-finished work

---

## Template System Architecture

### Template Philosophy

**Templates as Training Wheels:**
- Capture best practices in copy-paste form
- Lower cognitive load for starting new work
- Ensure consistency across work items

**Not Rigid Forms:**
- Delete sections that don't apply
- Add sections as needed
- Template is starting point, not straightjacket

### Template Categories

**Work Item Templates (8 templates):**
- `FEATURE-TEMPLATE.md` - New features
- `BUGFIX-TEMPLATE.md` - Bug fixes
- `ENHANCEMENT-TEMPLATE.md` - Improvements
- `REFACTOR-TEMPLATE.md` - Code restructuring
- `BLOCKER-TEMPLATE.md` - Blockers and issues
- `SPIKE-TEMPLATE.md` - Investigation work
- `DOCUMENTATION-TEMPLATE.md` - Documentation tasks
- `CHORE-TEMPLATE.md` - Maintenance tasks

**Research Templates (5 templates):**
- `PROBLEM-STATEMENT-TEMPLATE.md` - Define problem
- `LANDSCAPE-ANALYSIS-TEMPLATE.md` - Survey existing solutions
- `FEASIBILITY-TEMPLATE.md` - Can we build this?
- `PROJECT-JUSTIFICATION-TEMPLATE.md` - Should we build this?
- `PROJECT-DEFINITION-TEMPLATE.md` - What are we building?

**ADR Templates (2 templates):**
- `ADR-MAJOR-TEMPLATE.md` - Significant decisions (8 sections)
- `ADR-MINOR-TEMPLATE.md` - Simple decisions (4 sections)

**Other Templates (4 templates):**
- `SESSION-HISTORY-TEMPLATE.md` - Daily work logs
- `RETROSPECTIVE-TEMPLATE.md` - Learning capture
- `ROADMAP-TEMPLATE.md` - Version planning
- `RELEASE-CHECKLIST-TEMPLATE.md` - Release process

### Template Naming Convention

**Format:** `[TYPE]-TEMPLATE.md`

**Why UPPERCASE:**
- Visually distinct from work items
- Easy to identify as templates
- Prevents accidental modification

**Why -TEMPLATE suffix:**
- Obvious purpose
- Search/grep friendly
- Clear separation from instances

---

## Documentation Hierarchy

### Core Documentation Files (Root Level)

**README.md**
- **Audience:** Humans discovering project
- **Purpose:** What, why, how to get started
- **Kept:** High-level overview
- **Detailed info:** Links to thoughts/

**PROJECT-STATUS.md**
- **Audience:** Humans and AI
- **Purpose:** Single source of truth for version and status
- **Content:** Current version, implementation status
- **Updated:** Every release

**CHANGELOG.md**
- **Audience:** Humans tracking changes
- **Format:** Keep a Changelog format
- **Purpose:** Version history
- **Updated:** Every release

**CLAUDE.md**
- **Audience:** AI assistants
- **Purpose:** Collaboration contract, quick reference
- **Strategy:** Keep concise (400-500 lines), link to collaboration/ for details
- **Special:** Contains AI Workflow Checkpoint Policy (ADR-001)

**INDEX.md**
- **Audience:** Humans navigating documentation
- **Purpose:** Table of contents for all docs
- **Updated:** When new docs added

### Hierarchical Documentation Strategy

**Problem:** CLAUDE.md was growing too large (654 lines, 5.1k tokens)

**Solution:** Hierarchical documentation pattern

**Pattern:**
```
CLAUDE.md (Quick Reference)
    ↓ links to
thoughts/project/collaboration/ (Detailed Guides)
    ↓ links to
thoughts/framework/templates/ (Copy-paste Examples)
```

**Example: ADR Documentation**

**Level 1 - CLAUDE.md (Quick Reference):**
```markdown
## Architecture Decision Records (ADRs)

**Quick Decision Tree:**
- Need to document decision? → Create ADR
- Affects 3+ files? → MAJOR template
- Simple 1-2 files? → MINOR template

**Full Details:** See workflow-guide.md
```

**Level 2 - collaboration/workflow-guide.md (Full Guide):**
```markdown
## Architecture Decision Records (ADRs)

### When to Create an ADR
[Detailed criteria with examples]

### MAJOR vs MINOR Template Selection
[Comprehensive decision guide]

### Upgrading MINOR to MAJOR
[Complete process with examples]
```

**Level 3 - framework/templates/ (Templates):**
- `ADR-MAJOR-TEMPLATE.md` - Copy-paste starting point
- `ADR-MINOR-TEMPLATE.md` - Copy-paste starting point

### AI Reading Protocol (Planned)

**Purpose:** Teach AI when to read which collaboration docs

**Location:** CLAUDE.md new section

**Format:** Decision tree
```markdown
## AI Reading Protocol

**Need workflow guidance?** → Read collaboration/workflow-guide.md
**Need coding standards?** → Read collaboration/code-quality-standards.md
**Need testing guidance?** → Read collaboration/testing-strategy.md
**Need security guidance?** → Read collaboration/security-policy.md
**Common problem?** → Read collaboration/troubleshooting-guide.md
```

---

## AI Integration Architecture

### CLAUDE.md as Collaboration Contract

**Philosophy:** CLAUDE.md is the "working contract" between human and AI

**Contents:**
- Critical rules that must be in AI context always
- Project structure (folder tree)
- AI Workflow Checkpoint Policy (ADR-001)
- Quick references with links to detailed docs
- Emergency troubleshooting

**What Doesn't Belong:**
- Detailed explanations (→ collaboration/ docs)
- Examples and rationale (→ collaboration/ docs)
- Copy-paste templates (→ framework/templates/)

### AI Workflow Checkpoint Policy (ADR-001)

**Problem:** AI was implementing features without user approval

**Solution:** Mandatory checkpoint between backlog and implementation

**Workflow:**
```
User Request
    ↓
AI creates feature in backlog
    ↓
AI presents plan
    ↓
AI asks "Should I proceed?"  ⬅️ MANDATORY CHECKPOINT
    ↓
User approves
    ↓
AI moves to todo → doing → implementation
```

**Why This Matters:**
- User maintains control over priorities
- Backlog is "safe space" for ideas
- Clear audit trail of approvals
- Prevents runaway implementation

**Status:** Process-critical, must remain verbatim in CLAUDE.md

### Session History Architecture

**Purpose:** Capture daily work context for future reference

**Format:** One file per day `YYYY-MM-DD-SESSION-HISTORY.md`

**Contents:**
- Summary (what was accomplished)
- Work completed (features, fixes)
- Decisions made
- Blockers encountered
- Next steps
- Metrics (commits, files, lines)

**Why Daily:**
- Natural checkpoint
- Fresh memory
- Matches git commit patterns

**Use Cases:**
- Future developers understanding history
- Retrospectives (review week/month)
- Status reports
- Knowledge transfer

---

## Design Decisions & Rationale

### Decision: Folder-Based Kanban Over External Tools

**Context:** Need to track work items and workflow

**Options:**
1. External tools (Jira, Trello, Asana)
2. File-based kanban in repo
3. Plain text lists (TODO.md)

**Decision:** File-based kanban (Option 2)

**Rationale:**
- Lives with code (single source of truth)
- Version controlled
- AI can manipulate directly
- No external dependencies
- Simple to understand

**Trade-offs:**
- Manual file moves (accepted)
- No fancy UI (accepted)

### Decision: Multi-Level Framework Over One-Size-Fits-All

**Context:** Need framework that works for scripts through full applications

**Options:**
1. Minimal framework for all (too light for complex projects)
2. Full framework for all (too heavy for simple projects)
3. Multi-level framework (chosen)

**Decision:** Multi-level with explicit upgrade paths

**Rationale:**
- Right-sized structure prevents under/over-engineering
- Clear criteria removes guesswork
- Upgrade path accommodates growth
- Proven by dogfooding (framework uses Standard on itself)

### Decision: Universal Collaboration Docs Over AI-Specific

**Context:** Need detailed guidance but CLAUDE.md was growing too large

**Options:**
1. Separate AI-specific docs (ai-collaboration/)
2. Universal docs for humans and AI (collaboration/)

**Decision:** Universal collaboration/ docs (Option 2)

**Rationale:**
- Single source of truth (no duplication)
- Easier maintenance (one set of docs)
- Consistency (humans and AI see same guidance)
- Simpler structure

**Impact:** FEAT-020 implementation strategy changed from creating `ai-collaboration/` to `collaboration/`

### Decision: Hierarchical Documentation Over Monolithic

**Context:** CLAUDE.md at 654 lines approaching context limits

**Options:**
1. Keep all content in CLAUDE.md (too large)
2. Split into many small files (too fragmented)
3. Hierarchical: quick ref + detailed guides (chosen)

**Decision:** Hierarchical documentation pattern

**Rationale:**
- Mirrors human pattern (quick ref + manual)
- Optimizes AI context usage
- Maintains single source of truth
- Scalable as project grows

**Implementation:** FEAT-020 restructuring

### Decision: WIP Limits with .limit File

**Context:** Need to enforce WIP limits in doing/ folder

**Options:**
1. Hardcoded in CLAUDE.md (inflexible)
2. Configuration file (.limit) in doing/ folder (chosen)
3. Count-based with no explicit limit (unclear)

**Decision:** `.limit` file in doing/ folder

**Rationale:**
- Visible (listed in folder)
- Per-project customizable
- AI and scripts can read easily
- Explicit better than implicit

### Decision: Templates in framework/, Work in project/

**Context:** How to organize reusable vs project-specific content

**Decision:** Separate `thoughts/framework/` (reusable) from `thoughts/project/` (specific)

**Rationale:**
- Framework can be updated independently
- Clear what to copy for new projects
- Templates don't clutter work folders
- Enables framework distribution

---

**Related Documentation:**
- [Workflow Guide](workflow-guide.md) - How to use the framework
- [Code Quality Standards](code-quality-standards.md) - Implementation patterns
- [Testing Strategy](testing-strategy.md) - Quality assurance approach

---

**Last Updated:** 2025-12-22
**Maintained By:** Framework Team
