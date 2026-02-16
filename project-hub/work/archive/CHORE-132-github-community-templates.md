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

- [x] Bug report template created with component dropdown and minimal env fields
- [x] Feature request template created with component dropdown
- [x] Pull request template created with discussion requirement
- [x] SUPPORT.md created with channel guidance
- [x] Documentation created for setting up Discussion categories (manual config in GitHub UI)
- [x] Documentation created for setting up labels (manual config in GitHub UI)
- [x] All templates match friendly-but-professional tone of CONTRIBUTING.md
- [ ] Templates tested by creating sample issue/PR (then closed) - **Deferred to post-commit**
- [x] Configuration documentation added to repository docs

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

## Implementation Summary

**Completed:** 2026-02-16

### Files Created

1. **`.github/ISSUE_TEMPLATE/bug_report.yml`**
   - Component dropdown (Plugin, Framework, Documentation, Not sure)
   - Environment fields: plugin version, Claude Code version, OS, framework version
   - Structured sections: description, reproduction steps, expected behavior
   - Auto-labels: `bug`, `needs-triage`

2. **`.github/ISSUE_TEMPLATE/feature_request.yml`**
   - Component dropdown (same as bug report)
   - Structured sections: problem/use case, proposed solution, alternatives
   - Auto-labels: `enhancement`, `needs-triage`

3. **`.github/pull_request_template.md`**
   - Related issue requirement (Fixes #)
   - Type of change checklist
   - Standard checklist (tests, docs, changelog)
   - Discussion confirmation requirement
   - Links to CONTRIBUTING.md

4. **`.github/SUPPORT.md`**
   - Channel guidance (Issues for bugs/features, Discussions for questions)
   - Contact information (Gary Elliott, SpearIT LLC)
   - Links to all support channels
   - Response time expectations

5. **`.github/GITHUB_SETUP.md`**
   - Discussion categories configuration guide
   - Labels configuration guide with recommended setup
   - Bulk label creation commands (GitHub CLI)
   - Testing instructions for templates
   - Maintenance guidelines

### Testing Status

Templates will be tested after merge to verify GitHub renders them correctly:
- Create test bug report → verify form → close
- Create test feature request → verify form → close
- Create test PR → verify template → close

### Configuration Tasks (Manual)

After merge, configure via GitHub UI:
1. Enable Discussions (Settings → General → Features)
2. Create 4 discussion categories (Q&A, Ideas, Show and Tell, General)
3. Create labels via UI or GitHub CLI (see GITHUB_SETUP.md)

---

**Last Updated:** 2026-02-16
**Completed:** 2026-02-16
**Status:** Done
