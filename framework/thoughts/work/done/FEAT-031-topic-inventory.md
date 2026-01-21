# FEAT-031 Working File: Topic Source-of-Truth Inventory

**Purpose:** Catalog all major topics and identify authoritative sources before deciding on registry strategy.
**Created:** 2026-01-21
**Status:** Working document

---

## Quick Summary

| Metric | Count |
|--------|-------|
| Major Topics | 26 |
| Authoritative Sources | 12 unique files |
| Templates | 22 |
| Problematic Duplication | None identified |

---

## Authoritative Sources - Compact View

This is the core data that would go into a registry:

| Topic | Authoritative Source | Quick Ref |
|-------|---------------------|-----------|
| Workflow Process | `docs/collaboration/workflow-guide.md#development-workflow-phases` | `CLAUDE.md` |
| Workflow Transitions | `docs/collaboration/workflow-guide.md#workflow-transitions` | `CLAUDE.md` |
| Work Item Numbering | `docs/collaboration/workflow-guide.md#work-item-numbering` | Templates |
| Work Item Templates | `docs/collaboration/workflow-guide.md#work-item-templates` | Templates |
| Git Workflow | `docs/collaboration/workflow-guide.md#git-workflow` | `CLAUDE.md` |
| Versioning & Releases | `docs/collaboration/workflow-guide.md#versioning--releases` | `CLAUDE.md` |
| Code Quality | `docs/collaboration/code-quality-standards.md` | `CLAUDE.md#core-standards-summary` |
| Testing Strategy | `docs/collaboration/testing-strategy.md` | `CLAUDE.md#core-standards-summary` |
| Security Policy | `docs/collaboration/security-policy.md` | `CLAUDE.md#core-standards-summary` |
| Architecture | `docs/collaboration/architecture-guide.md` | `CLAUDE.md#architecture-project-folders` |
| Troubleshooting | `docs/collaboration/troubleshooting-guide.md` | `CLAUDE-QUICK-REFERENCE.md` |
| Documentation Standards | `docs/collaboration/workflow-guide.md#documentation-standards` | - |
| DRY Principles | `docs/collaboration/documentation-dry-principles.md` | - |
| Project Structure | `docs/PROJECT-STRUCTURE-STANDARD.md` | `templates/STRUCTURE.md` |
| AI Collaboration | `CLAUDE.md#ai-reading-protocol` | `CLAUDE-QUICK-REFERENCE.md` |
| AI Roles | `docs/ref/framework-roles.yaml` | `CLAUDE.md#ai-roles` |
| AI Checkpoint Policy | `CLAUDE.md#ai-workflow-checkpoint-policy-critical---adr-001` | `CLAUDE-QUICK-REFERENCE.md` |
| Framework Config | `framework.yaml` + `docs/ref/framework-schema.yaml` | - |
| Session History | `docs/collaboration/workflow-guide.md#session-history` | Template |
| ADR Process | `docs/collaboration/workflow-guide.md#architecture-decision-records-adrs` | `CLAUDE.md#architecture-decision-records-adrs` |
| Research Phase | `docs/collaboration/workflow-guide.md#research-phase` | Templates |
| Planning Guidelines | `docs/collaboration/workflow-guide.md#planning-guidelines` | - |
| Template Selection | `templates/README-TEMPLATE-SELECTION.md` | - |
| New Project Setup | `templates/NEW-PROJECT-CHECKLIST.md` | - |
| CMD/PowerShell Patterns | `docs/patterns/*.md` | Templates |
| Collaboration Practices | `docs/collaboration/workflow-guide.md#collaboration-practices` | `CLAUDE.md#working-with-claude-collaboration-tips` |

---

## Detailed Topic Breakdown

### 1. Workflow Process (Kanban)

**Authoritative:** `framework/docs/collaboration/workflow-guide.md` (962 lines)

Covers:
- Backlog → Todo → Doing → Done lifecycle
- Work item numbering (FEAT-XXX, BUG-XXX, etc.)
- Transition rules and validation
- WIP limits
- Session history format
- ADR lifecycle

**Quick references:**
- `CLAUDE.md` - AI-focused summary
- `.claude/commands/fw-*.md` - Command implementations

**Templates:**
- `templates/work-items/FEATURE-TEMPLATE.md`
- `templates/work-items/BUG-TEMPLATE.md`
- `templates/work-items/TECHDEBT-TEMPLATE.md`
- `templates/work-items/SPIKE-TEMPLATE.md`
- `templates/work-items/DECISION-TEMPLATE.md`

