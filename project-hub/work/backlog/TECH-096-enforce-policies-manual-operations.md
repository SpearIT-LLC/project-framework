# Tech Debt: Enforce Workflow Policies for Manual Operations

**ID:** TECH-096
**Type:** Tech Debt
**Priority:** Low
**Version Impact:** MINOR
**Created:** 2026-01-29
**Theme:** Workflow

---

## Summary

TECH-094 implemented three-layer enforcement (fw-move, templates, pre-commit hook) that only applies when Claude performs operations. Manual git commits and file moves bypass all validation. Explore options for enforcing policies when users operate directly without Claude assistance.

---

## Problem Statement

**What is the current state?**

The enforcement system implemented in TECH-094:
- **Layer 1 (fw-move):** Only runs when user invokes `/fw-move` command through Claude
- **Layer 2 (Templates):** Only guides Claude's implementation, not manual work
- **Layer 3 (Hook):** Claude Code PreToolUse hook that only intercepts Claude's Bash tool usage

**Manual Operations Bypass All Enforcement:**
```bash
# User commits manually (no Claude) - Hook does NOT run
git commit -m "Complete FEAT-042"

# User moves work item manually - No fw-move validation
mv work/doing/FEAT-042.md work/done/
git add .
git commit -m "move item"
```

**Why is this a problem?**

- Users can commit invalid work items to done/ without Status/Completed fields
- Work items can be moved without checking dependencies or WIP limits
- No validation when Claude is unavailable (token limits, offline)
- Inconsistent enforcement based on whether Claude or human performs operation
- Framework relies on AI assistance for quality gates

**Who is affected?**

- Solo developers who sometimes commit manually
- Teams with mix of Claude and manual workflows
- Projects that hit Claude token limits mid-day
- Anyone troubleshooting without AI assistance

**What is the desired state?**

Policies enforced consistently regardless of whether Claude or human performs the operation.

---

## Proposed Solution

### Research Options

**Option 1: Convert to Native Git Hooks**
- Install `.claude/hooks/Validate-WorkItems.ps1` as `.git/hooks/pre-commit`
- Pros: Runs for all commits (manual and Claude)
- Cons: `.git/hooks/` not tracked in git, requires per-user setup, different input format

**Option 2: Use core.hooksPath**
```bash
git config core.hooksPath .claude/hooks
```
- Points git to tracked hooks directory
- Pros: Hooks tracked in repo, applies to all commits
- Cons: Requires one-time setup per user, PowerShell script needs dual-mode support

**Option 3: Pre-commit Framework**
- Use https://pre-commit.com/ for portable, cross-platform hooks
- Pros: Standard tool, handles installation, supports multiple languages
- Cons: Additional dependency, YAML configuration, Python requirement

**Option 4: Hybrid Approach**
- Keep Claude Code hook for Claude operations
- Add optional native git hook for manual operations
- Document in setup guide as recommended but not required
- Pros: Flexible, no breaking changes
- Cons: Dual maintenance, users may skip setup

**Option 5: Accept Limitation**
- Document that enforcement only applies to Claude operations
- Add "Known Limitations" section to documentation
- Treat manual operations as "expert mode" - user responsibility
- Pros: No additional work, clear expectations
- Cons: Policies not universally enforced

### Recommendation

Start with **Option 5** (document limitation) + **Option 4** (optional native hook):

1. Add "Known Limitations" section to documentation
2. Create optional setup script for native git hook
3. Document manual verification checklist for manual commits
4. Consider native hooks in future if usage patterns show need

---

## Acceptance Criteria

- [ ] Research completed: Evaluated all options with pros/cons
- [ ] Recommendation documented with rationale
- [ ] Known Limitations section added to appropriate docs
- [ ] Optional native git hook implementation (if pursuing hybrid approach)
- [ ] Setup documentation for native hook (if applicable)
- [ ] Manual operation checklist documented (if staying Claude-only)

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
<!-- User can say "continue to completion" to approve remaining steps at once. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED**
  - AI presents: Research findings, trade-offs, recommended approach
  - User explicitly approves before proceeding

- [ ] Research all options thoroughly
- [ ] Create recommendation with clear rationale
- [ ] Add Known Limitations section to docs
- [ ] Implement chosen approach
- [ ] Update documentation
- [ ] CHANGELOG.md updated
- [ ] Acceptance criteria verified

---

## Notes

**Origin:** Discovered during TECH-094 testing when questioning what happens if user commits manually without Claude.

**Key Insight:** Framework is primarily AI-assisted. Manual operations as "expert mode" may be acceptable trade-off vs complexity of native hooks.

**Documentation Locations to Consider:**
- `README.md` - High-level limitations
- `QUICK-START.md` - Known issues section
- `framework/docs/collaboration/workflow-guide.md` - Detailed enforcement explanation
- `framework/CLAUDE.md` - AI-specific context

---

## Related

- TECH-094 - Implemented Claude-based enforcement system
- `.claude/hooks/Validate-WorkItems.ps1` - Current hook implementation
- `.claude/settings.json` - Hook configuration

---

**Last Updated:** 2026-01-29
