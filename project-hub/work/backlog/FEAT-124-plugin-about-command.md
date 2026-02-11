# Feature: Plugin About Command

**ID:** FEAT-124
**Type:** Feature
**Priority:** Medium
**Created:** 2026-02-11

---

## Summary

Create a `/spearit-framework-light:about` command that displays comprehensive plugin information including branding, version, description, and available commands in a friendly, professional format. This provides users with an easy way to learn what the plugin is and what it can do.

---

## Problem Statement

Users need an accessible way to understand what the SpearIT Framework Light plugin is, what it does, and what commands are available without having to consult external documentation or navigate through help files.

**Context:**
This started as a test feature ("hello plugin") but evolved into a genuinely useful onboarding and reference tool. New users benefit from a welcoming introduction, while existing users get quick access to plugin metadata and capabilities.

**Impact:**
- **New users:** Immediate understanding of plugin purpose and capabilities
- **Existing users:** Quick reference for version info and available commands
- **Support:** Reduces questions about "what does this plugin do?"

---

## Requirements

**Must Have:**
- Context-aware friendly greeting (detects project name, first run vs returning user)
- SpearIT Solutions branding/company name
- Plugin name: "SpearIT Framework Light"
- Plugin version number
- Plugin description (what it does)
- Complete list of available commands
- Professional but friendly tone

**Out of Scope (for this version):**
- Interactive features (keep it informational)
- User configuration/preferences
- Per-user customization
- Command execution from within about page

---

## Proposed Solution

Create `/spearit-framework-light:about` command that outputs a comprehensive, well-formatted "about page" for the plugin.

**Technical Approach:**
- Read plugin metadata from package.json or plugin manifest
- Detect context (project name, user session, etc.) for personalized greeting
- Format output with clear sections: greeting, branding, metadata, commands, links
- Use markdown formatting for readability

**Constraints:**
- Must complete in single output (no multi-turn conversation)
- Should be fast (< 2 seconds, < 1k tokens)
- No external API calls required
- Works offline with local metadata only

---

## Acceptance Criteria

- [ ] Command `/spearit-framework-light:about` executes successfully
- [ ] Displays context-aware greeting (adapts to project/session)
- [ ] Shows "SpearIT Solutions" branding prominently
- [ ] Displays plugin name, version, and description
- [ ] Lists all available plugin commands
- [ ] Uses professional, friendly tone throughout
- [ ] Formatted clearly with markdown (sections, headings, lists)
- [ ] Completes in single output (< 2 seconds)
- [ ] Works without internet connection

---

## Implementation Notes

**Command location:** `plugins/spearit-framework-light/commands/about.md`

**Metadata sources:**
- Plugin version: `plugins/spearit-framework-light/plugin.json` (or equivalent)
- Commands list: Read from `plugins/spearit-framework-light/commands/` directory
- Project context: Available via framework.yaml or session context

**Output format:**
```
[Context-aware greeting]

## About SpearIT Framework Light
[Description]

**Company:** SpearIT Solutions
**Version:** X.X.X

## Available Commands
- /spearit-framework-light:help
- /spearit-framework-light:about
- [etc.]

## Learn More
[Links to docs, if applicable]
```

**Performance consideration:**
- DO NOT spawn Task agents (use direct Glob/Read tools)
- Cache command list if possible
- Keep token usage < 1k

---

## Questions / Open Issues

- Should we detect "first run" and show extended onboarding message?
- Should we include link to GitHub repo or documentation URL?
- What version number format to use (semver)?
- Should we show plugin installation path or just logical info?

---

**Last Updated:** 2026-02-11
**Status:** Backlog