---

### 2. Git & Version Control

**Authoritative:** `framework/docs/process/version-control-workflow.md` (505 lines)

Covers:
- Semantic versioning rules
- Branch strategy
- Commit message format
- Release checklist
- Tag conventions

**Quick references:**
- `CLAUDE.md` - Brief summary

---

### 3. Code Quality Standards

**Authoritative:** `framework/docs/collaboration/code-quality-standards.md` (517 lines)

Covers:
- Clean code principles
- Naming conventions
- Function design (single responsibility, fail-fast)
- Error handling
- Code review standards

**Quick references:**
- `CLAUDE.md` - Section 7

---

### 4. Testing Strategy

**Authoritative:** `framework/docs/collaboration/testing-strategy.md` (639 lines)

Covers:
- TDD methodology
- Coverage targets
- Edge case testing
- Test organization

**Quick references:**
- `CLAUDE.md` - Section 8

---

### 5. Security Policy

**Authoritative:** `framework/docs/collaboration/security-policy.md` (758 lines)

Covers:
- Input validation
- Authentication/authorization
- XSS/CSRF prevention
- Secrets management
- OWASP Top 10

**Quick references:**
- `CLAUDE.md` - Section 8

---

### 6. Architecture

**Authoritative:** `framework/docs/collaboration/architecture-guide.md` (662 lines)

Covers:
- Framework design philosophy
- Folder structure rationale
- AI integration decisions
- File-based kanban design

**Quick references:**
- `CLAUDE.md` - Overview
- `README.md` - Introduction

---

### 7. Troubleshooting

**Authoritative:** `framework/docs/collaboration/troubleshooting-guide.md` (547 lines)

Covers:
- Common issues catalog
- Quick diagnostics
- Version sync issues
- Emergency fixes

**Quick references:**
- `CLAUDE-QUICK-REFERENCE.md` - Critical issues only

---

### 8. Documentation Standards

**Authoritative:** `framework/docs/process/documentation-standards.md`

Covers:
- Markdown formatting
- Document structure
- Header conventions
- Link formatting

**Related:**
- `docs/collaboration/documentation-dry-principles.md` - DRY policy

**Templates:**
- `templates/documentation/README-TEMPLATE.md`
- `templates/documentation/PROJECT-STATUS-TEMPLATE.md`
- `templates/documentation/CHANGELOG-TEMPLATE.md`
- `templates/documentation/INDEX-TEMPLATE.md`
- `templates/documentation/CLAUDE-TEMPLATE.md`
- `templates/documentation/session-history-template.md`

---

### 9. Project Structure

**Authoritative:** (by level)
- Standard: `docs/PROJECT-STRUCTURE-STANDARD.md`
- Light: `docs/PROJECT-STRUCTURE-LIGHT.md`
- Minimal: `docs/PROJECT-STRUCTURE-MINIMAL.md`
- Repository root: `docs/REPOSITORY-STRUCTURE.md`

**Quick references:**
- `templates/STRUCTURE.md` - Quick lookup

---

### 10. AI Collaboration

**Authoritative:** `framework/CLAUDE.md` (~720 lines)

Covers:
- AI collaboration contract
- Reading protocol
- Role system
- Checkpoint policy (ADR-001)
- Decision trees

**Quick references:**
- `CLAUDE-QUICK-REFERENCE.md` (~335 lines) - Critical rules only

**Commands:**
- `.claude/commands/fw-help.md`
- `.claude/commands/fw-move.md`
- `.claude/commands/fw-status.md`
- `.claude/commands/fw-wip.md`
- `.claude/commands/fw-backlog.md`
- `.claude/commands/fw-next-id.md`
- `.claude/commands/fw-session-history.md`

---

### 11. Roles System

**Authoritative:** `framework/docs/ref/framework-roles.yaml`

**Schema:** `framework/docs/ref/framework-schema.yaml`

**Quick references:**
- `CLAUDE.md` - AI Roles section
- `framework.yaml` - Default role config

---

### 12. Research Phase

**Authoritative:** `docs/collaboration/workflow-guide.md` (Research Phase section)

