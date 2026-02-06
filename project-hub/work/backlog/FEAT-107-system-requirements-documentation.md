# Feature: System Requirements Documentation

**ID:** FEAT-107
**Type:** Feature
**Priority:** High
**Version Impact:** PATCH
**Created:** 2026-02-04
**Theme:** Distribution & Onboarding
**Planning Period:** Sprint D&O 1

---

## Summary

Create clear system requirements/prerequisites documentation that accurately describes what users need to use the SpearIT Project Framework, including the AI assistant dependency discovered during FEAT-095.

---

## Problem Statement

**What problem does this solve?**

Users don't know what they need before attempting to use the framework:
- AI assistant requirement not documented (discovered during FEAT-095 positioning work)
- No clear list of required vs optional tools
- Operating system compatibility not stated
- Missing guidance on setup prerequisites

**Current state:**
- No system requirements section in README, QUICK-START, or setup docs
- AI dependency implied but not explicitly stated
- PowerShell-based scripts assume Windows without documenting this

**Who is affected?**
- New users attempting to adopt the framework
- Users on non-Windows systems (currently limited support)
- Users without Git or AI assistant access

**Current workaround (if any):**
- Users discover requirements through trial and error
- No clear documentation to reference before download

---

## Requirements

### Functional Requirements

**System Requirements to Document:**

**Required:**
- [ ] AI coding assistant (Claude Code, Claude API, or compatible)
  - Why required: Framework designed for AI collaboration (skills, hooks, strategic guidance)
  - Minimum: Supports Claude Code skills and markdown file operations
- [ ] Git (version control)
  - Why required: Work item management uses `git mv`, version control built-in
  - Minimum version: Git 2.x+
  - **Branch requirement:** Repository must use "main" as primary branch
    - Why: Eliminates tension between documentation, scripts, and actual repo state
    - Migration: Setup script provides automated migration helper for "master" → "main"
- [ ] Scripting environment
  - Current: PowerShell 5.1+ (Windows)
  - Planned: Bash or Python (Unix/Mac - FUTURE)
- [ ] Text editor
  - Why required: Markdown files are the core data format
  - Examples: VS Code, Vim, Sublime Text, any markdown-capable editor

**Optional:**
- [ ] VS Code (recommended for IDE integration with Claude Code)
- [ ] Terminal/command prompt (for script execution)

**Operating System:**
- [ ] Currently supported: Windows (PowerShell-based)
- [ ] Planned support: Unix/Mac (requires cross-platform scripting - see roadmap)
- [ ] Note: File-based workflow is OS-agnostic, only scripts are platform-specific

### Prerequisite Validation (Setup Script)

- [ ] Setup-Framework.ps1 validates prerequisites before proceeding:
  - [ ] Git installed and accessible (minimum 2.x)
  - [ ] PowerShell version adequate (minimum 5.1)
  - [ ] Branch name is "main" (or offer migration)
  - [ ] Git user configured (user.name, user.email)
- [ ] Clear, actionable error messages:
  - [ ] "Git not found. Install from https://git-scm.com/"
  - [ ] "PowerShell 4.0 detected. Framework requires 5.1+"
  - [ ] Include links to installation/upgrade guides
- [ ] Success confirmation when all prerequisites met
- [ ] Option to skip checks (--skip-prereq-check) for advanced users

### Non-Functional Requirements

- [ ] Clear: No ambiguity about what's required vs optional
- [ ] Honest: Don't oversell compatibility (document current Windows focus)
- [ ] Helpful: Explain WHY each requirement exists
- [ ] Forward-looking: Mention planned cross-platform support

---

## Design

### Open Question: Where Should Requirements Documentation Live?

**Options to evaluate:**

**Option A: README.md (Root)**
- Location: Before "Quick Start" section
- Pros: First thing users see, highly visible
- Cons: Clutters main README

