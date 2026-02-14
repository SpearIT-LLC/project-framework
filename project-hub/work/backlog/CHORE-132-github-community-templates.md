# Chore: GitHub Community Templates

**ID:** CHORE-132
**Type:** Chore
**Priority:** Medium
**Created:** 2026-02-13

---

## Summary

Create comprehensive GitHub templates and configuration to support community feedback for the newly published SpearIT Framework plugin and repository. This establishes a professional, welcoming environment for bug reports, feature requests, and community contributions while respecting the "discuss before coding" policy.

---

## Scope

### Issue Templates (.github/ISSUE_TEMPLATE/)

**Bug Report Template:**
- Component dropdown (Plugin Lightweight, Framework Comprehensive, Documentation, Not sure)
- Environment info fields:
  - Plugin version
  - Claude Code version
  - Operating System (Windows/Mac/Linux)
  - Framework version (if applicable)
- Reproduction steps
- Expected vs actual behavior
- Friendly tone matching CONTRIBUTING.md

**Feature Request Template:**
- Component dropdown (same as bug report)
- Use case description
- Proposed solution
- Alternatives considered
- Clear scope (plugin vs framework)

**No question template** - Users will discover Discussions naturally

### Pull Request Template (.github/pull_request_template.md)

- Link to related issue requirement
- Checklist (tests, docs, changelog)
- Confirmation that approach was discussed first
- Reminder of "discuss before coding" policy
- Friendly but clear expectations

### Support Documentation (.github/SUPPORT.md)

- Points users to appropriate channels:
  - Bugs → GitHub Issues
  - Features → GitHub Issues
  - Questions → GitHub Discussions
  - General conversation → GitHub Discussions
- Contact information (Gary Elliott, SpearIT LLC)
- Repository links

### Discussion Categories (Configuration Guide)

**Categories to set up:**
- Q&A (for user questions)
- Ideas (feature brainstorming)
- Show and Tell (user projects)
- General (everything else)

**Note:** No pre-populated content - let users organically create discussions

### Labels (Configuration Guide)

**Scope labels:**
- `plugin` - Plugin-related issues
- `framework` - Full framework issues
- `documentation` - Docs improvements
- `tooling` - Build/setup scripts

**Type labels:**
- `bug` - Something broken
- `enhancement` - Feature request
- `question` - Should redirect to Discussions

**Status labels:**
- `needs-triage` - New issue needs review
- `waiting-for-feedback` - Blocked on user response
- `wontfix` - Won't implement

**Priority labels:**
- `critical` - Breaks functionality
- `high` - Important but not blocking
- `medium` - Nice to have
- `low` - Future consideration

---

## Completion Criteria

- [ ] Bug report template created with component dropdown and minimal env fields
- [ ] Feature request template created with component dropdown
- [ ] Pull request template created with discussion requirement
- [ ] SUPPORT.md created with channel guidance
- [ ] Documentation created for setting up Discussion categories (manual config in GitHub UI)
- [ ] Documentation created for setting up labels (manual config in GitHub UI)
- [ ] All templates match friendly-but-professional tone of CONTRIBUTING.md
- [ ] Templates tested by creating sample issue/PR (then closed)
- [ ] Configuration documentation added to repository docs

---

## Dependencies

None - This is greenfield work

---

## Notes

- Plugin was just submitted to Anthropic marketplace, users may start filing issues soon
- No FAQ or existing issues to redirect to yet - keep templates simple
- Discussion categories can be configured in GitHub UI (Settings → Discussions)
- Labels can be bulk-created via GitHub UI (Issues → Labels → New label)
- Templates should emphasize plugin/framework dual structure

---

**Last Updated:** 2026-02-13
**Status:** Backlog