**Templates:**
- `templates/research/PROBLEM-STATEMENT-TEMPLATE.md`
- `templates/research/LANDSCAPE-ANALYSIS-TEMPLATE.md`
- `templates/research/FEASIBILITY-TEMPLATE.md`
- `templates/research/PROJECT-JUSTIFICATION-TEMPLATE.md`
- `templates/research/PROJECT-DEFINITION-TEMPLATE.md`
- `templates/research/TESTING-PLAN-TEMPLATE.md`

---

### 13. ADR Process

**Authoritative:** `docs/collaboration/workflow-guide.md` (ADR section)

**Templates:**
- `templates/decisions/ADR-MAJOR-TEMPLATE.md`
- `templates/decisions/ADR-MINOR-TEMPLATE.md`

**Quick references:**
- `CLAUDE.md` - Decision trees

---

### 14. CMD/PowerShell Patterns

**Authoritative:**
- `docs/patterns/cmd-wrappers.md`
- `docs/patterns/powershell-modules.md`
- `docs/patterns/config-management.md`

**Templates:**
- `templates/wrappers/cmd/WRAPPER.cmd`
- `templates/wrappers/cmd/WRAPPER-ENHANCED.cmd`
- `templates/wrappers/cmd/WRAPPER-PS7.cmd`
- `templates/wrappers/cmd/WRAPPER-ADMIN.cmd`

---

### 15. New Project Setup

**Authoritative:**
- `templates/README-TEMPLATE-SELECTION.md` - Which level to choose
- `templates/NEW-PROJECT-CHECKLIST.md` - Setup steps
- `templates/UPGRADE-PATH.md` - Migration between levels

**Quick references:**
- `QUICK-START.md` - Bare-bones guide

---

## Duplication Analysis

### Acceptable Duplication (Hierarchical References)

| Pattern | Status | Reason |
|---------|--------|--------|
| `CLAUDE.md` summarizes `collaboration/*.md` | OK | Different audiences (quick ref vs. deep dive) |
| `CLAUDE-QUICK-REFERENCE.md` extracts from `CLAUDE.md` | OK | Critical rules for rapid lookup |
| Templates reference guides | OK | Templates = structure; guides = rationale |
| `QUICK-START.md` overlaps `README.md` | OK | Different purposes (how-to vs. overview) |

### Problematic Duplication

**None identified.** The framework follows DRY principles well:
- Single authoritative source per topic
- Quick references link back to sources
- Templates provide structure, not duplicate content

---

## What framework.yaml Already Covers

```yaml
policies:
  workflow: framework/docs/collaboration/workflow-guide.md
  onTransition: framework/docs/collaboration/workflow-guide.md#workflow-transitions

roles:
  definitions: framework/docs/ref/framework-roles.yaml
  default: senior-architect
```

This already establishes source-of-truth for:
- Workflow policy
- Transition rules
- Role definitions

---

## Gaps: What's NOT in framework.yaml

Topics that have authoritative sources but aren't in `framework.yaml`:

1. **Code quality** → `docs/collaboration/code-quality-standards.md`
2. **Testing** → `docs/collaboration/testing-strategy.md`
3. **Security** → `docs/collaboration/security-policy.md`
4. **Documentation standards** → `docs/process/documentation-standards.md`
5. **Version control** → `docs/process/version-control-workflow.md`
6. **Architecture** → `docs/collaboration/architecture-guide.md`
7. **Troubleshooting** → `docs/collaboration/troubleshooting-guide.md`
8. **Project structure** → `docs/PROJECT-STRUCTURE-*.md`

---

## Strategy Options

### Comparison Matrix

| Criteria | A: framework.yaml | B: INDEX.md | C: Hybrid | D: Close |
|----------|-------------------|-------------|-----------|----------|
| **Machine-readable** | ✅ Yes | ❌ No | ✅ Yes | ⚠️ Partial |
| **Human-discoverable** | ⚠️ Requires knowing to look | ✅ Yes | ✅ Yes | ✅ Yes |
| **Single source of truth** | ✅ One file | ✅ One file | ❌ Two files | ⚠️ Implicit |
| **Maintenance burden** | Low | Medium | Higher | None |
| **AI can parse** | ✅ Trivial | ⚠️ Regex needed | ✅ Trivial | ⚠️ Ad-hoc |
| **Anchor precision** | ✅ Supported | ✅ Supported | ✅ Supported | ❌ N/A |
| **Validates on change** | ⚠️ Manual | ⚠️ Manual | ⚠️ Manual | ❌ N/A |
| **Extends existing pattern** | ✅ Yes (policies:) | ✅ Yes (INDEX) | Mixed | N/A |
| **Work required** | Medium | Medium | High | None |
| **Risk of duplication** | ❌ Low | ❌ Low | ⚠️ Possible | ❌ Low |