**Option B: QUICK-START.md**
- Location: At the very top, before any instructions
- Pros: Logical place (users check before starting), doesn't clutter README
- Cons: Might be missed if users skip straight to README

**Option C: Dedicated SYSTEM-REQUIREMENTS.md**
- Location: New file in root or docs/
- Pros: Detailed, referenceable, doesn't clutter other docs
- Cons: Might be missed, requires linking from README and QUICK-START

**Option D: Distribution Package (INSTALL.md or similar)**
- Location: In the distribution ZIP
- Pros: User sees it immediately after download
- Cons: Not visible before download

**Option E: Multiple Locations (Recommended)**
- Brief mention in README.md (1-2 lines with link)
- Full list in QUICK-START.md (top of file)
- Detailed explanation in distribution package
- Reference from setup scripts

**Decision needed:** Which option(s) to implement?

### Proposed Content Structure

```markdown
## System Requirements

**Required:**
- **AI Coding Assistant** - Claude Code or compatible AI assistant
  - Framework is designed for AI collaboration (skills, roadmaps, strategic guidance)
  - See [AI assistant setup guide](link) for configuration
- **Git 2.x+** - Version control system
  - Work item management and history tracking use Git
  - Repository must use "main" as primary branch (setup script assists with migration)
- **PowerShell 5.1+** (Windows) - Scripting environment
  - Cross-platform support (Bash/Python) planned for future release
- **Text Editor** - Any markdown-capable editor
  - Recommended: VS Code (integrates with Claude Code)

**Optional:**
- VS Code with Claude Code extension (recommended for best experience)
- Windows Terminal (improved PowerShell experience)

**Operating System:**
- Currently supported: Windows (PowerShell-based scripts)
- Planned: Unix/Mac support via Bash or Python (see roadmap)
- Note: File-based workflow works on any OS; scripts are platform-specific

**Not Required:**
- No databases (all data in markdown files)
- No external project management tools (Jira, Trello, Asana, etc.)
- No cloud services (everything is local)
```

---

## Acceptance Criteria

- [ ] System requirements section created with clear required/optional breakdown
- [ ] AI assistant requirement explicitly documented with rationale
- [ ] Operating system compatibility honestly stated (Windows current, Unix planned)
- [ ] Explanations provided for WHY each requirement exists
- [ ] Positioned in logical location(s) (per design decision)
- [ ] Referenced from README and QUICK-START
- [ ] Included in distribution package
- [ ] Synced to starter template
- [ ] Setup script validates prerequisites before proceeding
  - [ ] Checks Git installation and version (2.x+)
  - [ ] Checks PowerShell version (5.1+)
  - [ ] Checks branch name ("main" requirement)
  - [ ] Clear error messages if requirements not met
  - [ ] Links to installation guides for missing tools

---

## Dependencies

**Requires:**
- DECISION-105: Approved positioning statements (AI collaboration partner)

**Related:**
- TECH-106: Will update README/QUICK-START (can include requirements section)
- Sprint D&O 1: Setup and installation focus

---

## Open Questions

### 1. Documentation Location

**Question:** Where should system requirements documentation live?

**Options:**
- Brief in README, full in QUICK-START (Option E recommended)
- Dedicated file (SYSTEM-REQUIREMENTS.md)
- Distribution package only
- Multiple locations with links

**Decision:** TBD during implementation

### 2. AI Assistant Compatibility

**Question:** Which AI assistants should we claim compatibility with?

**Context:**
- Framework was designed with Claude Code
- Skills use markdown format (potentially portable)
- Hooks are PowerShell/Bash (AI-agnostic)

**Options:**
- A: "Claude Code only" (most honest, most restrictive)
- B: "Claude Code or compatible AI coding assistant" (current wording, flexible)
- C: List specific compatible assistants (requires testing)

**Decision:** Recommend Option B until tested with other assistants

### 3. Git Requirement

**Question:** Should we document minimum Git version?

