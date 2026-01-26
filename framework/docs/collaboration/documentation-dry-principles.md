# Documentation DRY Principles

**Purpose:** Guidelines for avoiding duplication and maintaining single sources of truth in documentation
**Last Updated:** 2026-01-26

---

## Table of Contents

1. [Core Principles](#core-principles)
2. [What Is a Source of Truth](#what-is-a-source-of-truth)
3. [Acceptable vs Problematic Duplication](#acceptable-vs-problematic-duplication)
4. [Update Process](#update-process)
5. [Cross-Cutting Concerns](#cross-cutting-concerns)
6. [Implementation Guidance](#implementation-guidance)

---

## Core Principles

### 1. Single Source of Truth

Every policy, process, concept, or specification should have **ONE authoritative document**.

**Why:** When information exists in multiple places, updates get applied inconsistently, leading to contradictions that confuse both humans and AI.

### 2. Reference, Don't Duplicate

Other documents should **link to** the source of truth, not copy the information.

**Why:** Links are maintenance-free. Copied content becomes stale.

### 3. Acceptable Summaries

Brief summaries are OK **if they link to the authoritative source**.

**Why:** Context helps readers understand why they should follow a link. The summary should be short enough that it won't become stale quickly.

### 4. Clear Attribution

When referencing information, always link to its source.

**Why:** Readers need to know where to find complete, current information.

### 5. Reference with Purpose

Only add links when the reader would benefit from following them. Tangential or "see also" links add clutter without value.

**Why:** Reflexive linking creates noise that obscures genuinely useful references.

**Test before adding a reference:**
- Would the reader need this information to understand or act on what they're reading?
- Would they be confused or blocked without it?

If no to both, skip the link.

---

## What Is a Source of Truth

A **source of truth** is the single authoritative location for a piece of information.

### Identifying Source of Truth

| Information Type | Source of Truth Location |
|-----------------|-------------------------|
| Workflow process | `docs/collaboration/workflow-guide.md` |
| Release process | `docs/process/version-control-workflow.md` |
| Issue response process | `docs/process/version-control-workflow.md` |
| Code standards | `docs/collaboration/code-quality-standards.md` |
| Security policy | `docs/collaboration/security-policy.md` |
| Testing approach | `docs/collaboration/testing-strategy.md` |
| Architecture decisions | `thoughts/adr/` (specific ADR file) |
| Work item details | `thoughts/work/` (specific work item file) |
| Project configuration | `framework.yaml` |
| AI collaboration rules | `CLAUDE.md` |
| Session history format | `docs/collaboration/workflow-guide.md` (Session History section) |

### Characteristics of a Good Source of Truth

- **Complete:** Contains all relevant details
- **Maintained:** Has a "Last Updated" date and is actively kept current
- **Discoverable:** Located where readers expect to find it
- **Authoritative:** Clearly marked as the definitive source

---

## Acceptable vs Problematic Duplication

### Acceptable: Brief Summary with Link

```markdown
## Security

Follow input validation rules when handling user data.
See [Security Policy](docs/collaboration/security-policy.md) for complete guidelines.
```

**Why this works:**
- Short summary provides context
- Link points to complete, maintained source
- Reader knows where to find details

### Acceptable: Quick Reference Extract

CLAUDE.md may contain a condensed quick-reference section that extracts key points from detailed guides, **as long as it links to the full source**.

```markdown
## Quick Reference: Git Commits

- Use conventional commit format
- Include ticket ID when applicable

**Full details:** [Workflow Guide - Git Section](docs/collaboration/workflow-guide.md#git-workflow)
```

### Problematic: Full Duplication

```markdown
## Security Policy

### Input Validation
All user input must be validated...
[200 lines of duplicated content]
```

**Why this fails:**
- When source updates, this copy becomes stale
- Readers may not know which version is authoritative
- Maintenance burden doubles

### Problematic: Partial Duplication Without Link

```markdown
## Security

All user input must be validated using allowlist patterns.
Reject unexpected input rather than trying to sanitize it.
Always use parameterized queries for database access.
```

**Why this fails:**
- No link to complete source
- Readers may think this is the complete guidance
- Updates to source won't reach this copy

---

## Update Process

When information needs to change:

### Step 1: Identify the Source of Truth

Find the authoritative document for the information being changed.

### Step 2: Update the Source

Make changes to the source of truth document only.

### Step 3: Verify References

Check documents that reference this information:
- Do summaries still accurately reflect the source?
- Are links still valid?

### Step 4: Update Summaries Only If Needed

If a summary is now misleading, update it minimally. Don't expand summaries into duplicated content.

### Step 5: Update "Last Updated" Date

In the source document, update the date to reflect the change.

---

## Cross-Cutting Concerns

Some topics span multiple documents. Handle these carefully.

### Strategy: Pick One Home

Choose ONE document as the source of truth. Other documents reference it.

**Example:** Session history format
- **Source of truth:** `docs/collaboration/workflow-guide.md` (Session History section)
- **References from:** CLAUDE.md, architecture-guide.md

### Strategy: Link to Related Topics

When a document naturally touches another topic, link rather than explain.

**Example:** In testing-strategy.md
```markdown
## Security Testing

For security-specific testing patterns, see [Security Policy - Testing Section](security-policy.md#security-testing).
```

### When Topics Genuinely Overlap

Sometimes two documents legitimately cover similar ground from different angles.

**Solution:**
1. Each document covers its specific angle
2. Both link to each other
3. Neither tries to be comprehensive about the other's domain

**Example:**
- `code-quality-standards.md` covers error handling patterns
- `security-policy.md` covers security-specific error handling
- Each links to the other for the related perspective

---

## Implementation Guidance

### For New Documentation

1. **Check if source of truth exists** before writing
2. **If it exists:** Link to it, add brief summary if needed
3. **If it doesn't exist:** Create it in the appropriate location
4. **Add to INDEX.md** (when implemented) to register the source

### For Existing Documentation

1. **Audit for duplication** (see TECH-036)
2. **Identify authoritative version** for each duplicated topic
3. **Replace duplicates with links** to the source of truth
4. **Keep summaries short** and always linked

### For CLAUDE.md

CLAUDE.md serves as a quick reference and routing document:
- **Include:** Critical rules, quick reference, links to detailed docs
- **Exclude:** Comprehensive explanations (link to collaboration docs instead)
- **Keep it concise:** Aim for fast AI parsing, not exhaustive coverage

---

## Related Documentation

- [Workflow Guide](workflow-guide.md) - Process documentation (source of truth for workflow)
- [Architecture Guide](architecture-guide.md) - Framework design decisions
- FEAT-031 - INDEX.md registry (future: tracks all sources of truth)
- TECH-036 - Documentation refactoring (future: applies these principles)

---

**Last Updated:** 2026-01-14