### Option A: Expand framework.yaml

Add a `sources:` section with anchors:

```yaml
sources:
  # Workflow & Process
  workflow-process: docs/collaboration/workflow-guide.md#development-workflow-phases
  workflow-transitions: docs/collaboration/workflow-guide.md#workflow-transitions
  work-item-numbering: docs/collaboration/workflow-guide.md#work-item-numbering
  work-item-templates: docs/collaboration/workflow-guide.md#work-item-templates
  git-workflow: docs/collaboration/workflow-guide.md#git-workflow
  versioning: docs/collaboration/workflow-guide.md#versioning--releases
  planning: docs/collaboration/workflow-guide.md#planning-guidelines
  session-history: docs/collaboration/workflow-guide.md#session-history
  adr-process: docs/collaboration/workflow-guide.md#architecture-decision-records-adrs
  research-phase: docs/collaboration/workflow-guide.md#research-phase
  collaboration: docs/collaboration/workflow-guide.md#collaboration-practices
  documentation-standards: docs/collaboration/workflow-guide.md#documentation-standards

  # Standards & Policies
  code-quality: docs/collaboration/code-quality-standards.md
  testing: docs/collaboration/testing-strategy.md
  security: docs/collaboration/security-policy.md
  architecture: docs/collaboration/architecture-guide.md
  troubleshooting: docs/collaboration/troubleshooting-guide.md
  dry-principles: docs/collaboration/documentation-dry-principles.md

  # AI Collaboration
  ai-reading-protocol: CLAUDE.md#ai-reading-protocol
  ai-roles: docs/ref/framework-roles.yaml
  ai-checkpoint-policy: CLAUDE.md#ai-workflow-checkpoint-policy-critical---adr-001

  # Structure
  structure:
    standard: docs/PROJECT-STRUCTURE-STANDARD.md
    light: docs/PROJECT-STRUCTURE-LIGHT.md
    minimal: docs/PROJECT-STRUCTURE-MINIMAL.md

  # Patterns
  patterns:
    cmd-wrappers: docs/patterns/cmd-wrappers.md
    powershell-modules: docs/patterns/powershell-modules.md
    config-management: docs/patterns/config-management.md
```

**Pros:** Machine-readable, single config file, AI can parse, anchors provide precision
**Cons:** Less discoverable for humans, longer file

### Option B: Enhance INDEX.md

Add `[SOURCE]` markers and cross-references:

```markdown
### Collaboration Guides
- **workflow-guide.md** [SOURCE: Workflow] - Complete workflow process
  - Referenced by: CLAUDE.md, fw-move.md
- **code-quality-standards.md** [SOURCE: Code Quality] - Coding standards
  - Referenced by: CLAUDE.md
```

**Pros:** Human-readable, visible in navigation
**Cons:** Requires manual maintenance, not machine-parseable

### Option C: Hybrid

- `framework.yaml` → Machine-readable source mappings (for AI/tooling)
- `INDEX.md` → Human navigation (no duplication, just links)

**Pros:** Best of both worlds
**Cons:** Two files to maintain

### Option D: Close FEAT-031

Current state may be sufficient:
- `framework.yaml` exists for key policies
- `INDEX.md` provides navigation
- Documentation follows DRY already
- No problematic duplication found

**Pros:** No work needed
**Cons:** Misses opportunity to make sources explicit

---

## Recommendation

Based on this inventory:

**Option C (Hybrid)** seems most appropriate:

1. Expand `framework.yaml` with a `sources:` section for tooling/AI
2. Keep `INDEX.md` as human navigation (no changes needed)
3. Don't duplicate the source registry in INDEX.md

This preserves:
- Machine-readability for AI bootstrap
- Human-friendliness for navigation
- DRY principles (single source of truth for the registry itself)

---

## Next Steps

1. [ ] Review this inventory for accuracy
2. [ ] Decide on strategy (A/B/C/D)
3. [ ] If implementing, update framework.yaml or INDEX.md accordingly
4. [ ] Update FEAT-031 with decision and close

---

**Last Updated:** 2026-01-21 (added anchor links)
