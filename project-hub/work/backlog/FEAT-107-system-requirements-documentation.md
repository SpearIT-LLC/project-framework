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

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- System requirements documentation
  - Required: AI coding assistant, Git 2.x+, PowerShell (Windows)
  - Optional: VS Code, Windows Terminal
  - Operating system compatibility clearly stated
  - Rationale provided for each requirement
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

**Last Updated:** 2026-02-04