**Context:**
- Framework uses basic Git commands (mv, add, commit, log)
- Most Git 2.x+ versions should work

**Decision:** Specify Git 2.x+ (safe baseline)

### 4. Git Branch Naming Requirement

**Question:** Should framework require "main" as primary branch, or support arbitrary branch names?

**Context:**
- Discovered in FEAT-011 validation: hello-father project initially had "master" branch
- Supporting arbitrary branch names creates ongoing tension:
  - Documentation must use variables ("your primary branch") instead of concrete examples
  - Every script must look up branch name (performance overhead)
  - Skills must parameterize all git commands
  - Users must mentally translate documentation to their branch name
- Modern standard: GitHub, GitLab, Bitbucket all default to "main" since 2020-2021

**Options Evaluated:**
- A: Support arbitrary branch names (auto-detect from `framework.yaml` or git)
  - Pros: Maximum flexibility, no migration needed
  - Cons: Ongoing complexity, performance overhead, unclear documentation
- B: Require "main" branch with migration helper (SELECTED)
  - Pros: Zero ongoing tension, clear docs, standard git usage, aligns with industry
  - Cons: One-time migration needed (30 seconds)
- C: Support whitelist (main, master, develop)
  - Pros: Handles common cases
  - Cons: Still creates tension, just for fewer branches

**Decision (2026-02-06):** Require "main" branch with automated migration helper
- Setup-Framework.ps1 detects branch name on initialization
- If not "main", prompts user to migrate with one-click option
- Clear error if user declines migration
- Document as hard requirement in system requirements
- Rationale: One-time 30-second migration cost vs perpetual complexity/overhead

### 5. Prerequisite Validation Scope

**Question:** How comprehensive should the setup script's prerequisite checking be?

**Context:**
- Discovered in FEAT-011: Need to validate requirements before setup
- Prevents confusing errors mid-setup
- Better user experience (fail fast with clear guidance)

**What to check:**

**Critical (must validate):**
- Git installed and version 2.x+
- PowerShell version 5.1+
- Branch name is "main" (or offer migration)

**Helpful (should validate):**
- Git user configured (user.name, user.email)
- Repository initialized (or offer to init)

**Optional (nice to have):**
- AI assistant detection (how? check for Claude Code?)
- VS Code installed
- Disk space available

**Decision:** Validate critical + helpful, skip optional
- Critical checks block setup (hard requirement)
- Helpful checks warn but allow continuation
- Optional checks not implemented (too complex, low value)

**Error Message Strategy:**
```
❌ Prerequisites not met:
   - Git not found. Install: https://git-scm.com/
   - PowerShell 4.0 detected (need 5.1+). Upgrade: https://...

Setup cancelled. Fix prerequisites and retry.
```

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- System requirements documentation
  - Required: AI coding assistant, Git 2.x+ with "main" branch, PowerShell (Windows)
  - Optional: VS Code, Windows Terminal
  - Operating system compatibility clearly stated
  - Rationale provided for each requirement
  - Git "main" branch requirement with migration helper in setup script
- Prerequisite validation in Setup-Framework.ps1
  - Checks Git installation and version before proceeding
  - Validates PowerShell version (5.1+)
  - Verifies "main" branch or offers migration
  - Clear error messages with installation links
```

---

## Notes

**Why This Matters:**

Discovered during FEAT-095 that the framework's AI dependency was not explicitly documented. Saying "AI collaboration partner" in positioning implies AI is needed, but never states "you must have Claude Code or compatible assistant."

**Key Insight from FEAT-095:**
Version 2 positioning originally said "without requiring external services" which was technically false (AI assistant IS an external service). Fixed to say "no project management tools or databases required" but this exposed the gap: we don't document what IS required.

**Sprint D&O 1 Alignment:**
This work supports the Distribution & Onboarding theme's goal of creating a clear, positive first-time user experience. Users shouldn't discover requirements through trial and error.

---

**Last Updated:** 2026-02-06
