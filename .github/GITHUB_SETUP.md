# GitHub Community Configuration Guide

This guide documents the manual configuration steps needed to complete the GitHub community setup for the SpearIT Project Framework repository.

---

## Discussion Categories

GitHub Discussions must be configured manually via the GitHub UI.

**To configure:**

1. Navigate to repository **Settings → General**
2. Scroll to **Features** section
3. Enable **Discussions** (if not already enabled)
4. Click **Set up discussions**
5. Create the following categories:

### Recommended Categories

| Category | Type | Description |
|----------|------|-------------|
| **Q&A** | Question/Answer | Ask questions about using the framework or plugin |
| **Ideas** | Open Discussion | Brainstorm feature ideas and enhancements |
| **Show and Tell** | Announcement | Share projects you've built with the framework |
| **General** | Open Discussion | General conversation and community chat |

**Notes:**
- Q&A format allows marking answers as "accepted"
- Let discussions emerge organically - don't pre-populate
- Moderators can convert issues to discussions when appropriate

---

## Labels

Labels help organize and triage issues. Configure via GitHub UI: **Issues → Labels**

### Scope Labels

| Label | Color | Description |
|-------|-------|-------------|
| `plugin` | `#0366d6` | Related to the Plugin (Lightweight Edition) |
| `framework` | `#1d76db` | Related to the Framework (Comprehensive Edition) |
| `documentation` | `#0075ca` | Documentation improvements |
| `tooling` | `#5319e7` | Build scripts, setup tools, development infrastructure |

### Type Labels

| Label | Color | Description |
|-------|-------|-------------|
| `bug` | `#d73a4a` | Something isn't working correctly |
| `enhancement` | `#a2eeef` | New feature or improvement request |
| `question` | `#d876e3` | Question (redirect to Discussions) |

### Status Labels

| Label | Color | Description |
|-------|-------|-------------|
| `needs-triage` | `#fbca04` | New issue requiring maintainer review |
| `waiting-for-feedback` | `#fef2c0` | Blocked waiting for user response |
| `wontfix` | `#ffffff` | Will not be implemented (with explanation) |

### Priority Labels

| Label | Color | Description |
|-------|-------|-------------|
| `critical` | `#b60205` | Breaks core functionality, needs immediate attention |
| `high` | `#d93f0b` | Important but not blocking |
| `medium` | `#fbca04` | Nice to have, standard priority |
| `low` | `#0e8a16` | Low priority, future consideration |

---

## Bulk Label Creation

You can create labels individually via the GitHub UI, or use the GitHub CLI:

```bash
# Scope labels
gh label create plugin --color 0366d6 --description "Related to the Plugin (Lightweight Edition)"
gh label create framework --color 1d76db --description "Related to the Framework (Comprehensive Edition)"
gh label create documentation --color 0075ca --description "Documentation improvements"
gh label create tooling --color 5319e7 --description "Build scripts, setup tools"

# Type labels
gh label create bug --color d73a4a --description "Something isn't working correctly"
gh label create enhancement --color a2eeef --description "New feature or improvement request"
gh label create question --color d876e3 --description "Question (redirect to Discussions)"

# Status labels
gh label create needs-triage --color fbca04 --description "New issue requiring maintainer review"
gh label create waiting-for-feedback --color fef2c0 --description "Blocked waiting for user response"
gh label create wontfix --color ffffff --description "Will not be implemented"

# Priority labels
gh label create critical --color b60205 --description "Breaks core functionality"
gh label create high --color d93f0b --description "Important but not blocking"
gh label create medium --color fbca04 --description "Nice to have, standard priority"
gh label create low --color 0e8a16 --description "Low priority, future consideration"
```

---

## Testing Templates

### Test Bug Report

1. Navigate to [Issues](https://github.com/SpearIT-LLC/project-framework/issues)
2. Click **New Issue**
3. Select **Bug Report**
4. Fill out form and submit
5. Verify all fields appear correctly
6. Close the test issue

### Test Feature Request

1. Navigate to [Issues](https://github.com/SpearIT-LLC/project-framework/issues)
2. Click **New Issue**
3. Select **Feature Request**
4. Fill out form and submit
5. Verify all fields appear correctly
6. Close the test issue

### Test Pull Request Template

1. Create a test branch: `git checkout -b test-pr-template`
2. Make a trivial change (e.g., add comment to README)
3. Push and open a PR
4. Verify template appears in PR description
5. Close the PR without merging
6. Delete the test branch

---

## Maintenance

### Regular Tasks

- **Triage new issues** - Review, label, and respond within 1-2 business days
- **Convert questions to discussions** - If someone files a question as an issue, politely redirect
- **Close stale issues** - If waiting for feedback >30 days with no response
- **Update labels** - Add new labels as patterns emerge

### When to Use Each Channel

**Issues:**
- Bug reports with reproduction steps
- Feature requests with clear use cases
- Documentation improvements

**Discussions:**
- General questions ("How do I...")
- Ideas and brainstorming
- Show and Tell projects
- Community conversation

**Pull Requests:**
- Code contributions (after discussion in issue)
- Documentation fixes
- Bug fixes

---

## Related Files

- [CONTRIBUTING.md](../CONTRIBUTING.md) - Contribution guidelines
- [SUPPORT.md](SUPPORT.md) - Support channels
- [Bug Report Template](ISSUE_TEMPLATE/bug_report.yml)
- [Feature Request Template](ISSUE_TEMPLATE/feature_request.yml)
- [Pull Request Template](pull_request_template.md)

---

**Last Updated:** 2026-02-16
**Status:** Configuration guide for manual GitHub UI setup
